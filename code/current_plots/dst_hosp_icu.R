plot_data <- read_csv2("../data/tidy_dst_hosp_icu.csv") %>%
  pivot_wider(names_from = "Variable", values_from = "Daily") %>%
  mutate(hosp_no_icu = hospitalized - icu) %>%
  pivot_longer(-Date, values_to = "daily") %>%
  group_by(name) %>%
  mutate(ra = ra(daily)) %>%
  pivot_longer(c(daily, ra), "type", "value")

plot_data %>%
  ggplot() +
  geom_bar(data = subset(plot_data, type != "ra" & name != "hospitalized"), stat = "identity", position = "stack", aes(Date, value, fill = name), alpha = 0.6, width = 1) +
  geom_line(data = subset(plot_data, type == "ra" & name == "hospitalized"), aes(Date, value), size = 1, color = admit_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
  scale_fill_manual(
    name = "Heraf:",
    labels = c("Ikke-intensiv", "Intensiv"),
    values = c(lighten(admit_col, 0.4), darken(admit_col, 0.6))
  ) +
  labs(
    y = "Antal",
    x = "Dato",
    title = "Indlagte med positiv SARS-CoV-2 test",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, data: Danmarks Statistik"
  ) +
  theme(
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, "cm")
  )

ggsave("../figures/dst_hosp_icu.png", width = 18, height = 10, units = "cm", dpi = 300)
