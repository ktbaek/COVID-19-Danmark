prevpos <- read_csv2("../data/24_reinfektioner_daglig_region.csv", locale = locale(encoding = "ISO-8859-1")) %>% 
  rename(
    Date = Prøvedato,
    Positive = infected,
    Type = `Type af tilfælde (reinfektion eller bekræftet tilfælde)`
  ) %>%
  select(-type_count, -`Antal borgere`) %>%
  filter(Type == "1.Reinfektion") %>% 
  group_by(Date) %>% 
  summarize(daily = sum(Positive, na.rm = TRUE)) %>% 
  mutate(name = "Repositive") %>% 
  slice(1:(n() - 2)) # exclude last two days that may not be updated

read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name == "Positive") %>%
  mutate(name = "Nye positive") %>% 
  bind_rows(prevpos) %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily, fill = name), alpha = 0.8, width = 1) +
  #geom_line(aes(Date, ra), size = 1, color = pos_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
  scale_fill_manual(name = "", values = c(pos_col, darken(pos_col, 0.7))) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Antal positive",
    x = "Dato",
    title = "Dagligt antal positivt SARS-CoV-2 testede",
    caption = standard_caption
  ) +
  standard_theme

ggsave("../figures/ntl_pos.png", width = 18, height = 10, units = "cm", dpi = 300)




  
  