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

# Figur: Daglige positiv vs testede - kommuner med over 10 smittede fra aug --------

plot_data <- muni_all %>%
  filter(Date > as.Date("2020-08-01")) %>%
  filter(Kommune %in% muni_10) %>%
  mutate(Positive = Positive * 100) %>%
  pivot_longer(cols = c(Positive, Tested), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 0.8, aes(color = variable)) +
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
  labs(y = "Procent positive", x = "Uge", title = "Ugentlig procent positive tests for udvalgte kommuner") +
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
    limits = c(0, 5)
  ) +
  labs(y = "Procent positive", x = "Uge", title = "Daglig procent positive tests for udvalgte kommuner") +
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
  labs(y = "Procent positive", x = "Uge", title = "Ugentlig procent positive tests for alle kommuner") +
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
  labs(y = "Procent positive", x = "Dato", title = "Ugentlig procent positive tests udvalgte kommuner") +
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

# Figur: Procent - alle kommuner, heatmap ----------


plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-04-07")) %>%
  mutate(Ratio = Positive_wk / Tested_wk * 100) %>%
  mutate(Kommune = factor(Kommune, levels = rev(sort(unique(Kommune)))))


ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Ratio)) +
  geom_tile(colour = "white", size = 0.25) +
  coord_fixed(ratio = 7) +
  labs(x = "", y = "", title = "Procent positive tests per udførte tests") +
  scale_fill_continuous(name = "Procent", na.value = "White", low = lighten(desaturate(color_scale[6], 0.7), 0.7), high = color_scale[4]) +
  theme_light() +
  theme(
    plot.background = element_blank(),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    text = element_text(size = 13, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    axis.title.y = element_text(size = 12, family = "lato"),
    axis.title.x = element_text(size = 12, family = "lato")
  )

ggsave("../figures/all_muni_weekly_pos_pct_tile.png", width = 16, height = 50, units = "cm", dpi = 300)


# Figur: Incidens - alle kommuner, heatmap ---------------------------------


# plot_data <- muni_wk %>%
#   filter(Week_end_Date > as.Date("2020-04-07")) %>%
#   mutate(Ratio = Pos_diff/Befolkningstal * 100000) %>%
#   mutate(`Kommune_(navn)`=factor(`Kommune_(navn)`,levels=rev(sort(unique(`Kommune_(navn)`)))))
#
# ggplot(plot_data, aes(Date, `Kommune_(navn)`, fill = Ratio)) +
#   geom_tile(colour="white",size=0.25) +
#   coord_fixed(ratio = 7) +
#   labs(x="",y="", title="Antal positive tests per 100.000 indbyggere") +
#   scale_fill_continuous(name = "Antal/100.000",low =  "#00AFBB", high = "#FC4E07") +
#   theme_light() +
#   theme(plot.background=element_blank(),
#         panel.border=element_blank(),
#         axis.ticks = element_blank(),
#         plot.title=element_text(size = 14, hjust=0.5, face="bold"),
#         text = element_text(size=13, family="lato"),
#         legend.text=element_text(size=12, family="lato"),
#         axis.title.y = element_text(size=12, family="lato"),
#         axis.title.x = element_text(size=12, family="lato"))
#
#
# ggsave("../figures/all_muni_weekly_incidens_tile.png",width = 17, height = 50, units = "cm", dpi = 300)

# Figur: Pos over 50 vs nyindlagte, fra marts -----------------------------------------------------


plot_data <- age_data %>%
  mutate(value = ifelse(variable == "admitted", -value, value)) %>%
  mutate(variable = ifelse(variable == "admitted", "z_admitted", variable)) %>%
  filter(variable %in% c("old", "z_admitted"))

ggplot(plot_data, aes(Date, value)) +
  geom_bar(stat = "identity", position = "stack", aes(fill = variable)) +
  scale_fill_manual(name = "", labels = c("Pos over 50 år", "Nyindlagte"), values = alpha(c(pos_col, admit_col), 0.9)) +
  labs(y = "Antal", x = "Dato", title = "Ugentligt antal positive testede ældre vs. total nyindlagte") +
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
  labs(y = "Antal", x = "Dato", title = "Ugentligt antal positive testede yngre vs. total nyindlagte") +
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
  labs(y = "Antal", x = "Dato", title = "Ugentligt antal positive tests for ældre og yngre") +
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
  labs(y = "Andel", x = "Dato", title = "Ugentlig fordeling af positive tests mellem ældre og yngre") +
  # scale_y_continuous(breaks = c(-500,0, 500, 1000),labels=as.character(c("500","0", "500", "1000"))) +
  theme_minimal() +
  theme(
    text = element_text(size = 11, family = "lato"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/age_group_fill.png", width = 17, height = 12, units = "cm", dpi = 300)

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
  scale_color_manual(name = "", labels = c("Positive", "Testede"), values = c(pos_col, test_col)) +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, 50000)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Positive og testede per uge for hver aldersgruppe") +
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

ggsave("../figures/age_groups_pos_tested.png", width = 30, height = 15, units = "cm", dpi = 300)

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
