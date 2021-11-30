bt_cases <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_antal_cases.csv")
bt_tests <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_antal_tests.csv")
bt_admitted <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_antal_indlagte.csv")
bt_admitted_inc <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_incidence_indlagte.csv")
bt_cases_inc <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_incidence_cases.csv")
bt_deaths_inc <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_incidence_dode.csv")
bt_deaths <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_antal_dode.csv")
bt_table1 <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table1.csv")
bt_icu_inc <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_incidence_intensiv.csv")
bt_icu <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_antal_intensiv.csv")
bt_repos <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_antal_repositive.csv")
bt_cases_inc_all <- read_csv2("../data/SSIdata_211130/gennembrudsinfektioner_table2_incidence_alle.csv")

library(patchwork)

amager <- c("#b79128", "#006d86", "#79a039", "#e0462e", "#004648", "#1c6ac9", '#fc981e')

table2_files <- list.files("../data/SSIdata_211130", pattern = "gennembrudsinfektioner_table2", full.names = TRUE) 

read_tidy_table2 <- function(filename){
  
  table_name <- paste(str_split(filename, "_")[[1]][4], str_split(filename, "_")[[1]][5], sep = "_") %>% 
    str_sub(1, length(.) - 6)
    
  read_csv2(filename) %>% 
    pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "value", names_sep = "_") %>% 
    mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
    filter(
      !Aldersgruppe %in% c("12+", "Alle")
    ) %>% 
    mutate(variable = table_name) %>% 
    select(variable, everything())
  
}

table2 <- lapply(table2_files, read_tidy_table2) %>% 
  bind_rows()








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

# two-panel age plots -----------------------------------------------------

x <- bt_deaths %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "number", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  group_by(Aldersgruppe, Vax_status) %>% 
  summarize(
    number = sum(number, na.rm = TRUE)
  )

plot_data <- bt_deaths_inc %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "incidence", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  group_by(Aldersgruppe, Vax_status) %>% 
  summarize(
    incidence = sum(incidence, na.rm = TRUE)
  ) %>% 
  full_join(x, by = c("Aldersgruppe", "Vax_status"))

plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Fuld effekt efter primært forløb'))  

