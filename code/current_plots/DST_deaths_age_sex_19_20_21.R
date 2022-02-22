pop <- get_pop_by_breaks(age_breaks = get_age_breaks(maxage = 100, agesplit = 5))

pop$Age <- factor(pop$Age, levels = c(
  "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39",
  "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79",
  "80-84", "85-89", "90-94", "95-99", "100+"
))

all_data <- read_csv2("../data/tidy_DST_daily_deaths_age_sex.csv") %>%
  mutate(
    Year = as.integer(year(Date)),
    Quarter = quarter(Date),
    New_date = `year<-`(Date, 2021)
  ) %>%
  full_join(pop, by = c("Age", "Year", "Quarter", "Sex")) %>%
  filter(Year >= 2015) %>%
  arrange(Date) %>%
  group_by(Age, Sex) %>%
  fill(Population)

all_data %>%
  select(Date, Year, Age, Sex, Population, Deaths, -New_date) %>%
  write_csv2("../data/tidy_dst_age_sex_2015_22.csv")

all_data$Age <- factor(all_data$Age, levels = c(
  "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39",
  "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79",
  "80-84", "85-89", "90-94", "95-99", "100+"
))

plot_data <- all_data %>%
  mutate(Deaths_relative = Deaths / Population * 100000) %>%
  mutate(Year_group = ifelse(Year %in% c(2015:2019), "2015-2019", as.character(Year))) %>%
  group_by(Year, Age, Sex) %>%
  arrange(New_date) %>%
  mutate(
    Cum = cumsum(replace_na(Deaths, 0)),
    Cum_relative = cumsum(replace_na(Deaths_relative, 0)),
  )

plot_layer <- list(
  scale_x_date(date_labels = "%e %b", date_breaks = "4 months", minor_breaks = "1 month"),
  scale_color_manual(name = "", values = rev(hue_pal()(4))),
  scale_alpha_manual(name = "", values = c(0.2, 1, 1, 1)),
  labs(
    y = "Cumulated deaths",
    caption = "Kristoffer T. Bæk, data: Danmarks Statistik"
  ),
  facet_wrap(Sex ~ Age, scales = "free_y", ncol = 7),
  guides(color = guide_legend(override.aes = list(alpha = 1, size = 1))),
  facet_theme,
  theme(
    strip.text = element_text(margin = margin(t = 2)),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
    plot.margin = margin(0.6, 0.6, 0.3, 0.6, "cm"),
    panel.grid.minor.x = element_blank()
  )
)

plot_cum_deaths <- function(df, age_range) {
  df %>%
    filter(Age %in% age_range) %>%
    ggplot() +
    geom_line(aes(New_date, Cum, group = Year, alpha = as.factor(Year_group), color = as.factor(Year_group))) +
    plot_layer
}

