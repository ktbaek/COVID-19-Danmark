Sys.setlocale("LC_ALL", "da_DK.UTF-8")

paultol_colors <- c("#CC6677", "#332288", "#DDCC77", "#117733", "#88CCEE", "#882255", "#44AA99", "#999933", "#AA4499")

plot_data <- read_csv2("../data/SSI_weekly_age_data.csv")

plot_data$Aldersgruppe <- factor(plot_data$Aldersgruppe, levels = c("0-2", "3-5", "6-11", "12-15", "16-19", "20-39", "40-64", "65-79", "80+"))

plot_layer <- list(
  geom_line(aes(Date, Value, color = Aldersgruppe), size = 0.8),
  scale_color_manual(name = "", values = paultol_colors),
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month", expand = expansion(mult = 0.01)),
  scale_y_continuous(limits = c(0, NA)),
  guides(colour = guide_legend(nrow = 1)),
  standard_theme
)

plot_data %>%
  filter(
    Type == "incidence",
    Variable == "admitted"
  ) %>%
  ggplot() +
  plot_layer +
  labs(
    y = "Nyindlagte pr. 100.000",
    x = "Dato",
    title = "Ugentligt antal SARS-CoV-2-positive nyindlagte pr. 100.000",
    caption = standard_caption
  )

ggsave("../figures/ntl_hosp_age.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(
    Type == "antal",
    Variable == "admitted"
  ) %>%
  ggplot() +
  plot_layer +
  labs(
    y = "Nyindlagte",
    x = "Dato",
    title = "Ugentligt antal SARS-CoV-2-positive nyindlagte",
    caption = standard_caption
  )

ggsave("../figures/ntl_hosp_age_abs.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(
    Type == "incidence",
    Variable == "admitted",
    Date > as_date("2021-02-28")
  ) %>%
  ggplot() +
  plot_layer +
  labs(
    y = "Nyindlagte pr. 100.000",
    x = "Dato",
    title = "Ugentligt antal SARS-CoV-2-positive nyindlagte pr. 100.000",
    caption = standard_caption
  )

ggsave("../figures/ntl_hosp_age_2.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(
    Type == "incidence",
    Variable == "positive"
  ) %>%
  ggplot() +
  plot_layer +
  labs(
    y = "Positive pr. 100.000",
    x = "Dato",
    title = "Ugentligt antal SARS-CoV-2-positive pr. 100.000",
    caption = standard_caption
  )

ggsave("../figures/ntl_pos_age.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(
    Type == "incidence",
    Variable == "tested"
  ) %>%
  ggplot() +
  plot_layer +
  labs(
    y = "Testede pr. 100.000",
    x = "Dato",
    title = "Ugentligt antal SARS-CoV-2-testede pr. 100.000",
    caption = standard_caption
  )

ggsave("../figures/ntl_test_age.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(
    Type == "antal",
    Variable %in% c("tested", "positive"),
    Date > as_date("2020-08-01")
  ) %>%
  pivot_wider(names_from = Variable, values_from = Value) %>%
  mutate(Value = positive / tested * 100) %>%
  ggplot() +
  plot_layer +
  labs(
    y = "Positivprocent",
    x = "Dato",
    title = "Ugentlig SARS-CoV-2 positivprocent",
    caption = standard_caption
  )

ggsave("../figures/ntl_pct_age.png", width = 18, height = 10, units = "cm", dpi = 300)
