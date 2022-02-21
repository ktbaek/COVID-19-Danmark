plot_data <- read_csv2("../data/SSI_daily_data.csv") %>%
  filter(!name %in% c("Index", "Tested")) %>%
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
  filter(new_date > "2021-09-30", new_date <= ymd(today)) %>%
  pivot_longer(c(daily, ra), names_to = "type", values_to = "value")

plot_layer <- list(
  geom_line(aes(new_date, value, color = name, size = type, alpha = type)),
  scale_x_date(labels = my_date_labels_no_year, date_breaks = "1 months", expand = expansion(mult = c(0.01, 0))),
  scale_size_manual(
    guide = FALSE,
    values = c(0.3, 1.2)
  ),
  scale_alpha_manual(
    guide = FALSE,
    values = c(0.6, 1)
  ),
  labs(
    x = "Date",
    caption = standard_caption
  ),
  guides(color = guide_legend(override.aes = list(size = 1))),
  facet_wrap(~year),
  facet_theme,
  theme(
    axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0)),
    axis.title.y.left = element_text(margin = margin(t = 0, r = 4, b = 0, l = 0)),
    axis.title.y.right = element_text(margin = margin(t = 0, r = 0, b = 0, l = 8)),
    plot.margin = margin(0.4, 0.4, 0.2, 0.4, "cm"),
    plot.title = element_blank(),
    plot.caption = element_blank(),
    strip.text.x = element_text(size = rel(1.5)),
    panel.spacing.x = unit(0.6, "cm")
  )
)

p1 <- plot_data %>%
  filter(name %in% c("Positive", "Admitted")) %>%
  mutate(value = ifelse(name == "Admitted", value * 30, value)) %>%
  ggplot() +
  plot_layer +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Positive",
    sec.axis = sec_axis(~ . / 30, name = "Indlæggelser")
  ) +
  scale_color_manual(name = "", guide = FALSE, labels = c("Indlæggelser", "PCR positive"), values = c(admit_col, pos_col)) +
  labs(
    title = "PCR positive vs indlæggelser"
  )

p2 <- plot_data %>%
  filter(name %in% c("Positive", "Deaths")) %>%
  mutate(value = ifelse(name == "Deaths", value * 300, value)) %>%
  ggplot() +
  plot_layer +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Positive",
    sec.axis = sec_axis(~ . / 300, name = "Døde")
  ) +
  scale_color_manual(name = "", labels = c("Døde", "PCR positive"), values = c(death_col, pos_col)) +
  labs(
    title = "PCR positive vs døde"
  )

p3 <- plot_data %>%
  filter(name %in% c("Percent", "Admitted")) %>%
  mutate(value = ifelse(name == "Admitted", value / 25, value)) %>%
  ggplot() +
  plot_layer +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Procent",
    labels = function(x) paste0(x, " %"),
    sec.axis = sec_axis(~ . * 25, name = "Indlæggelser")
  ) +
  scale_color_manual(name = "", labels = c("Indlæggelser", "PCR positivprocent"), values = c(admit_col, pct_col)) +
  labs(
    title = "PCR positivprocent vs indlæggelser"
  ) +
  theme(strip.text.x = element_blank())

p4 <- plot_data %>%
  filter(name %in% c("Percent", "Deaths")) %>%
  mutate(value = ifelse(name == "Deaths", value / 2.5, value)) %>%
  ggplot() +
  plot_layer +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Procent",
    labels = function(x) paste0(x, " %"),
    sec.axis = sec_axis(~ . * 2.5, name = "Døde")
  ) +
  scale_color_manual(name = "", guide = FALSE, labels = c("Døde", "PCR positivprocent"), values = c(death_col, pct_col)) +
  labs(
    title = "PCR positivprocent vs døde"
  ) +
  theme(strip.text.x = element_blank())

(p1 + p2) / (p3 + p4) +
  plot_annotation(
    title = "SARS-CoV-2, efterår/vinter 2021 vs 2020, Danmark",
    caption = standard_caption,
    theme = theme(
      legend.position = "bottom",
      legend.margin = margin(t = 0),
      plot.margin = margin(0.6, 0.4, 0.2, 0.4, "cm"),
      plot.title = element_text(size = rel(1.6), face = "bold", hjust = 0, margin = margin(b = 0)),
      plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
    )
  ) &
  theme(
    text = element_text(family = "lato")
  )


ggsave("../figures/ntl_four_compare_20_21.png", width = 27, height = 15, units = "cm", dpi = 300)
