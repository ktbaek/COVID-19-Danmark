bt_1 <- read_csv2("../data/tidy_breakthru_table1.csv")
bt_2 <- read_csv2("../data/tidy_breakthru_table2.csv")

plot_data <- bt_1 %>% 
  filter(Variable %in% c("personer", "cases")) %>%
  pivot_wider(names_from = c(Type, Variable, Group), values_from = Value, names_sep = "_") %>%
  mutate(
    antal_personer_prevpos = antal_personer_alle - antal_personer_notprevpos,
    incidence_cases_notprevpos = antal_cases_notprevpos / antal_personer_notprevpos * 100000,
    incidence_cases_prevpos = antal_cases_prevpos / antal_personer_prevpos * 100000
    ) %>% 
  select(Week, Vax_status, incidence_cases_notprevpos, incidence_cases_prevpos) %>%
  pivot_longer(c(incidence_cases_notprevpos, incidence_cases_prevpos), names_to = c("Type", "Variable", "Group"), values_to = "Value", names_sep = "_") %>% 
  filter(Vax_status != "Anden vaccination") %>% 
  mutate(Vax_status = case_when(
    Vax_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
    Vax_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
    TRUE ~ Vax_status
  )) 

plot_data$Vax_status <- factor(plot_data$Vax_status, levels = c("Ingen vaccination", "Første vaccination", "Fuld effekt 2 doser", "Fuld effekt 3 doser"))

plot_data %>% 
  filter(Week > 48) %>% 
  mutate(Week = paste0("Uge ", Week)) %>% 
  mutate(Group = case_when(
    Group == "notprevpos" ~ "Ikke tidligere\npositive",
    Group == "prevpos" ~ "Tidligere positive"
  )) %>% 
ggplot() +
  geom_bar(aes(Group, Value, group = Vax_status, fill = Vax_status), stat = "identity", position = "dodge") +
  facet_wrap(~ Week, ncol = 3) +
  labs(y = "Positive per 100.000",
       title = "<b><span style = 'font-size:13pt'>Ugentligt smittede per 100.000 fordelt på vaccinationsstatus og tidligere smitte</span></b><br><br>Antal positive er opgivet per 100.000 i vaccinationsgruppe/tidligere-smittegruppe. Tidligere positive er defineret som >60 dage siden seneste positive PCR test. Alle tal er baseret på PCR test og på hele befolkningen. <br>", 
       caption = standard_caption) +
  geom_text(
    aes(Group, Value + 20, group = Vax_status, color = Vax_status, label = sprintf("%.0f",round(Value,0))),
    vjust = 0,
    position = position_dodge(0.9),
    size = rel(2),
    family = "lato"
  ) +
  facet_theme +
  scale_y_continuous(limits = c(0, NA)) +
  scale_fill_manual(name = "", values = c(pct_col, death_col, admit_col, "#67cc32", pos_col)) +
  scale_color_manual(name = "", values = c(pct_col, death_col, admit_col, "#67cc32", pos_col)) +
  guides(color = FALSE) +
  theme(
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    plot.caption.position =  "plot",
    panel.grid.major.x = element_blank(),
    axis.text.x = element_text(margin = margin(t = -5, r = 0, b = 0, l = 0)),
    plot.title.position = "plot",
    plot.title = element_textbox_simple(
      size = 9, face = "plain", lineheight = 1.05, padding = margin(0, 5, 5, 0), width = unit(0.9, "npc"),
    )
  )

ggsave("../figures/bt_incidence_all.png", width = 20, height = 11, units = "cm", dpi = 300)


plot_data <- bt_2 %>% 
  mutate(Vax_status = case_when(
    Vax_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
    Vax_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
    TRUE ~ Vax_status
  )) %>% 
  filter(Type == "incidence",
         Variable == "cases",
         Group == "notprevpos",
         Week == 51,
         Vax_status %in% c("Fuld effekt 2 doser", "Fuld effekt 3 doser"),
         !Aldersgruppe %in% c("0-5", "6-11")
         ) 
  
plot_data$Aldersgruppe <- factor(plot_data$Aldersgruppe, levels = c("0-5", "6-11", "12-15", "16-19", "20-29", "30-39", "40-49", "50-59", "60-64", "65-69", "70-79", "80+"))

plot_data %>% 
  ggplot() +
  geom_bar(aes(Aldersgruppe, Value, group = Vax_status, fill = Vax_status), stat = "identity", position = "dodge") +
  labs(y = "Positive per 100.000",
       title = "Positive per 100.000",
       caption = standard_caption) +
  standard_theme +
  scale_y_continuous(limits = c(0, NA)) +
  scale_fill_manual(name = "", values = c(admit_col, "#67cc32")) +
  scale_color_manual(name = "", values = c(admit_col, "#67cc32")) +
  guides(color = FALSE) +
  theme(
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    panel.grid.major.x = element_blank(),
    axis.text.x = element_text(margin = margin(t = -5, r = 0, b = 0, l = 0))
    )

