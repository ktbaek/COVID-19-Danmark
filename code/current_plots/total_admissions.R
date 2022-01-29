library(ISOweek)

dst_admitted <- read_csv2("../data/exp_UG_DST_admitted.csv", col_names = TRUE)

population_2018 <- dst_admitted %>%
  mutate(Date = as.Date(paste0(str_sub(Date, 7, 10), "-", str_sub(Date, 4, 5), "-", str_sub(Date, 1, 2)))) %>%
  group_by(Date, Admission_type) %>%
  summarize(pop_2018 = sum(Population, na.rm = TRUE)) %>% 
  filter(Admission_type == "Akut") %>% 
  filter(Date == floor_date(Date, "1 month"), year(Date) == 2018) %>% 
  mutate(Year = year(Date), Month = month(Date)) %>%
  ungroup() %>%
  select(Month, pop_2018)

population <- dst_admitted %>%
  mutate(Date = as.Date(paste0(str_sub(Date, 7, 10), "-", str_sub(Date, 4, 5), "-", str_sub(Date, 1, 2)))) %>%
  group_by(Date, Admission_type) %>%
  summarize(pop = sum(Population, na.rm = TRUE)) %>% 
  filter(Admission_type == "Akut") %>% 
  filter(Date == floor_date(Date, "1 month")) %>% 
  mutate(Year = year(Date), Month = month(Date)) %>%
  ungroup() %>%
  select(Year, Month, pop) %>%
  full_join(population_2018, by = "Month") %>%
  mutate(ratio_2018 = pop / pop_2018)

cols <- c("covid" = lighten(admit_col, 0.3), "average" = darken(admit_col, 0.5))
  
x <- dst_admitted %>%
  mutate(Date = as.Date(paste0(str_sub(Date, 7, 10), "-", str_sub(Date, 4, 5), "-", str_sub(Date, 1, 2)))) %>%
  group_by(Date=floor_date(Date, "1 day"), Admission_type) %>%
  summarize(admit = sum(Admitted, na.rm = TRUE)) %>%
  mutate(Year = year(Date), Month = month(Date), Week = isoweek(Date)) %>%
  filter(Year %in% c(2008:2018)) %>%
  filter(Date != as.Date("2018-12-31"),
         Date != as.Date("2018-12-30")) %>%
  full_join(population, by = c("Year", "Month")) %>%
  mutate(admit = admit / ratio_2018) %>%
  ungroup() %>%
  group_by(Week, Admission_type) %>%
  summarize(mean_avg = mean(admit, na.rm = TRUE)) %>%
  filter(Admission_type == "Akut")


tibble("Date" =  seq(as.Date("2020-01-01"), as.Date(today), by = "1 day")) %>%
  mutate(Week = week(Date),
         wday = wday(Date)) %>%
  filter(wday == 1) %>%
  select(-wday) %>%
  full_join(x, by = "Week") %>%
  ggplot() +
  geom_area(aes(Date, mean_avg, fill = "average")) +
  geom_bar(data = admitted, stat="identity",position = "identity", aes(Date, Admitted, fill = "covid"), width = 1) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month") +
  scale_fill_manual(name = "", labels = c("Total (gennemsnit 2008-18)", "COVID-19"), values = cols[1:2]) +
  labs(x = "Dato", y = "Antal nyindlæggelser", title = "Antal daglige akutindlæggelser i Danmark", subtitle = "Data for 2008-18 er justeret til 2018 befolkningstal. Total-kurven viser ugegennemsnit", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik og SSI") + 
  scale_y_continuous(limits = c(0, 3000)) + 
  standard_theme 
  
  
ggsave("../figures/dst_admissions_covid_all.png", width = 18, height = 12, units = "cm", dpi = 300)



age_incidence <- dst_admitted %>% 
  mutate(Date = as.Date(paste0(str_sub(Date, 7, 10), "-", str_sub(Date, 4, 5), "-", str_sub(Date, 1, 2)))) %>%
  mutate(
    Age = case_when(
      AldersGrpOrg == "00-09" ~ "0-9",
      AldersGrpOrg == "okt.19" ~ "10-19",
      str_detect(AldersGrpOrg, "Over 89") ~ "90+",
      TRUE ~ AldersGrpOrg
    ),
    Sex = case_when(
      Sex == "Kvinder" ~ "Female",
      TRUE ~ "Male"
    )) %>% 
  select(Date, Admission_type, Sex, Age, Admitted, Population) %>% 
  group_by(Date, Sex, Age, Population) %>% 
  summarize(Admitted = sum(Admitted, na.rm = TRUE)) %>% 
  group_by(Age) %>%
  summarize(
    Admitted = sum(Admitted, na.rm = TRUE),
    Person_days = sum(Population, na.rm = TRUE)) %>%
  group_by(Age) %>%
  summarize(Incidense = Admitted / Person_days * 100000) 
  
x <- read_csv2("../data/tidy_dst_age_sex_2015_21.csv") %>% 
  mutate(Age = case_when(
    Age == "0-4" ~ "0-9",
    Age == "5-9" ~ "0-9",
    Age == "10-14" ~ "10-19",
    Age == "15-19" ~ "10-19",
    Age == "20-24" ~ "20-29",
    Age == "25-29" ~ "20-29",
    Age == "30-34" ~ "30-39",
    Age == "35-39" ~ "30-39",
    Age == "40-44" ~ "40-49",
    Age == "45-49" ~ "40-49",
    Age == "50-54" ~ "50-59",
    Age == "55-59" ~ "50-59",
    Age == "60-64" ~ "60-69",
    Age == "65-69" ~ "60-69",
    Age == "70-74" ~ "70-79",
    Age == "75-79" ~ "70-79",
    Age == "80-84" ~ "80-89",
    Age == "85-89" ~ "80-89",
    TRUE ~ "90+"
  )) %>% 
  group_by(Date, Age) %>% 
  summarize(
    Population = sum(Population, na.rm = TRUE)
  ) %>% 
  full_join(age_incidence, by = "Age") %>% 
  mutate(Admitted = Population / 100000 * Incidense) %>% 
  group_by(Date) %>% 
  summarize(Admitted = sum(Admitted, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(Date, Admitted)) +
  scale_x_date(date_label = "%Y", date_breaks = "3 years", minor_breaks = "1 year") +
  scale_y_continuous(limits = c(0, NA), labels = scales::number) +
  labs(
    title = "Befolkningsudvikling 2015-2021",
    caption = "Kristoffer T. Bæk, data: Danmarks Statistik"
  ) +
  facet_theme +
  theme(
    legend.position = "none",
    panel.grid.minor.x = element_line(size = rel(0.3)),
    plot.margin = margin(0.8, 0.8, 0.3, 0.8, "cm"),
    axis.title.y = element_blank()
  )




  
