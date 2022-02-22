
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
  group_by(Date = floor_date(Date, "1 day"), Admission_type) %>%
  summarize(admit = sum(Admitted, na.rm = TRUE)) %>%
  mutate(Year = year(Date), Month = month(Date), Week = isoweek(Date)) %>%
  filter(Year %in% c(2008:2018)) %>%
  filter(
    Date != as.Date("2018-12-31"),
    Date != as.Date("2018-12-30")
  ) %>%
  full_join(population, by = c("Year", "Month")) %>%
  mutate(admit = admit / ratio_2018) %>%
  ungroup() %>%
  group_by(Week, Admission_type) %>%
  summarize(mean_avg = mean(admit, na.rm = TRUE)) %>%
  filter(Admission_type == "Akut")


tibble("Date" = seq(as.Date("2020-01-01"), as.Date(today), by = "1 day")) %>%
  mutate(
    Week = week(Date),
    wday = wday(Date)
  ) %>%
  filter(wday == 1) %>%
  select(-wday) %>%
  full_join(x, by = "Week") %>%
  ggplot() +
  geom_area(aes(Date, mean_avg, fill = "average")) +
  geom_bar(data = admitted, stat = "identity", position = "identity", aes(Date, Admitted, fill = "covid"), width = 1) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month") +
  scale_fill_manual(name = "", labels = c("Total (gennemsnit 2008-18)", "COVID-19"), values = cols[1:2]) +
  labs(x = "Dato", y = "Antal nyindlæggelser", title = "Antal daglige akutindlæggelser i Danmark", subtitle = "Data for 2008-18 er justeret til 2018 befolkningstal. Total-kurven viser ugegennemsnit", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik og SSI") +
  scale_y_continuous(limits = c(0, 3000))


ggsave("../figures/dst_admissions_covid_all.png", width = 18, height = 12, units = "cm", dpi = 300)

