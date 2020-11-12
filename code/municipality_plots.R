
# Subset kommuner by most positives the last month ------------------------

muni_subset <- muni_wk %>% 
  filter(Week_end_Date > as.Date(today) - months(1)) %>%
  group_by(Kommune) %>% 
  summarize(x = sum(Positive_wk)) %>% 
  arrange(desc(x)) %>%
  slice(1:30) %>% 
  pull(Kommune)


# Figur: Positiv vs testede - udvalgte kommuner, 3 mdr------------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date(today) - months(3)) %>%
  group_by(Kommune) %>%
  filter(Kommune %in% muni_subset) %>%
  ungroup() %>%
  mutate(Positive_wk = Positive_wk * 100) %>%
  pivot_longer(cols = c(Positive_wk, Tested_wk), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Week_end_Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 1.5, aes(color = variable)) +
  facet_wrap(~Kommune, scales = "free", ncol = 5) +
  scale_color_manual(name = "", labels = c("Positive", "Testede"), values = c(pos_col, test_col)) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Ugentligt antal nye positive og testede for udvalgte kommuner") +
  facet_theme

ggsave("../figures/muni_10_pos_vs_test_july.png", width = 30, height = 20, units = "cm", dpi = 300)

# Figur: Positiv vs testede - alle kommuner, 3 mdr-----------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date(today) - months(3)) %>%
  mutate(Positive_wk = Positive_wk * 100) %>%
  pivot_longer(cols = c(Positive_wk, Tested_wk), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Week_end_Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) +
  facet_wrap(~Kommune, scales = "free") +
  scale_color_manual(name = "", labels = c("Positive", "Testede"), values = c(pos_col, test_col)) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Ugentligt antal nye positive og testede for alle kommuner") +
  facet_theme

ggsave("../figures/muni_all_pos_vs_test_july.png", width = 54, height = 36, units = "cm", dpi = 300)

# Figur: Positiv vs testede - udvalgte kommuner fra april, datoer ------------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-07")) %>%
  group_by(Kommune) %>%
  filter(Kommune %in% muni_subset) %>%
  ungroup() %>%
  mutate(Positive_wk = Positive_wk * 100) %>%
  pivot_longer(cols = c(Positive_wk, Tested_wk), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Week_end_Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 1.5, aes(color = variable)) +
  facet_wrap(~Kommune, scales = "free", ncol = 5) +
  scale_color_manual(name = "", labels = c("Positive", "Testede"), values = c(pos_col, test_col)) +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Ugentligt antal nye positive og testede for udvalgte kommuner") +
  facet_theme

ggsave("../figures/muni_10_pos_vs_test_april.png", width = 30, height = 20, units = "cm", dpi = 300)


# Figur: Daglige positiv vs testede - udvalgte kommuner 3 mdr --------

plot_data <- muni_all %>%
  filter(Date > as.Date(today) - months(3)) %>%
  filter(Kommune %in% muni_subset) %>%
  mutate(Positive = Positive * 100) %>%
  pivot_longer(cols = c(Positive, Tested), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 0.6, aes(color = variable)) +
  facet_wrap(~Kommune, scales = "free", ncol = 5) +
  scale_color_manual(name = "", labels = c("Positive", "Testede"), values = c(pos_col, test_col)) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Dagligt antal nye positive og testede for udvalgte kommuner") +
  facet_theme

ggsave("../figures/muni_10_pos_vs_test_daily.png", width = 30, height = 20, units = "cm", dpi = 300)


# -------------------------------------------------------------------------

# Figur: Procent - udvalgte kommuner, ugenumre --------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date(today) - months(3)) %>%
  group_by(Kommune) %>%
  filter(Kommune %in% muni_subset) %>%
  ungroup() %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100)

max_y_value <- ceiling(max(plot_data$Ratio, na.rm = TRUE))

ggplot(plot_data, aes(Week_end_Date, Ratio)) +
  geom_bar(stat = "identity", position = "stack", fill = pct_col) +
  facet_wrap(~Kommune, scales = "free", ncol = 5) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    limits = c(0, max_y_value)
  ) +
  labs(y = "Procent positive", x = "Dato", title = "Ugentlig procent positivt testede for udvalgte kommuner") +
  facet_theme

ggsave("../figures/muni_10_pct_july.png", width = 27, height = 20, units = "cm", dpi = 300)


# Figur: Procent - alle kommuner fra juli, ugenumre --------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date(today) - months(3)) %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100)

max_y_value <- ceiling(max(plot_data$Ratio, na.rm = TRUE))


ggplot(plot_data, aes(Week_end_Date, Ratio)) +
  geom_bar(stat = "identity", position = "stack", fill = pct_col) +
  facet_wrap(~Kommune, scales = "free") +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    limits = c(0, max_y_value)
  ) +
  labs(y = "Procent positive", x = "Dato", title = "Ugentlig procent positivt testede for alle kommuner") +
  facet_theme

ggsave("../figures/muni_all_pct_july.png", width = 46, height = 34, units = "cm", dpi = 300)


# Figur: Procent - udvalgte kommuner fra april, datoer --------


plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-07")) %>%
  group_by(Kommune) %>%
  filter(Kommune %in% muni_subset) %>%
  ungroup() %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100)

max_y_value <- ceiling(max(plot_data$Ratio, na.rm = TRUE) / 5) * 5

ggplot(plot_data, aes(Week_end_Date, Ratio)) +
  geom_bar(stat = "identity", position = "stack", fill = pct_col) +
  facet_wrap(~Kommune, scales = "free", ncol = 5) +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_y_continuous(
    limits = c(0, max_y_value)
  ) +
  labs(y = "Procent positive", x = "Dato", title = "Ugentlig procent positivt testede for udvalgte kommuner") +
  facet_theme

ggsave("../figures/muni_10_pct_april.png", width = 27, height = 20, units = "cm", dpi = 300)


# Figur: Daglige procent - kommuner med over 10 smittede fra aug -----------------



plot_data <- muni_all %>%
  filter(Date > as.Date(today) - months(3)) %>%
  filter(Kommune %in% muni_subset) %>%
  mutate(Ratio = Positive / Tested * 100)

max_y_value <- ceiling(max(plot_data$Ratio, na.rm = TRUE))


ggplot(plot_data, aes(Date, Ratio)) +
  geom_bar(stat = "identity", position = "stack", fill = pct_col) +
  facet_wrap(~Kommune, scales = "free", ncol = 5) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    limits = c(0, max_y_value)
  ) +
  labs(y = "Procent positive", x = "Dato", title = "Daglig procent positivt testede for udvalgte kommuner") +
  facet_theme

ggsave("../figures/muni_10_pct_daily.png", width = 27, height = 20, units = "cm", dpi = 300)


# -------------------------------------------------------------------------

# Figur: Incidens - alle kommuner, heatmap ---------------------------------


plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  mutate(Incidens = Positive_wk / Befolkningstal * 1000) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune)))))

ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Incidens)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal positive per indbyggertal") +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Promille", na.value = "White", low = lighten("#999999", 0.8), high = pos_col) +
  tile_theme + 
  theme(text = element_text(size = 12))


ggsave("../figures/muni_all_weekly_incidens_tile.png",width = 16, height = 38, units = "cm", dpi = 300)

# Figur: Procent - alle kommuner, heatmap ----------


plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune)))))


ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Ratio)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal positive per antal testede") +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten("#999999", 0.8), high = darken(pct_col, 0.1)) +
  tile_theme + 
  theme(text = element_text(size = 12))

ggsave("../figures/muni_all_weekly_pos_pct_tile.png", width = 16, height = 38, units = "cm", dpi = 300)


# Figur: Total test - alle kommuner, heatmap ---------------------------------


plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  mutate(Incidens = Tested_wk / Befolkningstal * 100) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 
  

ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Incidens)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal testede per indbyggertal") +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten("#999999", 0.8), high = test_col) +
  tile_theme + 
  theme(text = element_text(size = 12))


ggsave("../figures/muni_all_weekly_tests_tile.png",width = 16, height = 38, units = "cm", dpi = 300)





# -------------------------------------------------------------------------

# Figur: Incidens - udvalgte kommuner, heatmap ---------------------------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  mutate(Incidens = Positive_wk / Befolkningstal * 1000) %>%
  filter(Kommune %in% muni_subset) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 


ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Incidens)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal positive per indbyggertal for udvalgte kommuner") +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Promille", na.value = "White", low = lighten("#999999", 0.8), high = pos_col) +
  tile_theme + 
  theme(axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)))


ggsave("../figures/muni_10_weekly_incidens_tile.png", width = 20, height = 19, units = "cm", dpi = 300)

# Figur: Procent - udvalgte kommuner, heatmap ----------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100) %>%
  filter(Kommune %in% muni_subset) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 


ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Ratio)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal positive per antal testede for udvalgte kommuner") +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten("#999999", 0.8), high = darken(pct_col, 0.1)) +
  tile_theme + 
  theme(axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)))

ggsave("../figures/muni_10_weekly_pct_tile.png", width = 20, height = 19, units = "cm", dpi = 300)



# Figur: Total test - udvalgte kommuner, heatmap ---------------------------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  #mutate(Incidens = Tested_wk / Befolkningstal * 100) %>%
  filter(Kommune %in% muni_subset) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 


ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Tested_wk)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal testede i udvalgte kommuner") +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  scale_fill_continuous(name = "Antal", na.value = "White", low = lighten("#999999", 0.8), high = test_col) +
  tile_theme + 
  theme(axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)))


ggsave("../figures/muni_10_weekly_tests_tile.png", width = 20, height = 19, units = "cm", dpi = 300)



# -------------------------------------------------------------------------


# Figur: Positiv vs testede - landsdele -----------------------------------

plot_data <- landsdele_wk %>%
  filter(Week_end_Date > as.Date(today) - months(3)) %>%
  mutate(Positive_wk = Positive_wk * 100) %>%
  pivot_longer(cols = c(Positive_wk, Tested_wk), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Week_end_Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 1.5, aes(color = variable)) +
  facet_wrap(~Landsdel, scales = "free", ncol = 5) +
  scale_color_manual(name = "", labels = c("Positive", "Testede"), values = c(pos_col, test_col)) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Ugentligt antal nye positive og testede for landsdele") +
  facet_theme

