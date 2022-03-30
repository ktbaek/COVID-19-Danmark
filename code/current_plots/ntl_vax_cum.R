
read_csv2(paste0("../data/Vax_data/Vaccine_DB_", vax_today_string, "/Vaccine_dato_region.csv"), locale = locale(encoding = "ISO-8859-1")) %>% 
  select(Dato, Region, `Samlet antal 1. stik`, `Samlet antal 2. stik`, `Samlet antal 3. stik`) %>% 
  pivot_longer(c(-Dato, -Region)) %>%
  group_by(Dato, name) %>% 
  summarize(value = sum(value, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(Dato, value, color = name), size = 2) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months", minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
  scale_y_continuous(limits = c(0, NA), labels = scales::number) +
  scale_color_manual(name = "", labels = c("Første dose", "Anden dose", "Tredje dose"), values = c("#30e3ca", "#11999e", "#1c3499")) +
  labs(y = "Antal", title = "Kumuleret antal COVID-19 vaccinerede", caption = standard_caption) 

ggsave("../figures/ntl_vax_cum.png", width = 18, height = 10, units = "cm", dpi = 300)
