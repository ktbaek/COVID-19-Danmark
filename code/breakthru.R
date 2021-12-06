



amager <- c("#b79128", "#006d86", "#79a039", "#e0462e", "#004648", "#1c6ac9", '#fc981e')



bt_admitted %<>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Admitted", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(Aldersgruppe == "12+")

plot_data <- bt_admitted_inc %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "incidence", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  full_join(bt_admitted, by = c("Week", "Vax_status", "Aldersgruppe")) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Fuld effekt efter primært forløb"),
    Week > 43,
    Aldersgruppe == "12+") %>% 
  mutate(Week = paste0("Uge ", Week)) 
  
plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Første vaccination', 'Fuld effekt efter primært forløb'))  

plot_data %>%   
ggplot() +
  geom_bar(aes(Week, incidence, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_manual(name = "", values = amager[1:3]) +
  scale_color_manual(name = "", values = amager[1:3]) +
  geom_text(
    aes(Week, -0.5, group = Vax_status, color = Vax_status, label = Admitted),
    vjust = 1,
    position = position_dodge(0.9),
    size = rel(3),
    fontface = "bold",
    family = "lato"
  ) +
  geom_text(
    aes(Week, incidence + 0.5, group = Vax_status, color = Vax_status, label = sprintf("%.1f",round(incidence,1))),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(3),
    family = "lato"
  ) +
  scale_y_continuous(limits = c(-1, NA)) +
  labs(y = "Indlæggelser per 100.000",
       title = "<b><span style = 'font-size:13pt'>Ugentlige indlæggelser per 100.000</span></b><br><br>Antal indlæggelser er opgivet per 100.000 i vaccinationsgruppen. Tal er for befolkningen over 12 år. Tallene <b>under</b> hver søjle angiver de absolutte indlæggelsestal. <br>", 
       caption = standard_caption) +
  facet_theme +
  theme(
    plot.title = element_textbox_simple(
      size = 9, face = "plain", lineheight = 1.05, padding = margin(0, 5, 5, 0), width = unit(1, "npc"),
    ),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    axis.text.x = element_text(size = rel(1.5), margin = margin(t = 6, r = 0, b = 0, l = 0)),
    panel.grid.major.x = element_blank(),
  )

ggsave("../figures/ntl_breakthru_admitted.png", width = 18, height = 10, units = "cm", dpi = 300)

prev_infection <- bt_table1 %>% 
  pivot_longer(-Ugenummer, names_to = c("Group", "Vax_status"), values_to = "Number", names_sep = "_[A-Z]") %>% 
  mutate(Vax_status = case_when(
    Vax_status == "ngen vaccination" ~ "Ingen vaccination",
    Vax_status == "ørste vaccination" ~ "Første vaccination",
    Vax_status == "nden vaccination" ~ "Anden vaccination",
    Vax_status == "uld effekt efter primært forløb" ~ "Fuld effekt efter primært forløb",
  )) %>% 
  filter(str_detect(Group, "personer")) %>% 
  pivot_wider(names_from = Group, values_from = Number) %>% 
  mutate(Prev_infection = antal_personer_alle - antal_personer) %>% 
  rename(No_prev_infection = antal_personer) %>% 
  select(-antal_personer_alle)

plot_data <- bt_table1 %>% 
  pivot_longer(-Ugenummer, names_to = c("Group", "Vax_status"), values_to = "Number", names_sep = "_[A-Z]") %>% 
  mutate(Vax_status = case_when(
    Vax_status == "ngen vaccination" ~ "Ingen vaccination",
    Vax_status == "ørste vaccination" ~ "Første vaccination",
    Vax_status == "nden vaccination" ~ "Anden vaccination",
    Vax_status == "uld effekt efter primært forløb" ~ "Fuld effekt efter primært forløb",
  )) %>% 
  filter(
    Group %in% c("antal_cases", "antal_repositive")
    ) %>% 
  full_join(prev_infection, by = c("Ugenummer", "Vax_status")) %>% 
  mutate(incidence = case_when(
    Group == "antal_cases" ~ Number / No_prev_infection * 100000,
    Group == "antal_repositive" ~ Number / Prev_infection * 100000
  )
  ) %>% 
  filter(Vax_status != "Anden vaccination")
  
plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Første vaccination', 'Fuld effekt efter primært forløb'))  
  
plot_data %>% 
  mutate(Week = as.integer(str_sub(Ugenummer, 5, 6))) %>% 
  filter(Week > 42) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  mutate(Group = case_when(
    Group == "antal_cases" ~ "Ikke tidligere\npositive",
    Group == "antal_repositive" ~ "Tidligere positive"
  )) %>% 
ggplot() +
  geom_bar(aes(Group, incidence, group = Vax_status, fill = Vax_status), stat = "identity", position = "dodge") +
  facet_wrap(~ Week, ncol = 4) +
  labs(y = "Positive per 100.000",
       title = "<b><span style = 'font-size:13pt'>Ugentligt smittede per 100.000 fordelt på vaccinationsstatus og tidligere smitte</span></b><br><br>Antal positive er opgivet per 100.000 i vaccinationsgruppe/tidligere-smittegruppe. Tidligere positive er defineret som >60 dage siden seneste positive PCR test. Alle tal er baseret på PCR test og på hele befolkningen (også 0-12 år). Tallene <b>under</b> hver søjle angiver de absolutte smittetal. <br>", 
       caption = standard_caption) +
  geom_text(
    aes(Group, -20, group = Vax_status, color = Vax_status, label = Number),
    vjust = 1,
    position = position_dodge(0.9),
    size = rel(2),
    fontface = "bold",
    family = "lato"
  ) +
  geom_text(
    aes(Group, incidence + 10, group = Vax_status, color = Vax_status, label = sprintf("%.0f",round(incidence,0))),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(2),
    family = "lato"
  ) +
  facet_theme +
  scale_y_continuous(limits = c(-20, NA)) +
  scale_fill_manual(name = "", values = amager[1:3]) +
  scale_color_manual(name = "", values = amager[1:3]) +
  guides(color = FALSE) +
  theme(
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    panel.grid.major.x = element_blank(),
    axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0)),
    plot.title.position = "plot",
    plot.title = element_textbox_simple(
      size = 9, face = "plain", lineheight = 1.05, padding = margin(0, 5, 5, 0), width = unit(0.9, "npc"),
    )
  )

