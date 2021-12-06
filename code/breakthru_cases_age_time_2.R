library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)
library(ggtext)
library(patchwork)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

# Read and clean up -------------------------------------------------------

bt_1 <- read_csv2("../data/tidy_breakthru_table1.csv")
bt_2 <- read_csv2("../data/tidy_breakthru_table2.csv")

# Functions ---------------------------------------------------------------

# function for calculating test adjusted incidence
tai <- function(pop, pos, tests, beta) {
  pos / (pop * (tests / pop) ** beta) * 100000
}

# Check that table2 data is consistent with table1 data -------------------

# check that cases and repositive numbers match
bt_2 %>%
  group_by(Week, Type, Variable, Vax_status) %>%
  summarize(Number_table2 = sum(Value, na.rm = TRUE)) %>%
  inner_join(filter(bt_1, Type == "antal" & Variable %in% c("cases.notprevpos", "cases.prevpos")), by = c("Week", "Type", "Variable", "Vax_status")) %>%
  mutate(Check = Number_table2 == Value) %>%
  pull(Check) %>%
  all() # -> they are identical in table 1 and 2, as expected. 

# compare my calculation of population sizes with those in table 1
temp_df_1 <- bt_2 %>%
  filter(Variable %in% c("cases.notprevpos", "cases.prevpos", "tests.notprevpos", "tests.alle", "cases.alle")) %>% 
  pivot_wider(names_from = c(Type, Variable), values_from = Value, names_sep = "_") %>% 
  select(-incidence_tests.alle) %>% 
  mutate(
    antal_personer.notprevpos = antal_cases.notprevpos / incidence_cases.notprevpos * 100000,
    antal_personer.alle = (antal_cases.notprevpos + antal_cases.prevpos) / incidence_cases.alle * 100000,
    antal_personer.prevpos = antal_personer.alle - antal_personer.notprevpos,
    incidence_cases.prevpos = antal_cases.prevpos / antal_personer.prevpos * 100000,
    antal_tests.prevpos = antal_tests.alle - antal_tests.notprevpos
  ) %>% 
  select(-incidence_cases.alle, -antal_tests.alle) %>% 
  pivot_longer(c(antal_cases.notprevpos:antal_tests.prevpos), names_to = c("Type", "Variable"), values_to = "Value", names_sep = "_") %>% 
  arrange(Aldersgruppe, Week, Vax_status, Type, Variable)
  
temp_df_1 %>% 
  filter(Type != "incidence") %>% 
  group_by(Week, Vax_status, Type, Variable) %>%
  summarize(
    Table2 = sum(Value, na.rm = TRUE)
  ) %>%
  inner_join(filter(bt_1, Type == "antal" & Variable %in% c("personer.alle", "personer.notprevpos")), by = c("Week", "Type", "Variable", "Vax_status")) %>%
  mutate(
    Diff = Table2 - Value,
    Diff_pct = round(abs(Diff / Table2) * 100, 2)
  ) 
# -> Within the categories that I'm using ("Ingen vaccination" and "Anden vaccination") the max percent difference is 0.09% -> I trust the calculation.

# compare my calculation of prev infection population with those calculated from table 1. Given that the above check was OK, this is just a double check. 
prevpos_check <- temp_df_1 %>% 
  filter(Type != "incidence") %>% 
  group_by(Week, Vax_status, Type, Variable) %>%
  summarize(
    Table2 = sum(Value, na.rm = TRUE)
  ) %>%
  inner_join(filter(bt_1, Type == "antal" & Variable %in% c("personer.alle", "personer.notprevpos")), by = c("Week", "Type", "Variable", "Vax_status")) %>%
  rename(Table1 = Value) %>% 
  # pivot swap
  pivot_wider(names_from = Variable, values_from = c(Table1, Table2), names_sep = ":") %>%
  pivot_longer(c(-Week, -Vax_status, -Type), names_to = c("Dataset", "Variable"), values_to = "value", names_sep = ":") %>%
  pivot_wider(names_from = Variable, values_from = value) %>%
  mutate(
    personer.prevpos = personer.alle - personer.notprevpos
  ) %>%
  select(-personer.alle, -personer.notprevpos) %>%
  pivot_wider(names_from = Dataset, values_from = personer.prevpos, names_sep = ":") %>%
  mutate(
    Diff = Table2 - Table1,
    Diff_pct = round(abs(Diff / Table2) * 100, 2)
  ) 
# -> Within the categories that I'm using ("Ingen vaccination" and "Anden vaccination") the max percent difference is 1.9% and most are <1% -> I still trust the calculation.

# Check how my calculations compare with total infected over time ------------

