cols <- c("all" = lighten("#16697a", 0.4), "covid" = "#ffa62b", "average" = darken("#16697a", .4))

deaths <- read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name == "Deaths") %>%
  rename(Covid = daily) %>%
  select(Date, Covid)

deaths_avg <- read_csv2("../data/tidy_DST_daily_deaths_age_sex.csv") %>%
  group_by(Date) %>%
  summarize(Deaths = sum(Deaths, na.rm = TRUE)) %>%
  mutate(
    Week = isoweek(Date),
    Year = year(Date)
  ) %>%
  filter(Year %in% c(2015:2019)) %>%
  group_by(Week) %>%
  summarize(avg_5yr = mean(Deaths, na.rm = TRUE))

plot_data <- read_csv2("../data/tidy_DST_daily_deaths_age_sex.csv") %>%
  filter(year(Date) >= 2020) %>%
  group_by(Date) %>%
  summarize(Deaths = sum(Deaths, na.rm = TRUE)) %>%
  mutate(Week = isoweek(Date)) %>%
  full_join(deaths, by = "Date") %>%
  full_join(deaths_avg, by = "Week") %>%
  mutate(avg_5yr = ifelse(wday(Date) == 2, avg_5yr, NA))

plot_data %>%
  ggplot() +
  geom_bar(aes(Date, Deaths, fill = "all"), width = 1, stat = "identity", position = "identity") +
  geom_bar(aes(Date, Covid, fill = "covid"), width = 1, stat = "identity", position = "identity") +
  geom_line(data = plot_data[!is.na(plot_data$avg_5yr), ], aes(Date, avg_5yr, color = "average"), size = 1) +
  scale_x_date(labels = my_date_labels, breaks = "3 months", minor_breaks = "1 month") +
  labs(
    x = "Dato",
    y = "Antal døde",
    title = "Daglige dødsfald i Danmark",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, data: Danmarks Statistik og SSI"
  ) +
  scale_fill_manual(name = "", labels = c("Alle", "COVID-19"), values = cols[1:2]) +
  scale_color_manual(name = "", labels = c("Gennemsnit 2015-19", "Gennemsnit alle 2020"), values = cols[3])

ggsave("../figures/dst_deaths_covid_all.png", width = 18, height = 12, units = "cm", dpi = 300)

plot_data <- read_csv2("../data/tidy_DST_daily_deaths_age_sex.csv") %>%
  filter(year(Date) >= 2020) %>%
  group_by(Date) %>%
  summarize(Deaths = sum(Deaths, na.rm = TRUE)) %>%
  mutate(Week = isoweek(Date)) %>%
  full_join(deaths, by = "Date") %>%
  full_join(deaths_avg, by = "Week") %>%
  mutate(avg_5yr = ifelse(wday(Date) == 2, avg_5yr, NA)) %>%
  mutate(Covid = ifelse(is.na(Covid), 0, Covid)) %>%
  mutate(Non_covid = Deaths - Covid) %>%
  select(-Deaths, -Week) %>%
  filter(!is.na(Non_covid)) %>%
  pivot_longer(-Date, names_to = "variable", values_to = "value")

cols <- c("all" = lighten("#16697a", 0.4), "covid" = "#ffa62b", "average" = darken("#16697a", .4))

ggplot(plot_data) +
  geom_bar(data = subset(plot_data, variable %in% c("Non_covid", "Covid")), stat = "identity", position = "stack", aes(Date, value, fill = variable), width = 1) +
  geom_line(data = plot_data[plot_data$variable == "avg_5yr" & !is.na(plot_data$value), ], aes(Date, value, color = "average"), size = 1) +
  scale_x_date(labels = my_date_labels, breaks = "3 months", minor_breaks = "1 month") +
  labs(
    x = "Dato",
    y = "Antal døde",
    title = "Daglige dødsfald i Danmark",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, data: Danmarks Statistik og SSI"
  ) +
  scale_fill_manual(name = "", labels = c("COVID-19", "Ikke COVID-19"), values = c("#ffa62b", lighten("#16697a", 0.4))) +
  scale_color_manual(name = "", labels = c("Gennemsnit 2015-19", "", ""), values = rep(cols[3], 3))

ggsave("../figures/dst_deaths_covid_all_2.png", width = 18, height = 12, units = "cm", dpi = 300)
