read_csv2("../data/SSI_Ag_data.csv") %>%
  full_join(tests, by = "Date") %>%
  mutate(ag_testede = AG_testede - AGpos_PCRneg - AGpos_PCRpos - AGnegPCRneg - AGnegPCRpos) %>%
  select(Date, ag_testede, Tested) %>%
  pivot_longer(c(-Date)) %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = name), width = 1) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 months", minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
  scale_y_continuous(
    limits = c(0, NA),
    labels = scales::number
  ) +
  scale_fill_manual(
    name = "Heraf:",
    labels = c("Antigen", "PCR"),
    values = c(alpha(lighten(test_col, 0.6), 0.8), alpha(darken(test_col, 0), 0.9))
  ) +
  labs(
    y = "Antal",
    x = "Dato",
    title = "Dagligt antal SARS-CoV-2 testede",
    caption = standard_caption
  )

ggsave("../figures/ntl_ag_test.png", width = 18, height = 10, units = "cm", dpi = 300)
