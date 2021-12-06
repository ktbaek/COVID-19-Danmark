read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name %in% c("Percent", "Deaths")) %>%
  filter(Date > ymd("2020-03-14")) %>%
  pivot_longer(c(daily, ra), names_to = "type") %>%
  mutate(
    value = ifelse(name == "Deaths", value / 4, value)
  ) %>%
  ggplot() +
  geom_line(aes(Date, value, alpha = type, size = type, color = name)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Positivprocent",
    labels = function(x) paste0(x, " %"),
    sec.axis = sec_axis(~ . * 4, name = "Døde")
  ) +
  scale_size_manual(
    name = "",
    labels = c("Dagligt", "7-dages gennemsnit"),
    values = c(0.3, 1),
    guide = FALSE
  ) +
  scale_alpha_manual(
    name = "",
    labels = c("Dagligt", "7-dages gennemsnit"),
    values = c(0.6, 1),
    guide = FALSE
  ) +
  scale_color_manual(
    name = "",
    labels = c("Døde", "Positivprocent"),
    values = c(death_col, pct_col)
  ) +
  labs(
    y = "Antal",
    x = "Dato",
    title = "Døde med positiv SARS-CoV-2 test vs. procent positivt SARS-CoV-2 testede",
    caption = standard_caption
  ) +
  guides(color = guide_legend(override.aes = list(size = 1))) +
  standard_theme +
  theme(
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, "cm")
  )

ggsave("../figures/ntl_pct_deaths.png", width = 18, height = 10, units = "cm", dpi = 300)
