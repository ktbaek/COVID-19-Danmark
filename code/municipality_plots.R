
# Subset kommuner by most positives the last month ------------------------
muni_subset <- muni_all %>% 
  filter(Date > ymd(today) - months(1)) %>%
  group_by(Kommune) %>% 
  summarize(pos_month = sum(Positive)) %>% 
  arrange(desc(pos_month)) %>%
  head(30) %>% 
  pull(Kommune)

# Figur: Positiv vs testede - alle kommuner 3 mdr-----------------
plot_data <- muni_all %>%
  filter(Date > ymd(today) - months(3)) %>%
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
    data = subset(plot_data, variable == 'Tested'), 
    aes(Date, value, color = variable), 
    size = 1) +
  facet_wrap(~ Kommune, scales = "free", ncol = 8) +
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
    title = "Dagligt antal SARS-CoV-2 testede og positive for alle kommuner", 
    caption = standard_caption) +
  facet_theme

ggsave("../figures/muni_all_pos_vs_test.png", width = 42, height = 48, units = "cm", dpi = 300)

# Figur: Positiv vs testede - udvalgte kommuner fra marts ------------------

plot_data <- muni_all %>%
  filter(Date > ymd("2020-02-29")) %>%
  filter(Kommune %in% muni_subset) %>%
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
    data = subset(plot_data, variable == 'Tested'), 
    aes(Date, value, color = variable), 
    size = 0.4) +
  facet_wrap(~ Kommune, scales = "free", ncol = 5) +
  scale_fill_manual(name = "", labels = c("Positive"), values = alpha(pos_col, 0.8)) +
  scale_color_manual(name = "", labels = c("Testede"), values = test_col) +
  scale_x_date(date_labels = "%b", date_breaks = "3 month", date_minor_breaks = "1 month") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)) +
  labs(
    y = "Positive : Testede", 
    x = "Dato", 
    title = "Dagligt antal SARS-CoV-2 testede og positive for udvalgte kommuner", 
    caption = standard_caption) +
  facet_theme

ggsave("../figures/muni_30_pos_vs_test_march.png", width = 28, height = 22, units = "cm", dpi = 300)


# Figur: Positiv vs testede - udvalgte kommuner 3 mdr --------

plot_data <- muni_all %>%
  filter(Date > ymd(today) - months(3)) %>%
  filter(Kommune %in% muni_subset) %>%
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
    data = subset(plot_data, variable == 'Tested'), 
    aes(Date, value, color = variable),
    size = 1) +
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
    title = "Dagligt antal SARS-CoV-2 testede og positive for udvalgte kommuner", 
    caption = standard_caption) +
  facet_theme

ggsave("../figures/muni_30_pos_vs_test.png", width = 28, height = 21, units = "cm", dpi = 300)



# -------------------------------------------------------------------------

# Figur: Procent - alle kommuner 3 mdr --------
ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 2)
}

plot_data <- muni_all %>%
  filter(Date > ymd(today) - months(3)) %>%
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
    width = 1) +
  geom_line(
    aes(Date, ra_pct), 
    size = 0.6, 
    color = darken(pct_col, 0.2)) +
  facet_wrap(~ Kommune, scales = "free", ncol = 8) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    limits = c(0, max_y_value)) +
  labs(
    y = "Positivprocent", 
    x = "Dato", 
    title = "Daglig procent SARS-CoV-2 positivt testede for alle kommuner", 
    caption = standard_caption) +
  facet_theme

ggsave("../figures/muni_all_pct.png", width = 42, height = 47, units = "cm", dpi = 300)


# Figur: Procent - udvalgte kommuner fra maj --------


plot_data <- muni_all %>%
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
    width = 1) +
  geom_line(
    aes(Date, ra_pct), 
    size = 0.4, 
    color = darken(pct_col, 0.2)) +
  facet_wrap(~ Kommune, scales = "free", ncol = 5) +
  scale_x_date(date_labels = "%b", date_breaks = "3 month", date_minor_breaks = "1 month") +
  scale_y_continuous(limits = c(0, max_y_value)) +
  labs(
    y = "Positivprocent", 
    x = "Dato", 
    title = "Daglig procent SARS-CoV-2 positivt testede for udvalgte kommuner", 
    caption = standard_caption) +
  facet_theme

ggsave("../figures/muni_30_pct_may.png", width = 27, height = 20, units = "cm", dpi = 300)


# Figur: procent - udvalgte kommuner 3 mdr -----------------

ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 2)
}

