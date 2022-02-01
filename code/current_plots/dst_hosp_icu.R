read_csv2("../data/tidy_dst_hosp_icu.csv") %>%
  group_by(Variable) %>% 
  mutate(ra = ra(Daily)) %>% 
  pivot_longer(c(Daily, ra), "type", "value") %>% 
  ggplot() +
  geom_line(aes(Date, value, alpha = type, size = type, color = Variable)) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
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
    labels = c("Intensiv", "Indlagte"),
    values = c(darken(admit_col, 0.6), admit_col)
  ) +
  labs(
    y = "Antal",
    x = "Dato",
    title = "Indlagte med positiv SARS-CoV-2 test",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, data: Danmarks Statistik"
  ) +
  guides(color = guide_legend(override.aes = list(size = 1))) +
  standard_theme +
  theme(
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, "cm")
  )

ggsave("../figures/dst_hosp_icu.png", width = 18, height = 10, units = "cm", dpi = 300)
