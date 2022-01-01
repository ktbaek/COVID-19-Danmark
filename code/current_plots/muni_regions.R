muni_data <- read_csv2("../data/tidy_muni_data.csv")

month_correction <- case_when(
  day(ymd(today)) == 31 & month(ymd(today)) %in% c(3, 5, 7, 10, 12) ~ 1,
  day(ymd(today)) %in% c(29, 30, 31) & month(ymd(today)) == 5 ~ 3,
  TRUE ~ 0
)

ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 1)
}

muni_data %>%
  full_join(geo, by = "Kommune") %>%
  group_by(Region, Date) %>%
  mutate(
    Tested = sum(Tested, na.rm = TRUE),
    Positive = sum(Positive, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  select(-Kommune, -Landsdel, -Befolkningstal) %>%
  distinct() %>%
  mutate(pct = Positive / Tested * 100) %>%
  select(-Tested) %>%
  full_join(filter(read_csv2("../data/tidy_admitted_region.csv"), Region != "Ukendt_region"), by = c("Region", "Date")) %>%
  pivot_longer(c(-Date, -Region), values_to = "daily") %>%
  group_by(Region, name) %>% 
  mutate(ra = ra(daily)) %>% 
  filter(Date > ymd(today) - month_correction - months(3)) %>%
  ggplot() +
  geom_bar(stat = "identity", aes(Date, daily, fill = name), alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra, color = name), size = 1) +
  facet_grid(name ~ Region, scales = "free") +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", minor_breaks = "1 month") +
  scale_fill_manual(name = "", labels = c("Nyindlæggelser", "Positivprocent", "Positive"), values = c(admit_col, pct_col, pos_col)) +
  scale_color_manual(name = "", values = c(admit_col, pct_col, pos_col), guide = FALSE) +
  labs(
    y = "Værdi",
    x = "Dato",
    title = "Daglige indikatorer for hver region",
    caption = standard_caption
  ) +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  facet_theme +
  theme(
    strip.text.y = element_blank(),
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, "cm")
  )

ggsave("../figures/muni_region_all.png", width = 23, height = 14, units = "cm", dpi = 300)

muni_data %>%
  full_join(geo, by = "Kommune") %>%
  group_by(Region, Date) %>%
  mutate(
    Tested = sum(Tested, na.rm = TRUE),
    Positive = sum(Positive, na.rm = TRUE),
    Population = sum(Befolkningstal, na.rm = TRUE)
  ) %>%
  select(-Kommune, -Landsdel, -Befolkningstal) %>%
  distinct() %>%
  select(-Tested) %>%
  full_join(filter(read_csv2("../data/tidy_admitted_region.csv"), Region != "Ukendt_region"), by = c("Region", "Date")) %>%
  mutate(
    Positive = Positive / Population * 100000,
    Admitted = Admitted / Population * 100000
  ) %>%
  select(-Population) %>%
  pivot_longer(c(-Date, -Region), values_to = "daily") %>%
  group_by(Region, name) %>% 
  mutate(ra = ra(daily)) %>% 
  filter(Date > ymd(today) - month_correction - months(3)) %>%
  ggplot() +
  geom_bar(stat = "identity", aes(Date, daily, fill = name), alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra, color = name), size = 1) +
  facet_grid(name ~ Region, scales = "free") +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", minor_breaks = "1 month") +
  scale_fill_manual(name = "", labels = c("Nyindlæggelser", "Positive"), values = c(admit_col, pos_col)) +
  scale_color_manual(name = "", values = c(admit_col, pos_col), guide = FALSE) +
  labs(
    y = "Antal per 100.000 indbyggere",
    x = "Dato",
    title = "Daglige indikatorer for hver region per indbyggertal",
    caption = standard_caption
  ) +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  facet_theme +
  theme(
    strip.text.y = element_blank(),
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, "cm")
  )

ggsave("../figures/muni_region_incidens.png", width = 23, height = 12, units = "cm", dpi = 300)