plot_data <- muni_all %>%
  filter(Date > ymd(today) - months(3)) %>%
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
    width = 1) +
  geom_line(
    aes(Date, ra_pct), 
    size = 0.8, 
    color = darken(pct_col, 0.2)) +
  facet_wrap(~ Kommune, scales = "free", ncol = 5) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(limits = c(0, max_y_value)) +
  labs(
    y = "Positivprocent", 
    x = "Dato", 
    title = "Daglig procent SARS-CoV-2 positivt testede for udvalgte kommuner", 
    caption = standard_caption) +
  facet_theme

ggsave("../figures/muni_30_pct.png", width = 27, height = 20, units = "cm", dpi = 300)


# -------------------------------------------------------------------------

# Figur: Incidens - alle kommuner, heatmap ---------------------------------

no_weeks <- length(unique(muni_wk$Week_end_Date))

plot_data <- muni_wk %>%
  filter(Week_end_Date > ymd("2020-04-01")) %>%
  mutate(Incidens = Positive_wk / Befolkningstal * 1000) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune)))))

plot_data %>% 
  ggplot() +
  geom_tile(aes(Week_end_Date, Kommune, fill = Incidens), color = "white", size = 0.25) +
  coord_fixed(ratio = 1) +
  labs(
    x = "", 
    y = "", 
    title = "Ugentligt antal positive per indbyggertal", 
    caption = standard_caption) +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Promille", na.value = "White", low = lighten("#999999", 0.8), high = pos_col) +
  tile_theme + 
  theme(text = element_text(size = 12))


ggsave("../figures/muni_all_weekly_incidens_tile.png", width = no_weeks * 0.5, height = 38, units = "cm", dpi = 300)

# Figur: Procent - alle kommuner, heatmap ----------


plot_data <- muni_wk %>%
  filter(Week_end_Date > ymd("2020-04-01")) %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune)))))

plot_data %>% 
  ggplot() +
  geom_tile(aes(Week_end_Date, Kommune, fill = Ratio), color = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(
    x = "", 
    y = "", 
    title = "Ugentligt antal positive per antal testede", 
    caption = standard_caption) +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten("#999999", 0.8), high = darken(pct_col, 0.1)) +
  tile_theme + 
  theme(text = element_text(size = 12))

ggsave("../figures/muni_all_weekly_pos_pct_tile.png", width = no_weeks * 0.5, height = 38, units = "cm", dpi = 300)


# Figur: Total test - alle kommuner, heatmap ---------------------------------


plot_data <- muni_wk %>%
  filter(Week_end_Date > ymd("2020-04-01")) %>%
  mutate(Incidens = Tested_wk / Befolkningstal * 100) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 
  
plot_data %>% 
  ggplot() +
  geom_tile(aes(Week_end_Date, Kommune, fill = Incidens), color = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(
    x = "", 
    y = "", title = "Ugentligt antal testede per indbyggertal", 
    caption = standard_caption) +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten("#999999", 0.8), high = test_col) +
  tile_theme + 
  theme(text = element_text(size = 12))


ggsave("../figures/muni_all_weekly_tests_tile.png",width = no_weeks * 0.5, height = 38, units = "cm", dpi = 300)


# -------------------------------------------------------------------------

# Figur: Incidens - udvalgte kommuner, heatmap ---------------------------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > ymd("2020-04-01")) %>%
  mutate(Incidens = Positive_wk / Befolkningstal * 1000) %>%
  filter(Kommune %in% muni_subset) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 

plot_data %>% 
  ggplot() +
  geom_tile(aes(Week_end_Date, Kommune, fill = Incidens), color = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(
    x = "", 
    y = "", 
    title = "Ugentligt antal positive per indbyggertal for udvalgte kommuner", 
    caption = standard_caption) +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Promille", na.value = "White", low = lighten("#999999", 0.8), high = pos_col) +
  tile_theme + 
  theme(axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)))


ggsave("../figures/muni_30_weekly_incidens_tile.png", width = no_weeks * 0.6, height = 19, units = "cm", dpi = 300)

# Figur: Procent - udvalgte kommuner, heatmap ----------

plot_data <- muni_wk %>%
  filter(Week_end_Date > ymd("2020-04-01")) %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100) %>%
  filter(Kommune %in% muni_subset) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 

