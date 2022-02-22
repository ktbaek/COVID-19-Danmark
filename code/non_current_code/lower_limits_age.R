library(zoo)

# How mainy people are admitted daily per age group (based on numbers from 2008 to 2018) -------------

dst_admitted <- read_csv2("../data/exp_UG_DST_admitted.csv", col_names = TRUE)

# fraction of population in each age group that is admitted ('akut') daily
fraction_admitted <- dst_admitted %>%
  mutate(Date = as.Date(paste0(str_sub(Date, 7, 10), "-", str_sub(Date, 4, 5), "-", str_sub(Date, 1, 2)))) %>%
  group_by(Date=floor_date(Date, "1 day"), Admission_type) %>%
  mutate(Aldersgruppe = case_when(
    AldersGrpOrg == "okt.19" ~ "10-19", #correcting Excel stupidity
    str_detect(AldersGrpOrg, "Over 89") ~ "90+",
    TRUE ~ AldersGrpOrg)) %>% 
  select(Date, Admission_type, Aldersgruppe, Admitted, Population) %>% 
  group_by(Date, Admission_type, Aldersgruppe) %>% 
  filter(Admission_type == "Akut") %>% 
  summarize(
    Admitted = sum(Admitted, na.rm = TRUE),
    Population = sum(Population, na.rm = TRUE)
  ) %>% 
  mutate(Fraction = Admitted / Population) %>% 
  group_by(Aldersgruppe) %>% 
  summarize(Fraction = mean(Fraction, na.rm = TRUE))


fraction_admitted_adj <- tribble(~Aldersgruppe, ~Fraction,
        "0-19", 0.00035,
        "20-39", 0.0003,
        "40-64", 0.00035,
        "65-79", 0.0008,
        "80+", 0.0017)
  

# How many people are in each age group in 2021 -------------------

dst_age_groups <- read_csv2("../data/DST_age_sex_group_1_year.csv", col_names = FALSE)

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
    Alder = X1,
    Male = X2,
    Female = X3
  ) %>%
  mutate_all(str_replace_all, " år", "") %>%
  mutate_all(as.double) %>%
  mutate(Population = Male + Female) %>%
  select(-Male, -Female) %>%
  group_by(Aldersgruppe_cut = cut(Alder, breaks= c(-1, 2, 5, 11, 15, 19, 39, 64, 79, 125))) %>%
  summarize(Population = sum(Population)) %>%
  full_join(age_lookup_1, by = "Aldersgruppe_cut") %>%
  select(-Aldersgruppe_cut) 
 

# How many people are admitted, tested, and positive with covid per age group per week -------------------

ssi_18 <- read_csv2("../data/18_fnkt_alder_uge_testede_positive_nyindlagte.csv")

covid_data <- ssi_18 %>% 
  full_join(age_groups, by = "Aldersgruppe") %>% 
  separate(Uge, into = c("year", "week"), sep = "-") %>% 
  mutate(week = str_remove(week, "W")) %>% 
  mutate(
    week = as.integer(week),
    year = as.integer(year)
  ) %>% 
  rename(
    admitted = `Nyindlagte pr. 100.000 borgere`,
    tested = `Testede pr. 100.000 borgere`,
    positive = `Positive pr. 100.000 borgere`
  ) %>% 
  select(year, week, Aldersgruppe, admitted, tested, positive, Population) %>% 
  mutate(
    admitted = ifelse(is.na(admitted), 0, admitted),
    positive = ifelse(is.na(positive), 0, positive),
    tested = ifelse(is.na(tested), 0, tested)
  ) %>% 
  mutate(Date = as.Date(paste0(year, sprintf("%02d", week), "1"), "%Y%U%u")) %>% 
  mutate(
    total_admitted = Population * admitted / 100000,
    total_positive = Population * positive / 100000,
    total_tested = Population * tested / 100000
  ) %>% 
  mutate(Aldersgruppe = case_when(
    Aldersgruppe == "0-2" ~ "0-19",
    Aldersgruppe == "3-5" ~ "0-19",
    Aldersgruppe == "6-11" ~ "0-19",
    Aldersgruppe == "12-15" ~ "0-19",
    Aldersgruppe == "16-19" ~ "0-19",
    Aldersgruppe == "20-39" ~ "20-39",
    Aldersgruppe == "40-64" ~ "40-64",
    Aldersgruppe == "65-79" ~ "65-79",
    Aldersgruppe == "80+" ~ "80+"
  )) %>%
  group_by(Aldersgruppe, Date) %>% 
  summarize(
    total_admitted = sum(total_admitted, na.rm = TRUE),
    total_positive = sum(total_positive, na.rm = TRUE),
    total_tested = sum(total_tested, na.rm = TRUE),
    Population = sum(Population, na.rm = TRUE)
  ) %>% 
  full_join(fraction_admitted_adj, by = "Aldersgruppe") %>% 
  mutate(Fraction = Fraction * 7) # adjust to weekly data


# Read old vax data files

days <- seq(ymd("2021-02-22"), ymd(today), by = "days")
mondays <- days[which(wday(days) == 2)]
monday_strings <- paste0(str_sub(mondays, 3, 4), str_sub(mondays, 6, 7), str_sub(mondays, 9, 10))

