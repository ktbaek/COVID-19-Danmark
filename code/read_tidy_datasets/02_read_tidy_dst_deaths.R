dodc1_meta <- dkstat::dst_meta("DODC1", lang = "da")

age_groups = c("0-4 år", "5-9 år", "10-14 år", "15-19 år", "20-24 år", "25-29 år", "30-34 år", "35-39 år", "40-44 år", "45-49 år", "50-54 år", "55-59 år", "60-64 år", "65-69 år", "70-74 år", "75-79 år", "80-84 år", "85-89 år", "90-94 år", "95-99 år", "100 år og derover")

sex_groups <- c("Mænd", "Kvinder")

dst_dodc1 <- dkstat::dst_get_data(table = "DODC1", KØN = sex_groups, ALDER = age_groups, Tid = "*", lang = "da", meta_data = dodc1_meta) 

dst_dodc1 %>% 
  as_tibble() %>% 
  rename(
    Sex = KØN,
    Age = ALDER,
    Date = TID,
    Deaths = value
  ) %>% 
  rowwise() %>% 
  mutate(
    Age = str_split(Age, " ")[[1]][1],
    Age = ifelse(Age == 100, "100+", Age),
    Sex = ifelse(Sex == "Mænd", "Male", "Female")
  ) %>% 
  select(Date, Age, Sex, Deaths) %>% 
  write_csv2("../data/tidy_DST_daily_deaths_age_sex.csv")
  
  



