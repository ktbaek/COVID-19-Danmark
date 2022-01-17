library(tidyverse)
library(magrittr)
library(patchwork)

bt_2 <- read_csv2("../data/tidy_breakthru_table2.csv")

my_breaks <- c(ymd("2021-10-01"), ymd("2021-12-01"))

plot_breakthru_age_panel <- function(df, variable, variable_name, maintitle, subtitle) {
  
  zero_replace <- df %>% 
    filter(
      Vax_status == "Fuld effekt efter revaccination",
      Variable == "tests",
      Group == "alle",
      Value == 0) %>% 
    mutate(
      Type = "incidence",
      Variable = variable,
      Group = NA,
      zero_tests = TRUE) %>% 
    select(-Value)
  
    plot_data <- df %>%
    left_join(zero_replace, by = c("Type", "Variable", "Group", "Age", "Week", "Year", "Vax_status")) %>% 
    mutate(Value = ifelse(is.na(zero_tests), Value, NA)) %>% 
    filter(
      !Age %in% c("0-5", "6-11"),
      Vax_status %in% c("Ingen vaccination", "Fuld effekt efter primært forløb", "Fuld effekt efter revaccination"),
      Variable == variable
    ) %>%
    mutate(Date = as.Date(paste0(Year, sprintf("%02d", Week), "1"), "%Y%U%u")) %>%
    mutate(Vax_status = case_when(
      Vax_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
      Vax_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
      TRUE ~ Vax_status
    ))
    
  if(variable == "cases") plot_data %<>% filter(Group == "notprevpos")
      
  plot_data$Vax_status <- factor(plot_data$Vax_status, levels = c("Ingen vaccination", "Fuld effekt 2 doser", "Fuld effekt 3 doser"))

  p1 <- plot_data %>%
    filter(Type == "incidence") %>%
    ggplot() +
    geom_line(aes(Date, Value, fill = Vax_status, color = Vax_status), size = 0.7, alpha = 1) +
    scale_fill_manual(name = "", values = c(pct_col, admit_col, "#67cc32")) +
    scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, "#67cc32")) +
    scale_x_date(labels = my_date_labels, breaks = my_breaks, expand = expansion(mult = 0.01)) +
    scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
    labs(
      y = paste0(variable_name, " per 100.000"),
      title = paste0(variable_name, " per 100.000"),
      subtitle = paste0("Angiver antal ", str_to_lower(variable_name), " per 100.000 i alders- og vaccinationsgruppen")
    ) +
    facet_wrap(~Age, ncol = 5) +
    facet_theme +
    guides(fill = guide_legend(override.aes = list(alpha = 1))) +
    theme(
      plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
      plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
      plot.caption.position = "plot",
      panel.background = element_rect(
        fill = "gray97",
        colour = NA,
        size = 0.3
      ),
    )

  p2 <- plot_data %>%
    filter(Type == "antal") %>%
    ggplot() +
    geom_area(aes(Date, Value, fill = Vax_status, color = Vax_status), size = 0, stat = "identity", position = "stack", alpha = 0.9) +
    scale_fill_manual(name = "", values = c(pct_col, admit_col, "#67cc32")) +
    scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, "#67cc32")) +
    scale_x_date(labels = my_date_labels, breaks = my_breaks, expand = expansion(mult = 0.01)) +
    scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
    labs(
      y = variable_name,
      title = paste0("Absolut antal ", str_to_lower(variable_name)),
      subtitle = paste0("Angiver antal ", str_to_lower(variable_name), " opdelt på vaccinationsstatus (grupperne er stablet)")
    ) +
    facet_wrap(~Age, ncol = 5) +
    facet_theme +
    guides(fill = guide_legend(override.aes = list(alpha = 1))) +
    theme(
      plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
      plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
      plot.caption.position = "plot",
      panel.background = element_rect(
        fill = "gray97",
        colour = NA,
        size = 0.3
      ),
    )

  p1 / p2 + plot_layout(guides = "collect") +
    plot_annotation(
      title = maintitle,
      subtitle = subtitle,
      caption = standard_caption,
      theme = theme(
        plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
        plot.title = element_text(size = rel(1.3), face = "bold", margin = margin(b = 5)),
        plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
      )
    ) & theme(
    text = element_text(family = "lato"),
    strip.text.x = element_text(margin = margin(0, 0, 0.8, 0)),
    legend.position = "bottom",
    panel.grid.major.x = element_line(color = "white", size = rel(1)),
    panel.grid.major.y = element_line(color = "white"),
    panel.grid.minor.x = element_blank()
  )
}

bt_2 %>% plot_breakthru_age_panel(
  variable = "indlagte",
  variable_name = "Indlæggelser",
  maintitle = "Ugentligt antal indlæggelser opdelt på alder og vaccinestatus",
  subtitle = "Relative og absolutte antal indlæggelser indenfor 30 dage\nefter en positiv SARS-CoV-2 PCR test"
)

ggsave("../figures/bt_admit_age_time.png", width = 16, height = 20, units = "cm", dpi = 300)


bt_2 %>% plot_breakthru_age_panel(
  variable = "dode",
  variable_name = "Døde",
  maintitle = "Ugentligt antal døde opdelt på alder og vaccinestatus",
  subtitle = "Relative og absolutte antal døde med positiv SARS-CoV-2 PCR test"
)

ggsave("../figures/bt_deaths_age_time.png", width = 16, height = 20, units = "cm", dpi = 300)

bt_2 %>% plot_breakthru_age_panel(
  variable = "intensiv",
  variable_name = "Intensivindlæggelser",
  maintitle = "Ugentlige intensivindlæggelser opdelt på alder og vaccinestatus",
  subtitle = "Relative og absolutte antal intensivindlæggelser indenfor 30 dage\nefter positiv SARS-CoV-2 PCR test"
)

ggsave("../figures/bt_icu_age_time.png", width = 16, height = 20, units = "cm", dpi = 300)

bt_2 %>% plot_breakthru_age_panel(
  variable = "cases",
  variable_name = "Positive",
  maintitle = "Ugentligt antal positive opdelt på alder og vaccinestatus",
  subtitle = "Relative og absolutte antal personer med en positiv SARS-CoV-2 PCR test\nViser kun ikke-tidligere positive."
)

ggsave("../figures/bt_pos_age_time.png", width = 16, height = 20, units = "cm", dpi = 300)
