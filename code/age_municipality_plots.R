# Figur: Positiv vs testede - kommuner med over 10 smittede fra juli, ugenumre------------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-07-07")) %>%
  group_by(Kommune) %>%
  filter(max(Positive_wk) > 10) %>%
  ungroup() %>%
  mutate(Positive_wk = Positive_wk * 100) %>%
  pivot_longer(cols = c(Positive_wk, Tested_wk), names_to = "variable", values_to = "value")

muni_10 <- plot_data %>%
  pull(Kommune) %>%
  unique() # for later daily use

ggplot(plot_data, aes(Week, value)) +
  geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) +
  facet_wrap(~Kommune, scales = "free") +
  scale_color_manual(name = "", labels = c("Positive", "Testede"), values = c(pos_col, test_col)) +
  scale_x_continuous(breaks = breaks_width(2)) +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(y = "Positive : Testede", x = "Uge", title = "Ugentligt antal nye positive og testede for udvalgte kommuner") +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/muni_10_pos_vs_test_july.png", width = 30, height = 20, units = "cm", dpi = 300)

# Figur: Positiv vs testede - alle kommuner, ugenumre------------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-07-07")) %>%
  mutate(Positive_wk = Positive_wk * 100) %>%
  pivot_longer(cols = c(Positive_wk, Tested_wk), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Week, value)) +
  geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) +
  facet_wrap(~Kommune, scales = "free") +
  scale_color_manual(name = "", labels = c("Positive", "Testede"), values = c(pos_col, test_col)) +
  scale_x_continuous(breaks = breaks_width(2)) +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(y = "Positive : Testede", x = "Uge", title = "Ugentligt antal nye positive og testede for alle kommuner") +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/muni_all_pos_vs_test_july.png", width = 54, height = 36, units = "cm", dpi = 300)

# Figur: Positiv vs testede - kommuner med over 10 smittede fra april, datoer ------------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-07")) %>%
  group_by(Kommune) %>%
  filter(max(Positive_wk) > 10) %>%
  ungroup() %>%
  mutate(Positive_wk = Positive_wk * 100) %>%
  pivot_longer(cols = c(Positive_wk, Tested_wk), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Week_end_Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) +
  facet_wrap(~Kommune, scales = "free") +
  scale_color_manual(name = "", labels = c("Positive", "Testede"), values = c(pos_col, test_col)) +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Ugentligt antal nye positive og testede for udvalgte kommuner") +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/muni_10_pos_vs_test_april.png", width = 42, height = 27, units = "cm", dpi = 300)


# Figur: Procent - kommuner med over 10 smittede fra juli, ugenumre --------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-07-07")) %>%
  group_by(Kommune) %>%
  filter(max(Positive_wk) > 10) %>%
  ungroup() %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100)


ggplot(plot_data, aes(Week, Ratio)) +
  geom_bar(stat = "identity", position = "stack", fill = pct_col) +
  facet_wrap(~Kommune, scales = "free") +
  scale_x_continuous(breaks = breaks_width(2)) +
  scale_y_continuous(
    limits = c(0, 5)
  ) +
  labs(y = "Procent positive", x = "Uge", title = "Ugentlig procent positivt testede for udvalgte kommuner") +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/muni_10_pct_july.png", width = 27, height = 20, units = "cm", dpi = 300)


# Figur: Procent - alle kommuner fra juli, ugenumre --------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-07-07")) %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100)


ggplot(plot_data, aes(Week, Ratio)) +
  geom_bar(stat = "identity", position = "stack", fill = pct_col) +
  facet_wrap(~Kommune, scales = "free") +
  scale_x_continuous(breaks = breaks_width(2)) +
  scale_y_continuous(
    limits = c(0, 5)
  ) +
  labs(y = "Procent positive", x = "Uge", title = "Ugentlig procent positivt testede for alle kommuner") +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/muni_all_pct_july.png", width = 46, height = 34, units = "cm", dpi = 300)


# Figur: Procent - kommuner med over 10 smittede fra april, datoer --------


plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-07")) %>%
  group_by(Kommune) %>%
  filter(max(Positive_wk) > 10) %>%
  ungroup() %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100)


ggplot(plot_data, aes(Week_end_Date, Ratio)) +
  geom_bar(stat = "identity", position = "stack", fill = pct_col) +
  facet_wrap(~Kommune, scales = "free") +
  scale_y_continuous(
    limits = c(0, 20)
  ) +
  labs(y = "Procent positive", x = "Dato", title = "Ugentlig procent positivt testede for udvalgte kommuner") +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/muni_10_pct_april.png", width = 32, height = 24, units = "cm", dpi = 300)