plot_data %>% 
  ggplot() +
  geom_tile(aes(Week_end_Date, Kommune, fill = Ratio), color = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(
    x = "", 
    y = "", 
    title = "Ugentligt antal positive per antal testede for udvalgte kommuner", 
    caption = standard_caption) +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten("#999999", 0.8), high = darken(pct_col, 0.1)) +
  tile_theme + 
  theme(axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)))

ggsave("../figures/muni_30_weekly_pct_tile.png", width = no_weeks * 0.6, height = 19, units = "cm", dpi = 300)



# Figur: Total test - udvalgte kommuner, heatmap ---------------------------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > ymd("2020-04-01")) %>%
  #mutate(Incidens = Tested_wk / Befolkningstal * 100) %>%
  filter(Kommune %in% muni_subset) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 

plot_data %>% 
  ggplot() +
  geom_tile(aes(Week_end_Date, Kommune, fill = Tested_wk), color = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(
    x = "", 
    y = "", 
    title = "Ugentligt antal testede i udvalgte kommuner", 
    caption = standard_caption) +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Antal", na.value = "White", low = lighten("#999999", 0.8), high = test_col) +
  tile_theme + 
  theme(axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)))


ggsave("../figures/muni_30_weekly_tests_tile.png", width = no_weeks * 0.6, height = 19, units = "cm", dpi = 300)



# -------------------------------------------------------------------------


# Figur: Positiv vs testede - landsdele -----------------------------------

plot_data <- landsdele %>%
  filter(Date > ymd(today) - months(3)) %>%
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
    data = subset(plot_data, variable == 'Tested'), 
    aes(Date, value, color = variable),
    size = 0.8) +
  facet_wrap(~ Landsdel, scales = "free", ncol = 4) +
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
    title = "Dagligt antal SARS-CoV-2 testede og positive for landsdele", 
    caption = standard_caption) +
  facet_theme

ggsave("../figures/muni_pos_vs_test_landsdele.png", width = 23, height = 15, units = "cm", dpi = 300)

# Figur: Procent - landsdele -----------------------------------

ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 2)
}

plot_data <- landsdele %>%
  filter(Date > ymd(today) - months(3)) %>%
  mutate(pct = Positive / Tested * 100) %>%
  group_by(Landsdel) %>%
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
    size = 1, 
    color = darken(pct_col, 0.2)) +
  facet_wrap(~ Kommune, scales = "free") +
  facet_wrap(~ Landsdel, scales = "free", ncol = 4) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(limits = c(0, max_y_value)) +
  labs(
    y = "Positivprocent", 
    x = "Dato", 
    title = "Daglig procent positivt SARS-CoV-2 testede for landsdele", 
    caption = standard_caption) +
  facet_theme

ggsave("../figures/muni_pct_landsdele.png", width = 23, height = 14, units = "cm", dpi = 300)



# # Figur: Positiv vs testede - NJ kommuner, 1 md------------------
# 
# nj7 <- c("Frederikshavn", "Hjørring", "Vesthimmerlands", "Brønderslev", "Jammerbugt", "Thisted", "Læsø")
# 
# plot_data <- muni_all %>%
#   filter(Date > ymd(today) - months(2)) %>%
#   group_by(Kommune) %>%
#   filter(Kommune %in% nj7) %>%
#   ungroup() %>%
#   mutate(Positive = Positive * 100) %>%
#   pivot_longer(cols = c(Positive, Tested), names_to = "variable", values_to = "value")
# 
# ggplot(plot_data, aes(Date, value)) +
#   geom_bar(data = subset(plot_data, variable == 'Positive'), stat = "identity", position = "identity", size = 1, aes(fill = variable), width = 1) +
#   geom_line(data = subset(plot_data, variable == 'Tested'), stat = "identity", position = "identity", size = 0.8, aes(color = variable)) +
#   facet_wrap(~Kommune, scales = "free", ncol = 4) +
#   scale_fill_manual(name = "", labels = c("Positive"), values = alpha(pos_col, 0.8)) +
#   scale_color_manual(name = "", labels = c("Testede"), values = test_col) +
#   scale_x_date(date_labels = "%b", date_breaks = "1 month") +
#   scale_y_continuous(
#     name = "Testede",
#     sec.axis = sec_axis(~ . / 100, name = "Positive"),
#     limits = c(0, NA)
#   ) +
#   labs(y = "Positive : Testede", x = "Dato", title = "Dagligt antal nye positive og testede for 7 nordjyske kommuner") +
#   facet_theme
# 
# ggsave("../figures/muni_NJ7_pos_vs_test.png", width = 28, height = 13, units = "cm", dpi = 300)
# 
# # Figur: Procent - NJ kommuner, 1 md --------
# ra <- function(x, n = 7) {
#   stats::filter(x, rep(1 / n, n), sides = 1)
# }
# 
# plot_data <- muni_all %>%
#   filter(Date > ymd(today) - months(2)) %>%
#   filter(Kommune %in% nj7) %>%
#   mutate(pct = Positive / Tested * 100) %>%
#   group_by(Kommune) %>%
#   mutate(ra_pct = ra(pct)) %>%
#   ungroup()
# 
# max_y_value <- ceiling(max(plot_data$pct, na.rm = TRUE))
# 
# ggplot(plot_data) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, pct), fill = alpha(pct_col, 0.8), width = 1) +
#   geom_line(aes(Date, ra_pct), size = 1, color = darken(pct_col, 0.2)) +
#   facet_wrap(~Kommune, scales = "free", ncol = 4) +
#   scale_x_date(date_labels = "%b", date_breaks = "1 month") +
#   scale_y_continuous(
#     limits = c(0, max_y_value)
#   ) +
#   labs(y = "Procent positive", x = "Dato", title = "Daglig procent positivt testede for 7 nordjyske kommuner") +
#   facet_theme
# 
# ggsave("../figures/muni_NJ7_pct.png", width = 27, height = 13, units = "cm", dpi = 300)
# 