ggsave("../figures/bt_incidence_example2.png", width = 18, height = 10, units = "cm", dpi = 300)

  
plot_data <- bt_2 %>% 
  filter(Variable == "cases") %>%
  pivot_wider(names_from = c(Type, Variable, Group), values_from = Value, names_sep = "_") %>%
  mutate(
    antal_personer_notprevpos = replace_na(antal_cases_notprevpos / incidence_cases_notprevpos * 100000, 0)
    ) %>% 
  mutate(Vax_status = case_when(
    Vax_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
    Vax_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
    TRUE ~ Vax_status
  )) %>% 
  filter(
         Week == 51,
         Vax_status %in% c("Fuld effekt 2 doser", "Fuld effekt 3 doser"),
         !Aldersgruppe %in% c("0-5", "6-11")
  ) 

plot_data$Aldersgruppe <- factor(plot_data$Aldersgruppe, levels = c("0-5", "6-11", "12-15", "16-19", "20-29", "30-39", "40-49", "50-59", "60-64", "65-69", "70-79", "80+"))

plot_data %>% 
  ggplot() +
  geom_bar(aes(Aldersgruppe, antal_personer_notprevpos, group = Vax_status, fill = Vax_status), stat = "identity", position = "dodge") +
  labs(y = "Antal personer",
       title = "Antal vaccinerede",
       caption = standard_caption) +
  standard_theme +
  scale_y_continuous(limits = c(0, NA), labels = scales::number) +
  scale_fill_manual(name = "", values = c(admit_col, "#67cc32")) +
  scale_color_manual(name = "", values = c(admit_col, "#67cc32")) +
  guides(color = FALSE) +
  theme(
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    panel.grid.major.x = element_blank(),
    axis.text.x = element_text(margin = margin(t = -5, r = 0, b = 0, l = 0))
  )

ggsave("../figures/bt_incidence_example3.png", width = 18, height = 10, units = "cm", dpi = 300)
  
plot_data <- bt_2 %>% 
  mutate(Vax_status = case_when(
    Vax_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
    Vax_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
    TRUE ~ Vax_status
  )) %>% 
  filter(
    Variable == "cases",
    Type == "antal",
    Group == "notprevpos",
    Week == 51, 
    Vax_status %in% c("Fuld effekt 2 doser", "Fuld effekt 3 doser"),
    !Aldersgruppe %in% c("0-5", "6-11")) %>% 
  group_by(Aldersgruppe) %>% 
  summarize(Value = sum(Value, na.rm = TRUE))

plot_data$Aldersgruppe <- factor(plot_data$Aldersgruppe, levels = c("0-5", "6-11", "12-15", "16-19", "20-29", "30-39", "40-49", "50-59", "60-64", "65-69", "70-79", "80+"))

plot_data %>% 
  ggplot() +
  geom_bar(aes(Aldersgruppe, Value), stat = "identity", position = "dodge") +
  labs(y = "Antal positive",
       title = "Antal positive blandt vax opdelt på alder",
       caption = standard_caption) +
  standard_theme +
  scale_y_continuous(limits = c(0, NA)) +
  guides(color = FALSE) +
  theme(
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    panel.grid.major.x = element_blank(),
    axis.text.x = element_text(margin = margin(t = -5, r = 0, b = 0, l = 0))
  )

ggsave("../figures/bt_incidence_example4.png", width = 18, height = 10, units = "cm", dpi = 300)

bt_1 <- read_csv2("../data/tidy_breakthru_table1.csv")

bt_1 %>% 
  filter(Variable %in% c("personer", "cases"),
         Week == 51,) %>%
  pivot_wider(names_from = c(Type, Variable, Group), values_from = Value, names_sep = "_") %>%
  mutate(
    antal_personer_prevpos = antal_personer_alle - antal_personer_notprevpos,
    incidence_cases_notprevpos = antal_cases_notprevpos / antal_personer_notprevpos * 100000,
    incidence_cases_prevpos = antal_cases_prevpos / antal_personer_prevpos * 100000
  ) %>% 
  select(Week, Vax_status, incidence_cases_notprevpos, incidence_cases_prevpos) %>%
  pivot_longer(c(incidence_cases_notprevpos, incidence_cases_prevpos), names_to = c("Type", "Variable", "Group"), values_to = "Value", names_sep = "_") %>% 
  filter(Vax_status != "Anden vaccination") %>% 
  mutate(Vax_status = case_when(
    Vax_status == "Fuld effekt efter primært forløb" ~ "Fuld effekt 2 doser",
    Vax_status == "Fuld effekt efter revaccination" ~ "Fuld effekt 3 doser",
    TRUE ~ Vax_status
  )) %>% 
  filter(
    Group == "notprevpos",
    Vax_status %in% c("Fuld effekt 2 doser", "Fuld effekt 3 doser")) %>% 
  ggplot() +
  geom_bar(aes(Vax_status, Value, fill = Vax_status), stat = "identity", position = "dodge") +
  scale_fill_manual(name = "", values = c(admit_col, "#67cc32")) +
  labs(y = "Positive per 100.000",
       title = "Positive per 100.000 (alle aldre)",
       caption = standard_caption) +
  standard_theme +
  scale_y_continuous(limits = c(0, NA)) +
  guides(color = FALSE) +
  theme(
    plot.margin = margin(0.7, 0.7, 0.2, 0.7, "cm"),
    panel.grid.major.x = element_blank(),
    axis.text.x = element_blank()
  )



ggsave("../figures/bt_incidence_example1.png", width = 18, height = 10, units = "cm", dpi = 300)