temp_df_2 <- prevpos_check %>%
  filter(Vax_status %in% c("Ingen vaccination", "Første vaccination", "Anden vaccination")) %>%
  group_by(Week) %>%
  summarize(Table2 = sum(Table2, na.rm = TRUE)) %>% 
  mutate(Date = as.Date(paste0("2021", sprintf("%02d", Week), "7"), "%Y%U%u"))
  
x <- read_csv2("../data/SSI_plot_data.csv") %>%
  filter(name == "Positive") %>% 
  select(Date, daily) %>% 
  mutate(cum_daily = cumsum(daily)) %>% 
  full_join(temp_df_2, by = "Date") %>% 
  mutate(Table2 = lead(Table2, 60)) %>% 
  filter(!is.na(Table2)) %>% 
  mutate(pct_diff = abs(cum_daily - Table2) / Table2 * 100) %>% 
  ggplot() +
  geom_line(aes(Date + days(60), pct_diff)) +
  scale_y_continuous(limits = c(0, NA))

# This is close enough

# Plots -------------------------------------------------------------------

plot_data <- temp_df_1 %>%
  filter(
    !Aldersgruppe %in% c("0-5", "6-11"),
    Vax_status %in% c("Ingen vaccination", "Anden vaccination"),
    !str_detect(Variable, "tests"),
    !str_detect(Variable, "personer")
  ) %>%
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) %>% 
  filter(!(Vax_status == "Anden vaccination" & Variable == "cases.prevpos")) %>% 
  mutate(Immunity_status = case_when(
    Vax_status == "Ingen vaccination" & Variable == "cases.prevpos" ~ "Tidligere positiv",
    TRUE ~ Vax_status
  )) %>%
    mutate(Immunity_status = ifelse(Immunity_status == "Anden vaccination", "Anden/tredje vaccination", Immunity_status))

plot_data$Immunity_status <- factor(plot_data$Immunity_status, levels = c("Ingen vaccination", "Anden/tredje vaccination", "Tidligere positiv"))

p1 <- plot_data %>%
  filter(Type == "incidence") %>%
  ggplot() +
  geom_line(aes(Date, Value, fill = Immunity_status, color = Immunity_status), size = 0.7,  alpha = 1) +
  scale_fill_manual(name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(
    y = "Positive per 100.000",
    title = "Positive per 100.000",
    subtitle = "Angiver antal positive per 100.000 i alders- og immunitetsgruppen"
  ) +
  facet_wrap(~Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position = "plot",
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
    ),
  )

p2 <- plot_data %>%
  filter(Type == "antal") %>%
  ggplot() +
  geom_area(aes(Date, Value, fill = Immunity_status, color = Immunity_status), size = 0, stat = "identity", position = "stack", alpha = 0.9) +
  scale_fill_manual(name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(
    y = "Positive",
    title = "Absolut antal positive",
    subtitle = "Angiver total antal positive opdelt på immunitetsstatus"
  ) +
  facet_wrap(~Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position = "plot",
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
    ),
  )

p1 / p2 + plot_layout(guides = "collect") +
  plot_annotation(
    title = "Ugentligt antal positive opdelt på alder og immunitetsstatus",
    subtitle = "Relative og absolutte antal personer med positiv SARS-CoV-2 PCR test.\n'Tidligere positive' er tidligere positive, ikke-vaccinerede.",
    caption = standard_caption,
    theme = theme(
      plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
      plot.title = element_text(size = rel(1.3), face = "bold", margin = margin(b = 5)),
      plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
    )
  ) & theme(
  text = element_text(family = "lato"),
  strip.text.x = element_text(margin = margin(0, 0, 0.8, 0)),
  legend.position = "bottom",
  panel.grid.major.x = element_line(color = "white", size = rel(1)),
  panel.grid.major.y = element_line(color = "white"),
  panel.grid.minor.x = element_blank()
)

ggsave("../figures/breakthru_cases_age_time_2.png", width = 16, height = 20, units = "cm", dpi = 300)


plot_data <- temp_df_1 %>%
  filter(
    !Aldersgruppe %in% c("0-5", "6-11"),
    Vax_status %in% c("Ingen vaccination", "Anden vaccination")
  ) %>%
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) %>% 
  filter(!(Vax_status == "Anden vaccination" & str_detect(Variable, "\\.prevpos"))) %>% 
  mutate(Immunity_status = case_when(
    Vax_status == "Ingen vaccination" & str_detect(Variable, "\\.prevpos") ~ "Tidligere positiv",
    TRUE ~ Vax_status
  )) %>%
  filter(
    str_detect(Variable, "tests") | str_detect(Variable, "personer"),
    Variable != "personer.alle",
    Type == "antal") %>% 
 separate(Variable, c("Variable", "PrevPos"), "\\.") %>% 
  pivot_wider(names_from = Variable, values_from = Value) %>% 
  mutate(incidence_tests = tests / personer * 100000) %>% 
  mutate(Immunity_status = ifelse(Immunity_status == "Anden vaccination", "Anden/tredje vaccination", Immunity_status))