# Figur: Positiv vs testede - København og omegn, 1 md------------------


plot_data <- muni_all %>%
  full_join(geo, by = "Kommune") %>%
  filter(Date > ymd(today) - months(3)) %>%
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

plot_data <- muni_all %>%
  full_join(geo, by = "Kommune") %>%
  filter(Date > ymd(today) - months(3)) %>%
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


# # procent med og uden nordjylland -----------------------------------------
# nj7 <- c("Frederikshavn", "Hjørring", "Vesthimmerlands", "Brønderslev", "Jammerbugt", "Thisted", "Læsø")
# 
# 
# muni_all %>%
#   full_join(geo, by = "Kommune") %>%
#   filter(Date > ymd(today)- months(1)) %>%
#   mutate(nj7 = ifelse(Kommune %in% nj7, TRUE, FALSE)) %>%
#   group_by(Date) %>%
#   mutate(pct_total = sum(Positive, na.rm = TRUE)/sum(Tested, na.rm = TRUE) * 100) %>%
#   ungroup() %>%
#   group_by(nj7, Date) %>%
#   mutate(pct_stratified = sum(Positive, na.rm = TRUE)/sum(Tested, na.rm = TRUE) * 100) %>%
#   ungroup() %>%
#   filter(!nj7) %>%
#   select(Date, pct_stratified, pct_total) %>%
#   distinct() %>%
#   pivot_longer(-Date, names_to = "variable", values_to = "values") %>%
#   ggplot(aes(Date, values)) +
#   geom_line(aes(color = variable), size = 2) + 
#   scale_x_date(date_labels = "%e. %b", date_breaks = "1 week") +
#   labs(y = "Positivprocent", x = "Dato", title = "Positivprocent med og uden de 7 nordjyske kommuner", caption = standard_caption) +
#   scale_color_manual(name = "", labels = c("Uden nordjylland", "Hele landet"), values = c(lighten(pct_col, 0.2), darken(pct_col, 0.2))) +
#   scale_y_continuous(
#     limits = c(0, NA)
#   ) +
#   standard_theme
# 
# ggsave("../figures/muni_pct_stratified.png", width = 20, height = 12, units = "cm", dpi = 300)
# 
# 
# 
# 
# 
# 

# indikatorer per region -----------------------------------------------------

ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 1)
}

x <- admitted %>%
  select(-running_avg_admit, -Total, -`Ukendt Region`) %>%
  pivot_longer(-Date, names_to = "Region", values_to = "Admitted") 