# Figur: Daglige positiv vs testede - kommuner med over 10 smittede fra aug --------

plot_data <- muni_all %>%
  filter(Date > as.Date("2020-08-01")) %>%
  filter(Kommune %in% muni_10) %>%
  mutate(Positive = Positive * 100) %>%
  pivot_longer(cols = c(Positive, Tested), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 0.6, aes(color = variable)) +
  facet_wrap(~Kommune, scales = "free") +
  scale_color_manual(name = "", labels = c("Positive", "Testede"), values = c(pos_col, test_col)) +
  scale_x_date(date_labels = "%e. %b", date_breaks = "1 month") +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Dagligt antal nye positive og testede for udvalgte kommuner") +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/muni_10_pos_vs_test_daily.png", width = 30, height = 20, units = "cm", dpi = 300)


# Figur: Daglige procent - kommuner med over 10 smittede fra aug -----------------



plot_data <- muni_all %>%
  filter(Date > as.Date("2020-08-01")) %>%
  filter(Kommune %in% muni_10) %>%
  mutate(Ratio = Positive / Tested * 100)


ggplot(plot_data, aes(Date, Ratio)) +
  geom_bar(stat = "identity", position = "stack", fill = pct_col) +
  facet_wrap(~Kommune, scales = "free") +
  scale_x_date(date_labels = "%e. %b", date_breaks = "1 month") +
  scale_y_continuous(
    limits = c(0, 6)
  ) +
  labs(y = "Procent positive", x = "Uge", title = "Daglig procent positivt testede for udvalgte kommuner") +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/muni_10_pct_daily.png", width = 27, height = 20, units = "cm", dpi = 300)


# Figur: Procent - alle kommuner, heatmap ----------


plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune)))))


ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Ratio)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal positive per antal testede") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten("#999999", 0.8), high = darken(pct_col, 0.1)) +
  theme_tufte() +
  theme(
    plot.background = element_blank(),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    text = element_text(size = 13, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    axis.text.y = element_text(margin = margin(t = 0, r = -5, b = 0, l = 0)),
    axis.title.y = element_text(size = 12, family = "lato"),
    axis.title.x = element_text(size = 12, family = "lato")
  )

ggsave("../figures/all_muni_weekly_pos_pct_tile.png", width = 16, height = 44, units = "cm", dpi = 300)


# Figur: Incidens - alle kommuner, heatmap ---------------------------------


plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  mutate(Incidens = Positive_wk / Befolkningstal * 1000) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune)))))

ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Incidens)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal positive per indbyggertal") +
  scale_fill_continuous(name = "Promille", na.value = "White", low = lighten("#999999", 0.8), high = pos_col) +
  theme_tufte() +
  theme(
    plot.background = element_blank(),
    panel.border = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    text = element_text(size = 13, family = "lato"),
    axis.text.y = element_text(margin = margin(t = 0, r = -5, b = 0, l = 0)),
    legend.text = element_text(size = 12, family = "lato"),
    axis.title.y = element_text(size = 12, family = "lato"),
    axis.title.x = element_text(size = 12, family = "lato"),
    axis.ticks = element_blank()
  )


ggsave("../figures/all_muni_weekly_incidens_tile.png",width = 16, height = 44, units = "cm", dpi = 300)

# Figur: Total test incidens - alle kommuner, heatmap ---------------------------------


plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  mutate(Incidens = Tested_wk / Befolkningstal * 100) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 
  

ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Incidens)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal testede per indbyggertal") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten("#999999", 0.8), high = test_col) +
  theme_tufte() +
  theme(
    plot.background = element_blank(),
    panel.border = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    text = element_text(size = 13, family = "lato"),
    axis.text.y = element_text(margin = margin(t = 0, r = -5, b = 0, l = 0)),
    legend.text = element_text(size = 12, family = "lato"),
    axis.title.y = element_text(size = 12, family = "lato"),
    axis.title.x = element_text(size = 12, family = "lato"),
    axis.ticks = element_blank()
  )


ggsave("../figures/all_muni_weekly_tests_tile.png",width = 16, height = 44, units = "cm", dpi = 300)


