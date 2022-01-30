read_csv2("../data/SSI_Ag_data.csv") %>%
  full_join(tests, by = "Date") %>%
  mutate(ag_testede = AG_testede - AGpos_PCRneg - AGpos_PCRpos - AGnegPCRneg - AGnegPCRpos) %>%
  select(Date, AG_testede, Tested, PosPct) %>%
  rename(
    Ag_testede = AG_testede,
    PCR_testede = Tested
  ) %>%
  pivot_longer(c(-Date)) %>%
  filter(
    Date > ymd("2021-11-07"),
    Date < ymd("2022-01-02")
  ) %>%
  mutate(
    week = isoweek(Date),
    wday = case_when(
      wday(Date) > 1 ~ wday(Date) - 1,
      TRUE ~ 7
    )
  ) %>%
  ggplot() +
  geom_line(aes(wday, value, color = as.factor(week)), size = 1) +
  scale_y_continuous(
    limits = c(0, NA),
    labels = scales::number
  ) +
  facet_wrap(~name, scales = "free") +
  scale_color_discrete(name = "Uge") +
  labs(
    y = "Antal",
    x = "Ugedag (mandag = 1)",
    title = "Antal SARS-CoV-2 testede fordelt på ugedage",
    caption = standard_caption
  ) +
  guides(colour = guide_legend(nrow = 1)) +
  standard_theme +
  theme(axis.title.x = element_text())

ggsave("../figures/ntl_test_pct_wday.png", width = 18, height = 10, units = "cm", dpi = 300)
