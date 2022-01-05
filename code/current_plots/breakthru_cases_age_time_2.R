library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)
library(ggtext)
library(patchwork)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

my_breaks <- c(ymd("2021-10-01"), ymd("2021-12-01"))

# Read and clean up -------------------------------------------------------

bt_1 <- read_csv2("../data/tidy_breakthru_table1.csv")
bt_2 <- read_csv2("../data/tidy_breakthru_table2.csv")

# function for calculating test adjusted incidence
tai <- function(pop, pos, tests, beta) {
  pos / (pop * (tests / pop)**beta) * 100000
}

beta <- 0.5
# Check that table2 data is consistent with table1 data -------------------

# check that cases and repositive numbers match
bt_2 %>%
  group_by(Week, Type, Variable, Group, Vax_status) %>%
  summarize(Number_table2 = sum(Value, na.rm = TRUE)) %>%
  inner_join(filter(bt_1, Type == "antal" & Variable == "cases"), by = c("Week", "Type", "Variable", "Group", "Vax_status")) %>%
  mutate(Check = Number_table2 == Value) %>%
  pull(Check) %>%
  all() # -> they are identical in table 1 and 2, as expected.

# compare my calculation of population sizes with those in table 1

temp_df_1 <- bt_2 %>%
  filter(Variable %in% c("cases", "tests")) %>%
  pivot_wider(names_from = c(Type, Variable, Group), values_from = Value, names_sep = "_") %>%
  select(-antal_tests_total) %>%
  mutate(
    antal_personer_notprevpos = antal_cases_notprevpos / incidence_cases_notprevpos * 100000,
    antal_personer_alle = antal_tests_alle / incidence_tests_alle * 100000,
    antal_personer_prevpos = antal_personer_alle - antal_personer_notprevpos,
    incidence_cases_prevpos = antal_cases_prevpos / antal_personer_prevpos * 100000,
    antal_tests_prevpos = antal_tests_alle - antal_tests_notprevpos,
    incidence_tac_notprevpos = tai(antal_personer_notprevpos, antal_cases_notprevpos, antal_tests_notprevpos, beta),
    incidence_tac_prevpos = tai(antal_personer_prevpos, antal_cases_prevpos, antal_tests_prevpos, beta)
  ) %>%
  select(-incidence_cases_alle, -antal_tests_alle) %>%
  pivot_longer(c(antal_cases_notprevpos:incidence_tac_prevpos), names_to = c("Type", "Variable", "Group"), values_to = "Value", names_sep = "_") %>%
  arrange(Aldersgruppe, Week, Vax_status, Type, Variable, Group)

pop_check <- temp_df_1 %>%
  filter(Type != "incidence") %>%
  group_by(Week, Vax_status, Type, Variable, Group) %>%
  summarize(
    Table2 = sum(Value, na.rm = TRUE)
  ) %>%
  inner_join(filter(bt_1, Type == "antal" & Variable == "personer"), by = c("Week", "Type", "Variable", "Group", "Vax_status")) %>%
  mutate(
    Diff = Table2 - Value,
    Diff_pct = round(abs(Diff / Table2) * 100, 2)
  ) %>% 
  arrange(desc(Diff_pct))
# -> Within the categories that I'm using ("Ingen vaccination" and "Anden vaccination") the max percent difference is 0.11% -> I trust the calculation.

# compare my calculation of prev infection population with those calculated from table 1. Given that the above check was OK, this is just a double check.
prevpos_check <- temp_df_1 %>%
  filter(Type != "incidence") %>%
  group_by(Week, Vax_status, Type, Variable, Group) %>%
  summarize(
    Table2 = sum(Value, na.rm = TRUE)
  ) %>%
  inner_join(filter(bt_1, Type == "antal" & Variable == "personer"), by = c("Week", "Type", "Variable", "Group", "Vax_status")) %>%
  rename(Table1 = Value) %>%
  # pivot swap
  pivot_wider(names_from = c(Variable, Group), values_from = c(Table1, Table2), names_sep = "_") %>%
  pivot_longer(c(-Week, -Vax_status, -Type), names_to = c("Dataset", "Variable", "Group"), values_to = "value", names_sep = "_") %>%
  pivot_wider(names_from = c(Variable, Group), values_from = value, names_sep = "_") %>%
  mutate(
    personer_prevpos = personer_alle - personer_notprevpos
  ) %>%
  select(-personer_alle, -personer_notprevpos) %>%
  pivot_wider(names_from = Dataset, values_from = personer_prevpos) %>%
  mutate(
    Diff = Table2 - Table1,
    Diff_pct = round(abs(Diff / Table2) * 100, 2)
  ) %>% 
  arrange(desc(Diff_pct))
