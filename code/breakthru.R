bt_cases <- read_csv2("../data/SSIdata_211116/gennembrudsinfektioner_table2_antal_cases.csv")
bt_tests <- read_csv2("../data/SSIdata_211116/gennembrudsinfektioner_table2_antal_tests.csv")
bt_admitted <- read_csv2("../data/SSIdata_211116/gennembrudsinfektioner_table2_antal_indlagte.csv")
bt_admitted_inc <- read_csv2("../data/SSIdata_211116/gennembrudsinfektioner_table2_incidence_indlagte.csv")

bt_cases %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Antal", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Fuld vaccineeffekt"),
    Week > 31,
    Aldersgruppe != "12+") %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  ggplot() +
  geom_bar(aes(Aldersgruppe, Antal, fill = Vax_status), stat = "identity", position = "stack") + 
  scale_fill_discrete(name = "") +
  facet_wrap(~ Week, ncol = 4) +
  labs(
    y = "Positive", 
    x = "Aldersgruppe", 
    title = "SARS-CoV-2 positive", 
    caption = standard_caption
  ) +
  standard_theme +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave("../figures/ntl_breakthru_cases.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data <- bt_cases %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Antal", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Anden vaccination"),
    Week > 31,
    Aldersgruppe == "12+") %>% 
  mutate(Week = paste0("Uge ", Week)) 

plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Første vaccination', 'Anden vaccination'))

plot_data %>% 
  ggplot() +
  geom_bar(aes(Week, Antal, fill = Vax_status), stat = "identity", position = "fill") + 
  scale_fill_discrete(name = "") +
  labs(
    y = "Andel", 
    title = "SARS-CoV-2 positive over 12 år", 
    caption = standard_caption
  ) +
  standard_theme +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave("../figures/ntl_breakthru_cases_12.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data <- bt_admitted_inc %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Antal", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Fuld vaccineeffekt"),
    Week > 41,
    Aldersgruppe != "12+") %>% 
  mutate(Week = paste0("Uge ", Week)) 
  
plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Første vaccination', 'Fuld vaccineeffekt'))  

plot_data %>%   
ggplot() +
  geom_bar(aes(Aldersgruppe, Antal, fill = Vax_status), stat = "identity", position = "stack") + 
  scale_fill_manual(name = "", values = amager[1:3]) +
  facet_wrap(~ Week, ncol = 4) +
  labs(
    y = "Positive", 
    x = "Aldersgruppe", 
    title = "SARS-CoV-2 positive", 
    caption = standard_caption
  ) +
  standard_theme +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave("../figures/ntl_breakthru_admitted.png", width = 18, height = 10, units = "cm", dpi = 300)


bt_tests %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Antal", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Fuld vaccineeffekt"),
   Week > 31,
    Aldersgruppe != "12+") %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  ggplot() +
  geom_bar(aes(Aldersgruppe, Antal, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_discrete(name = "") +
  facet_wrap(~ Week, ncol = 4) +
  labs(
    y = "Testede", 
    x = "Aldersgruppe", 
    title = "SARS-CoV-2 testede", 
    caption = standard_caption
  ) +
  standard_theme +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )


bt_cases %<>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Positive", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) 

bt_tests %<>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Tested", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6)))

bt_cases %>%  
  full_join(bt_tests, by = c("Aldersgruppe", "Week", "Vax_status")) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Fuld vaccineeffekt"),
    Week > 35,
    Aldersgruppe != "12+") %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  mutate(pct = Positive / Tested * 100) %>% 
  ggplot() +
  geom_bar(aes(Aldersgruppe, pct, fill = Vax_status), stat = "identity", position = "dodge") + 
  scale_fill_discrete(name = "") +
  facet_wrap(~ Week, ncol = 4) +
  labs(
    y = "Testede", 
    x = "Aldersgruppe", 
    title = "SARS-CoV-2 positivprocent", 
    caption = standard_caption
  ) +
  standard_theme +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave("../figures/ntl_breakthru_pct.png", width = 18, height = 10, units = "cm", dpi = 300)

bt_table1 <- read_csv2("../data/SSIdata_211116/gennembrudsinfektioner_table1.csv")

