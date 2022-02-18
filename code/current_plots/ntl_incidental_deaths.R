
case_data <- read_csv2("../data/SSI_weekly_age_data.csv") %>%
  filter(
    Type == "antal",
    Variable == "positive"
  ) %>%
  mutate(Aldersgruppe = case_when(
    Aldersgruppe == "0-2" ~ "0-19",
    Aldersgruppe == "3-5" ~ "0-19",
    Aldersgruppe == "6-11" ~ "0-19",
    Aldersgruppe == "12-15" ~ "0-19",
    Aldersgruppe == "16-19" ~ "0-19",
    Aldersgruppe == "20-39" ~ "20-39",
    Aldersgruppe == "40-64" ~ "40-64",
    Aldersgruppe == "65-79" ~ "65-79",
    Aldersgruppe == "80+" ~ "80+"
  )) %>%
  group_by(Aldersgruppe, Date) %>%
  summarize(Positive = sum(Value, na.rm = TRUE))

pop <- get_pop_by_breaks(age_breaks = get_age_breaks(100, 5)) %>%
  group_by(Year, Quarter, Age) %>%
  summarize(Population = sum(Population, na.rm = TRUE))

weekly_all_deaths <- read_csv2("../data/tidy_DST_daily_deaths_age_sex.csv") %>%
  group_by(Date, Age) %>%
  summarize(Deaths = sum(Deaths, na.rm = TRUE)) %>%
  mutate(
    Year = year(Date),
    Quarter = quarter(Date)
  ) %>%
  filter(Year >= 2020) %>%
  left_join(pop, by = c("Age", "Year", "Quarter")) %>%
  group_by(Age) %>%
  fill(Population) %>%
  mutate(Age = case_when(
    Age == "0-4" ~ "0-19",
    Age == "5-9" ~ "0-19",
    Age == "10-14" ~ "0-19",
    Age == "15-19" ~ "0-19",
    Age == "20-24" ~ "20-39",
    Age == "25-29" ~ "20-39",
    Age == "30-34" ~ "20-39",
    Age == "35-39" ~ "20-39",
    Age == "40-44" ~ "40-64",
    Age == "45-49" ~ "40-64",
    Age == "50-54" ~ "40-64",
    Age == "55-59" ~ "40-64",
    Age == "60-64" ~ "40-64",
    Age == "65-69" ~ "65-79",
    Age == "70-74" ~ "65-79",
    Age == "75-79" ~ "65-79",
    Age == "80-84" ~ "80+",
    Age == "85-89" ~ "80+",
    Age == "90-94" ~ "80+",
    Age == "95-99" ~ "80+",
    Age == "100+" ~ "80+"
  )) %>%
  group_by(Age, Date) %>%
  summarize(
    Deaths = sum(Deaths, na.rm = TRUE),
    Population = sum(Population, na.rm = TRUE)
  ) %>%
  group_by(Date = floor_date_wday(Date), Age) %>%
  summarize(
    Deaths = sum(Deaths, na.rm = TRUE),
    Population = mean(Population, na.rm = TRUE),
    Death_incidence = Deaths / Population
  )

weekly_covid_deaths <- read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name == "Deaths") %>%
  select(Date, daily) %>%
  group_by(Date = floor_date_wday(Date)) %>%
  summarize(Obs_deaths = sum(daily, na.rm = TRUE))

pred_obs <- weekly_all_deaths %>%
  full_join(case_data, by = c("Age" = "Aldersgruppe", "Date")) %>%
  arrange(Date) %>%
  group_by(Age) %>%
  fill(Deaths, Population, Death_incidence) %>%
  mutate(pool_28 = rollsum(Positive, 4, align = "right", na.pad = TRUE)) %>%
  ungroup() %>%
  mutate(Pred_deaths = Death_incidence * pool_28 * 1.125) %>% # The extra .125 is an approximation to account for these being summed weekly data.
  group_by(Date) %>%
  summarize(Pred_deaths = sum(Pred_deaths, na.rm = TRUE)) %>%
  full_join(weekly_covid_deaths, by = "Date") %>%
  pivot_longer(-Date)

pred_obs %>%
  filter(Date <= floor_date_wday(today, 7)) %>%
  ggplot() +
  geom_line(aes(Date, value, color = name), size = 1) +
  scale_color_manual(name = "", labels = c("Død med Covid", 'Estimeret "tilfældig" død med Covid'), values = c(pos_col, test_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
  guides(color = guide_legend(override.aes = list(size = 1.5))) +
  labs(
    y = "Antal",
    title = 'Estimat af antallet af "tilfældige" ugentlige Covid dødsfald',
    caption = "Kristoffer T. Bæk, covid19danmark.dk, data: SSI, Danmarks Statistik"
  ) +
  standard_theme

ggsave("../figures/ntl_incidental_deaths.png", width = 18, height = 10, units = "cm", dpi = 300)

pred_obs %>%
  filter(Date <= floor_date_wday(today, 7)) %>%
  pivot_wider() %>%
  ggplot() +
  geom_line(aes(Date, Obs_deaths - Pred_deaths), color = death_col, size = 1) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
  guides(color = guide_legend(override.aes = list(size = 1.5))) +
  labs(
    y = "Antal",
    title = "Estimat af antallet af ugentlige dødsfald pga. COVID-19",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, data: SSI, Danmarks Statistik"
  ) +
  standard_theme

ggsave("../figures/ntl_nonincidental_deaths.png", width = 18, height = 10, units = "cm", dpi = 300)

pred_obs %>%
  pivot_wider() %>% 
  mutate(covid_deaths = Obs_deaths - Pred_deaths) %>% 
  select(-Obs_deaths) %>% 
  pivot_longer(-Date) %>% 
  filter(
    Date <= floor_date_wday(today, 7),
    Date > ymd("2020-04_01")) %>%
  ggplot() +
  geom_bar(aes(Date, value, fill = name), stat = "identity", position = "fill", width = 7) +
  scale_fill_manual(name = "", labels = c("Ikke tilfældig", "Tilfældig"), values = c("gray85", test_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month", expand = expansion(mult = 0.0)) +
  scale_y_continuous(limits = c(0, NA), labels = function(x) paste0(x * 100, " %"), expand = expansion(mult = 0.02)) +
  guides(color = guide_legend(override.aes = list(size = 1.5))) +
  labs(
    y = "Andel",
    title = 'Estimat af andelen af "tilfældige" Covid dødsfald',
    caption = "Kristoffer T. Bæk, covid19danmark.dk, data: SSI, Danmarks Statistik"
  ) +
  standard_theme

ggsave("../figures/ntl_incidental_deaths_share.png", width = 18, height = 10, units = "cm", dpi = 300)