# -> Within the categories that I'm using ("Ingen vaccination" and "Anden vaccination") the max percent difference is 1.97% and most are <1% -> I still trust the calculation.

# Check how my calculations compare with total infected over time ------------

temp_df_2 <- prevpos_check %>%
  filter(Vax_status %in% c("Ingen vaccination", "Første vaccination", "Anden vaccination")) %>%
  group_by(Week) %>%
  summarize(Table2 = sum(Table2, na.rm = TRUE)) %>%
  mutate(Date = as.Date(paste0("2021", sprintf("%02d", Week), "7"), "%Y%U%u"))

read_csv2("../data/SSI_daily_data.csv") %>%
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

# Plots -------------------------------------------------------------------

plot_data <- temp_df_1 %>%
  filter(
    !Aldersgruppe %in% c("0-5", "6-11"),
    Vax_status %in% c("Ingen vaccination", "Fuld effekt efter primært forløb", "Fuld effekt efter revaccination"),
    Variable != "tests",
    Variable != "personer"
  ) %>%
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) %>%
  filter(!(Vax_status %in% c("Fuld effekt efter primært forløb", "Fuld effekt efter revaccination") & Group == "prevpos")) %>%
  mutate(Immunity_status = case_when(
    Vax_status == "Ingen vaccination" & Group == "prevpos" ~ "Tidligere positiv",
    TRUE ~ Vax_status
  )) %>%
  mutate(Immunity_status = case_when(
    Immunity_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
    Immunity_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
    TRUE ~ Immunity_status
  )) %>% 
  mutate(Value = ifelse(Value < 3, NA, Value))

plot_data$Immunity_status <- factor(plot_data$Immunity_status, levels = c("Ingen vaccination", "Fuld effekt 2 doser", "Fuld effekt 3 doser", "Tidligere positiv"))