bt_table1 %>% 
  pivot_longer(-Ugenummer, names_to = c("Group", "Vax_status"), values_to = "Number", names_sep = "_[A-Z]") %>% 
  #mutate(Week = as.integer(str_sub(Ugenummer, 5, 6))) %>% 
  mutate(Vax_status = case_when(
    Vax_status == "ngen vaccination" ~ "Ingen vaccination",
    Vax_status == "ørste vaccination" ~ "Første vaccination",
    Vax_status == "nden vaccination" ~ "Anden vaccination",
    Vax_status == "uld vaccineeffekt" ~ "Fuld vaccineeffekt",
    )) %>% 
  filter(str_detect(Group, "personer")) %>% 
  pivot_wider(names_from = Group, values_from = Number) %>% 
  mutate(Previous_infection = antal_personer_alle - antal_personer) %>% 
  filter(!Vax_status %in% c("Fuld vaccineeffekt")) %>% 
  group_by(Ugenummer) %>% 
  mutate(
    Total_befolkning = sum(antal_personer_alle, na.rm = TRUE),
    Immune = case_when(
      Vax_status == "Ingen vaccination" ~ Previous_infection,
      Vax_status == "Første vaccination" ~ Previous_infection,
      Vax_status == "Anden vaccination" ~ antal_personer_alle
    ),
    Immune_status = case_when(
      Vax_status == "Ingen vaccination" ~ "Tidligere PCR positiv",
      Vax_status == "Første vaccination" ~ "Tidligere PCR positiv",
      Vax_status == "Anden vaccination" ~ "Anden vaccination / tidligere PCR positiv"
    ),
  Vax_status_2 = case_when(
    Vax_status == "Ingen vaccination" ~ "Ikke-vaccineret",
    Vax_status == "Første vaccination" ~ "Vaccineret",
    Vax_status == "Anden vaccination" ~ "Vaccineret"
  ))%>% 
  group_by(Ugenummer, Vax_status_2) %>% 
  summarize(Previous_infection = sum(Previous_infection, na.rm = TRUE)
  ) %>% 
  ggplot() +
  geom_bar(aes(Ugenummer, Previous_infection, fill = Vax_status_2), stat = "identity", position = "stack") + 
  scale_fill_manual(name = "", labels = c("Ikke-vaccineret", "Vaccineret"), values=c("#30e3ca", "#11999e")) +
  scale_y_continuous(labels = scales::number)+
  labs(
    y = "Antal tidligere smittede", 
    x = "Uge", 
    title = "Antal personer med tidligere positiv SARS-CoV-2 PCR test", 
    caption = standard_caption
  ) +
  standard_theme +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
  
ggsave("../figures/ntl_prev_infection.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data <- bt_table1 %>% 
  pivot_longer(-Ugenummer, names_to = c("Group", "Vax_status"), values_to = "Number", names_sep = "_[A-Z]") %>% 
  #mutate(Week = as.integer(str_sub(Ugenummer, 5, 6))) %>% 
  mutate(Vax_status = case_when(
    Vax_status == "ngen vaccination" ~ "Ingen vaccination",
    Vax_status == "ørste vaccination" ~ "Første vaccination",
    Vax_status == "nden vaccination" ~ "Anden vaccination",
    Vax_status == "uld vaccineeffekt" ~ "Fuld vaccineeffekt",
  )) %>% 
  filter(Group == "antal_cases") %>% 
  filter(!Vax_status %in% c("Anden vaccination")) 

plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Første vaccination', 'Fuld vaccineeffekt'))

plot_data %>% 
  ggplot() +
  geom_bar(aes(Ugenummer, Number, fill = Vax_status), stat = "identity", position = "stack") + 
  scale_y_continuous(labels = scales::number)+
  labs(
    y = "Antal tidligere smittede", 
    x = "Uge", 
    title = "Antal personer med tidligere positiv SARS-CoV-2 PCR test", 
    caption = standard_caption
  ) +
  standard_theme +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave("../figures/ntl_breakthru_pos_total.png", width = 18, height = 10, units = "cm", dpi = 300)
  
prev_infection <- bt_table1 %>% 
  pivot_longer(-Ugenummer, names_to = c("Group", "Vax_status"), values_to = "Number", names_sep = "_[A-Z]") %>% 
  mutate(Vax_status = case_when(
    Vax_status == "ngen vaccination" ~ "Ingen vaccination",
    Vax_status == "ørste vaccination" ~ "Første vaccination",
    Vax_status == "nden vaccination" ~ "Anden vaccination",
    Vax_status == "uld vaccineeffekt" ~ "Fuld vaccineeffekt",
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
    Vax_status == "uld vaccineeffekt" ~ "Fuld vaccineeffekt",
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
  
plot_data$Vax_status <- factor(plot_data$Vax_status, levels=c('Ingen vaccination', 'Første vaccination', 'Fuld vaccineeffekt'))  
  
amager <- c("#b79128", "#006d86", "#79a039", "#e0462e", "#004648", "#1c6ac9", '#fc981e')
plot_data %>% 
  mutate(Week = as.integer(str_sub(Ugenummer, 5, 6))) %>% 
  filter(Week > 41) %>% 
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

