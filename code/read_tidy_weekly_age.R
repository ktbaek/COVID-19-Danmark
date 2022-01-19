ssi_18 <- read_csv2("../data/18_fnkt_alder_uge_testede_positive_nyindlagte.csv")

fnkt_age_breaks <- c(-1, 2, 5, 11, 15, 19, 39, 64, 79, 125)

pop <- read_tidy_age(fnkt_age_breaks) %>% 
  group_by(Year, Quarter, Age) %>% 
  summarize(Population = sum(Population, na.rm = TRUE))

ssi_18 %>% 
  separate(Uge, into = c("year", "week"), sep = "-") %>% 
  mutate(week = str_remove(week, "W")) %>% 
  mutate(
    week = as.integer(week),
    Year = as.integer(year)
  ) %>% 
  mutate(date = as.Date(paste0(year, sprintf("%02d", week), "1"), "%Y%U%u")) %>% 
  mutate(Quarter = quarter(date)) %>% 
  full_join(pop, by = c("Aldersgruppe" = "Age", "Quarter", "Year")) %>% 
  arrange(date) %>% 
  group_by(Aldersgruppe) %>% 
  fill(Population) %>% 
  ungroup() %>% 
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
  write_csv2("../data/SSI_weekly_age_data.csv")