p1 <- plot_data %>%
  filter(
    Type == "incidence", 
    Variable != "tac",
   !(Aldersgruppe %in% c("60-64", "65-69", "70-79", "80+") & Immunity_status == "Tidligere positiv"),
   !(Aldersgruppe %in% c("12-15", "16-19") & Immunity_status == "Fuld effekt 3 doser")
    ) %>%
  ggplot() +
  geom_line(aes(Date, Value, fill = Immunity_status, color = Immunity_status), size = 0.7, alpha = 1) +
  scale_fill_manual(name = "", values = c(pct_col, admit_col, "#67cc32", pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, "#67cc32", pos_col)) +
  scale_x_date(labels = my_date_labels, breaks = my_breaks, expand = expansion(mult = 0.01)) +
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
  filter(
    Type == "incidence", 
    Variable == "tac",
    !(Aldersgruppe %in% c("60-64", "65-69", "70-79", "80+") & Immunity_status == "Tidligere positiv"),
    !(Aldersgruppe %in% c("12-15", "16-19") & Immunity_status == "Fuld effekt 3 doser")
  ) %>%
  ggplot() +
  geom_line(aes(Date, Value, fill = Immunity_status, color = Immunity_status), size = 0.7, alpha = 1) +
  scale_fill_manual(name = "", values = c(pct_col, admit_col, "#67cc32", pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, "#67cc32", pos_col)) +
  scale_x_date(labels = my_date_labels, breaks = my_breaks, expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(
    y = "Testjusteret positive per 100.000",
    title = "Testjusteret antal positive per 100.000 (beta = 0.5)",
    subtitle = "Angiver den testjusterede incidens i alders- og immunitetsgruppen"
  ) +
  facet_wrap(~ Aldersgruppe, ncol = 5) +
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


p3 <- plot_data %>%
  filter(Type == "antal") %>%
  ggplot() +
  geom_area(aes(Date, Value, fill = Immunity_status, color = Immunity_status), size = 0, stat = "identity", position = "stack", alpha = 0.9) +
  scale_fill_manual(name = "", values = c(pct_col, admit_col, "#67cc32", pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col,"#67cc32", pos_col)) +
  scale_x_date(labels = my_date_labels, breaks = my_breaks, expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(
    y = "Positive",
    title = "Absolut antal positive",
    subtitle = "Angiver total antal positive opdelt på immunitetsstatus (grupperne er stablet)"
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

p1 / p3 + plot_layout(guides = "collect") +
  plot_annotation(
    title = "Ugentligt antal positive opdelt på alder og immunitetsstatus",
    subtitle = "Relative og absolutte antal personer med positiv SARS-CoV-2 PCR test.\n'Tidligere positive' = tidligere positive, ikke-vaccinerede.\nØvrige tre grupper = ikke tidligere positive.",
    caption = standard_caption,
    theme = theme(
      plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
      plot.title = element_text(size = rel(1.3), face = "bold", margin = margin(b = 5)),
      plot.subtitle = element_text(size = rel(0.9)),
      plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
    )
  ) & theme(
  text = element_text(family = "lato"),
  strip.text.x = element_text(margin = margin(0, 0, 0.8, 0)),
  legend.position = "bottom",
  legend.text = element_text(size = rel(1)),
  legend.key.size = unit(0.34, "cm"),
  panel.grid.major.x = element_line(color = "white", size = rel(1)),
  panel.grid.major.y = element_line(color = "white"),
  panel.grid.minor.x = element_blank()
)

ggsave("../figures/bt_cases_age_time_2.png", width = 16, height = 20, units = "cm", dpi = 300)

p2 / p3 + plot_layout(guides = "collect") +
  plot_annotation(
    title = "Ugentligt antal positive opdelt på alder og immunitetsstatus",
    subtitle = "Relative og absolutte antal personer med positiv SARS-CoV-2 PCR test.\n'Tidligere positive' = tidligere positive, ikke-vaccinerede.\nØvrige tre grupper = ikke tidligere positive.",
    caption = standard_caption,
    theme = theme(
      plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
      plot.title = element_text(size = rel(1.3), face = "bold", margin = margin(b = 5)),
      plot.subtitle = element_text(size = rel(0.9)),
      plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
    )
  ) & theme(
  text = element_text(family = "lato"),
  strip.text.x = element_text(margin = margin(0, 0, 0.8, 0)),
  legend.position = "bottom",
  legend.text = element_text(size = rel(1)),
  legend.key.size = unit(0.34, "cm"),
  panel.grid.major.x = element_line(color = "white", size = rel(1)),
  panel.grid.major.y = element_line(color = "white"),
  panel.grid.minor.x = element_blank()
)

ggsave("../figures/bt_tac_age_time_2.png", width = 16, height = 20, units = "cm", dpi = 300)

p2 +
  scale_color_manual(name = "", values = c(pct_col, admit_col, "#67cc32", pos_col)) +
  guides(color = guide_legend(override.aes = list(size = 1.5))) +
  labs(caption = standard_caption) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    panel.grid.major.x = element_line(color = "white", size = rel(1)),
    panel.grid.major.y = element_line(color = "white"),
    panel.grid.minor.x = element_blank(),
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
    ),
  )

ggsave("../figures/bt_tac_age_time_1.png", width = 18, height = 10, units = "cm", dpi = 300)




plot_data <- temp_df_1 %>%
  filter(
    !Aldersgruppe %in% c("0-5", "6-11"),
    Vax_status %in% c("Ingen vaccination", "Fuld effekt efter primært forløb", "Fuld effekt efter revaccination"),
  ) %>%
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) %>%
  filter(!(Vax_status %in% c("Fuld effekt efter primært forløb", "Fuld effekt efter revaccination") & Group == "prevpos")) %>%
  mutate(Immunity_status = case_when(
    Vax_status == "Ingen vaccination" & Group == "prevpos" ~ "Tidligere positiv",
    TRUE ~ Vax_status
  )) %>%
  mutate(Immunity_status = case_when(
    Immunity_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
    Immunity_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
    TRUE ~ Immunity_status
  )) %>%
  filter(
    Variable %in% c("tests", "personer"),
    Group != "alle",
    Type == "antal"
  ) %>%
  pivot_wider(names_from = Variable, values_from = Value) %>%
  mutate(incidence_tests = tests / personer * 100000) 

plot_data$Immunity_status <- factor(plot_data$Immunity_status, levels = c("Ingen vaccination", "Fuld effekt 2 doser", "Fuld effekt 3 doser", "Tidligere positiv"))

