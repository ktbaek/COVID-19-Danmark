dst_folk1a <- read_csv2("https://api.statbank.dk/v1/data/FOLK1A/CSV?delimiter=Semicolon&K%C3%98N=1%2C2&ALDER=*&CIVILSTAND=TOT&Tid=*")

dst_folk1a %>%
  rename(
    Sex = KØN,
    Age = ALDER,
    Kvartal = TID,
    Population = INDHOLD
  ) %>%
  filter(Age != "I alt") %>%
  mutate(
    Year = as.integer(str_sub(Kvartal, 1, 4)),
    Quarter = as.integer(str_sub(Kvartal, 6, 6)),
  ) %>%
  select(-CIVILSTAND, -Kvartal) %>%
  rowwise() %>%
  mutate(
    Age = as.integer(str_split(Age, " ")[[1]][1]),
    Sex = ifelse(Sex == "Mænd", "Male", "Female")
  ) %>%
  select(Year, Quarter, Age, Sex, Population) %>%
  write_csv2("../data/tidy_DST_pop.csv")