# Figur: Total test incidens - kommuner med over 10 smittede, heatmap ---------------------------------
biggest_10 <- muni_wk %>% group_by(Kommune) %>% summarize(x = mean(Befolkningstal)) %>% arrange(desc(x)) %>% slice(1:10) %>% pull(Kommune)

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  #mutate(Incidens = Tested_wk / Befolkningstal * 100) %>%
  filter(Kommune %in% muni_10) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 


ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Tested_wk)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal testede i udvalgte kommuner") +
  scale_fill_continuous(name = "Antal", na.value = "White", low = lighten("#999999", 0.8), high = test_col) +
  theme_tufte() +
  theme(
    plot.background = element_blank(),
    panel.border = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    text = element_text(size = 14, family = "lato"),
    axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)),
    legend.text = element_text(size = 12, family = "lato"),
    axis.title.y = element_text(size = 12, family = "lato"),
    axis.title.x = element_text(size = 12, family = "lato"),
    axis.ticks = element_blank()
  )


ggsave("../figures/muni_10_weekly_tests_tile.png", width = 20, height = 25, units = "cm", dpi = 300)

# Figur: Incidens - kommuner med over 10 smittede, heatmap ---------------------------------
biggest_10 <- muni_wk %>% group_by(Kommune) %>% summarize(x = mean(Befolkningstal)) %>% arrange(desc(x)) %>% slice(1:10) %>% pull(Kommune)

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  mutate(Incidens = Positive_wk / Befolkningstal * 1000) %>%
  filter(Kommune %in% muni_10) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 

ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Incidens)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal positive per indbyggertal for udvalgte kommuner") +
  scale_fill_continuous(name = "Promille", na.value = "White", low = lighten("#999999", 0.8), high = pos_col) +
  theme_tufte() +
  theme(
    plot.background = element_blank(),
    panel.border = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    text = element_text(size = 14, family = "lato"),
    axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)),
    legend.text = element_text(size = 12, family = "lato"),
    axis.title.y = element_text(size = 12, family = "lato"),
    axis.title.x = element_text(size = 12, family = "lato"),
    axis.ticks = element_blank()
  )


ggsave("../figures/muni_10_weekly_incidens_tile.png", width = 20, height = 25, units = "cm", dpi = 300)

# Figur: Procent - kommuner med over 10 smittede, heatmap ----------
biggest_10 <- muni_wk %>% group_by(Kommune) %>% summarize(x = mean(Befolkningstal)) %>% arrange(desc(x)) %>% slice(1:10) %>% pull(Kommune)

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-01")) %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100) %>%
  filter(Kommune %in% muni_10) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune))))) 


ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Ratio)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Ugentligt antal positive per antal testede for udvalgte kommuner") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten("#999999", 0.8), high = darken(pct_col, 0.1)) +
  theme_tufte() +
  theme(
    plot.background = element_blank(),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    text = element_text(size = 14, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)),
    axis.title.y = element_text(size = 12, family = "lato"),
    axis.title.x = element_text(size = 12, family = "lato")
  )

ggsave("../figures/muni_10_weekly_pct_tile.png", width = 20, height = 25, units = "cm", dpi = 300)


# Figur: Pos over 50 vs nyindlagte, fra marts -----------------------------------------------------


plot_data <- age_data %>%
  mutate(value = ifelse(variable == "admitted", -value, value)) %>%
  mutate(variable = ifelse(variable == "admitted", "z_admitted", variable)) %>%
  filter(variable %in% c("old", "z_admitted"))