ggsave("../figures/ntl_prev_infection.png", width = 20, height = 11, units = "cm", dpi = 300)

# pos% -----------------------------------------------------

tji = function(pop, cases, tests, beta) {
  pos * (pop / tests)**beta / pop * 100000
}


temp_df <- bt_2 %>% 
  filter(Variable %in% c("cases", "repositive", "tests_notprevpos", "tests", "alle")) %>% 
  pivot_wider(names_from = c(Type, Variable), values_from = Value, names_sep = "_") %>% 
  select(-incidence_tests) %>% 
  mutate(
    antal_personer.notprevpos = as.integer(antal_cases / incidence_cases * 100000),
    antal_personer.alle = as.integer(((antal_cases + antal_repositive) / incidence_alle * 100000)),
    antal_personer.prevpos = antal_personer.alle - antal_personer.notprevpos,
    incidence_repositive = antal_repositive / antal_personer.prevpos * 100000
    ) %>% 
  select(-antal_personer.alle, -incidence_alle) %>% 
  pivot_longer(c(antal_cases:incidence_repositive), names_to = c("Type", "Variable"), values_to = "Value", names_sep = "_")

plot_data <- temp_df %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Anden vaccination"),
    !(Vax_status == "Anden vaccination" & Variable == "repositive"),
    !Variable %in% c("personer.notprevpos", "personer.prevpos"),
    Variable != "tests"
    ) %>% 
  mutate(Immunity_status = case_when(
    Vax_status == "Ingen vaccination" & Variable == "repositive" ~ "Tidligere positiv",
    TRUE ~ Vax_status
  )) %>% 
  filter(
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) 

plot_data$Immunity_status <- factor(plot_data$Immunity_status, levels=c('Ingen vaccination', 'Anden vaccination', 'Tidligere positiv'))  

