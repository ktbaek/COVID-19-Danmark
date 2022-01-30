ssi_18 <- read_csv2("../data/18_fnkt_alder_uge_testede_positive_nyindlagte.csv")

fnkt_age_breaks <- c(-1, 2, 5, 11, 15, 19, 39, 64, 79, 125)

pop <- get_pop_by_breaks(fnkt_age_breaks) %>%
  group_by(Year, Quarter, Age) %>%
  summarize(Population = sum(Population, na.rm = TRUE))

ssi_18 %>%
  separate(Uge, into = c("Year", "Week"), sep = "-") %>%
  mutate(Week = str_remove(Week, "W")) %>%
  mutate(
    Week = as.integer(Week),
    Year = as.integer(Year),
    # fix spelling of age groups
    Aldersgruppe = case_when(
      Aldersgruppe == "00-02" ~ "0-2",
      Aldersgruppe == "03-05" ~ "3-5",
      Aldersgruppe == "06-11" ~ "6-11",
      TRUE ~ Aldersgruppe
    )
  ) %>%
  mutate(
    Date = week_to_date(Year, Week),
    Date = fix_week_2020(Year, Week, Date),
    Quarter = quarter(Date)
  ) %>%
  left_join(pop, by = c("Aldersgruppe" = "Age", "Quarter", "Year")) %>%
  # fill latest missing population numbers
  arrange(Date) %>%
  group_by(Aldersgruppe) %>%
  fill(Population) %>%
  ungroup() %>%
  rename(
    admitted = `Nyindlagte pr. 100.000 borgere`,
    tested = `Testede pr. 100.000 borgere`,
    positive = `Positive pr. 100.000 borgere`
  ) %>%
  mutate(
    incidence.admitted = ifelse(is.na(admitted), 0, admitted),
    incidence.positive = ifelse(is.na(positive), 0, positive),
    incidence.tested = ifelse(is.na(tested), 0, tested),
    antal.persons = Population
  ) %>%
  mutate(
    antal.admitted = antal.persons * admitted / 100000,
    antal.positive = `Antal positive`,
    antal.tested = `Antal testede`
  ) %>%
  select(Date, Year, Week, Aldersgruppe, incidence.admitted:antal.tested) %>%
  pivot_longer(incidence.admitted:antal.tested, values_to = "Value") %>%
  separate(name, c("Type", "Variable"), "\\.") %>%
  write_csv2("../data/SSI_weekly_age_data.csv")
