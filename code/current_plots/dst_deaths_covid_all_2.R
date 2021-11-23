cols <- c("all" = lighten("#16697a", 0.4),"covid" = "#ffa62b", "average" = darken("#16697a", .4))

deaths <- read_csv2("../data/SSI_plot_data.csv") %>% 
  filter(name == "Deaths") %>% 
  select(Date, daily)

deaths_avg <- read_data("../data/DST_daily_deaths_5yr.csv", col_names = TRUE) %>%
  mutate(md = paste0(sprintf("%02d", Month), str_sub(Day, 2, 3))) %>%
  select(-Month, -Day) %>%
  pivot_longer(-md, names_to = "year", values_to = "Deaths") %>%
  mutate(
    Deaths = ifelse(Deaths == "..", NA, Deaths),
    Deaths = as.double(Deaths)) %>%
  group_by(md) %>%
  summarize(
    avg_5yr = mean(Deaths, na.rm = TRUE),
    max_5yr = max(Deaths, na.rm = TRUE),
    min_5yr = min(Deaths, na.rm = TRUE)
  ) %>%
  ungroup()

plot_data <- dst_deaths %>%
  mutate(md = paste0(str_sub(Date, 6, 7), str_sub(Date, 9, 10))) %>%
  mutate(Date = ymd(paste0(str_sub(Date, 1, 4), "-", str_sub(Date, 6, 7), "-", str_sub(Date, 9, 10)))) %>%
  full_join(deaths, by = "Date") %>%
  full_join(deaths_avg, by = "md") %>%
  group_by(Date_wk = floor_date(Date + 4, "1 week")) %>%
  mutate(smooth_avg = mean(avg_5yr, na.rm = TRUE)) %>%
  mutate(smooth_avg = ifelse(Date == Date_wk, smooth_avg, NA)) %>%
  ungroup() %>%
  select(-Date_wk) %>%
  mutate(Antal_døde = ifelse(is.na(daily), 0, daily)) %>%
  mutate(Non_covid = current - daily) %>%
  select(-current, -md) %>%
  filter(!is.na(Non_covid)) %>%
  pivot_longer(-Date, names_to = "variable", values_to = "value") 

cols <- c("all" = lighten("#16697a", 0.4),"covid" = "#ffa62b", "average" = darken("#16697a", .4))

ggplot(plot_data) +
  geom_bar(data = subset(plot_data, variable %in% c("Non_covid", "Antal_døde")), stat="identity", position = "stack", aes(Date, value, fill = variable), width = 1) +
  geom_line(data = plot_data[plot_data$variable == "smooth_avg" & !is.na(plot_data$value), ], aes(Date, value, color = "average"), size = 1) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month") +
  labs(x = "Dato", y = "Antal døde", title = "Daglige dødsfald i Danmark", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik og SSI") +
  scale_fill_manual(name = "", labels = c("COVID-19", "Ikke COVID-19"), values = c("#ffa62b", lighten("#16697a", 0.4))) +
  scale_color_manual(name = "", labels = c("Gennemsnit 2015-19", "", ""), values = rep(cols[3],3)) +
  standard_theme  

ggsave("../figures/dst_deaths_covid_all_2.png", width = 18, height = 12, units = "cm", dpi = 300)