p1 <- plot_data %>%   
  filter(Type == "incidence") %>% 
  ggplot() +
  geom_area(aes(Date, Value, fill = Immunity_status, color = Immunity_status), size = 0.7, stat = "identity", position = "identity", alpha = 0.2) + 
  scale_fill_manual(name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(y = "Positive per 100.000",
       title = "Positive per 100.000",
       subtitle = "Angiver antal positive per 100.000 i alders- og immunitetsgruppen") +
  facet_wrap(~ Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    plot.title = element_text(size = 11, face = "bold", margin = margin(b = 3)),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    panel.background = element_rect(
      fill = "gray97", 
      colour = NA,
      size = 0.3
    ), 
  )

p2 <- plot_data %>%   
  filter(Type == "antal") %>% 
  ggplot() +
  geom_area(aes(Date, Value, fill = Immunity_status, color = Immunity_status), size = 0.7, stat = "identity", position = "identity", alpha = 0.2) + 
  scale_fill_manual(name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(y = "Positive",
       title = "Absolutte antal positive") +
  facet_wrap(~ Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    plot.title = element_text(size = 11, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    panel.background = element_rect(
      fill = "gray97", 
      colour = NA,
      size = 0.3
    ), 
  )

p1 / p2 + plot_layout(guides='collect') + 
  plot_annotation(
    title = 'Ugentligt antal positive opdelt på alder og immunitetsstatus',
    subtitle = "Relative og absolutte antal personer med positiv SARS-CoV-2 PCR test.\n'Tidligere positive' er tidligere positive, ikke-vaccinerede.",
    caption = standard_caption,
    theme = theme(
      plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
      plot.title = element_text(size = rel(1.3), face = "bold", margin = margin(b = 5)),
      plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
    )) & theme(
      text = element_text(family = "lato"),
      strip.text.x = element_text(margin = margin(0, 0, 0.8, 0)), 
      legend.position = "bottom",
      panel.grid.major.x = element_line(color = "white", size = rel(1)),
      panel.grid.major.y = element_line(color = "white"),
      panel.grid.minor.x = element_blank())

ggsave("../figures/breakthru_cases_age_time_2.png", width = 16, height = 20, units = "cm", dpi = 300)








plot_data <- bt_2 %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Anden vaccination"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11"),
    Type == "antal",
    Variable %in% c("cases", "repositive", "tests", "tests_notprevpos")
  ) %>% 
  select(-Type) %>% 
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) %>% 
  pivot_wider(names_from = Variable, values_from = Value) %>% 
  mutate(
    tests_prevpos = tests - tests_notprevpos, 
    pct_cases = cases / tests_notprevpos**0.7,
    pct_repos = repositive / tests_prevpos**0.7
  ) %>% 
  select(-tests_notprevpos, -tests, -tests_prevpos) %>% 
  rename(
    abs_cases = cases,
    abs_repos = repositive
  ) %>% 
  pivot_longer(c(abs_cases, abs_repos, pct_cases, pct_repos), names_to = c("type", "variable"), values_to = "value", names_sep = "_") %>% 
  filter(!(Vax_status == "Anden vaccination" & variable == "repos")) %>% 
  mutate(Immunity_status = case_when(
    Vax_status == "Ingen vaccination" & variable == "repos" ~ "Tidligere positiv",
    TRUE ~ Vax_status
  ))  


plot_data$Immunity_status <- factor(plot_data$Immunity_status, levels=c('Ingen vaccination', 'Anden vaccination', 'Tidligere positiv'))  

p1 <- plot_data %>%   
  filter(type == "pct") %>% 
  ggplot() +
  geom_area(aes(Date, value, fill = Immunity_status, color = Immunity_status), size = 0.7, stat = "identity", position = "identity", alpha = 0.2) + 
  scale_fill_manual(name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col, pos_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA),  labels = function(x) paste0(x, " %"), expand = expansion(mult = 0.02)) +
  labs(y = "Positivprocent",
       title = "SARS-CoV-2 positivprocent",
       caption = standard_caption) +
  facet_wrap(~ Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    legend.position = "bottom",
    panel.grid.major.x = element_line(color = "white", size = rel(1)),
    panel.grid.major.y = element_line(color = "white"),
    panel.grid.minor.x = element_blank(),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    panel.background = element_rect(
      fill = "gray97", 
      colour = NA,
      size = 0.3
    ), 
  )

ggsave("../figures/exp_breakthru_pct_age_time.png", width = 18, height = 10, units = "cm", dpi = 300)




x <- bt_icu %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "number", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) 

plot_data <- bt_icu_inc %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "incidence", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  full_join(x, by = c("Aldersgruppe", "Vax_status", "Week")) %>% 
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) %>% 
  pivot_longer(c(incidence, number), names_to = "variable", values_to = "value")

plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Fuld effekt efter primært forløb'))  

plot_data %>%   
  filter(variable == "incidence") %>% 
  ggplot() +
  geom_bar(aes(Date, value, fill = Vax_status), stat = "identity", position = "dodge", alpha = 1) + 
  scale_fill_manual(name = "", values = c(pct_col, admit_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = c(0.01, 0))) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.001)) +
  facet_wrap(~ Aldersgruppe, ncol = 5) +
  facet_theme +
  guides(fill = guide_legend(override.aes = list(alpha = 1))) +
  theme(
    plot.title = element_text(size = 11, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    panel.background = element_rect(
      fill = "gray97", 
      colour = NA,
      size = 0.3
    ), 
  )


