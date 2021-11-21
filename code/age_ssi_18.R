library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

ssi_18 <- read_csv2("../data/18_fnkt_alder_uge_testede_positive_nyindlagte.csv")
dst_age_groups <- read_csv2("../data/DST_age_group_1_year_quarterly.csv", col_names = FALSE)

age_lookup_1 <- tribble(~Aldersgruppe, ~Aldersgruppe_cut,
                        "0-2", "(-1,2]",
                        "3-5", "(2,5]",
                        "6-11", "(5,11]",
                        "12-15", "(11,15]",
                        "16-19", "(15,19]",
                        "20-39", "(19,39]",
                        "40-64", "(39,64]",
                        "65-79", "(64,79]",
                        "80+", "(79,125]"
)

age_groups <- dst_age_groups %>%
  rename(
    Alder = X4,
    `2020_1` = X5,
    `2020_2` = X6,
    `2020_3` = X7,
    `2020_4` = X8,
    `2021_1` = X9,
    `2021_2` = X10,
    `2021_3` = X11,
  ) %>%
  mutate(`2021_4` = `2021_3`) %>% 
  select(-X1, -X2, -X3) %>% 
  rowwise() %>% 
  mutate(Alder = as.double(str_split(Alder, " ")[[1]][1])) %>%
  pivot_longer(-Alder, names_to = "Kvartal", values_to = "Population") %>% 
  separate(Kvartal, c("Year", "Quarter"), sep = "_") %>% 
  mutate(
    Quarter = as.integer(Quarter),
    Year = as.integer(Year)
  ) %>% 
  
  group_by(Year, Quarter, Aldersgruppe_cut = cut(Alder, breaks= c(-1, 2, 5, 11, 15, 19, 39, 64, 79, 125))) %>% 
  summarize(Population = sum(Population)) %>%
  full_join(age_lookup_1, by = "Aldersgruppe_cut") %>%
  select(-Aldersgruppe_cut) 

plot_data <- ssi_18 %>% 
  #full_join(age_groups, by = "Aldersgruppe") %>% 
  separate(Uge, into = c("year", "week"), sep = "-") %>% 
  mutate(week = str_remove(week, "W")) %>% 
  mutate(
    week = as.integer(week),
    Year = as.integer(year)
  ) %>% 
  mutate(date = as.Date(paste0(year, sprintf("%02d", week), "1"), "%Y%U%u")) %>% 
  mutate(Quarter = quarter(date)) %>% 
  full_join(age_groups, by = c("Aldersgruppe", "Quarter", "Year")) %>% 
  rename(
    admitted = `Nyindlagte pr. 100.000 borgere`,
    tested = `Testede pr. 100.000 borgere`,
    positive = `Positive pr. 100.000 borgere`
  ) %>% 
  select(date, Aldersgruppe, admitted, tested, positive, Population) %>% 
  mutate(
    admitted = ifelse(is.na(admitted), 0, admitted),
    positive = ifelse(is.na(positive), 0, positive),
    tested = ifelse(is.na(tested), 0, tested)
  ) %>% 
  mutate(
    total_admitted = Population * admitted / 100000,
    total_positive = Population * positive / 100000,
    total_tested = Population * tested / 100000
  ) %>% 
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
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Nyindlagte pr. 100.000", 
    x = "Dato", 
    title = "Ugentligt antal SARS-CoV-2-positive nyindlagte pr. 100.000", 
    caption = standard_caption
  ) +
  standard_theme

ggsave("../figures/ntl_hosp_age.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% 
  filter(date > as_date("2021-02-28")) %>% 
  ggplot() +
  geom_line(aes(date, admitted_incidens, color = Aldersgruppe), size = 0.8) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Nyindlagte pr. 100.000", 
    x = "Dato", 
    title = "Ugentligt antal SARS-CoV-2-positive nyindlagte pr. 100.000", 
    caption = standard_caption
  ) +
  standard_theme

ggsave("../figures/ntl_hosp_age_2.png", width = 18, height = 10, units = "cm", dpi = 300)


plot_data %>% 
  ggplot() +
  geom_line(aes(date, positive_incidens, color = Aldersgruppe), size = 0.8) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Positive pr. 100.000", 
    x = "Dato", 
    title = "Ugentligt antal SARS-CoV-2-positive pr. 100.000", 
    caption = standard_caption
  ) +
  standard_theme

ggsave("../figures/ntl_pos_age.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% 
  ggplot() +
  geom_line(aes(date, tested_incidens, color = Aldersgruppe), size = 0.8) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Testede pr. 100.000", 
    x = "Dato", 
    title = "Ugentligt antal SARS-CoV-2-testede pr. 100.000", 
    caption = standard_caption
  ) +
  standard_theme

ggsave("../figures/ntl_test_age.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% 
  mutate(pos_pct = total_positive / total_tested * 100) %>% 
  filter(date > as_date("2020-08-01")) %>% 
  ggplot() +
  geom_line(aes(date, pos_pct, color = Aldersgruppe), size = 0.8) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA), labels = function(x) paste0(x, " %")) +
  labs(
    y = "Positivprocent", 
    x = "Dato", 
    title = "Ugentlig SARS-CoV-2 positivprocent", 
    caption = standard_caption
  ) +
  standard_theme

ggsave("../figures/ntl_pct_age.png", width = 18, height = 10, units = "cm", dpi = 300)

  
