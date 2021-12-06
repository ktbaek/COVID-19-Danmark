read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name == "Admitted") %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily), fill = admit_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra), size = 1, color = admit_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Antal",
    x = "Dato",
    title = "Dagligt antal nyindlagte med positiv SARS-CoV-2 test",
    caption = standard_caption
  ) +
  standard_theme

ggsave("../figures/ntl_hosp.png", width = 18, height = 10, units = "cm", dpi = 300)
