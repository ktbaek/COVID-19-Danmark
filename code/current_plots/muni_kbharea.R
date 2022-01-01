muni_data <- read_csv2("../data/tidy_muni_data.csv")

plot_data <- muni_data %>%
  full_join(geo, by = "Kommune") %>%
  filter(Date > ymd(today) - month_correction - months(3)) %>%
  filter(Landsdel %in% c("København", "Københavns omegn")) %>%
  mutate(Positive = Positive * 100) %>%
  pivot_longer(cols = c(Positive, Tested), names_to = "variable", values_to = "value")

plot_data %>% 
  ggplot() +
  geom_bar(
    data = subset(plot_data, variable == 'Positive'), 
    aes(Date, value, fill = variable),
    stat = "identity", 
    position = "identity", 
    width = 1) +
  geom_line(
    aes(Date, value, color = variable),
    data = subset(plot_data, variable == 'Tested'), 
    size = 0.8) +
  facet_wrap(~ Kommune, scales = "free", ncol = 5) +
  scale_fill_manual(name = "", labels = c("Positive"), values = alpha(pos_col, 0.8)) +
  scale_color_manual(name = "", labels = c("Testede"), values = test_col) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)) +
  labs(
    y = "Positive : Testede", 
    x = "Dato", 
    title = "Dagligt antal SARS-CoV-2 testede og positive for københavnsområdet", 
    caption = standard_caption) +
  facet_theme

ggsave("../figures/muni_kbharea_pos_vs_test.png", width = 26, height = 17, units = "cm", dpi = 300)


# Figur: Procent - København og omegn, 1 md --------
ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 2)
}

plot_data <- muni_data %>%
  full_join(geo, by = "Kommune") %>%
  filter(Date > ymd(today) - month_correction - months(3)) %>%
  filter(Landsdel %in% c("København", "Københavns omegn")) %>%
  mutate(pct = Positive / Tested * 100) %>%
  group_by(Kommune) %>%
  mutate(ra_pct = ra(pct)) %>%
  ungroup()

max_y_value <- ceiling(max(plot_data$pct, na.rm = TRUE))

plot_data %>% 
  ggplot() +
  geom_bar(
    aes(Date, pct), 
    stat = "identity", 
    position = "stack", 
    fill = alpha(pct_col, 0.8), 
    width = 1) +
  geom_line(
    aes(Date, ra_pct), 
    size = 0.9, 
    color = darken(pct_col, 0.2)) +
  facet_wrap(~ Kommune, scales = "free", ncol = 5) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(limits = c(0, max_y_value)) +
  labs(
    y = "Positivprocent", 
    x = "Dato", 
    title = "Daglig procent positivt SARS-CoV-2 testede for københavnsområdet", 
    caption = standard_caption) +
  facet_theme

ggsave("../figures/muni_kbharea_pct.png", width = 24, height = 15, units = "cm", dpi = 300)
