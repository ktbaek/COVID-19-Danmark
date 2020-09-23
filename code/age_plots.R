# Figur: Pos over 50 vs nyindlagte, fra marts -----------------------------------------------------


plot_data <- age_data %>%
  mutate(value = ifelse(variable == "admitted", -value, value)) %>%
  mutate(variable = ifelse(variable == "admitted", "z_admitted", variable)) %>%
  filter(variable %in% c("old", "z_admitted"))

ggplot(plot_data, aes(Date, value)) +
  geom_bar(stat = "identity", position = "stack", width = 6, aes(fill = variable)) +
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
  geom_bar(stat = "identity", position = "stack", width = 6, aes(fill = variable)) +
  scale_fill_manual(name = "", labels = c("Pos under 50 år", "Nyindlagte"), values = alpha(c(pos_col, admit_col), 0.9)) +
  labs(y = "Antal", x = "Dato", title = "Ugentligt antal positivt testede yngre vs. total nyindlagte") +
  scale_y_continuous(breaks = c(-500, 0, 500, 1000, 1500), labels = as.character(c("500", "0", "500", "1000", "1500"))) +
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

# Figur: Aldersgrupper, pct, heatmap fra maj ----------

plot_data <- week_df %>%
  filter(!Aldersgruppe == "I alt") %>%
  rename(Testede = Antal_testede) %>%
  pivot_longer(cols = c(positive, Testede), names_to = "variable", values_to = "value") %>%
  group_by(Aldersgruppe, variable) %>%
  mutate(value = c(0, diff(value))) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  mutate(Ratio = positive / Testede * 100) %>%
  filter(Date > as.Date("2020-05-15"))


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
    plot.title = element_text(size = 15, hjust = 0.5, face = "bold"),
    text = element_text(size = 15, family = "lato"),
    legend.text = element_text(size = 13, family = "lato"),
    legend.box.margin = margin(t = 0, r = 0, b = 0, l = 15),
    axis.title.y = element_text(size = 17, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.text.y = element_text(margin = margin(t = 0, r = -10, b = 0, l = 0)),
    axis.title.x = element_text(size = 17, family = "lato")
  )

ggsave("../figures/age_weekly_pct_tile_may.png", width = 21, height = 12, units = "cm", dpi = 250)



# Figur: Test: cases_by_age vs test_pos_over_time  -------------------------------------

plot_data <- week_df %>%
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
  summarize(Tested_kum_total = max(Tested_kum_total)) %>% 
  ungroup() %>%
  pivot_longer(cols = -Date, names_to = "variable", values_to = "value")  %>%
  mutate(diff = c(0, diff(value))) 

plot_data <- bind_rows(plot_data, test_1) %>% 
  filter(!Date == as.Date("2020-03-18"), !Date == as.Date("2020-09-16")) %>%
  select(-value) %>%
  pivot_wider(names_from = variable, values_from = diff) %>%
  mutate(new_tested = Tested_kum_total - Tested_kum_unique) %>%
  select(-Tested_kum_total) %>%
  pivot_longer(cols = -Date, names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Date,value)) +
  geom_bar(stat = "identity", position = "fill", aes(fill = variable)) +
  scale_fill_discrete(name = "Kategori", labels = c("Testet tidligere", "Førstegangstestede")) +
  labs(y = "Andel", x = "Dato", title = "Ugentlig andel af førstegangstestede vs. testede tidligere") +
  # scale_y_continuous(breaks = c(-500,0, 500, 1000),labels=as.character(c("500","0", "500", "1000"))) +
  theme_minimal() +
  theme(
    text = element_text(size = 11, family = "lato"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/prev_tested_new_tested.png", width = 25, height = 12, units = "cm", dpi = 300)
