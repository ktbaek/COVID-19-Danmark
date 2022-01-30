plot_kommuner_pos <- function(muni_df, kommune, ratio = 10) {
  plot_data <- muni_df %>%
    filter(Date > ymd(today) - month_correction - months(3)) %>%
    filter(Kommune == kommune) %>%
    mutate(Positive = Positive * ratio) %>%
    pivot_longer(cols = c(Positive, Tested), names_to = "variable", values_to = "value")

  plot_data %>%
    ggplot() +
    geom_bar(
      data = subset(plot_data, variable == "Positive"),
      stat = "identity",
      position = "identity",
      aes(Date, value, fill = variable),
      width = 1
    ) +
    geom_line(
      data = subset(plot_data, variable == "Tested"),
      size = 1,
      aes(Date, value, color = variable)
    ) +
    geom_segment(
      aes(y = 0, x = ymd(today) - month_correction - months(3) + 0.5, yend = 0, xend = ymd(today) - 1.5),
      color = alpha(pos_col, 0.5),
      size = 0.1
    ) +
    scale_fill_manual(name = "", labels = c("Positive"), values = alpha(pos_col, 0.8)) +
    scale_color_manual(name = "", labels = c("Testede"), values = test_col) +
    scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
    scale_y_continuous(
      name = "Testede",
      sec.axis = sec_axis(~ . / ratio, name = "Positive"),
      limits = c(0, NA)
    ) +
    labs(
      y = "Positive : Testede",
      x = "Dato",
      title = paste0("Dagligt antal SARS-CoV-2 testede og positive for ", kommune),
      caption = standard_caption
    ) +
    standard_theme

  ggsave(paste0("../figures/Kommuner/", kommune, "_pos_test_daily.png"), width = 18, height = 10, units = "cm", dpi = 300)
}

plot_kommuner_pct <- function(muni_df, kommune) {
  muni_df %>%
    filter(Date > ymd(today) - month_correction - months(3)) %>%
    filter(Kommune == kommune) %>%
    mutate(pct = Positive / Tested * 100) %>%
    ggplot() +
    geom_bar(
      stat = "identity", position = "stack",
      aes(Date, pct),
      fill = alpha(pct_col, 0.8),
      width = 1
    ) +
    geom_segment(
      aes(y = 0, x = ymd(today) - month_correction - months(3) + 0.5, yend = 0, xend = ymd(today) - 1.5),
      color = alpha(pct_col, 0.5),
      size = 0.1
    ) +
    scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
    scale_y_continuous(limits = c(0, NA), labels = function(x) paste0(x, " %")) +
    labs(
      y = "Positivprocent",
      x = "Dato",
      title = paste0("Dagligt procent positivt SARS-CoV-2 testede for ", kommune),
      caption = standard_caption
    ) +
    standard_theme

  ggsave(paste0("../figures/Kommuner/", kommune, "_pct_daily.png"), width = 18, height = 10, units = "cm", dpi = 300)
}

muni_data <- read_csv2("../data/tidy_muni_data.csv")

month_correction <- case_when(
  day(ymd(today)) == 31 & month(ymd(today)) %in% c(3, 5, 7, 10, 12) ~ 1,
  day(ymd(today)) %in% c(29, 30, 31) & month(ymd(today)) == 5 ~ 3,
  TRUE ~ 0
)

walk(unique(muni_data$Kommune), ~ plot_kommuner_pos(muni_data, .x))
walk(unique(muni_data$Kommune), ~ plot_kommuner_pct(muni_data, .x))
