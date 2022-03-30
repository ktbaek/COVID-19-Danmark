muni_data <- read_csv2("../data/tidy_muni_data.csv")

month_correction <- case_when(
  day(ymd(today)) == 31 & month(ymd(today)) %in% c(3, 5, 7, 10, 12) ~ 1,
  day(ymd(today)) %in% c(29, 30, 31) & month(ymd(today)) %in% c(3, 5) ~ 3,
  TRUE ~ 0
)

ratio <- 10 # ratio between tested and positive axes

# Subset kommuner by most positives the last month ------------------------
muni_subset <- muni_data %>%
  filter(Date > ymd(today) - month_correction - months(1)) %>%
  group_by(Kommune) %>%
  summarize(pos_month = sum(Positive, na.rm = TRUE)) %>%
  arrange(desc(pos_month)) %>%
  head(30) %>%
  pull(Kommune)

# Figur: Positiv vs testede - alle kommuner 3 mdr-----------------
plot_data <- muni_data %>%
  filter(Date > ymd(today) - month_correction - months(3)) %>%
  mutate(Positive = Positive * ratio) %>%
  pivot_longer(cols = c(Positive, Tested), names_to = "variable", values_to = "value")

plot_data %>%
  ggplot() +
  geom_bar(
    data = subset(plot_data, variable == "Positive"),
    aes(Date, value, fill = variable),
    stat = "identity",
    position = "identity",
    width = 1
  ) +
  geom_line(
    data = subset(plot_data, variable == "Tested"),
    aes(Date, value, color = variable),
    size = 1
  ) +
  facet_wrap(~Kommune, scales = "free", ncol = 8) +
  scale_fill_manual(name = "", labels = c("Positive"), values = alpha(pos_col, 0.8)) +
  scale_color_manual(name = "", labels = c("Testede"), values = test_col) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / ratio, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(
    y = "Positive : Testede",
    x = "Dato",
    title = "Dagligt antal SARS-CoV-2 testede og positive for alle kommuner",
    caption = standard_caption
  ) +
  facet_theme

ggsave("../figures/muni_all_pos_vs_test.png", width = 42, height = 48, units = "cm", dpi = 300)

# Figur: Positiv vs testede - udvalgte kommuner fra marts ------------------

plot_data <- muni_data %>%
  filter(Date > ymd("2020-02-29")) %>%
  filter(Kommune %in% muni_subset) %>%
  mutate(Positive = Positive * 100) %>%
  pivot_longer(cols = c(Positive, Tested), names_to = "variable", values_to = "value")

plot_data %>%
  ggplot() +
  geom_bar(
    data = subset(plot_data, variable == "Positive"),
    aes(Date, value, fill = variable),
    stat = "identity",
    position = "identity",
    width = 1
  ) +
  geom_line(
    data = subset(plot_data, variable == "Tested"),
    aes(Date, value, color = variable),
    size = 0.4
  ) +
  facet_wrap(~Kommune, scales = "free", ncol = 5) +
  scale_fill_manual(name = "", labels = c("Positive"), values = alpha(pos_col, 0.8)) +
  scale_color_manual(name = "", labels = c("Testede"), values = test_col) +
  scale_x_date(date_labels = "%b", date_breaks = "4 month", date_minor_breaks = "1 month") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(
    y = "Positive : Testede",
    x = "Dato",
    title = "Dagligt antal SARS-CoV-2 testede og positive for udvalgte kommuner",
    caption = standard_caption
  ) +
  facet_theme

ggsave("../figures/muni_30_pos_vs_test_march.png", width = 28, height = 22, units = "cm", dpi = 300)


# Figur: Positiv vs testede - udvalgte kommuner 3 mdr --------

plot_data <- muni_data %>%
  filter(Date > ymd(today) - month_correction - months(3)) %>%
  filter(Kommune %in% muni_subset) %>%
  mutate(Positive = Positive * ratio) %>%
  pivot_longer(cols = c(Positive, Tested), names_to = "variable", values_to = "value")

