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
    `2021_4` = X12
  ) %>%
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

ssi_18 %>% 
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
  write_csv2("../data/SSI_weekly_age_data.csv")
