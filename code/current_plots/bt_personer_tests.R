plot_data <- bt_2_extra %>%
  filter(
    Variable == "personer",
    Group == "notprevpos",
    !Age %in% c("0-5", "6-11"),
  ) %>%
  mutate(Date = as.Date(paste0(Year, sprintf("%02d", Week), "1"), "%Y%U%u")) %>% 
  mutate(Vax_status = case_when(
    Vax_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
    Vax_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
    TRUE ~ Vax_status
  )) %>% 
  filter(Vax_status %in% c("Ingen vaccination", "Fuld effekt 2 doser", "Fuld effekt 3 doser"))


plot_data$Age <- factor(plot_data$Age, levels = c("12-15", "16-19", "20-29", "30-39", "40-49", "50-59", "60-64", "65-69", "70-79", "80+"))
plot_data$Vax_status <- factor(plot_data$Vax_status, levels = c("Ingen vaccination", "Fuld effekt 2 doser", "Fuld effekt 3 doser"))


plot_data %>%
  ggplot() +
  geom_line(aes(Date, Value, color = Vax_status), size = 0.7) +
  scale_x_date(labels = my_date_labels, breaks = my_breaks, expand = expansion(mult = 0.01)) +
  scale_color_manual(name = "", values = c(pct_col, admit_col, "#67cc32")) +
  scale_y_continuous(limits = c(0, NA), labels = scales::number) +
  labs(
    y = "Antal",
    title = "Antal personer i hver vaccinationsgruppe",
    caption = standard_caption
  ) +
  facet_wrap(~ Age, ncol = 5) +
  facet_theme +
  guides(color = guide_legend(override.aes = list(size = 1.5))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    panel.grid.major.x = element_line(color = "white", size = rel(1)),
    panel.grid.major.y = element_line(color = "white"),
    panel.grid.minor.x = element_blank(),
    plot.caption.position = "plot",
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
      )
  )

ggsave("../figures/bt_personer_vaxgroup_age_time.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data <- bt_2_extra %>%
  filter(
    Variable == "tests",
    Group == "notprevpos",
    Type == "incidence",
    !Age %in% c("0-5", "6-11"),
  ) %>%
  mutate(Date = as.Date(paste0(Year, sprintf("%02d", Week), "1"), "%Y%U%u")) %>% 
  mutate(Vax_status = case_when(
    Vax_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
    Vax_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
    TRUE ~ Vax_status
  )) %>% 
  filter(Vax_status %in% c("Ingen vaccination", "Fuld effekt 2 doser", "Fuld effekt 3 doser"))


plot_data$Age <- factor(plot_data$Age, levels = c("12-15", "16-19", "20-29", "30-39", "40-49", "50-59", "60-64", "65-69", "70-79", "80+"))
plot_data$Vax_status <- factor(plot_data$Vax_status, levels = c("Ingen vaccination", "Fuld effekt 2 doser", "Fuld effekt 3 doser"))


plot_data %>%
  ggplot() +
  geom_line(aes(Date, Value, color = Vax_status), size = 0.7) +
  scale_x_date(labels = my_date_labels, breaks = my_breaks, expand = expansion(mult = 0.01)) +
  scale_color_manual(name = "", values = c(pct_col, admit_col, "#67cc32")) +
  scale_y_continuous(limits = c(0, NA), labels = scales::number) +
  labs(
    y = "Testede per 100.000",
    title = "PCR testede per 100.000",
    subtitle = "Angiver antal testede personer per 100.000 i alders- og vaccinationsgruppen",
    caption = standard_caption
  ) +
  facet_wrap(~ Age, ncol = 5) +
  facet_theme +
  guides(color = guide_legend(override.aes = list(size = 1.5))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    panel.grid.major.x = element_line(color = "white", size = rel(1)),
    panel.grid.major.y = element_line(color = "white"),
    panel.grid.minor.x = element_blank(),
    plot.caption.position = "plot",
    panel.background = element_rect(
      fill = "gray97",
      colour = NA,
      size = 0.3
    )
  )

ggsave("../figures/bt_tests_age_time.png", width = 18, height = 10, units = "cm", dpi = 300)
