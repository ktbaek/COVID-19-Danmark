x <- read_csv2("../data/DST_tidy_daily_deaths_age.csv") %>%
  mutate(
    Age = case_when(
      Age == "0-4" ~ "0-49",
      Age == "5-9" ~ "0-49",
      Age == "10-14" ~ "0-49",
      Age == "15-19" ~ "0-49",
      Age == "20-24" ~ "0-49",
      Age == "25-29" ~ "0-49",
      Age == "30-34" ~ "0-49",
      Age == "35-39" ~ "0-49",
      Age == "40-44" ~ "0-49",
      Age == "45-49" ~ "0-49",
      Age == "50-54" ~ "50-59",
      Age == "55-59" ~ "50-59",
      Age == "60-64" ~ "60-69",
      Age == "65-69" ~ "60-69",
      Age == "70-74" ~ "70-79",
      Age == "75-79" ~ "70-79",
      Age == "80-84" ~ "80-89",
      Age == "85-89" ~ "80-89",
      Age == "90-94" ~ "90+",
      Age == "95-99" ~ "90+",
      Age == "100+" ~ "90+",
      TRUE ~ Age
    )
  ) %>%
  group_by(Age, Date) %>%
  summarize(Deaths = sum(Deaths, na.rm = TRUE)) %>%
  mutate(
    md = paste0(str_sub(Date, 6, 7), str_sub(Date, 9, 10)),
    year = year(Date)
  ) %>%
  select(-Date) %>%
  bind_rows(cbind(dst_dd_age_5yr, year = as.double("2019"))) %>%
  group_by(Age, year) %>%
  arrange(md) %>%
  filter(md != "0229") %>%
  mutate(
    ra_deaths = ra(Deaths),
    year = ifelse(year == 2019, "z2019", as.character(year))
  ) %>%
  mutate(Date = ymd(paste("2019", str_sub(md, 1, 2), str_sub(md, 3, 4), sep = "-")))

x %>%
  ggplot() +
  geom_area(data = subset(x, year == "z2019"), aes(Date, ra_deaths), fill = hue_pal()(3)[3], alpha = 0.2) +
  geom_line(aes(Date, ra_deaths, color = year, size = year)) +
  scale_size_manual(
    name = "",
    values = c(0.2, 0.2, 0.05),
    guide = FALSE
  ) +
  facet_wrap(~Age, ncol = 6) +
  scale_x_date(date_labels = "%b", breaks = c(ymd("2019-01-01"), ymd("2019-07-01")), date_minor_breaks = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    x = "Dato",
    y = "Antal døde",
    title = "Daglige dødsfald i Danmark per alder",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik"
  ) +
  scale_colour_discrete(
    name = "",
    labels = c("2020", "2021", "Gennemsnit 2015-19 (justeret til 2020 befolkningstal)")
  ) + # ,
  # values = c(admit_col, pct_col, darken("#16697a", .5))) +
  guides(color = guide_legend(override.aes = list(size = 2))) +
  standard_theme


ggsave("../figures/ntl_deaths_age_total.png", width = 18, height = 10, units = "cm", dpi = 300)
