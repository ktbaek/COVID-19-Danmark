read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name %in% c("Positive", "Deaths")) %>%
  pivot_longer(c(daily, ra), names_to = "type") %>%
  mutate(
    value = ifelse(name == "Deaths", value * 100, value)
  ) %>%
  ggplot() +
  geom_line(aes(Date, value, alpha = type, size = type, color = name)) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Positive",
    sec.axis = sec_axis(~ . / 100, name = "Døde")
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
    labels = c("Døde", "Positive"),
    values = c(death_col, pos_col)
  ) +
  labs(
    y = "Antal",
    x = "Dato",
    title = "Døde med positiv SARS-CoV-2 test vs. antal positivt SARS-CoV-2 testede",
    caption = standard_caption
  ) +
  guides(color = guide_legend(override.aes = list(size = 1))) +
  standard_theme +
  theme(
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, "cm")
  )

ggsave("../figures/ntl_pos_deaths.png", width = 18, height = 10, units = "cm", dpi = 300)
