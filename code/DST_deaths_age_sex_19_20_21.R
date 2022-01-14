pop <- read_tidy_age(get_age_breaks(maxage = 100, agesplit = 5))

pop$Age <- factor(pop$Age, levels = c(
  "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39",
  "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79",
  "80-84", "85-89", "90-94", "95-99", "100+"
))

all_data <- read_csv2("../data/DST_deaths_daily_age.csv", col_names = FALSE) %>%
  rename(
    Male = X3,
    Female = X4,
    Date = X2,
    Age = X1
  ) %>%
  mutate(
    Date = ymd(paste0(str_sub(Date, 1, 4), "-", str_sub(Date, 6, 7), "-", str_sub(Date, 9, 10))),
    Age = str_sub(Age, 1, nchar(Age) - 3),
    Age = ifelse(str_detect(Age, "100"), "100+", Age)
  ) %>%
  distinct() %>%
  mutate(
    Year = as.integer(year(Date)),
    New_date = `year<-`(Date, 2020)
  ) %>%
  pivot_longer(c(Male, Female), names_to = "Sex", values_to = "Daily") %>%
  mutate(Quarter = quarter(Date)) %>%
  full_join(pop, by = c("Age", "Year", "Quarter", "Sex")) %>%
  arrange(Date)

all_data %>%
  select(Date, Year, Age, Sex, Population, Daily, -New_date) %>%
  rename(Daily_deaths = Daily) %>%
  write_csv2("../data/tidy_dst_age_sex_2015_21.csv")

all_data$Age <- factor(all_data$Age, levels = c(
  "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39",
  "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79",
  "80-84", "85-89", "90-94", "95-99", "100+"
))

minmax_years <- all_data %>% 
  filter(Year %in% c(2015:2019)) %>% 
  group_by(Year, Age, Sex) %>% 
  summarize(sum = sum(Daily, na.rm = TRUE)) %>% 
  group_by(Age, Sex) %>% 
  summarize(
    min = Year[which.min(sum)], 
    max = Year[which.max(sum)]
  ) %>% 
  pivot_longer(c(min, max), names_to = "type", values_to = "Year")
    
minmax <- all_data %>% 
  right_join(minmax_years, by = c("Age", "Sex", "Year")) %>% 
  select(-Date, -Year, -Population, - Quarter) %>% 
  pivot_wider(names_from = type, values_from = Daily) %>% 
  arrange(New_date) %>% 
  group_by(Age, Sex) %>% 
  mutate(
    min = cumsum(replace_na(min, 0)),
    max = cumsum(replace_na(max, 0)),
  ) %>% 
  arrange(Age, New_date)
  

plot_data <- all_data %>%
  mutate(Daily_relative = Daily / Population * 100000) %>% 
  group_by(Year_group = ifelse(Year %in% c(2015:2019), "2015-2019", as.character(Year)), Age, Sex, New_date) %>%
  summarize(
    Daily = mean(Daily, na.rm = TRUE),
    Daily_relative = mean(Daily_relative, na.rm = TRUE)) %>% 
  group_by(Year_group, Age, Sex) %>% 
  arrange(New_date) %>%
  mutate(
    Cum = cumsum(replace_na(Daily, 0)),
    Cum_relative = cumsum(replace_na(Daily_relative, 0)),
  ) %>% 
  full_join(minmax, by = c("New_date", "Age", "Sex"))



plot_layer <- list(
  scale_x_date(date_labels = "%e %b", date_breaks = "4 months", minor_breaks = "1 month"),
  scale_color_manual(name = "", values = rev(hue_pal()(3))),
  labs(
    y = "Cumulated deaths",
    caption = "Kristoffer T. Bæk, data: Danmarks Statistik"
  ),
  facet_wrap(Sex ~ Age, scales = "free_y", ncol = 7),
  guides(color = guide_legend(override.aes = list(size = 1))),
  facet_theme,
  theme(
    strip.text = element_text(margin = margin(t = 2)),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
    plot.margin = margin(0.6, 0.6, 0.3, 0.6, "cm"),
    panel.grid.minor.x = element_blank()
  )
)

Age_range <- c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34")

plot_data %>%
  filter(Age %in% Age_range) %>%
  ggplot() +
  geom_ribbon(data = filter(plot_data, Year_group == "2015-2019", Age %in% Age_range), aes(New_date, ymin = min, ymax = max), alpha = 0.2, fill = hue_pal()(3)[3]) +
  geom_line(aes(New_date, Cum, color = as.factor(Year_group))) +
  plot_layer

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_young.png", width = 18, height = 10, units = "cm", dpi = 300)

Age_range <- c("35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69")