muni_all %>%
  full_join(geo, by = "Kommune") %>%
  group_by(Region, Date) %>%
  mutate(Tested = sum(Tested, na.rm = TRUE),
         Positive = sum(Positive, na.rm = TRUE)) %>%
  ungroup() %>%
  select(-Kommune, -Landsdel) %>%
  distinct() %>%
  mutate(pct = Positive / Tested * 100) %>%
  select(-Tested) %>%
  full_join(x, by = c("Region", "Date")) %>%
  pivot_longer(c(-Date, -Region), names_to = "variable", values_to = "value") %>%
  filter(Date > ymd(today) - months(3)) %>%
  ggplot() +
  geom_bar(
    stat = "identity", 
    position = "stack", 
    aes(Date, value, fill = variable),  
    width = 1) +
  facet_grid(variable ~ Region, scales = "free") +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_fill_manual(name = "", labels = c("Nyindlæggelser", "Positivprocent", "Positive"), values = c(admit_col, pct_col, pos_col)) +
  labs(
    y = "Værdi", 
    x = "Dato", 
    title = "Daglige indikatorer for hver region", 
    caption = standard_caption) +
  facet_theme +
  theme(strip.text.y = element_blank(),
        legend.text = element_text(size = 11),
        legend.key.size = unit(0.4, 'cm'),
        panel.grid.minor.x = element_blank())

ggsave("../figures/muni_region_all.png", width = 23, height = 14, units = "cm", dpi = 300)

region_pop <- geo %>%
  full_join(muni_pop, by = "Kommune") %>%
  group_by(Region) %>%
  summarize(Pop = sum(Befolkningstal, na.rm = TRUE))

muni_all %>%
  full_join(geo, by = "Kommune") %>%
  group_by(Region, Date) %>%
  mutate(Tested = sum(Tested, na.rm = TRUE),
         Positive = sum(Positive, na.rm = TRUE)) %>%
  ungroup() %>%
  select(-Kommune, -Landsdel) %>%
  distinct() %>%
  select(-Tested) %>%
  full_join(x, by = c("Region", "Date")) %>%
  full_join(region_pop, by = "Region") %>%
  mutate(Positive = Positive / Pop * 100000,
         Admitted = Admitted / Pop * 100000) %>%
  select(-Pop) %>%
  pivot_longer(c(-Date, -Region), names_to = "variable", values_to = "value") %>%
  filter(Date > ymd(today) - months(3)) %>%
  ggplot() +
  geom_bar(
    stat = "identity", 
    position = "stack", 
    aes(Date, value, fill = variable),  
    width = 1) +
  facet_grid(variable ~ Region, scales = "free") +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_fill_manual(name = "", labels = c("Nyindlæggelser", "Positive"), values = c(admit_col, pos_col)) +
  labs(
    y = "Antal per 100.000 indbyggere", 
    x = "Dato", 
    title = "Daglige indikatorer for hver region per indbyggertal", 
    caption = standard_caption) +
  facet_theme +
  theme(strip.text.y = element_blank(),
        legend.text = element_text(size = 11),
        legend.key.size = unit(0.4, 'cm'),
        panel.grid.minor.x = element_blank())

ggsave("../figures/muni_region_incidens.png", width = 23, height = 12, units = "cm", dpi = 300)


# Individual plots --------------------------------------------------------

