library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

plot_data <- read_csv2("../data/SSI_weekly_age_data.csv") %>%  
  mutate(Aldersgruppe = case_when(
    Aldersgruppe == "0-2" ~ "0-5",
    Aldersgruppe == "3-5" ~ "0-5",
    Aldersgruppe == "6-11" ~ "6-11",
    Aldersgruppe == "12-15" ~ "12-19",
    Aldersgruppe == "16-19" ~ "12-19",
    Aldersgruppe == "20-39" ~ "20-39",
    Aldersgruppe == "40-64" ~ "40-64",
    Aldersgruppe == "65-79" ~ "65-79",
    Aldersgruppe == "80+" ~ "80+"
  )) %>%
  group_by(Aldersgruppe, date) %>% 
  summarize(
    total_admitted = sum(total_admitted, na.rm = TRUE),
    total_positive = sum(total_positive, na.rm = TRUE),
    total_tested = sum(total_tested, na.rm = TRUE),
    Population = sum(Population, na.rm = TRUE)
  ) %>% 
  mutate(
    admitted_incidens = total_admitted / Population * 100000,
    positive_incidens = total_positive / Population * 100000,
    tested_incidens = total_tested / Population * 10000
  )

plot_data$Aldersgruppe = factor(plot_data$Aldersgruppe, levels=c('0-5', '6-11', '12-19', '20-39','40-64', '65-79', '80+'))

plot_data %>% 
  ggplot() +
  geom_line(aes(date, admitted_incidens, color = Aldersgruppe), size = 0.8) +
  scale_color_discrete(name = "") +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Nyindlagte pr. 100.000", 
    x = "Dato", 
    title = "Ugentligt antal SARS-CoV-2-positive nyindlagte pr. 100.000", 
    caption = standard_caption
  ) +
  guides(colour = guide_legend(nrow = 1)) +
  standard_theme

ggsave("../figures/ntl_hosp_age.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% 
  ggplot() +
  geom_line(aes(date, total_admitted, color = Aldersgruppe), size = 0.8) +
  scale_color_discrete(name = "") +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Nyindlagte", 
    x = "Dato", 
    title = "Ugentligt antal SARS-CoV-2-positive nyindlagte", 
    caption = standard_caption
  ) +
  guides(colour = guide_legend(nrow = 1)) +
  standard_theme

ggsave("../figures/ntl_hosp_age_abs.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% 
  filter(date > as_date("2021-02-28")) %>% 
  ggplot() +
  geom_line(aes(date, admitted_incidens, color = Aldersgruppe), size = 0.8) +
  scale_color_discrete(name = "") +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Nyindlagte pr. 100.000", 
    x = "Dato", 
    title = "Ugentligt antal SARS-CoV-2-positive nyindlagte pr. 100.000", 
    caption = standard_caption
  ) +
  guides(colour = guide_legend(nrow = 1)) +
  standard_theme

ggsave("../figures/ntl_hosp_age_2.png", width = 18, height = 10, units = "cm", dpi = 300)


plot_data %>% 
  ggplot() +
  geom_line(aes(date, positive_incidens, color = Aldersgruppe), size = 0.8) +
  scale_color_discrete(name = "") +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Positive pr. 100.000", 
    x = "Dato", 
    title = "Ugentligt antal SARS-CoV-2-positive pr. 100.000", 
    caption = standard_caption
  ) +
  guides(colour = guide_legend(nrow = 1)) +
  standard_theme

ggsave("../figures/ntl_pos_age.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% 
  ggplot() +
  geom_line(aes(date, tested_incidens, color = Aldersgruppe), size = 0.8) +
  scale_color_discrete(name = "") +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Testede pr. 100.000", 
    x = "Dato", 
    title = "Ugentligt antal SARS-CoV-2-testede pr. 100.000", 
    caption = standard_caption
  ) +
  guides(colour = guide_legend(nrow = 1)) +
  standard_theme

ggsave("../figures/ntl_test_age.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% 
  mutate(pos_pct = total_positive / total_tested * 100) %>% 
  filter(date > as_date("2020-08-01")) %>% 
  ggplot() +
  geom_line(aes(date, pos_pct, color = Aldersgruppe), size = 0.8) +
  scale_color_discrete(name = "") +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA), labels = function(x) paste0(x, " %")) +
  labs(
    y = "Positivprocent", 
    x = "Dato", 
    title = "Ugentlig SARS-CoV-2 positivprocent", 
    caption = standard_caption
  ) +
  guides(colour = guide_legend(nrow = 1)) +
  standard_theme

ggsave("../figures/ntl_pct_age.png", width = 18, height = 10, units = "cm", dpi = 300)