plot_data %>%
  ggplot() +
  geom_line(aes(Date, incidence_tests, color = Immunity_status), size = 0.7, alpha = 1) +
  scale_color_manual(name = "", values = c(pct_col, admit_col, "#67cc32", pos_col)) +
  scale_x_date(labels = my_date_labels, breaks = my_breaks, expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(
    y = "Tests per 100.000",
    title = "PCR tests per 100.000",
    subtitle = "Angiver antal testede per 100.000 i alders- og immunitetsgruppen",
    caption = standard_caption
  ) +
  facet_wrap(~Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(color = guide_legend(override.aes = list(size = 1.5))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    panel.grid.major.x = element_line(color = "white", size = rel(1)),
    panel.grid.major.y = element_line(color = "white"),
    panel.grid.minor.x = element_blank(),
    plot.caption.position = "plot",
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
    ),
  )

ggsave("../figures/bt_tests_age_time.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data <- temp_df_1 %>%
  filter(
    !Aldersgruppe %in% c("0-5", "6-11"),
    Vax_status %in% c("Ingen vaccination", "Fuld effekt efter primært forløb", "Fuld effekt efter revaccination"),
    !str_detect(Variable, "tests"),
    !str_detect(Variable, "personer")
  ) %>%
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) %>%
  filter(!(Vax_status %in% c("Fuld effekt efter primært forløb", "Fuld effekt efter revaccination") & Group == "prevpos")) %>%
  mutate(Immunity_status = case_when(
    Vax_status == "Ingen vaccination" & Group == "prevpos" ~ "Tidligere positiv",
    TRUE ~ Vax_status
  )) %>%
  mutate(Immunity_status = case_when(
    Immunity_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
    Immunity_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
    TRUE ~ Immunity_status
  )) 

plot_data$Immunity_status <- factor(plot_data$Immunity_status, levels = c("Ingen vaccination", "Fuld effekt 2 doser", "Fuld effekt 3 doser", "Tidligere positiv"))

plot_data %>%
  filter(Type == "antal", Immunity_status == "Tidligere positiv") %>%
  ggplot() +
  geom_line(aes(Date, Value, fill = Immunity_status, color = Immunity_status), size = 1, alpha = 1) +
  scale_fill_manual(name = "", values = c(pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pos_col)) +
  scale_x_date(labels = my_date_labels, breaks = my_breaks, expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(
    y = "Repositive",
    title = "Absolut antal repositive tidligere positive"
  ) +
  facet_wrap(~Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position = "plot",
    panel.grid.major.x = element_line(color = "white", size = rel(1)),
    panel.grid.major.y = element_line(color = "white"),
    panel.grid.minor.x = element_blank(),
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
    ),
  )

ggsave("../figures/bt_cases_prevpos_age_time.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(Type == "antal", Immunity_status == "Fuld effekt 3 doser") %>%
  ggplot() +
  geom_line(aes(Date, Value, fill = Immunity_status, color = Immunity_status), size = 1, alpha = 1) +
  scale_fill_manual(name = "", values = "#67cc32") +
  scale_color_manual(guide = FALSE, name = "", values = "#67cc32") +
  scale_x_date(labels = my_date_labels, breaks = my_breaks, expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(
    y = "Positive",
    title = "Absolut antal positive for booster"
  ) +
  facet_wrap(~Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position = "plot",
    panel.grid.major.x = element_line(color = "white", size = rel(1)),
    panel.grid.major.y = element_line(color = "white"),
    panel.grid.minor.x = element_blank(),
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
    ),
  )

ggsave("../figures/bt_cases_booster_age_time.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data <- temp_df_1 %>%
  filter(
    Variable == "personer",
    Group == "alle"
  ) %>%
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) %>%  
  filter(!(Vax_status %in% c("Fuld effekt efter primært forløb", "Fuld effekt efter revaccination"))) %>% 
  mutate(Vax_track = ifelse(Vax_status != "Ingen vaccination", "Påbegyndt vaccination", Vax_status)) %>% 
  group_by(Date, Vax_track, Aldersgruppe) %>% 
  summarize(Value = sum(Value, na.rm = TRUE))


plot_data$Aldersgruppe <- factor(plot_data$Aldersgruppe, levels = c("0-5", "6-11", "12-15", "16-19", "20-29", "30-39", "40-49", "50-59", "60-64", "65-69", "70-79", "80+"))


plot_data %>%
  ggplot() +
  geom_area(aes(Date, Value, fill = Vax_track), position = "fill", size = 1, alpha = 1) +
  scale_x_date(labels = my_date_labels, breaks = my_breaks, expand = expansion(mult = 0.01)) +
  scale_fill_manual(name = "", values = c(pct_col, admit_col)) +
  scale_y_continuous(limits = c(0, NA), labels = function(x) paste0(x * 100, " %"), expand = expansion(mult = c(0.05, 0))) +
  labs(
    y = "Andel",
    title = "Personer opdelt på vaccinationsstatus"
  ) +
  facet_wrap(~Aldersgruppe, ncol = 6) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position = "plot",
    panel.grid.minor.x = element_blank()
  )

ggsave("../figures/bt_personer_vax_age_time.png", width = 18, height = 10, units = "cm", dpi = 300)



