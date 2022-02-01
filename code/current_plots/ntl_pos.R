
plot_data <- read_csv2("../data/24_reinfektioner_daglig_region.csv", locale = locale(encoding = "ISO-8859-1")) %>%
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
  bind_rows(filter(read_csv2("../data/SSI_daily_data.csv"), name == "Positive")) %>%
  select(-ra) %>%
  pivot_wider(values_from = daily) %>%
  rowwise() %>%
  mutate(sum = sum(c(Positive, Repositive), na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(Date) %>%
  filter(Date <= ymd(today) - days(3)) %>%
  mutate(ra = ra(sum)) %>%
  select(-sum) %>%
  pivot_longer(-Date) %>%
  mutate(name = case_when(name == "Positive" ~ "Nye positive", TRUE ~ name))

plot_data %>%
  ggplot() +
  geom_bar(data = subset(plot_data, name != "ra"), stat = "identity", position = "stack", aes(Date, value, fill = name), alpha = 0.6, width = 1) +
  geom_line(data = subset(plot_data, name == "ra"), aes(Date, value), size = 1, color = pos_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
  scale_fill_manual(name = "Heraf:", values = c(pos_col, darken(pos_col, 0.9))) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Antal positive",
    x = "Dato",
    title = "Dagligt antal positivt SARS-CoV-2 testede",
    caption = standard_caption
  ) +
  standard_theme

ggsave("../figures/ntl_pos.png", width = 18, height = 10, units = "cm", dpi = 300)
