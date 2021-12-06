Sys.setlocale("LC_ALL", "en_US.UTF-8")

x <- dst_deaths %>%
  mutate(Date = ymd(paste0(str_sub(Date, 1, 4), "-", str_sub(Date, 6, 7), "-", str_sub(Date, 9, 10)))) %>%
  rename(daily = current) %>%
  mutate(
    name = "Daily deaths, all",
    ra = ra(daily)
  )


read_csv2("../data/SSI_daily_data.csv") %>%
  mutate(name = case_when(
    name == "Positive" ~ "Daily PCR positive",
    name == "Tested" ~ "Daily PCR tested",
    name == "Percent" ~ "Daily positivity rate",
    name == "Admitted" ~ "Daily admitted",
    name == "Deaths" ~ "Daily deaths, COVID"
  )) %>%
  filter(name != "Index") %>%
  bind_rows(x) %>%
  mutate(
    year = year(Date),
    new_date = `year<-`(Date, 2021)
  ) %>%
  pivot_longer(c(daily, ra), names_to = "type", values_to = "value") %>%
  filter(new_date > "2021-08-31", new_date <= "2021-12-31") %>%
  ggplot() +
  geom_line(aes(new_date, value, color = as.factor(year), size = type, alpha = type)) +
  scale_y_continuous(limits = c(0, NA)) +
  scale_x_date(date_labels = "%e %b", date_breaks = "1 months") +
  scale_color_discrete(name = "") +
  scale_size_manual(
    guide = FALSE,
    values = c(0.3, 1)
  ) +
  scale_alpha_manual(
    guide = FALSE,
    values = c(0.6, 1)
  ) +
  labs(
    y = "Number/Percent",
    x = "Date",
    title = "SARS-CoV-2, fall 2021 v. 2020, Denmark",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, data: SSI, Danmarks Statistik"
  ) +
  guides(color = guide_legend(override.aes = list(size = 1))) +
  facet_wrap(~name, scales = "free_y") +
  facet_theme +
  theme(
    axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0)),
    plot.margin = margin(0.6, 0.6, 0.3, 0.6, "cm"),
    legend.margin = margin(0, 0, 4, 0),
  )

ggsave("../figures/ntl_fall_20_21.png", width = 18, height = 10, units = "cm", dpi = 300)


Sys.setlocale("LC_ALL", "da_DK.UTF-8")
