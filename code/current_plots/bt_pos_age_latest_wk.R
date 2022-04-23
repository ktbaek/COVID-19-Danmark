bt_2 <- read_csv2("../data/tidy_breakthru_table2.csv") 

yr <- year(today)
wk <- filter(bt_2, Year == yr) %>% pull(Week) %>% max()

bt_2 %>% 
filter(
    Type == "incidence",
    Variable == "cases",
    Week == wk,
    Year == yr,
    !Vax_status %in% c("Første vaccination", "Anden vaccination")
  ) %>% 
  mutate(Vax_status = case_when(
    Vax_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
    Vax_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
    TRUE ~ Vax_status
  )) %>% 
  mutate(
    Age = krisr::new_order(Age, c("0-5", 
                                  "6-11", 
                                  "12-15", 
                                  "16-19", 
                                  "20-29", 
                                  "30-39", 
                                  "40-49", 
                                  "50-59", 
                                  "60-64", 
                                  "65-69", 
                                  "70-79", 
                                  "80+")),
    Vax_status = krisr::new_order(Vax_status, c("Ingen vaccination", 
                                                "Fuld effekt 2 doser", 
                                                "Fuld effekt 3 doser"))) %>% 
  ggplot() +
  geom_bar(aes(Vax_status, Value, fill = Vax_status), stat = "identity") +
  scale_fill_manual(name = "", values = c(pct_col, admit_col, "#67cc32")) +
  facet_grid(Group~Age, labeller = labeller(Group = c("alle" = "Alle", "notprevpos" = "Ikke tidligere positive"))) +
  labs(
    y = "Positive per 100.000",
    title = paste0("Positivt testede per 100.000, uge ", wk),
    caption = standard_caption
  ) +
  facet_theme +
  theme(
    panel.grid.major.x = element_blank(),
    axis.text.x = element_blank(),
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
  )

ggsave("../figures/bt_pos_age_latest_wk.png", width = 18, height = 10, units = "cm", dpi = 300)