read_vax_csv_1 <- function(x) {
  file <- read_csv(paste0("../data/Vax_data/Vaccine_DB_", x, "/Vaccinationer_region_aldgrp_koen.csv"), locale = locale(encoding = "ISO-8859-1"))
  file %<>%
    mutate(date_of_file = x) %>%
    mutate(Date = paste0("20", str_sub(date_of_file, 1, 2), "-", str_sub(date_of_file, 3, 4), "-", str_sub(date_of_file, 5, 6)))
  
  return(file)
}

read_vax_csv_2 <- function(x) {
  file <- read_csv2(paste0("../data/Vax_data/Vaccine_DB_", x, "/Vaccinationer_region_aldgrp_koen.csv"), locale = locale(encoding = "ISO-8859-1"))
  file %<>%
    mutate(date_of_file = x) %>%
    mutate(Date = paste0("20", str_sub(date_of_file, 1, 2), "-", str_sub(date_of_file, 3, 4), "-", str_sub(date_of_file, 5, 6)))
  
  return(file)
}

# SSI changed from comma to semicolon separated vax files in July
vax_dates_comma <- monday_strings[1:21]
vax_dates_semicolon <- monday_strings[22:length(monday_strings)]

csv_list_1 <- lapply(vax_dates_comma, read_vax_csv_1)
csv_list_2 <- lapply(vax_dates_semicolon, read_vax_csv_2)

vax_df_1 <- bind_rows(csv_list_1)
vax_df_2 <- bind_rows(csv_list_2)

vax_df <- bind_rows(vax_df_1, vax_df_2)

age_groups_2 <- age_groups %>% 
  mutate(Aldersgruppe = case_when(
    Aldersgruppe == "0-2" ~ "0-19",
    Aldersgruppe == "3-5" ~ "0-19",
    Aldersgruppe == "6-11" ~ "0-19",
    Aldersgruppe == "12-15" ~ "0-19",
    Aldersgruppe == "16-19" ~ "0-19",
    Aldersgruppe == "20-39" ~ "20-39",
    Aldersgruppe == "40-64" ~ "40-64",
    Aldersgruppe == "65-79" ~ "65-79",
    Aldersgruppe == "80+" ~ "80+"
  )) %>% 
  group_by(Aldersgruppe) %>% 
  summarize(Population = sum(Population))

vaxx <- vax_df %>% 
  rename(vax_done = `Antal faerdigvacc.`) %>% 
  group_by(Aldersgruppe, Date) %>% 
  filter(!is.na(Aldersgruppe)) %>% 
  summarize(vax_done = sum(vax_done, na.rm = TRUE)) %>% 
  pivot_wider(names_from = Aldersgruppe, values_from = vax_done) %>% 
  mutate(
    `60-64` = 0.5 * `60-69`,
    `65-69` = 0.5 * `60-69`
  ) %>% 
  select(-`60-69`) %>% 
  pivot_longer(-Date, names_to = "Aldersgruppe", values_to = "vax_done") %>% 
  mutate(Aldersgruppe = case_when(
    Aldersgruppe == "0-9" ~ "0-19",
    Aldersgruppe == "10-19" ~ "0-19",
    Aldersgruppe == "20-29" ~ "20-39",
    Aldersgruppe == "30-39" ~ "20-39",
    Aldersgruppe == "40-49" ~ "40-64",
    Aldersgruppe == "50-59" ~ "40-64",
    Aldersgruppe == "60-64" ~ "40-64",
    Aldersgruppe == "65-69" ~ "65-79",
    Aldersgruppe == "70-79" ~ "65-79",
    Aldersgruppe == "80-89" ~ "80+",
    Aldersgruppe == "90+" ~ "80+"
  )) %>% 
  group_by(Aldersgruppe, Date) %>% 
  summarize(vax_done = sum(vax_done, na.rm = TRUE)) %>% 
  full_join(age_groups_2, by = "Aldersgruppe") %>% 
  mutate(proportion_unvaxd = (Population - vax_done) / Population) %>% 
  mutate(Date = ymd(Date)) %>% 
  select(-vax_done, -Population)
  
covid_data %>% 
  filter(Date >= ymd("2021-02-22")) %>% 
  full_join(vaxx, by = c("Date", "Aldersgruppe")) %>%
  group_by(Aldersgruppe) %>% 
  mutate(
    pool_14 = rollsum(total_positive, 2, align = "right", na.pad = TRUE),
    pred_admit_lo = (pool_14 * Fraction) + (Fraction * Population *  total_positive / total_tested * 0.7),
    pred_admit_hi = (pool_14 * Fraction) + (Fraction * Population *  total_positive / total_tested * 1.5)
  ) %>% 
  rename(obs_admit_y = total_admitted) %>% 
  select(Date, Aldersgruppe, obs_admit_y, pred_admit_lo, pred_admit_hi) %>% 
  pivot_longer(c(-Date, -Aldersgruppe), names_to = c("type", "variable", "limit"), names_sep = "_") %>% 
  pivot_wider(names_from = limit, values_from = value) %>% 
  filter(Date >= ymd("2021-02-01")) %>% 
  ggplot() +
  geom_ribbon(aes(Date, ymin = lo, ymax = hi, fill = type), alpha = 0.8) +
  geom_line(aes(Date, y, color = type), size = 1)+#, alpha = type, size = type)) +
  facet_wrap(~Aldersgruppe) +
  scale_x_date(labels = my_date_labels, breaks = "3 months", minor_break = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  standard_theme +
  theme(
    plot.title.position = "plot",
    plot.title = element_textbox_simple(
      size = 10, face = "plain", lineheight = 1.05, padding = margin(0, 5, 5, 0)
    )
  )





