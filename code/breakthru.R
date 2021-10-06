bt_cases <- read_csv2("../data/SSIdata_211005/gennembrudsinfektioner_table2_incidence_cases.csv")
bt_tests <- read_csv2("../data/SSIdata_211005/gennembrudsinfektioner_table2_incidence_tests.csv")

bt_cases %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Antal", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Fuld vaccineeffekt"),
    Week > 31,
    Aldersgruppe != "12+") %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  ggplot() +
  geom_bar(aes(Aldersgruppe, Antal, fill = Vax_status), stat = "identity", position = "dodge") + 
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


bt_tests %>% 
  pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Antal", names_sep = "_") %>% 
  mutate(Week = as.integer(str_sub(Week, 5, 6))) %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Fuld vaccineeffekt"),
   # Week > 31,
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
    Vax_status %in% c("Ingen vaccination", "Fuld vaccineeffekt"),
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
