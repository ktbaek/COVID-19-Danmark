
plot_data <- read_csv2("../data/SSI_Ag_data.csv") %>%
  select(Date, AGpos_minusPCRkonf, AGpos_PCRpos, AGpos_PCRneg) %>%
  pivot_longer(c(-Date)) %>%
  filter(Date > ymd("2021-01-31"))

plot_data$name <- factor(plot_data$name, levels = c("AGpos_minusPCRkonf", "AGpos_PCRpos", "AGpos_PCRneg"))

plot_data %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = name), width = 1) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  scale_fill_manual(
    name = "",
    labels = c("Ikke PCR testede", "PCR positive", "PCR negative"),
    values = c("gray90", "gray70", pos_col)
  ) +
  labs(
    y = "Andel",
    x = "Dato",
    title = "Positive SARS-CoV-2 antigentests opdelt på PCR bekræftelse",
    caption = standard_caption
  ) +
  standard_theme

ggsave("../figures/ntl_ag_pos.png", width = 18, height = 10, units = "cm", dpi = 300)
