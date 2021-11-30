library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)
library(ggtext)
library(patchwork)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

# Read and clean up -------------------------------------------------------

bt_cases <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_antal_cases.csv")
bt_cases_inc <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_incidence_cases.csv")
bt_table1 <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table1.csv")
bt_repos <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_antal_repositive.csv")
bt_cases_inc_all <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_incidence_alle.csv")


tidy_breakthru <- function(df, name){
  
  df %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = name, names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle")
  ) 
  
}

x <- tidy_breakthru(bt_cases, "antal_cases")
y <- tidy_breakthru(bt_repos, "antal_repositive")
z <- tidy_breakthru(bt_cases_inc_all, "incidence_all")


# Check that table2 data is consistent with table1 data -------------------

table1_check_1 <- bt_table1 %>% 
  # tidy data
  pivot_longer(-Ugenummer, names_to = c("Group", "Vax_status"), values_to = "Number_table1", names_sep = "_[A-Z]") %>% 
  mutate(Week = as.integer(str_sub(Ugenummer, 5, 6))) %>% 
  select(-Ugenummer) %>% 
  mutate(Vax_status = case_when(
    Vax_status == "ngen vaccination" ~ "Ingen vaccination",
    Vax_status == "ørste vaccination" ~ "Første vaccination",
    Vax_status == "nden vaccination" ~ "Anden vaccination",
    Vax_status == "uld effekt efter primært forløb" ~ "Fuld effekt efter primært forløb",
  )) %>% 
  # select relevant variables and vax groups
  filter(
    Group %in% c("antal_personer_alle", "antal_personer", "antal_cases", "antal_repositive"),
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb")
  ) 

# check that cases and repositive numbers match
x %>% 
  full_join(y, by = c("Aldersgruppe", "Vax_status", "Week")) %>% 
  pivot_longer(c(antal_cases, antal_repositive), names_to = "Group", values_to = "Number_table2") %>% 
  group_by(Week, Group, Vax_status) %>% 
  summarize(Number_table2 = sum(Number_table2, na.rm = TRUE)) %>% 
  full_join(filter(table1_check_1, Group %in% c("antal_cases", "antal_repositive")), by = c("Week", "Group", "Vax_status")) %>% 
  mutate(Check = Number_table2 == Number_table1) %>% 
  pull(Check) %>% 
  all() # -> they are identical in table 1 and 2

# compare my calculation of population sizes with those in table 1
check1 <- bt_cases_inc %>% 
  tidy_breakthru("incidence") %>% 
  full_join(x, by = c("Aldersgruppe", "Vax_status", "Week")) %>% 
  full_join(z, by = c("Aldersgruppe", "Vax_status", "Week")) %>% 
  full_join(y, by = c("Aldersgruppe", "Vax_status", "Week")) %>% 
  mutate(
    # calculate population not including previous positives
    antal_personer = as.integer(antal_cases / incidence * 100000),
    # calculate population including previous positives
    antal_personer_alle = as.integer(((antal_cases + antal_repositive) / incidence_all * 100000))
  ) %>% 
  # sum across age groups
  group_by(Week, Vax_status) %>% 
  summarize(antal_personer = sum(antal_personer, na.rm = TRUE),
            antal_personer_alle = sum(antal_personer_alle, na.rm = TRUE)) %>% 
  pivot_longer(c(antal_personer, antal_personer_alle), names_to = "Group", values_to = "Number_table2") %>% 
  full_join(filter(table1_check_1, Group %in% c("antal_personer", "antal_personer_alle")), by = c("Week", "Group", "Vax_status")) %>% 
  mutate(
    Diff = Number_table2 - Number_table1,
    Diff_pct = abs(Diff / Number_table2) * 100
    ) # -> max 0.7% difference

# compare my calculation of prev infection population with those calculated from table 1
check2 <- check1 %>% 
  select(-Diff, -Diff_pct) %>% 
  # pivot swap
  pivot_wider(names_from = Group, values_from = c(Number_table1, Number_table2), names_sep = ":") %>% 
  pivot_longer(c(-Week, -Vax_status), names_to = c("Dataset", "Group"), values_to = "value", names_sep = ":") %>% 
  pivot_wider(names_from = Group, values_from = value) %>% 
  mutate(
    prev_infection = antal_personer_alle - antal_personer
  ) %>% 
  select(-antal_personer_alle) %>% 
  # pivot swap
  pivot_wider(names_from = Dataset, values_from = c(antal_personer, prev_infection), names_sep = ":") %>% 
  pivot_longer(c(-Week, -Vax_status), names_to = c("Group", "Dataset"), values_to = "value", names_sep = ":") %>%
  pivot_wider(names_from = Dataset, values_from = value) %>%
  mutate(
    Diff = Number_table2 - Number_table1,
    Diff_pct = abs(Diff / Number_table2) * 100
  ) # -> max 5% difference (week 31), most under 0.5%


# Check how calculations compare with total infected over time ------------

# number of cases up until 2 months before last entry
read_csv2("../data/SSI_plot_data.csv") %>% 
  filter(
    name == "Positive",
    Date < ymd("2021-09-28")) %>% 
  pull(daily) %>% 
  sum(na.rm = TRUE) # 355,000

check2 %>% 
  filter(
    Group == "prev_infection",
    Week == 47
  ) %>% 
  pull(Number_table2) %>% 
  sum() # 340,000

# This is close enough, given I haven't included first vax. 
  
# Plots -------------------------------------------------------------------