ggsave("../figures/muni_pos_vs_test_landsdele.png", width = 29, height = 14, units = "cm", dpi = 300)

# Figur: Procent - landsdele -----------------------------------

plot_data <- landsdele_wk %>%
  filter(Week_end_Date > as.Date(today) - months(3)) %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100)

max_y_value <- ceiling(max(plot_data$Ratio, na.rm = TRUE))

ggplot(plot_data, aes(Week_end_Date, Ratio)) +
  geom_bar(stat = "identity", position = "stack", fill = pct_col) +
  facet_wrap(~Landsdel, scales = "free", ncol = 5) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    limits = c(0, max_y_value)
  ) +
  labs(y = "Procent positive", x = "Dato", title = "Ugentlig procent positivt testede for landsdele") +
  facet_theme

ggsave("../figures/muni_pct_landsdele.png", width = 29, height = 14, units = "cm", dpi = 300)


# Figur: Positiv vs testede - NJ kommuner, 1 md------------------

nj7 <- c("Frederikshavn", "Hjørring", "Vesthimmerlands", "Brønderslev", "Jammerbugt", "Thisted", "Læsø")

plot_data <- muni_all %>%
  filter(Date > as.Date(today) - months(1)) %>%
  group_by(Kommune) %>%
  filter(Kommune %in% nj7) %>%
  ungroup() %>%
  mutate(Positive = Positive * 100) %>%
  pivot_longer(cols = c(Positive, Tested), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Date, value)) +
  geom_bar(data = subset(plot_data, variable == 'Positive'), stat = "identity", position = "identity", size = 1, aes(fill = variable)) +
  geom_line(data = subset(plot_data, variable == 'Tested'), stat = "identity", position = "identity", size = 1, aes(color = variable)) +
  facet_wrap(~Kommune, scales = "free", ncol = 4) +
  scale_fill_manual(name = "", labels = c("Positive"), values = alpha(pos_col, 0.8)) +
  scale_color_manual(name = "", labels = c("Testede"), values = test_col) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Dagligt antal nye positive og testede for 7 nordjyske kommuner") +
  facet_theme

ggsave("../figures/muni_NJ7_pos_vs_test.png", width = 28, height = 15, units = "cm", dpi = 300)

# Figur: Procent - NJ kommuner, 1 md --------

plot_data <- muni_all %>%
  filter(Date > as.Date(today) - months(1)) %>%
  group_by(Kommune) %>%
  filter(Kommune %in% nj7) %>%
  ungroup() %>%
  mutate(Ratio = Positive / Tested * 100)

max_y_value <- ceiling(max(plot_data$Ratio, na.rm = TRUE))

ggplot(plot_data, aes(Date, Ratio)) +
  geom_bar(stat = "identity", position = "stack", fill = pct_col) +
  facet_wrap(~Kommune, scales = "free", ncol = 4) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_y_continuous(
    limits = c(0, max_y_value)
  ) +
  labs(y = "Procent positive", x = "Dato", title = "Daglig procent positivt testede for 7 nordjyske kommuner") +
  facet_theme

ggsave("../figures/muni_NJ7_pct.png", width = 27, height = 13, units = "cm", dpi = 300)

# procent med og uden nordjylland -----------------------------------------
nj7 <- c("Frederikshavn", "Hjørring", "Vesthimmerlands", "Brønderslev", "Jammerbugt", "Thisted", "Læsø")


muni_all %>%
  full_join(geo, by = "Kommune") %>%
  filter(Date > as.Date(today)- months(1)) %>%
  mutate(nj7 = ifelse(Kommune %in% nj7, TRUE, FALSE)) %>%
  group_by(Date) %>%
  mutate(pct_total = sum(Positive, na.rm = TRUE)/sum(Tested, na.rm = TRUE) * 100) %>%
  ungroup() %>%
  group_by(nj7, Date) %>%
  mutate(pct_stratified = sum(Positive, na.rm = TRUE)/sum(Tested, na.rm = TRUE) * 100) %>%
  ungroup() %>%
  filter(!nj7) %>%
  select(Date, pct_stratified, pct_total) %>%
  distinct() %>%
  pivot_longer(-Date, names_to = "variable", values_to = "values") %>%
  ggplot(aes(Date, values)) +
  geom_line(aes(color = variable), size = 2) + 
  scale_x_date(date_labels = "%e. %b", date_breaks = "1 week") +
  labs(y = "Positivprocent", x = "Dato", title = "Positivprocent med og uden de 7 nordjyske kommuner") +
  scale_color_manual(name = "", labels = c("Uden nordjylland", "Hele landet"), values = c(lighten(pct_col, 0.2), darken(pct_col, 0.2))) +
  scale_y_continuous(
    limits = c(0, NA)
  ) +
  standard_theme

ggsave("../figures/muni_pct_stratified.png", width = 20, height = 12, units = "cm", dpi = 300)