plot_kommuner_pos <- function(muni_df, kommune) {
  
plot_data <- muni_df %>%
  filter(Date > ymd(today) - months(3)) %>%
  filter(Kommune == kommune) %>%
  mutate(Positive = Positive * 100) %>%
  pivot_longer(cols = c(Positive, Tested), names_to = "variable", values_to = "value") 
  
plot_data %>%
  ggplot() +
  geom_bar(
    data = subset(plot_data, variable == 'Positive'), 
    stat = "identity", 
    position = "identity", 
    aes(Date, value, fill = variable), 
    width = 1) +
  geom_line(
    data = subset(plot_data, variable == 'Tested'), 
    size = 1, 
    aes(Date, value, color = variable)) +
  geom_segment(
    aes(y = 0, x = ymd(today) - months(3) + 0.5, yend = 0, xend = ymd(today) - 1.5), 
    color = alpha(pos_col, 0.5), 
    size = 0.1) +
  scale_fill_manual(name = "", labels = c("Positive"), values = alpha(pos_col, 0.8)) +
  scale_color_manual(name = "", labels = c("Testede"), values = test_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
  scale_y_continuous(
      name = "Testede",
      sec.axis = sec_axis(~ . / 100, name = "Positive"),
      limits = c(0, NA)) +
  labs(
    y = "Positive : Testede", 
    x = "Dato", 
    title = paste0("Dagligt antal SARS-CoV-2 testede og positive for ", kommune), 
    caption = standard_caption) +
  standard_theme
  
  ggsave(paste0("../figures/Kommuner/", kommune, "_pos_test_daily.png"), width = 18, height = 10, units = "cm", dpi = 300)
  
}

plot_kommuner_pct <- function(muni_df, kommune) {
  
  muni_df %>%
    filter(Date > ymd(today) - months(3)) %>%
    filter(Kommune == kommune) %>%
    mutate(pct = Positive / Tested * 100) %>%
    ggplot() +
    geom_bar(
      stat = "identity", position = "stack", 
      aes(Date, pct), 
      fill = alpha(pct_col, 0.8), 
      width = 1) +
    geom_segment(
      aes(y = 0, x = ymd(today) - months(3) + 0.5, yend = 0, xend = ymd(today) - 1.5), 
      color = alpha(pct_col, 0.5), 
      size = 0.1) +
    scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
    scale_y_continuous(limits = c(0, NA), labels = function(x) paste0(x, " %")) +
    labs(
      y = "Positivprocent", 
      x = "Dato", 
      title = paste0("Dagligt procent positivt SARS-CoV-2 testede for ", kommune), 
      caption = standard_caption) +
    standard_theme
  
  ggsave(paste0("../figures/Kommuner/", kommune, "_pct_daily.png"), width = 18, height = 10, units = "cm", dpi = 300)
  
}

walk(unique(muni_all$Kommune), ~ plot_kommuner_pos(muni_all, .x))
walk(unique(muni_all$Kommune), ~ plot_kommuner_pct(muni_all, .x))



# # Risikerer nedlukning ----------------------------------------------------
# 
# 
# 
# 
# 
# 
# 
# muni_alert <- muni_all %>% 
#   filter(Date >= ymd(today) - days(8)) %>%
#   full_join(muni_population, by = c("Kommune", "Date")) %>% 
#   group_by(Kommune) %>% 
#   summarize(positive = sum(Positive, na.rm = TRUE),
#             incidens = positive / Befolkningstal * 100000) %>% 
#   filter(!is.na(incidens)) %>% 
#   distinct() %>% 
#   filter(incidens >= 120) %>% 
#   pull(Kommune) %>% 
#   unique()
# 
# 
# 
# plot_data <- muni_all %>%
#   full_join(muni_population, by = c("Kommune", "Date")) %>% 
#   filter(Date > ymd(today) - months(2)) %>%
#   group_by(Kommune) %>% 
#   fill(Befolkningstal, .direction = "down") %>% 
#   filter(!is.na(Positive)) %>% 
#   mutate(
#     test_intensity =  Tested / (0.017 * Befolkningstal),
#     adj_incidens = Positive * (0.017 * Befolkningstal / Tested)**0.58 / Befolkningstal * 100000,
#     roll_sum_adj_inc = sum_run(x = adj_incidens, k = 7, idx = Date, na_rm = TRUE)) 
# 
# max_value <- max(c(plot_data$roll_incidens, plot_data$roll_pct))
# 
# muni_alert <- plot_data %>% 
#   filter(Date >= ymd(today) - days(8)) %>%
#   group_by(Kommune) %>% 
#   summarize(sum = sum(adj_incidens, na.rm = TRUE)) %>% 
#   filter(sum >= 100) %>% 
#   pull(Kommune)
#   
# 
# n_rows <- ceiling(length(muni_alert)/5)
# 
# plot_data %>% 
#   filter(Kommune %in% muni_alert) %>% 
#   filter(Date > ymd(today) - months(1)) %>%
#   ggplot() +
#   geom_line(
#     aes(Date, roll_sum_adj_inc), 
#     color = pos_col, 
#     size = 1) +
#   geom_hline(
#     yintercept = 200, 
#     color = pos_col, 
#     alpha = 0.8, 
#     size = 0.3) +
#   facet_wrap(~ Kommune, ncol = 5) +
#   scale_x_date(labels = my_date_labels, breaks = "2 week") +
#   scale_y_continuous(limits = c(0, max_value)) +
#   labs(
#     y = "Testjusteret incidens",
#     x = "Dato", 
#     title = "Testjusteret incidens", 
#     caption = standard_caption, 
#     subtitle = paste0('Beregnet som 7-dages løbende sum af daglig testjusteret incidens . Seneste dato: ', ymd(today) - days(2))) +
#   facet_theme +
#   theme(
#     legend.position = "none",
#     plot.subtitle = element_markdown())
# 
# ggsave("../figures/muni_alert.png", width = 20, height = 4 + n_rows * 3, units = "cm", dpi = 300)
