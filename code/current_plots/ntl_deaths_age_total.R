x <- dst_dd_age %>% 
  mutate(across(c("0-4":"100+"), as.numeric)) %>% 
  pivot_longer(-Date, names_to = "Aldersgruppe", values_to = "daily_deaths") %>% 
  mutate(
    Aldersgruppe = case_when(
      Aldersgruppe == "0-4" ~ "0-49",
      Aldersgruppe =="5-9" ~ "0-49",
      Aldersgruppe =="10-14" ~ "0-49",
      Aldersgruppe =="15-19" ~ "0-49",
      Aldersgruppe =="20-24" ~ "0-49",
      Aldersgruppe =="25-29" ~ "0-49",
      Aldersgruppe =="30-34" ~ "0-49",
      Aldersgruppe =="35-39" ~ "0-49",
      Aldersgruppe =="40-44" ~ "0-49",
      Aldersgruppe =="45-49" ~ "0-49",
      Aldersgruppe =="50-54" ~ "50-59",
      Aldersgruppe =="55-59" ~ "50-59",
      Aldersgruppe =="60-64" ~ "60-69",
      Aldersgruppe =="65-69" ~ "60-69",
      Aldersgruppe =="70-74" ~ "70-79",
      Aldersgruppe =="75-79" ~ "70-79",
      Aldersgruppe =="80-84" ~ "80-89",
      Aldersgruppe =="85-89" ~ "80-89",
      Aldersgruppe =="90-94" ~ "90+",
      Aldersgruppe =="95-99" ~ "90+",
      Aldersgruppe =="100+" ~ "90+",
      TRUE ~ Aldersgruppe
    )) %>% 
  group_by(Aldersgruppe, Date) %>%
  summarize(deaths = sum(daily_deaths, na.rm = TRUE)) %>% 
  mutate(md = paste0(str_sub(Date, 6, 7), str_sub(Date, 9, 10)),
         year = year(Date)) %>%
  select(-Date) %>% 
  bind_rows(cbind(dst_dd_age_5yr, year = as.double("2019"))) %>% 
  group_by(Aldersgruppe, year) %>% 
  arrange(md) %>% 
  filter(md != "0229") %>% 
  mutate(ra_deaths = ra(deaths),
         year = ifelse(year == 2019, "z2019", as.character(year))) %>% 
  mutate(Date = ymd(paste("2019", str_sub(md, 1, 2), str_sub(md, 3, 4), sep = "-")))

x %>% 
  ggplot() +
  geom_area(data = subset(x, year == "z2019"), aes(Date, ra_deaths), fill = hue_pal()(3)[3], alpha = 0.2) +
  geom_line(aes(Date, ra_deaths, color = year, size = year)) +
  scale_size_manual(
    name = "", 
    values = c(0.2, 0.2, 0.05),
    guide = FALSE
  ) +
  facet_wrap(~ Aldersgruppe, ncol = 6) +
  scale_x_date(date_labels = "%b", breaks = c(ymd("2019-01-01"), ymd("2019-07-01")), date_minor_breaks = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    x = "Dato", 
    y = "Antal døde", 
    title = "Daglige dødsfald i Danmark per alder", 
    caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik") +
  scale_colour_discrete(
    name = "", 
    labels = c("2020", "2021", "Gennemsnit 2015-19 (justeret til 2020 befolkningstal)"))+#,
  # values = c(admit_col, pct_col, darken("#16697a", .5))) +
  guides(color = guide_legend(override.aes = list(size = 2)))+
  standard_theme 


ggsave("../figures/ntl_deaths_age_total.png", width = 18, height = 10, units = "cm", dpi = 300)
