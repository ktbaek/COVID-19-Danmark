ssi_18 <- read_csv2("../data/18_fnkt_alder_uge_testede_positive_nyindlagte.csv")

fnkt_age_breaks <- c(-1, 2, 5, 11, 15, 19, 39, 64, 79, 125)

pop <- read_tidy_age(fnkt_age_breaks) %>% 
  group_by(Year, Quarter, Age) %>% 
  summarize(Population = sum(Population, na.rm = TRUE))

x <- ssi_18 %>% 
  separate(Uge, into = c("Year", "Week"), sep = "-") %>% 
  mutate(Week = str_remove(Week, "W")) %>% 
  mutate(
    Week = as.integer(Week),
    Year = as.integer(Year),
    Aldersgruppe = case_when(
      Aldersgruppe == "00-02" ~ "0-2",
      Aldersgruppe == "03-05" ~ "3-5",
      Aldersgruppe == "06-11" ~ "6-11",
      TRUE ~ Aldersgruppe
      )
  ) %>% 
  mutate(
    Date = as.Date(paste0(Year, sprintf("%02d", Week), "1"), "%Y%U%u"),
    Date = case_when(
    Year == 2020 & Week == 53 ~ ymd("2020-12-28"),
    Year == 2020 & Week < 53 ~ Date - days(7),
    TRUE ~ Date
  )) %>% 
  mutate(Quarter = quarter(Date)) %>% 
  left_join(pop, by = c("Aldersgruppe" = "Age", "Quarter", "Year")) %>% 
  arrange(Date) %>% 
  group_by(Aldersgruppe) %>% 
  fill(Population) %>% 
  ungroup() %>% 
  rename(
    admitted = `Nyindlagte pr. 100.000 borgere`,
    tested = `Testede pr. 100.000 borgere`,
    positive = `Positive pr. 100.000 borgere`
  ) %>% 
  select(Date, Year, Week, Aldersgruppe, admitted, tested, positive, Population) %>% 
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
  write_csv2("../data/SSI_weekly_age_data.csv")