plot_data %>% plot_cum_deaths(c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34"))
ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_young.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% plot_cum_deaths(c("35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69"))
ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_mid.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% plot_cum_deaths(c("70-74", "75-79", "80-84", "85-89", "90-94", "95-99", "100+"))
ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_old.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_cumrel_deaths <- function(df, age_range) {
  df %>%
    filter(Age %in% age_range) %>%
    ggplot() +
    geom_line(aes(New_date, Cum_relative, group = Year, alpha = as.factor(Year_group), color = as.factor(Year_group))) +
    plot_layer +
    labs(
      y = "Cumulated deaths per 100,000",
      caption = "Kristoffer T. Bæk, data: Danmarks Statistik"
    )
}

plot_data %>% plot_cumrel_deaths(c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34"))
ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_rel_young.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% plot_cumrel_deaths(c("35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69"))
ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_rel_mid.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% plot_cum_deaths(c("70-74", "75-79", "80-84", "85-89", "90-94", "95-99", "100+"))
ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_cum_rel_old.png", width = 18, height = 10, units = "cm", dpi = 300)


# Plot population over time -----------------------------------------------

all_pop_data <- read_csv2("../data/tidy_dst_age_sex_2015_22.csv") %>%
  select(-Deaths) %>%
  group_by(Date, Age) %>%
  summarize(Population = sum(Population)) %>%
  filter(Date == floor_date(Date, "month"))

all_pop_data$Age <- factor(all_pop_data$Age, levels = c(
  "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39",
  "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79",
  "80-84", "85-89", "90-94", "95-99", "100+"
))

all_pop_data %>%
  ggplot() +
  geom_area(aes(Date, Population, fill = Age, color = Age), alpha = 0.4, size = 0.6, position = "stack") +
  scale_x_date(date_label = "%Y", date_breaks = "3 years", minor_breaks = "1 year") +
  facet_wrap(~Age, ncol = 7) +
  scale_y_continuous(labels = scales::number) +
  labs(
    title = "Befolkningsudvikling 2015-nu",
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


# Plot excess deaths ------------------------------------------------------

baseline <- all_data %>%
  mutate(Deaths_relative = Deaths / Population * 100000) %>%
  mutate(Year_group = ifelse(Year %in% c(2015:2019), "2015-2019", as.character(Year))) %>%
  filter(Year_group == "2015-2019") %>%
  group_by(Year, Age, Sex) %>%
  arrange(Date) %>%
  mutate(
    Cum = cumsum(replace_na(Deaths, 0)),
    Cum_relative = cumsum(replace_na(Deaths_relative, 0)),
  ) %>%
  group_by(New_date, Age, Sex) %>%
  summarize(
    Cum_baseline = mean(Cum),
    Cum_rel_baseline = mean(Cum_relative)
  )

plot_data <- all_data %>%
  mutate(Deaths_relative = Deaths / Population * 100000) %>%
  mutate(Year_group = ifelse(Year %in% c(2015:2019), "2015-2019", as.character(Year))) %>%
  group_by(Year, Age, Sex) %>%
  arrange(Date) %>%
  mutate(
    Cum = cumsum(replace_na(Deaths, 0)),
    Cum_relative = cumsum(replace_na(Deaths_relative, 0)),
  ) %>%
  full_join(baseline, by = c("New_date", "Age", "Sex")) %>%
  mutate(xs_rel_deaths = Cum_relative - Cum_rel_baseline) %>%
  filter(!is.na(New_date))

plot_layer <- list(
  scale_x_date(date_labels = "%e %b", date_breaks = "4 months", minor_breaks = "1 month"),
  scale_color_manual(name = "", values = c(rev(hue_pal()(3)), hue_pal()(6)[2])),
  scale_alpha_manual(name = "", values = c(0.2, 1, 1, 1)),
  labs(
    y = "Excess cumulated deaths per 100,000",
    subtitle = "Indicates excess yearly cumulated deaths per 100,000 in the gender- and age group. The baseline is mean cumulated deaths per 100,000 for 2015-2019.",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, data: Danmarks Statistik"
  ),
  facet_wrap(Sex ~ Age, scales = "free_y", ncol = 7),
  guides(color = guide_legend(override.aes = list(alpha = 1, size = 1))),
  facet_theme,
  theme(
    strip.text = element_text(margin = margin(t = 2)),
    axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1),
    plot.margin = margin(0.6, 0.6, 0.3, 0.6, "cm"),
    panel.grid.minor.x = element_blank(),
    plot.subtitle = element_textbox(
      width = unit(0.6, "npc"),
      lineheight = rel(1.2),
      margin = margin(0, 0, 0.6, 0, "cm"),
    )
  )
)

plot_xs_deaths <- function(df, age_range) {
  df %>%
    filter(Age %in% age_range) %>%
    ggplot() +
    geom_hline(yintercept = 0, color = "gray70", size = 0.2) +
    geom_line(aes(New_date, xs_rel_deaths, group = Year, alpha = as.factor(Year_group), color = as.factor(Year_group))) +
    plot_layer
}

plot_data %>%
  plot_xs_deaths(c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34")) +
  labs(title = "Excess deaths, 0-34 yo, Denmark")

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_xscum_rel_young.png", width = 22.5, height = 12.5, units = "cm", dpi = 300)

plot_data %>%
  plot_xs_deaths(c("35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69")) +
  labs(title = "Excess deaths, 35-69 yo, Denmark")

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_xscum_rel_mid.png", width = 22.5, height = 12.5, units = "cm", dpi = 300)

plot_data %>%
  plot_xs_deaths(c("70-74", "75-79", "80-84", "85-89", "90-94", "95-99", "100+")) +
  labs(title = "Excess deaths, 70+ yo, Denmark")

ggsave("../figures/DST_deaths_19_20_21/dst_deaths_age_sex_xscum_rel_old.png", width = 22.5, height = 12.5, units = "cm", dpi = 300)