plot_data %>%
  filter(Age %in% Age_range) %>%
  ggplot() +
  geom_ribbon(data = filter(plot_data, Year_group == "2015-2019", Age %in% Age_range), aes(New_date, ymin = min, ymax = max), alpha = 0.2, fill = hue_pal()(3)[3]) +
  geom_line(aes(New_date, Cum, color = as.factor(Year_group))) +
  plot_layer

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_mid.png", width = 18, height = 10, units = "cm", dpi = 300)

Age_range <- c("70-74", "75-79", "80-84", "85-89", "90-94", "95-99", "100+")

plot_data %>%
  filter(Age %in% Age_range) %>%
  ggplot() +
  geom_ribbon(data = filter(plot_data, Year_group == "2015-2019", Age %in% Age_range), aes(New_date, ymin = min, ymax = max), alpha = 0.2, fill = hue_pal()(3)[3]) +
  geom_line(aes(New_date, Cum, color = as.factor(Year_group))) +
  plot_layer

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_old.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(Age %in% c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34")) %>%
  ggplot() +
  geom_line(aes(New_date, Cum_relative, color = as.factor(Year_group))) +
  plot_layer +
  labs(
    y = "Cumulated deaths per 100,000",
    caption = "Kristoffer T. Bæk, data: Danmarks Statistik"
  )

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_rel_young.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(Age %in% c("35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69")) %>%
  ggplot() +
  geom_line(aes(New_date, Cum_relative, color = as.factor(Year_group))) +
  plot_layer +
  labs(
    y = "Cumulated deaths per 100,000",
    caption = "Kristoffer T. Bæk, data: Danmarks Statistik"
  )

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_rel_mid.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(Age %in% c("70-74", "75-79", "80-84", "85-89", "90-94", "95-99", "100+")) %>%
  ggplot() +
  geom_line(aes(New_date, Cum_relative, color = as.factor(Year_group))) +
  plot_layer +
  labs(
    y = "Cumulated deaths per 100,000",
    caption = "Kristoffer T. Bæk, data: Danmarks Statistik"
  )

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_rel_old.png", width = 18, height = 10, units = "cm", dpi = 300)

x <- all_data %>% 
  group_by(Date, Year, Age) %>% 
  summarize(Population = sum(Population)) %>% 
  ggplot() +
  geom_area(aes(Date, Population, fill = Age, color = Age), alpha = 0.4, size = 0.6, position = "stack") +
  scale_x_date(date_label = "%Y", date_breaks = "3 years", minor_breaks = "1 year") +
  facet_wrap(~ Age, ncol = 7) +
  scale_y_continuous(labels = scales::number) +
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

ggsave("../figures/DST_deaths_19_20_21/dst_pop_age_2015_21.png", width = 18, height = 10, units = "cm", dpi = 300)


all_data %>%
  group_by(Year, Date) %>% 
  summarize(
    Population = sum(Population, na.rm = TRUE),
    Daily = sum(Daily, na.rm = TRUE),
    Daily_relative = Daily / Population * 100000
  ) %>% 
  mutate(
    New_date = `year<-`(Date, 2020)
  ) %>% 
  group_by(Year_group = ifelse(Year %in% c(2015:2019), "2015-2019", as.character(Year)), New_date) %>%
  summarize(
    Daily = mean(Daily, na.rm = TRUE),
    Daily_relative = mean(Daily_relative, na.rm = TRUE)
  ) %>% 
  arrange(New_date) %>%
  mutate(
    Cum = cumsum(replace_na(Daily, 0)),
    Cum_relative = cumsum(replace_na(Daily_relative, 0)),
  ) %>% 
  pivot_longer(c(Cum, Cum_relative)) %>% 
  ggplot() +
  geom_line(aes(New_date, value, color = as.factor(Year_group))) +
  scale_x_date(date_labels = "%e %b", date_breaks = "3 months", minor_breaks = "1 month") +
scale_color_manual(name = "", values = rev(hue_pal()(3))) +
guides(color = guide_legend(override.aes = list(size = 1))) +
  facet_wrap(~ name, labeller = labeller(name = c("Cum" = "Antal døde", "Cum_relative" = "Antal døde per 100.000")), scales = "free") +
facet_theme +
theme(
  axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
  plot.margin = margin(0.6, 0.6, 0.3, 0.6, "cm"),
  panel.grid.minor.x = element_blank()
) +
  labs(
    y = "Cumulated deaths per 100,000",
    caption = "Kristoffer T. Bæk, data: Danmarks Statistik"
  )

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_cum_rel_all.png", width = 18, height = 10, units = "cm", dpi = 300)
