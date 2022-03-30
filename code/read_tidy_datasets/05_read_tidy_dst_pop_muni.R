dst_folk1a_muni <- read_csv2("https://api.statbank.dk/v1/data/FOLK1A/CSV?OMR%C3%85DE=*&K%C3%98N=TOT&ALDER=IALT&CIVILSTAND=TOT&Tid=2022K1%2C2021K4%2C2021K3%2C2021K2%2C2021K1%2C2020K4%2C2020K3%2C2020K2%2C2020K1")

dst_folk1a_muni %>%
  select(-KØN, -ALDER, -CIVILSTAND) %>% 
  rename(
    Kvartal = TID,
    Population = INDHOLD,
    Kommune = OMRÅDE
  ) %>%
  filter(
    Kommune != "Hele landet",
    !str_starts(Kommune, "Region")
  ) %>% 
  mutate(
    Year = as.integer(str_sub(Kvartal, 1, 4)),
    Quarter = as.integer(str_sub(Kvartal, 6, 6)),
  ) %>%
  select(-Kvartal) %>%
  write_csv2("../data/tidy_DST_pop_muni.csv")
