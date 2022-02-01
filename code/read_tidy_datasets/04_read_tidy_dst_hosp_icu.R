dst_smit1 <- read_csv2("https://api.statbank.dk/v1/data/SMIT1/CSV?delimiter=Semicolon&AKTP=%2C40%2C35&Tid=*")

dst_smit1 %>% 
  rename(
    Variable = AKTP,
    Date = TID,
    Daily = INDHOLD
  ) %>% 
  mutate(
    Date = DSTdate_to_date(Date),
    Variable = case_when(
      Variable == "Indlagte på Intensiv afdeling ifm. COVID-19" ~ "hospitalized",
      TRUE ~ "icu"
    )
  ) %>% 
  write_csv2("../data/tidy_dst_hosp_icu.csv")
