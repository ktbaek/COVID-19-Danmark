
plot_data <- read_csv2(paste0("../data/Vax_data/Vaccine_DB_", vax_today_string, "/Vaccine_uge_alder_vaccinstage.csv"), locale = locale(encoding = "ISO-8859-1")) %>% 
  select(Uge, Aldersgruppe, `Samlet dækning 1. stik (%)`, `Samlet dækning 2. stik (%)`, `Samlet dækning 3. stik (%)`) %>% 
  pivot_longer(c(-Uge, -Aldersgruppe)) %>%
  mutate(value = as.double(value)) %>% 
  mutate(
    Year = str_sub(Uge, 1, 4),
    Week = str_sub(Uge, 7, 8),
    Date = week_to_date(Year, Week),
    value = ifelse(value == 0, NA, value),
    Aldersgruppe = case_when(
      Aldersgruppe == "00-02" ~ "0-2",
      Aldersgruppe == "03-04" ~ "3-4",
      Aldersgruppe == "05-11" ~ "5-11",
      TRUE ~ Aldersgruppe
      )
  )

plot_data$Aldersgruppe <- factor(plot_data$Aldersgruppe, levels = c("0-2", "3-4", "5-11", "12-15", "16-19", "20-39", "40-64", "65-79", "80+"))

plot_data %>% 
  ggplot() +
  geom_line(aes(Date, value, color = name), size = 1) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
  scale_y_continuous(
    limits = c(0, NA), 
    labels = function(x) paste0(x, " %")
  ) +
  facet_wrap(~Aldersgruppe) +
  scale_color_manual(name = "", labels = c("Første dose", "Anden dose", "Tredje dose"), values = c("#30e3ca", "#11999e", "#1c3499")) +
  labs(y = "Procent", title = "Andel COVID-19 vaccinerede", caption = standard_caption) +
  facet_theme +
  theme(
    plot.margin = margin(0.5, 1, 0.2, 0.5, "cm"),
    plot.title = element_text(margin = margin(b = 3)),
    legend.margin = margin(t = 1)
  )

ggsave("../figures/ntl_vax_pct_age.png", width = 18, height = 10, units = "cm", dpi = 300)