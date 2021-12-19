pop <- read_csv2("../data/DST_pop_age_sex_19_20_21.csv", col_names = FALSE) %>%
  rename(
    Sex = X3,
    Age = X4,
    `2015_1` = X5,
    `2015_2` = X6,
    `2015_3` = X7,
    `2015_4` = X8,
    `2016_1` = X9,
    `2016_2` = X10,
    `2016_3` = X11,
    `2016_4` = X12,
    `2017_1` = X13,
    `2017_2` = X14,
    `2017_3` = X15,
    `2017_4` = X16,
    `2018_1` = X17,
    `2018_2` = X18,
    `2018_3` = X19,
    `2018_4` = X20,
    `2019_1` = X21,
    `2019_2` = X22,
    `2019_3` = X23,
    `2019_4` = X24,
    `2020_1` = X25,
    `2020_2` = X26,
    `2020_3` = X27,
    `2020_4` = X28,
    `2021_1` = X29,
    `2021_2` = X30,
    `2021_3` = X31,
    `2021_4` = X32,
  ) %>%
  select(-X1, -X2) %>%
  rowwise() %>%
  mutate(
    Age = as.double(str_split(Age, " ")[[1]][1]),
    Sex = str_sub(Sex, 1, 1),
    Sex = ifelse(Sex == "M", "Male", "Female")
  ) %>%
  pivot_longer(-c(Sex, Age), names_to = "Kvartal", values_to = "Population") %>%
  separate(Kvartal, c("Year", "Quarter"), sep = "_") %>%
  mutate(
    Quarter = as.integer(Quarter),
    Year = as.integer(Year)
  ) %>%
  group_by(Year, Quarter, Sex, Age_cut = cut(Age, breaks = c(seq(-1, 99, 5), 125))) %>%
  summarize(Population = sum(Population)) %>%
  rowwise() %>%
  mutate(
    from = as.double(str_split(str_replace_all(Age_cut, "[\\(\\]]", ""), ",")[[1]][1]) + 1,
    to = as.double(str_split(str_replace_all(Age_cut, "[\\(\\]]", ""), ",")[[1]][2]),
    Age = case_when(
      from == 100 ~ "100+",
      TRUE ~ paste(from, to, sep = "-")
    )
  ) %>%
  select(-from, -to, -Age_cut)

pop$Age <- factor(pop$Age, levels = c(
  "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39",
  "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79",
  "80-84", "85-89", "90-94", "95-99", "100+"
))

all_data <- read_csv2("../data/DST_deaths_age_sex.csv", col_names = FALSE) %>%
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
  )



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

plot_data %>%
  filter(Age %in% c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34")) %>%
  ggplot() +
  geom_line(aes(New_date, Cum, color = as.factor(Year_group))) +
  plot_layer

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_young.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(Age %in% c("35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69")) %>%
  ggplot() +
  geom_line(aes(New_date, Cum, color = as.factor(Year_group))) +
  plot_layer

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_mid.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(Age %in% c("70-74", "75-79", "80-84", "85-89", "90-94", "95-99", "100+")) %>%
  ggplot() +
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

all_data %>% 
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


# all_data$Age <- factor(all_data$Age, levels = rev(levels(all_data$Age)))
# 
# p2 <- all_data %>% 
#   group_by(Date, Year, Age) %>% 
#   summarize(Population = sum(Population)) %>% 
#   ggplot() +
#   geom_area(aes(Date, Population, fill = Age, color = Age), alpha = 0.6, position = "fill") +
#   scale_x_date(date_label = "%Y", date_breaks = "3 years", minor_breaks = "1 year") +
#   scale_fill_manual(values = rev(hue_pal()(21))) +
#   scale_color_manual(values = rev(hue_pal()(21))) +
#   scale_y_continuous(labels = function(x) paste0(x * 100, " %")) +
#   facet_theme +
#   theme(
#     legend.position = "none",
#     axis.title.y = element_blank(),
#     panel.grid.minor.x = element_line(size = rel(0.3))
#   )
# 
# p1 + p2 +
#   plot_layout(widths = c(4, 1))





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
