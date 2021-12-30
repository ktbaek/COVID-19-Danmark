
read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name == "Percent") %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily), fill = pct_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra), size = 1, color = pct_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month") +
  scale_y_continuous(limits = c(0, NA), labels = function(x) paste0(x, " %")) +
  labs(
    y = "Procent positive",
    x = "Dato",
    title = "Daglig SARS-CoV-2 PCR positivprocent",
    caption = standard_caption
  ) +
  standard_theme

ggsave("../figures/ntl_pct.png", width = 18, height = 10, units = "cm", dpi = 300)
