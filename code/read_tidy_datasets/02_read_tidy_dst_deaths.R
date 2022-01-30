dst_dodc1 <- read_csv2("https://api.statbank.dk/v1/data/DODC1/CSV?delimiter=Semicolon&K%C3%98N=1%2C2&ALDER=0-4%2C5-9%2C10-14%2C15-19%2C20-24%2C25-29%2C30-34%2C35-39%2C40-44%2C45-49%2C50-54%2C55-59%2C60-64%2C65-69%2C70-74%2C75-79%2C80-84%2C85-89%2C90-94%2C95-99%2C100OV&Tid=*")

dst_dodc1 %>%
  rename(
    Sex = KØN,
    Age = ALDER,
    Date = TID,
    Deaths = INDHOLD
  ) %>%
  mutate(Date = DSTdate_to_date(Date)) %>%
  rowwise() %>%
  mutate(
    Age = str_split(Age, " ")[[1]][1],
    Age = ifelse(Age == 100, "100+", Age),
    Sex = ifelse(Sex == "Mænd", "Male", "Female")
  ) %>%
  select(Date, Age, Sex, Deaths) %>%
  write_csv2("../data/tidy_DST_daily_deaths_age_sex.csv")
