
read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name == "Positive") %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily), fill = pos_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra), size = 1, color = pos_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Antal positive",
    x = "Dato",
    title = "Dagligt antal positivt SARS-CoV-2 testede",
    caption = standard_caption
  ) +
  standard_theme

ggsave("../figures/ntl_pos.png", width = 18, height = 10, units = "cm", dpi = 300)
