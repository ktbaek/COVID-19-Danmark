read_csv2("../data/SSI_plot_data.csv") %>%
  filter(name %in% c("Index", "Percent")) %>% 
  mutate(
    daily = ifelse(name == "Index", daily * 4, daily),
    ra = ifelse(name == "Index", ra * 4, ra)
  ) %>% 
  pivot_longer(c(daily, ra), names_to = "type") %>% 
  filter(Date > ymd("2020-03-14")) %>% 
  ggplot() +
  geom_line(aes(Date, value, alpha = type, size = type, color = name)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(
    limits = c(0, 5),
    name = "Positivprocent",
    labels = function(x) paste0(x, " %"),
    sec.axis = sec_axis(~ . / 4, name = "Index", breaks = c(0, 0.5, 1))
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
    labels = c("Index", "Percent"), 
    values = c(darken(pct_col, 0.3), lighten(pct_col, 0.3)),
    guide = FALSE
  ) +
  labs(
    y = "Indeks", 
    x = "Dato", 
    title = "Antal SARS-CoV-2 positive justeret for antal testede", 
    caption = standard_caption, 
    subtitle = '<b style="color:#EFA722;">Positivprocent</b> = positive / testede \u00D7 100. <b style="color:#9D6C06;">Smitteindeks</b> = positive / testede<sup>0.7</sup>'
  ) +
  standard_theme +
  theme(
    plot.subtitle = element_markdown()
  )

ggsave("../figures/ntl_index.png", width = 18, height = 10, units = "cm", dpi = 300)