plot_data$Immunity_status <- factor(plot_data$Immunity_status, levels = c("Ingen vaccination", "Anden/tredje vaccination", "Tidligere positiv"))

plot_data %>% 
  ggplot() +
  geom_line(aes(Date, incidence_tests, color = Immunity_status), size = 0.7, alpha = 1) +
  scale_color_manual(name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_x_date(labels = my_date_labels, breaks = c(ymd("2021-09-01"), ymd("2021-11-01")), expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(
    y = "Tests per 100.000",
    title = "Tests per 100.000",
    subtitle = "Angiver antal testede per 100.000 i alders- og immunitetsgruppen"
  ) +
  facet_wrap(~Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(color = guide_legend(override.aes = list(size = 1.5))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position = "plot",
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
    ),
  )




plot_data %>%
  ggplot() +
  geom_line(aes(Date, tests, color = Immunity_status), size = 0.7, alpha = 1) +
  scale_color_manual(name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(
    y = "Antal testede",
    title = "Absolut antal testede",
    subtitle = "Angiver antal testede i alders- og immunitetsgruppen"
  ) +
  facet_wrap(~Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(color = guide_legend(override.aes = list(size = 1.5))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position = "plot",
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
    ),
  )










plot_data <- temp_df_1 %>%
  filter(
    !Aldersgruppe %in% c("0-5", "6-11"),
    Vax_status %in% c("Ingen vaccination", "Anden vaccination"),
    Variable != "personer.alle",
    Type == "antal"
  ) %>%
  pivot_wider(names_from = c("Type", "Variable"), values_from = "Value", names_sep = "_") %>%
  mutate(antal_tests.prevpos = antal_tests.alle - antal_tests.notprevpos) %>% 
  select(-antal_tests.alle) %>% 
  pivot_longer(c(-Aldersgruppe, -Week, -Vax_status), names_to = c("Variable", "PrevPos"), values_to = "Value", names_sep = "\\.") %>%
  pivot_wider(names_from = Variable, values_from = Value) %>%
  mutate(tai = tai(antal_personer, antal_cases, antal_tests, 1)) %>% 
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) %>% 
  filter(!(Vax_status == "Anden vaccination" & PrevPos == "prevpos")) %>% 
  mutate(Immunity_status = case_when(
    Vax_status == "Ingen vaccination" & PrevPos == "prevpos" ~ "Tidligere positiv",
    TRUE ~ Vax_status
  )) %>%
  mutate(Immunity_status = ifelse(Immunity_status == "Anden vaccination", "Anden/tredje vaccination", Immunity_status))

plot_data$Immunity_status <- factor(plot_data$Immunity_status, levels = c("Ingen vaccination", "Anden/tredje vaccination", "Tidligere positiv"))

plot_data %>%
  ggplot() +
  geom_area(aes(Date, tai, fill = Immunity_status, color = Immunity_status), size = 0.7, stat = "identity", position = "identity", alpha = 0.2) +
  scale_fill_manual(name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(
    y = "Positive per 100.000",
    title = "Positive per 100.000",
    subtitle = "Angiver antal positive per 100.000 i alders- og immunitetsgruppen"
  ) +
  facet_wrap(~Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position = "plot",
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
    ),
  )




















temp_df %<>%
  filter(Vax_status == "Ingen vaccination") %>%
  select(Aldersgruppe, Week, prev_infection)

plot_data %>%
  filter(
    variable == "number",
    Immunity_status == "Tidligere positiv"
  ) %>%
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
  labs(
    y = "Repositive",
    title = "Ugentligt antal repositive og tidligere positive",
    subtitle = "Tidligere positive, ikke vaccinerede: >60 dage siden seneste positive PCR test",
    caption = standard_caption
  ) +
  facet_wrap(~Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    panel.grid.major.x = element_line(color = "white", size = rel(1)),
    panel.grid.major.y = element_line(color = "white"),
    panel.grid.minor.x = element_blank(),
    plot.title = element_text(size = 11, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position = "plot",
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
    ),
  )

ggsave("../figures/breakthru_cases_age_time_prev_inf.png", width = 18, height = 10, units = "cm", dpi = 300)