temp_df <- bt_cases_inc %>% 
  tidy_breakthru("incidence") %>% 
  full_join(x, by = c("Aldersgruppe", "Vax_status", "Week")) %>% 
  full_join(z, by = c("Aldersgruppe", "Vax_status", "Week")) %>% 
  full_join(y, by = c("Aldersgruppe", "Vax_status", "Week")) %>% 
  mutate(
    antal_personer = as.integer(antal_cases / incidence * 100000),
    antal_personer_alle = as.integer(((antal_cases + antal_repositive) / incidence_all * 100000)),
    prev_infection = antal_personer_alle - antal_personer,
    incidence_repos = antal_repositive / prev_infection * 100000
  )  

plot_data <- temp_df %>% 
  select(-incidence_all, -antal_personer_alle, -antal_personer, -prev_infection) %>% 
  rename(
    incidence_cases = incidence,
    number_cases = antal_cases,
    number_repositive = antal_repositive,
    incidence_repositive = incidence_repos
  ) %>% 
  pivot_longer(c(-Aldersgruppe, -Week, -Vax_status), names_to = c("variable", "type"), values_to = "value", names_sep = "_") %>% 
  filter(!(Vax_status == "Fuld effekt efter primært forløb" & type == "repositive")) %>% 
  mutate(Immunity_status = case_when(
    Vax_status == "Ingen vaccination" & type == "repositive" ~ "Tidligere positiv",
    TRUE ~ Vax_status
  )) %>% 
  select(-type) %>% 
  filter(
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) 

plot_data$Immunity_status <- factor(plot_data$Immunity_status, levels=c('Ingen vaccination', 'Fuld effekt efter primært forløb', 'Tidligere positiv'))  

p1 <- plot_data %>%   
  filter(variable == "incidence") %>% 
  ggplot() +
  geom_area(aes(Date, value, fill = Immunity_status, color = Immunity_status), size = 0.7, stat = "identity", position = "identity", alpha = 0.2) + 
  scale_fill_manual(name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(y = "Positive per 100.000",
       title = "Positive per 100.000",
       subtitle = "Angiver antal positive per 100.000 i alders- og immunitetsgruppen") +
  facet_wrap(~ Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    panel.background = element_rect(
      fill = "gray97", 
      colour = NA,
      size = 0.3
    ), 
  )

p2 <- plot_data %>%   
  filter(variable == "number") %>% 
  ggplot() +
  geom_area(aes(Date, value, fill = Immunity_status, color = Immunity_status), size = 0.7, stat = "identity", position = "identity", alpha = 0.2) + 
  scale_fill_manual(name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(y = "Positive",
       title = "Absolutte antal positive") +
  facet_wrap(~ Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    plot.title = element_text(size = 11, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    panel.background = element_rect(
      fill = "gray97", 
      colour = NA,
      size = 0.3
    ), 
  )

p1 / p2 + plot_layout(guides='collect') + 
  plot_annotation(
    title = 'Ugentligt antal positive opdelt på alder og immunitetsstatus',
    subtitle = "Relative og absolutte antal personer med positiv SARS-CoV-2 PCR test.\n'Tidligere positive' er tidligere positive, ikke-vaccinerede.",
    caption = standard_caption,
    theme = theme(
      plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
      plot.title = element_text(size = rel(1.3), face = "bold", margin = margin(b = 5)),
      plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
    )) & theme(
      text = element_text(family = "lato"),
      strip.text.x = element_text(margin = margin(0, 0, 0.8, 0)), 
      legend.position = "bottom",
      panel.grid.major.x = element_line(color = "white", size = rel(1)),
      panel.grid.major.y = element_line(color = "white"),
      panel.grid.minor.x = element_blank())

ggsave("../figures/breakthru_cases_age_time_2.png", width = 16, height = 20, units = "cm", dpi = 300)

temp_df %<>% 
  filter(Vax_status == "Ingen vaccination") %>% 
  select(Aldersgruppe, Week, prev_infection)

plot_data %>%  
  filter(variable == "number",
         Immunity_status == "Tidligere positiv") %>% 
  left_join(temp_df, by = c("Aldersgruppe", "Week")) %>% 
  select(Aldersgruppe, Date, value, prev_infection) %>% 
  mutate(prev_infection = prev_infection / 1000) %>% 
  rename(
    Repositive = value,
    `Tidligere positive` = prev_infection
  ) %>% 
  pivot_longer(c(Repositive, `Tidligere positive`), names_to = "variable", values_to = "value") %>% 
  ggplot() +
  geom_line(aes(Date, value, color = variable), size = 0.7, stat = "identity", position = "identity") + 
  scale_color_manual(name = "", values = c(pos_col, alpha(pos_col, 0.3))) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02), sec.axis = sec_axis(~ . * 1000, name = "Tidligere positive, ikke-vaccinerede")) +
  labs(y = "Repositive",
       title = "Ugentligt antal repositive og tidligere positive",
       subtitle = "Tidligere positive, ikke vaccinerede: >60 dage siden seneste positive PCR test",
       caption = standard_caption) +
  facet_wrap(~ Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    panel.grid.major.x = element_line(color = "white", size = rel(1)),
    panel.grid.major.y = element_line(color = "white"),
    panel.grid.minor.x = element_blank(),
    plot.title = element_text(size = 11, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    panel.background = element_rect(
      fill = "gray97", 
      colour = NA,
      size = 0.3
    ), 
  )

ggsave("../figures/breakthru_cases_age_time_prev_inf.png", width = 18, height = 10, units = "cm", dpi = 300)