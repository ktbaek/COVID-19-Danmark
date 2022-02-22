
deaths_all <- read_csv2("../data/tidy_DST_daily_deaths_age_sex.csv") %>%
  group_by(Date) %>%
  summarize(Deaths = sum(Deaths, na.rm = TRUE)) %>%
  mutate(
    name = "Daglige dødsfald, alle årsager",
    ra = ra(Deaths)
  ) %>%
  rename(daily = Deaths)

read_csv2("../data/SSI_daily_data.csv") %>%
  mutate(name = case_when(
    name == "Positive" ~ "Daglige PCR positive",
    name == "Tested" ~ "Daglige PCR testede",
    name == "Percent" ~ "Daglig PCR positivprocent",
    name == "Admitted" ~ "Daglige indlæggelser",
    name == "Deaths" ~ "Daglige dødsfald, COVID"
  )) %>%
  filter(name != "Index") %>%
  bind_rows(deaths_all) %>%
  mutate(
    year = year(Date),
    new_date = case_when(
      year == 2020 ~ `year<-`(Date, 2021),
      year == 2021 & month(Date) < 9 ~ `year<-`(Date, 2022),
      TRUE ~ Date
    ),
    year = case_when(
      year == 2020 ~ "2020/21",
      year == 2021 & month(Date) < 9 ~ "2020/21",
      TRUE ~ "2021/22"
    )
  ) %>%
  pivot_longer(c(daily, ra), names_to = "type", values_to = "value") %>%
  filter(new_date > "2021-09-30", new_date <= "2022-02-28") %>%
  ggplot() +
  geom_line(aes(new_date, value, color = as.factor(year), size = type, alpha = type)) +
  scale_y_continuous(limits = c(0, NA)) +
  scale_x_date(labels = my_date_labels_no_year, date_breaks = "2 months", minor_breaks = "1 month") +
  scale_color_manual(name = "", values = c(test_col, pos_col)) +
  scale_size_manual(
    guide = FALSE,
    values = c(0.3, 1)
  ) +
  scale_alpha_manual(
    guide = FALSE,
    values = c(0.6, 1)
  ) +
  labs(
    y = "Antal/procent",
    x = "Dato",
    title = "SARS-CoV-2, efterår/vinter 2021 vs 2020, Danmark",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, data: SSI, Danmarks Statistik"
  ) +
  guides(color = guide_legend(override.aes = list(size = 1))) +
  facet_wrap(~name, scales = "free_y") +
  facet_theme +
  theme(
    axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0)),
    plot.margin = margin(0.6, 0.6, 0.3, 0.6, "cm"),
    legend.margin = margin(0, 0, 4, 0),
  )

ggsave("../figures/ntl_fall_20_21.png", width = 18, height = 10, units = "cm", dpi = 300)