ggplot(plot_data, aes(Date, value)) +
  geom_bar(stat = "identity", position = "stack", aes(fill = variable)) +
  scale_fill_manual(name = "", labels = c("Pos over 50 år", "Nyindlagte"), values = alpha(c(pos_col, admit_col), 0.9)) +
  labs(y = "Antal", x = "Dato", title = "Ugentligt antal positivt testede ældre vs. total nyindlagte") +
  scale_y_continuous(breaks = c(-500, 0, 500, 1000), labels = as.character(c("500", "0", "500", "1000"))) +
  theme_minimal() +
  theme(
    text = element_text(size = 11, family = "lato"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/age_group_admitted_pos_old.png", width = 17, height = 12, units = "cm", dpi = 300)


# Figur: Pos under 50 vs nyindlagte, fra marts -----------------------------------

plot_data <- age_data %>%
  mutate(value = ifelse(variable == "admitted", -value, value)) %>%
  mutate(variable = ifelse(variable == "admitted", "z_admitted", variable)) %>%
  filter(variable %in% c("young", "z_admitted"))

ggplot(plot_data, aes(Date, value)) +
  geom_bar(stat = "identity", position = "stack", aes(fill = variable)) +
  scale_fill_manual(name = "", labels = c("Pos under 50 år", "Nyindlagte"), values = alpha(c(pos_col, admit_col), 0.9)) +
  labs(y = "Antal", x = "Dato", title = "Ugentligt antal positivt testede yngre vs. total nyindlagte") +
  scale_y_continuous(breaks = c(-500, 0, 500, 1000), labels = as.character(c("500", "0", "500", "1000"))) +
  theme_minimal() +
  theme(
    text = element_text(size = 11, family = "lato"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/age_group_admitted_pos_young.png", width = 17, height = 12, units = "cm", dpi = 300)

# Figur: Andel ung vs gammel stack, fra marts ----------------------------

plot_data <- age_data %>%
  filter(variable %in% c("young", "old"))

ggplot(plot_data, aes(Date, value)) +
  geom_bar(stat = "identity", position = "stack", aes(fill = variable)) +
  scale_fill_manual(name = "Alder", labels = c("Over 50 år", "Under 50 år"), values = binary_col) +
  labs(y = "Antal", x = "Dato", title = "Ugentligt antal positivt testede ældre og yngre") +
  # scale_y_continuous(breaks = c(-500,0, 500, 1000),labels=as.character(c("500","0", "500", "1000"))) +
  theme_minimal() +
  theme(
    text = element_text(size = 11, family = "lato"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/age_group_stack.png", width = 17, height = 12, units = "cm", dpi = 300)

# Figur: Andel ung vs gammel fill, fra marts ----------------------------

plot_data <- age_data %>%
  filter(variable %in% c("young", "old"))

ggplot(plot_data, aes(Date, value)) +
  geom_bar(stat = "identity", position = "fill", aes(fill = variable)) +
  scale_fill_manual(name = "Alder", labels = c("Over 50 år", "Under 50 år"), values = binary_col) +
  labs(y = "Andel", x = "Dato", title = "Ugentlig fordeling af positivt testede: ældre vs. yngre") +
  # scale_y_continuous(breaks = c(-500,0, 500, 1000),labels=as.character(c("500","0", "500", "1000"))) +
  theme_minimal() +
  theme(
    text = element_text(size = 11, family = "lato"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/age_group_fill.png", width = 17, height = 12, units = "cm", dpi = 300)



# Figur: Aldersgrupper, pos, testede --------------------------------------------------------------


plot_data <- week_df %>%
  select(-date_of_file) %>%
  filter(!Aldersgruppe == "I alt") %>%
  rename(Testede = Antal_testede) %>%
  pivot_longer(cols = c(positive, Testede), names_to = "variable", values_to = "value") %>%
  group_by(Aldersgruppe, variable) %>%
  mutate(value = c(0, diff(value))) %>%
  mutate(value = ifelse(variable == "positive", value * 100, value))

ggplot(plot_data, aes(Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) +
  facet_wrap(~Aldersgruppe, scales = "free") +
  scale_color_manual(name = "", labels = c("Positive", "Nye testede"), values = c(pos_col, test_col)) +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, 50000)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Positive og nye testede per uge for hver aldersgruppe") +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(size = 12, face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/age_groups_pos_tested.png", width = 31, height = 15, units = "cm", dpi = 300)

# Figur: Aldersgrupper, pct --------------------------------------------------------------

plot_data <- week_df %>%
  select(-date_of_file) %>%
  filter(!Aldersgruppe == "I alt") %>%
  rename(Testede = Antal_testede) %>%
  pivot_longer(cols = c(positive, Testede), names_to = "variable", values_to = "value") %>%
  group_by(Aldersgruppe, variable) %>%
  mutate(value = c(0, diff(value))) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  mutate(Ratio = positive / Testede * 100)

ggplot(plot_data, aes(Date, Ratio)) +
  geom_bar(stat = "identity", position = "stack", fill = pct_col) +
  facet_wrap(~Aldersgruppe, scales = "free") +
  labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
  scale_y_continuous(
    limits = c(0, 17)
  ) +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    plot.title = element_text(size = 12, face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/age_groups_pct.png", width = 22, height = 14, units = "cm", dpi = 300)


# Figur: Aldersgrupper, incidens, heatmap ----------


plot_data <- week_df %>%
  select(-date_of_file) %>%
  filter(!Aldersgruppe == "I alt") %>%
  full_join(dst_age, by = "Aldersgruppe") %>%
  rename(Testede = Antal_testede) %>%
  pivot_longer(cols = c(positive, Testede), names_to = "variable", values_to = "value") %>%
  group_by(Aldersgruppe, variable) %>%
  mutate(value = c(0, diff(value))) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  mutate(Ratio = positive / Befolkning * 1000) %>%
  filter(Date > as.Date("2020-03-18"))


ggplot(plot_data, aes(Date, Aldersgruppe, fill = Ratio)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Positivt testede per befolkningstal i aldersgruppen") +
  scale_fill_continuous(name = "Promille", na.value = "White", low = lighten("#999999", 0.8), high = pos_col) +
  theme_tufte() +
  theme(
    plot.background = element_blank(),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    text = element_text(size = 14, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)),
    axis.title.x = element_text(size = 12, family = "lato")
  )

ggsave("../figures/age_weekly_incidens_tile.png", width = 25, height = 12, units = "cm", dpi = 300)

# Figur: Aldersgrupper, total test incidens, heatmap ----------


plot_data <- week_df %>%
  select(-date_of_file) %>%
  filter(!Aldersgruppe == "I alt") %>%
  full_join(dst_age, by = "Aldersgruppe") %>%
  rename(Testede = Antal_testede) %>%
  pivot_longer(cols = c(positive, Testede), names_to = "variable", values_to = "value") %>%
  group_by(Aldersgruppe, variable) %>%
  mutate(value = c(0, diff(value))) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  mutate(Ratio = Testede / Befolkning * 100) %>%
  filter(Date > as.Date("2020-03-18"))


ggplot(plot_data, aes(Date, Aldersgruppe, fill = Ratio)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Antal nye testede per befolkningstal i aldersgruppen") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten("#999999", 0.8), high = test_col) +
  theme_tufte() +
  theme(
    plot.background = element_blank(),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    text = element_text(size = 14, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)),
    axis.title.x = element_text(size = 12, family = "lato")
  )

ggsave("../figures/age_weekly_tests_tile.png", width = 25, height = 12, units = "cm", dpi = 300)


# Figur: Aldersgrupper, pct, heatmap ----------

plot_data <- week_df %>%
  select(-date_of_file) %>%
  filter(!Aldersgruppe == "I alt") %>%
  rename(Testede = Antal_testede) %>%
  pivot_longer(cols = c(positive, Testede), names_to = "variable", values_to = "value") %>%
  group_by(Aldersgruppe, variable) %>%
  mutate(value = c(0, diff(value))) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  mutate(Ratio = positive / Testede * 100) %>%
  filter(Date > as.Date("2020-03-18"))


ggplot(plot_data, aes(Date, Aldersgruppe, fill = Ratio)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Positivt testede per nye testede (procent positive) i aldersgruppen") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten("#999999", 0.8), high = darken(pct_col, 0.1)) +
  theme_tufte() +
  theme(
    plot.background = element_blank(),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    text = element_text(size = 14, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.text.y = element_text(margin = margin(t = 0, r = -15, b = 0, l = 0)),
    axis.title.x = element_text(size = 12, family = "lato")
  )

ggsave("../figures/age_weekly_pct_tile.png", width = 25, height = 12, units = "cm", dpi = 300)




# Figur: Test: cases_by_age vs test_pos_over_time  -------------------------------------

plot_data <- week_df %>%
  select(-date_of_file) %>%
  filter(Aldersgruppe == "I alt") %>%
  select(Date, positive) %>%
  rename(Pos_agedata = positive) %>%
  pivot_longer(cols = -Date, names_to = "variable", values_to = "value") %>%
  group_by(variable) %>%
  mutate(value = c(0, diff(value))) 

test_1 <- tests %>%
  mutate(Week_end_Date = ceiling_date(Date + 4, unit = "week", getOption("lubridate.week.start", 0)) - 4) %>%
  select(Week_end_Date, NewPositive) %>%
  filter(Week_end_Date > as.Date("2020-03-11")) %>%
  rename(Date = Week_end_Date, Pos_testdata = NewPositive) %>%
  group_by(Date) %>%
  summarise_all(sum) %>%
  ungroup() %>%
  pivot_longer(cols = -Date, names_to = "variable", values_to = "value")  %>%
  filter(!Date == "2020-03-18", Date <= max(plot_data$Date))

plot_data <- bind_rows(plot_data, test_1)

ggplot(plot_data, aes(Date, value)) +
  geom_bar(stat = "identity", position = "dodge", aes(fill = variable)) +
  scale_fill_discrete(name = "Datasæt", labels = c("Cases_by_age", "Test_pos_over_time")) +
  labs(y = "Antal", x = "Dato", title = "Ugentligt antal positive") +
  # scale_y_continuous(breaks = c(-500,0, 500, 1000),labels=as.character(c("500","0", "500", "1000"))) +
  theme_minimal() +
  theme(
    text = element_text(size = 11, family = "lato"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/dataset_comparison.png", width = 25, height = 12, units = "cm", dpi = 300)

# Figur: Previously tested vs never before tested  -------------------------------------

plot_data <- week_df %>%
  select(-date_of_file) %>%
  filter(Aldersgruppe == "I alt") %>%
  select(Date, Antal_testede) %>%
  rename(Tested_kum_unique = Antal_testede) %>%
  pivot_longer(cols = -Date, names_to = "variable", values_to = "value") %>%
  mutate(diff = c(0, diff(value))) 
  

test_1 <- tests %>%
  mutate(Week_end_Date = ceiling_date(Date + 4, unit = "week", getOption("lubridate.week.start", 0)) - 4) %>%
  select(Week_end_Date, Tested_kumulativ) %>%
  filter(Week_end_Date > as.Date("2020-03-11")) %>%
  rename(Date = Week_end_Date, Tested_kum_total = Tested_kumulativ) %>%
  group_by(Date) %>%
  mutate(Tested_kum_total = max(Tested_kum_total))
  pivot_longer(cols = -Date, names_to = "variable", values_to = "value")  %>%
  filter(!Date == "2020-03-18", Date <= max(plot_data$Date)) %>%
  mutate(diff = c(0, diff(value))) 

plot_data <- bind_rows(plot_data, test_1)

ggplot(plot_data, aes(Date, value/1000000)) +
  geom_bar(stat = "identity", position = "dodge", aes(fill = variable)) +
  scale_fill_discrete(name = "Kategori", labels = c("Testede (inkl gengangere)", "Unikke testede personer")) +
  labs(y = "Antal (millioner)", x = "Dato", title = "Antal testede (kumulativ)") +
  # scale_y_continuous(breaks = c(-500,0, 500, 1000),labels=as.character(c("500","0", "500", "1000"))) +
  theme_minimal() +
  theme(
    text = element_text(size = 11, family = "lato"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/prev_tested_new_tested.png", width = 25, height = 15, units = "cm", dpi = 300)
# Experiments --------

ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 1)
}
tests_x <- tests %>% mutate(
  running_avg_pct = ra(pct_confirmed),
  running_avg_pos = ra(NewPositive),
  running_avg_total = ra(Tested)
)

admitted_x <- admitted %>%
  mutate(running_avg = ra(Total))

norm_pos <- tests_x %>% full_join(admitted_x, by = "Date") %>% filter(Date == as.Date("2020-07-01")) %>% mutate(Ratio = running_avg/running_avg_pos) %>% pull(Ratio)
norm_pct <- tests_x %>% full_join(admitted_x, by = "Date") %>% filter(Date == as.Date("2020-07-01")) %>% mutate(Ratio = running_avg/running_avg_pct) %>% pull(Ratio)

plot_data <- tests_x %>%
  full_join(admitted_x, by = "Date") %>%
  filter(Date > as.Date("2020-05-01")) %>%
  select(Date, Total, running_avg, running_avg_pct, running_avg_pos) %>%
  mutate(Ratio_0 = lead(Total,0)/running_avg_pct/norm_pct,
         Ratio_1 = lead(Total,1)/running_avg_pct/norm_pct,
         Ratio_2 = lead(Total,2)/running_avg_pct/norm_pct,
         Ratio_3 = lead(Total,3)/running_avg_pct/norm_pct,
         Ratio_4 = lead(Total,4)/running_avg_pct/norm_pct,
         Ratio_5 = lead(Total,5)/running_avg_pct/norm_pct) %>%
  # mutate(Ratio_pos = running_avg/running_avg_pos/norm_pos,
  #        Ratio_pct = running_avg/running_avg_pct/norm_pct) %>%
   pivot_longer(cols = c(Ratio_0:Ratio_5), names_to = "variable", values_to = "values")

plot_data %>% 
  group_by(variable) %>%
  summarize(max = max(values, na.rm = TRUE),
            min = min(values, na.rm = TRUE)) %>%
  mutate(range = max - min)


ggplot(plot_data, aes(Date, values)) +
  geom_line(stat = "identity", position = "identity" , aes(color = variable)) +
  labs(y = "Procent positive", x = "Uge", title = "Ugentlig procent positivt testede for udvalgte kommuner") +
  scale_y_continuous(
    limits = c(0, NA)
  ) +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )




