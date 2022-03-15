si <- read_csv("https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/timeseries/stringency_index.csv") %>% 
  filter(country_code == "DNK") %>% 
  select(-`...1`, -country_name, -country_code) %>% 
  pivot_longer(everything(), names_to = "Date", values_to = "SI") %>% 
  mutate(Date = dmy(Date)) %>% 
  fill(SI)

deaths_all <- read_csv2("../data/tidy_DST_daily_deaths_age_sex.csv") %>%
  group_by(Date) %>%
  summarize(Deaths = sum(Deaths, na.rm = TRUE)) %>%
  mutate(
    name = "Daglige dødsfald, alle årsager",
    ra = ra(Deaths)
  ) %>%
  rename(daily = Deaths)

pop <- read_csv2("../data/tidy_DST_pop.csv") %>% 
  filter(Year >= 2021) %>% 
  group_by(Year, Quarter) %>% 
  summarize(Population = sum(Population, na.rm = TRUE))

hosp_data <- read_csv2("../data/tidy_dst_hosp_icu.csv") %>%
  pivot_wider(names_from = "Variable", values_from = "Daily") %>%
  mutate(hosp_no_icu = hospitalized - icu) %>%
  pivot_longer(-Date, values_to = "daily") %>%
  group_by(name) %>%
  mutate(ra = ra(daily)) %>%
  pivot_longer(c(daily, ra), "type", "value")

plot_data <- read_csv2("../data/SSI_daily_data.csv") %>%
  bind_rows(deaths_all) %>%
  pivot_longer(c(daily, ra), names_to = "type", values_to = "value") %>%
  bind_rows(hosp_data) %>% 
  filter(
    Date > ymd("2021-01-01"),
    !name %in% c("Index", "hosp_no_icu")
  ) %>%
  mutate(
    Year = year(Date),
    Quarter = quarter(Date)
  ) %>% 
  left_join(pop, by = c("Year", "Quarter")) %>% 
  mutate(value_per_M = case_when(
    name != "Percent" ~ value / Population * 1e6,
    TRUE ~ value
  )) %>% 
  mutate(name = case_when(
    name == "Positive" ~ "PCR cases",
    name == "Tested" ~ "PCR tested",
    name == "Percent" ~ "PCR positivity rate",
    name == "Admitted" ~ "Admissions w/ positive PCR",
    name == "Deaths" ~ "Deaths w/ positive PCR",
    name == "hospitalized" ~ "Hospitalized w/ positive PCR",
    name == "icu" ~ "In ICU w/ positive PCR",
    name == "Daglige dødsfald, alle årsager" ~ "Deaths all causes",
    TRUE ~ name
  )
  ) %>%
  inner_join(si, by = "Date") 


plot_data$name = factor(plot_data$name, levels = c("PCR cases", "PCR tested", "PCR positivity rate", "Deaths w/ positive PCR",
                                                   "Admissions w/ positive PCR", "Hospitalized w/ positive PCR", "In ICU w/ positive PCR",
                                                   "Deaths all causes"))

Sys.setlocale("LC_ALL", "en_US.UTF-8")

plot_data %>% 
  filter(Date > "2021-09-01") %>% 
  ggplot() +
  geom_rect(aes(xmin=Date,xmax=Date+1,ymin = -Inf, ymax = Inf, 
                fill=SI), alpha = 0.2) +
  geom_line(aes(Date, value_per_M, size = type, alpha = type), color = admit_col) +
  scale_y_continuous(limits = c(0, NA)) +
  scale_x_date(labels = my_date_labels_en, date_breaks = "2 months", minor_breaks = "1 month", expand = expansion(mult = 0.01)) +
  scale_color_manual(name = "", values = c(test_col, pos_col)) +
  scale_size_manual(
    guide = FALSE,
    values = c(0.3, 1)
  ) +
  scale_alpha_manual(
    guide = FALSE,
    values = c(0.7, 1)
  ) +
  scale_fill_continuous(name = "Stringency Index", low = "#DADADA70", high = "#5D5D5D70") +
  labs(
    y = "Number per 1M/percent",
    x = "Date",
    title = "COVID-19 daily indicators and Stringency Index, Denmark",
    subtitle = "All numbers, except positivity rate (%), are per 1 million people",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, data: SSI, Danmarks Statistik, Oxford Covid-19 Government Response Tracker"
  ) +
  guides(
    color = guide_legend(override.aes = list(size = 1)),
    fill = guide_colourbar(barwidth = 8, barheight = 0.5)
  ) +
  facet_wrap(~name, ncol = 4, scales = "free_y") +
  facet_theme +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    axis.ticks.x = element_line(size = 0.2, color = "gray40"),
    axis.ticks.y = element_line(size = 0.2, color = "gray40"),
    axis.text.x = element_text(margin = margin(t = 2, r = 0, b = 0, l = 0)),
    plot.margin = margin(0.5, 0.5, 0.25, 0.5, "cm"),
    legend.text = element_text(size = rel(0.9)),
    plot.caption = element_text(size = rel(1))
  )

ggsave("../figures/ntl_indicators_SI.png", width = 20, height = 11, units = "cm", dpi = 300)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")