plot_data %>%
  ggplot() +
  geom_bar(
    data = subset(plot_data, variable == "Positive"),
    aes(Date, value, fill = variable),
    stat = "identity",
    position = "identity",
    width = 1
  ) +
  geom_line(
    data = subset(plot_data, variable == "Tested"),
    aes(Date, value, color = variable),
    size = 1
  ) +
  facet_wrap(~Kommune, scales = "free", ncol = 5) +
  scale_fill_manual(name = "", labels = c("Positive"), values = alpha(pos_col, 0.8)) +
  scale_color_manual(name = "", labels = c("Testede"), values = test_col) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / ratio, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(
    y = "Positive : Testede",
    x = "Dato",
    title = "Dagligt antal SARS-CoV-2 testede og positive for udvalgte kommuner",
    caption = standard_caption
  ) +
  facet_theme

ggsave("../figures/muni_30_pos_vs_test.png", width = 28, height = 21, units = "cm", dpi = 300)



# -------------------------------------------------------------------------
ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 2)
}
# Figur: Procent - alle kommuner 3 mdr --------

plot_data <- muni_data %>%
  filter(Date > ymd(today) - month_correction - months(3)) %>%
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
    fill = pct_col,
    alpha = 0.8,
    width = 1
  ) +
  geom_line(
    aes(Date, ra_pct),
    size = 0.6,
    color = darken(pct_col, 0.2)
  ) +
  facet_wrap(~Kommune, scales = "free", ncol = 8) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    limits = c(0, max_y_value)
  ) +
  labs(
    y = "Positivprocent",
    x = "Dato",
    title = "Daglig procent SARS-CoV-2 positivt testede for alle kommuner",
    caption = standard_caption
  ) +
  facet_theme

ggsave("../figures/muni_all_pct.png", width = 42, height = 47, units = "cm", dpi = 300)


# Figur: Procent - udvalgte kommuner fra maj --------

plot_data <- muni_data %>%
  filter(Date > ymd("2020-04-30")) %>%
  filter(Kommune %in% muni_subset) %>%
  mutate(pct = Positive / Tested * 100) %>%
  group_by(Kommune) %>%
  mutate(ra_pct = ra(pct))

max_y_value <- ceiling(max(plot_data$pct, na.rm = TRUE))

plot_data %>%
  ggplot() +
  geom_bar(
    aes(Date, pct),
    stat = "identity",
    position = "stack",
    fill = pct_col,
    alpha = 0.8,
    width = 1
  ) +
  geom_line(
    aes(Date, ra_pct),
    size = 0.4,
    color = darken(pct_col, 0.2)
  ) +
  facet_wrap(~Kommune, scales = "free", ncol = 5) +
  scale_x_date(date_labels = "%b", date_breaks = "3 month", date_minor_breaks = "1 month") +
  scale_y_continuous(limits = c(0, max_y_value)) +
  labs(
    y = "Positivprocent",
    x = "Dato",
    title = "Daglig procent SARS-CoV-2 positivt testede for udvalgte kommuner",
    caption = standard_caption
  ) +
  facet_theme

ggsave("../figures/muni_30_pct_may.png", width = 27, height = 20, units = "cm", dpi = 300)


# Figur: procent - udvalgte kommuner 3 mdr -----------------

plot_data <- muni_data %>%
  filter(Date > ymd(today) - month_correction - months(3)) %>%
  filter(Kommune %in% muni_subset) %>%
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
    fill = pct_col,
    alpha = 0.8,
    width = 1
  ) +
  geom_line(
    aes(Date, ra_pct),
    size = 0.8,
    color = darken(pct_col, 0.2)
  ) +
  facet_wrap(~Kommune, scales = "free", ncol = 5) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(limits = c(0, max_y_value)) +
  labs(
    y = "Positivprocent",
    x = "Dato",
    title = "Daglig procent SARS-CoV-2 positivt testede for udvalgte kommuner",
    caption = standard_caption
  ) +
  facet_theme

ggsave("../figures/muni_30_pct.png", width = 27, height = 20, units = "cm", dpi = 300)