plot_data %>%   
  ggplot() +
  geom_bar(aes(Aldersgruppe, incidence, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_manual(name = "", values = amager[c(1,3)]) +
  scale_color_manual(name = "", values = amager[c(1,3)]) +
  geom_text(
    aes(Aldersgruppe, -5, group = Vax_status, color = Vax_status, label = number),
    vjust = 1,
    position = position_dodge(0.9),
    size = rel(2.5),
    fontface = "bold",
    family = "lato"
  ) +
  geom_text(
    aes(Aldersgruppe, incidence + 3, group = Vax_status, color = Vax_status, label = sprintf("%.1f",round(incidence,1))),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(2.5),
    family = "lato"
  ) +
  scale_y_continuous(limits = c(-6, NA)) +
  labs(y = "Døde per 100.000",
       title = "<b><span style = 'font-size:13pt'>Total døde per 100.000 siden 1. august 2021</span></b><br><br>Antal døde er opgivet per 100.000 i vaccinationsgruppen. Tallene <b>under</b> hver søjle angiver de absolutte dødstal. <br>", 
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

ggsave("../figures/exp_breakthru_deaths.png", width = 18, height = 10, units = "cm", dpi = 300)

x <- bt_admitted %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "number", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  group_by(Aldersgruppe, Vax_status) %>% 
  summarize(
    number = sum(number, na.rm = TRUE)
  )

plot_data <- bt_admitted_inc %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "incidence", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  group_by(Aldersgruppe, Vax_status) %>% 
  summarize(
    incidence = sum(incidence, na.rm = TRUE)
  ) %>% 
  full_join(x, by = c("Aldersgruppe", "Vax_status"))

plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Fuld effekt efter primært forløb'))  

p1 <- plot_data %>%   
  ggplot() +
  geom_bar(aes(Aldersgruppe, incidence, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_manual(name = "", values = amager[1:2]) +
  scale_color_manual(name = "", values = amager[1:2]) +
  geom_text(
    aes(Aldersgruppe, incidence + 10, group = Vax_status, color = Vax_status, label = sprintf("%.1f",round(incidence,1))),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(2.2),
    family = "lato"
  ) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Indlæggelser per 100.000",
       title = "Indlæggelser per 100.000",
       subtitle = "Tallene angiver antal indlæggelser per 100.000 i alders- og vaccinationsgruppen.") +
  facet_theme +
  theme(
    plot.title = element_text(size = 12, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    axis.text.x = element_text(size = rel(1.5), margin = margin(t = 0, r = 0, b = 0, l = 0)),
    panel.grid.major.x = element_blank(),
  )


p2 <- plot_data %>%   
  ggplot() +
  geom_bar(aes(Aldersgruppe, number, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_manual(name = "", values = amager[1:2]) +
  scale_color_manual(name = "", values = amager[1:2]) +
  geom_text(
    aes(Aldersgruppe, number + 7, group = Vax_status, color = Vax_status, label = number),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(2.2),
    family = "lato"
  ) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Indlæggelser",
       title = "Absolut antal indlæggelser") +
  facet_theme +
  theme(
    plot.title = element_text(size = 12, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    axis.text.x = element_text(size = rel(1.5), margin = margin(t = 0, r = 0, b = 0, l = 0)),
    panel.grid.major.x = element_blank(),
  )

p1 / p2 + plot_layout(guides='collect') + plot_annotation(
  title = 'Indlæggelser fra 1. august - 20. november 2021',
  subtitle = 'Antal indlæggelser med positiv SARS-CoV-2 PCR test',
  caption = standard_caption,
  theme = theme(
    plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
  plot.title = element_text(size = rel(1.5), face = "bold"),
  plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
)) & theme(text = element_text(family = "lato"),
           legend.position = "bottom")

ggsave("../figures/exp_breakthru_admitted_age.png", width = 18, height = 20, units = "cm", dpi = 300)


x <- bt_deaths %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "number", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  group_by(Aldersgruppe, Vax_status) %>% 
  summarize(
    number = sum(number, na.rm = TRUE)
  )

plot_data <- bt_deaths_inc %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "incidence", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  group_by(Aldersgruppe, Vax_status) %>% 
  summarize(
    incidence = sum(incidence, na.rm = TRUE)
  ) %>% 
  full_join(x, by = c("Aldersgruppe", "Vax_status"))

plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Fuld effekt efter primært forløb'))  

p1 <- plot_data %>%   
  ggplot() +
  geom_bar(aes(Aldersgruppe, incidence, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_manual(name = "", values = amager[1:2]) +
  scale_color_manual(name = "", values = amager[1:2]) +
  geom_text(
    aes(Aldersgruppe, incidence + 5, group = Vax_status, color = Vax_status, label = sprintf("%.1f",round(incidence,1))),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(2.2),
    family = "lato"
  ) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Døde per 100.000",
       title = "Dødsfald per 100.000",
       subtitle = "Tallene angiver antal dødsfald per 100.000 i alders- og vaccinationsgruppen.") +
  facet_theme +
  theme(
    plot.title = element_text(size = 12, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    axis.text.x = element_text(size = rel(1.5), margin = margin(t = 0, r = 0, b = 0, l = 0)),
    panel.grid.major.x = element_blank(),
  )


p2 <- plot_data %>%   
  ggplot() +
  geom_bar(aes(Aldersgruppe, number, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_manual(name = "", values = amager[1:2]) +
  scale_color_manual(name = "", values = amager[1:2]) +
  geom_text(
    aes(Aldersgruppe, number + 2, group = Vax_status, color = Vax_status, label = number),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(2.2),
    family = "lato"
  ) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Døde",
       title = "Absolut antal dødsfald") +
  facet_theme +
  theme(
    plot.title = element_text(size = 12, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    axis.text.x = element_text(size = rel(1.5), margin = margin(t = 0, r = 0, b = 0, l = 0)),
    panel.grid.major.x = element_blank(),
  )

p1 / p2 + plot_layout(guides='collect') + plot_annotation(
  title = 'Dødsfald fra 1. august - 20. november 2021',
  subtitle = 'Antal døde med positiv SARS-CoV-2 PCR test',
  caption = standard_caption,
  theme = theme(
    plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
    plot.title = element_text(size = rel(1.5), face = "bold"),
    plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
  )) & theme(text = element_text(family = "lato"),
             legend.position = "bottom")

ggsave("../figures/exp_breakthru_deaths_age.png", width = 18, height = 20, units = "cm", dpi = 300)


x <- bt_cases %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "number", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  group_by(Aldersgruppe, Vax_status) %>% 
  summarize(
    number = sum(number, na.rm = TRUE)
  )

plot_data <- bt_cases_inc %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "incidence", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  group_by(Aldersgruppe, Vax_status) %>% 
  summarize(
    incidence = sum(incidence, na.rm = TRUE)
  ) %>% 
  full_join(x, by = c("Aldersgruppe", "Vax_status"))

plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Fuld effekt efter primært forløb'))  

p1 <- plot_data %>%   
  ggplot() +
  geom_bar(aes(Aldersgruppe, incidence, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_manual(name = "", values = amager[1:2]) +
  scale_color_manual(name = "", values = amager[1:2]) +
  geom_text(
    aes(Aldersgruppe, incidence + 100, group = Vax_status, color = Vax_status, label = sprintf("%.0f",round(incidence,0))),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(2),
    family = "lato"
  ) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Positive per 100.000",
       title = "Positivt testede per 100.000",
       subtitle = "Tallene angiver antal positive per 100.000 i alders- og vaccinationsgruppen.") +
  facet_theme +
  theme(
    plot.title = element_text(size = 12, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    axis.text.x = element_text(size = rel(1.5), margin = margin(t = 0, r = 0, b = 0, l = 0)),
    panel.grid.major.x = element_blank(),
  )


p2 <- plot_data %>%   
  ggplot() +
  geom_bar(aes(Aldersgruppe, number, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_manual(name = "", values = amager[1:2]) +
  scale_color_manual(name = "", values = amager[1:2]) +
  geom_text(
    aes(Aldersgruppe, number + 120, group = Vax_status, color = Vax_status, label = number),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(2),
    family = "lato"
  ) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Positive",
       title = "Absolut antal positivt testede") +
  facet_theme +
  theme(
    plot.title = element_text(size = 12, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    axis.text.x = element_text(size = rel(1.5), margin = margin(t = 0, r = 0, b = 0, l = 0)),
    panel.grid.major.x = element_blank(),
  )

p1 / p2 + plot_layout(guides='collect') + plot_annotation(
  title = 'Smittede fra 1. august - 20. november 2021',
  subtitle = 'Antal personer med positiv SARS-CoV-2 PCR test',
  caption = standard_caption,
  theme = theme(
    plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
    plot.title = element_text(size = rel(1.5), face = "bold"),
    plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
  )) & theme(text = element_text(family = "lato"),
             legend.position = "bottom")

ggsave("../figures/exp_breakthru_cases_age.png", width = 18, height = 20, units = "cm", dpi = 300)

x <- bt_icu %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "number", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  group_by(Aldersgruppe, Vax_status) %>% 
  summarize(
    number = sum(number, na.rm = TRUE)
  )

plot_data <- bt_icu_inc %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "incidence", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  group_by(Aldersgruppe, Vax_status) %>% 
  summarize(
    incidence = sum(incidence, na.rm = TRUE)
  ) %>% 
  full_join(x, by = c("Aldersgruppe", "Vax_status"))

plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Fuld effekt efter primært forløb'))  

p1 <- plot_data %>%   
  ggplot() +
  geom_bar(aes(Aldersgruppe, incidence, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_manual(name = "", values = amager[1:2]) +
  scale_color_manual(name = "", values = amager[1:2]) +
  geom_text(
    aes(Aldersgruppe, incidence + 1.5, group = Vax_status, color = Vax_status, label = sprintf("%.1f",round(incidence,1))),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(2.5),
    family = "lato"
  ) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Indlæggelser per 100.000",
       title = "Indlæggelser på intensiv per 100.000",
       subtitle = "Tallene angiver antal indlæggelser på intensiv per 100.000 i alders- og vaccinationsgruppen.") +
  facet_theme +
  theme(
    plot.title = element_text(size = 12, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    axis.text.x = element_text(size = rel(1.5), margin = margin(t = 0, r = 0, b = 0, l = 0)),
    panel.grid.major.x = element_blank(),
  )


p2 <- plot_data %>%   
  ggplot() +
  geom_bar(aes(Aldersgruppe, number, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_manual(name = "", values = amager[1:2]) +
  scale_color_manual(name = "", values = amager[1:2]) +
  geom_text(
    aes(Aldersgruppe, number + 1, group = Vax_status, color = Vax_status, label = number),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(2.5),
    family = "lato"
  ) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Indlæggelser",
       title = "Absolut antal indlæggelser på intensiv") +
  facet_theme +
  theme(
    plot.title = element_text(size = 12, face = "bold"),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    axis.text.x = element_text(size = rel(1.5), margin = margin(t = 0, r = 0, b = 0, l = 0)),
    panel.grid.major.x = element_blank(),
  )

p1 / p2 + plot_layout(guides='collect') + plot_annotation(
  title = 'Indlæggelser på intensiv fra 1. august - 20. november 2021',
  subtitle = 'Antal indlæggelser med positiv SARS-CoV-2 PCR test',
  caption = standard_caption,
  theme = theme(
    plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
    plot.title = element_text(size = rel(1.5), face = "bold"),
    plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
  )) & theme(text = element_text(family = "lato"),
             legend.position = "bottom")

ggsave("../figures/exp_breakthru_icu_age.png", width = 18, height = 20, units = "cm", dpi = 300)





x <- bt_tests %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "number", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  group_by(Week, Vax_status) %>% 
  summarize(
    tested = sum(number, na.rm = TRUE)
  )

plot_data <- bt_cases %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "number", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  group_by(Week, Vax_status) %>% 
  summarize(
    positive = sum(number, na.rm = TRUE)
  ) %>% 
  full_join(x, by = c("Week", "Vax_status"))

plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Fuld effekt efter primært forløb'))  

plot_data %>%   
  mutate(date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u")) %>% 
  ggplot() +
  geom_line(aes(date, positive / tested * 100, color = Vax_status), size = 1) + 
  scale_color_manual(name = "", values = amager[1:2]) +
  scale_y_continuous(limits = c(0, NA),  labels = function(x) paste0(x, " %")) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
  labs(y = "Positivprocent",
       title = "Ugentlig SARS-CoV-2 positivprocent",
       caption = standard_caption) +
  standard_theme 

ggsave("../figures/exp_pct_admitted_age.png", width = 18, height = 10, units = "cm", dpi = 300)



plot_breakthru_age_panel <- function(abs_df, inc_df, variable, maintitle, subtitle) {

x <- abs_df %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "number", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld vaccineeffekt"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) 

plot_data <- inc_df %>% 
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

p1 <- plot_data %>%   
  filter(variable == "incidence") %>% 
  ggplot() +
  geom_area(aes(Date, value, fill = Vax_status, color = Vax_status), size = 0.7, stat = "identity", position = "identity", alpha = 0.2) + 
  scale_fill_manual(name = "", values = c(pct_col, admit_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(y = paste0(variable, " per 100.000"),
       title = paste0(variable, " per 100.000"),
       subtitle = paste0("Angiver antal ", str_to_lower(variable), " per 100.000 i alders- og vaccinationsgruppen")) +
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
  filter(variable == "number") %>% 
  ggplot() +
  geom_area(aes(Date, value, fill = Vax_status, color = Vax_status), size = 0.7, stat = "identity", position = "identity", alpha = 0.2) + 
  scale_fill_manual(name = "", values = c(pct_col, admit_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", expand = expansion(mult = 0.01)) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = 0.02)) +
  labs(y = variable,
       title = paste0("Absolut antal ", str_to_lower(variable))) +
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
    title = maintitle,
    subtitle = subtitle,
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

}

plot_breakthru_age_panel(
  bt_cases, bt_cases_inc, 
  variable = "Positive",
  maintitle = 'Ugentligt antal positive opdelt på alder og vaccinestatus',
  subtitle = 'Relative og absolutte antal personer med positiv SARS-CoV-2 PCR test'
)

ggsave("../figures/exp_breakthru_cases_age_time.png", width = 16, height = 20, units = "cm", dpi = 300)

plot_breakthru_age_panel(
  bt_admitted, bt_admitted_inc, 
  variable = "Indlæggelser",
  maintitle = 'Ugentlige indlæggelser opdelt på alder og vaccinestatus',
  subtitle = 'Relative og absolutte antal nyindlagte med positiv SARS-CoV-2 PCR test'
)

ggsave("../figures/exp_breakthru_admit_age_time.png", width = 16, height = 20, units = "cm", dpi = 300)


plot_breakthru_age_panel(
  bt_deaths, bt_deaths_inc, 
  variable = "Døde",
  maintitle = 'Ugentligt antal døde opdelt på alder og vaccinestatus',
  subtitle = 'Relative og absolutte antal døde med positiv SARS-CoV-2 PCR test'
)

ggsave("../figures/exp_breakthru_deaths_age_time.png", width = 16, height = 20, units = "cm", dpi = 300)

plot_breakthru_age_panel(
  bt_icu, bt_icu_inc, 
  variable = "Indlæggelser",
  maintitle = 'Ugentlige intensivindlæggelser opdelt på alder og vaccinestatus',
  subtitle = 'Relative og absolutte antal nyindlagte på intensiv med positiv SARS-CoV-2 PCR test'
)

ggsave("../figures/exp_breakthru_icu_age_time.png", width = 16, height = 20, units = "cm", dpi = 300)



x <- bt_tests %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "tested", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) 

plot_data <- bt_cases %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "positive", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination",  "Fuld effekt efter primært forløb"),
    !Aldersgruppe %in% c("12+", "Alle", "0-5", "6-11")
  ) %>% 
  full_join(x, by = c("Aldersgruppe", "Vax_status", "Week")) %>% 
  mutate(Date = as.Date(paste0(2021, sprintf("%02d", Week), "1"), "%Y%U%u"),
         pct = positive / tested * 100)

plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Fuld effekt efter primært forløb'))  

p1 <- plot_data %>%   
  ggplot() +
  geom_area(aes(Date, pct, fill = Vax_status, color = Vax_status), size = 0.7, stat = "identity", position = "identity", alpha = 0.2) + 
  scale_fill_manual(name = "", values = c(pct_col, admit_col)) +
  scale_color_manual(guide = FALSE, name = "", values = c(pct_col, admit_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month") +
  scale_y_continuous(limits = c(0, NA),  labels = function(x) paste0(x, " %"), expand = expansion(mult = c(0.003, 0.1))) +
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


