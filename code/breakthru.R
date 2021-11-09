bt_cases <- read_csv2("../data/SSIdata_211109/gennembrudsinfektioner_table2_antal_cases.csv")
bt_tests <- read_csv2("../data/SSIdata_211109/gennembrudsinfektioner_table2_antal_tests.csv")
bt_admitted <- read_csv2("../data/SSIdata_211109/gennembrudsinfektioner_table2_antal_indlagte.csv")
bt_admitted_inc <- read_csv2("../data/SSIdata_211109/gennembrudsinfektioner_table2_incidence_indlagte.csv")

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

bt_cases %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Antal", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Anden vaccination"),
    Week > 31,
    Aldersgruppe == "12+") %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  ggplot() +
  geom_bar(aes(Week, Antal, fill = Vax_status), stat = "identity", position = "fill") + 
  scale_fill_discrete(name = "") +
  labs(
    y = "Positive", 
    x = "Aldersgruppe", 
    title = "SARS-CoV-2 positive over 12 år", 
    caption = standard_caption
  ) +
  standard_theme +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )



bt_admitted %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Antal", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Fuld vaccineeffekt"),
    Week > 39,
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

bt_table1 <- read_csv2("../data/SSIdata_211109/gennembrudsinfektioner_table1.csv")

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

bt_table1 %>% 
  pivot_longer(-Ugenummer, names_to = c("Group", "Vax_status"), values_to = "Number", names_sep = "_[A-Z]") %>% 
  #mutate(Week = as.integer(str_sub(Ugenummer, 5, 6))) %>% 
  mutate(Vax_status = case_when(
    Vax_status == "ngen vaccination" ~ "Ingen vaccination",
    Vax_status == "ørste vaccination" ~ "Første vaccination",
    Vax_status == "nden vaccination" ~ "Anden vaccination",
    Vax_status == "uld vaccineeffekt" ~ "Fuld vaccineeffekt",
  )) %>% 
  filter(Group == "antal_cases") %>% 
  filter(!Vax_status %in% c("Anden vaccination")) %>% 
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

  
  
  
  
  
  group_by(Ugenummer, Immune_status) %>% 
  summarize(
    Immune = sum(Immune, na.rm = TRUE),
    Befolkning = mean(Total_befolkning, na.rm = TRUE),
    Percent_immune = Immune / Befolkning * 100
  ) %>% 
  #mutate(Percent_infected = Previous_infection / antal_personer_alle * 100) %>% 
  ggplot() +
  geom_bar(aes(Ugenummer, Percent_immune, fill = Immune_status), stat = "identity", position = "stack") + 
  scale_fill_manual(name = "", labels = c("Anden vaccination / tidligere PCR positiv", "Tidligere PCR positiv"), values=c("#11999e", "#30e3ca")) +
  scale_y_continuous(
    limits = c(0, 100),
    name = "Procent immune",
    labels = function(x) paste0(x, " %")
  ) +
  #facet_wrap(~ Week, ncol = 4) +
  labs(
    y = "Procent tidligere smittede", 
    x = "Uge", 
    title = "Procentdel af befolkningen med specifik COVID-19 immunitet", 
    caption = standard_caption
  ) +
  standard_theme +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave("../figures/ntl_total_immune.png", width = 18, height = 10, units = "cm", dpi = 300)
  

