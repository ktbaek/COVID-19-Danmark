ag <- read_csv2("../data/SSI_Ag_data.csv")

PCR <- read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name %in% c("Tested", "Positive")) %>%
  select(-ra) %>%
  pivot_wider(names_from = name, values_from = daily)

beta <- 0.5

ag_data <- ag %>%
  full_join(PCR, by = "Date") %>%
  filter(
    Date > ymd("2021-01-31"),
    Date < ymd(today) - 2
  ) %>%
  mutate(
    total_testede = Tested + AG_testede - AGpos_PCRneg - AGpos_PCRpos - AGnegPCRneg - AGnegPCRpos,
    total_positive = Positive + AGpos_minusPCRkonf,
    PCRonly_testede = Tested - AGpos_PCRneg - AGpos_PCRpos - AGnegPCRpos - AGnegPCRneg,
    PCRonly_positive = Positive - AGnegPCRpos - AGpos_PCRpos,
    daily_Antigen_pct = AG_pos / AG_testede * 100,
    daily_Antigen_ix = AG_pos / (AG_testede / 100000)**beta,
    daily_PCRonly_pct = PCRonly_positive / PCRonly_testede * 100,
    daily_PCRonly_ix = PCRonly_positive / (PCRonly_testede / 100000)**beta,
    daily_PCRall_pct = Positive / Tested * 100,
    daily_PCRall_ix = Positive / (Tested / 100000)**beta,
    daily_Total_pct = total_positive / total_testede * 100,
    daily_Total_ix = total_positive / (total_testede / 100000)**beta
  ) %>%
  mutate(
    ra_Antigen_pct = ra(daily_Antigen_pct),
    ra_Antigen_ix = ra(daily_Antigen_ix),
    ra_PCRonly_pct = ra(daily_PCRonly_pct),
    ra_PCRonly_ix = ra(daily_PCRonly_ix),
    ra_PCRall_pct = ra(daily_PCRall_pct),
    ra_PCRall_ix = ra(daily_PCRall_ix),
    ra_Total_pct = ra(daily_Total_pct),
    ra_Total_ix = ra(daily_Total_ix)
  ) %>%
  select(Date, daily_Antigen_pct:ra_Total_ix) %>%
  pivot_longer(-Date, names_to = c("type", "method", "variable"), values_to = "value", names_sep = "_")

ag_plot_data <- ag_data %>%
  filter(
    Date > ymd("2021-06-30"),
    method != "Antigen"
  ) %>%
  mutate(
    method = case_when(
      method == "PCRonly" ~ "PCR fraregnet Ag-spor",
      method == "Antigen" ~ "Ag-spor",
      method == "PCRall" ~ "PCR inkl. Ag-spor",
      TRUE ~ method
    )
  )

plot_layer <- list(
  geom_line(aes(Date, value, color = method, size = type, alpha = type)),
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", minor_breaks = "1 month", expand = expansion(mult = 0.01)),
  scale_y_continuous(limits = c(0, NA)),
  scale_size_manual(
    guide = FALSE,
    name = "",
    labels = c("Dagligt", "7-dages gennemsnit"),
    values = c(0.3, 1)
  ),
  scale_alpha_manual(
    guide = FALSE,
    name = "",
    labels = c("Dagligt", "7-dages gennemsnit"),
    values = c(0.6, 1)
  ),
  guides(color = guide_legend(override.aes = list(size = 1))),
  facet_theme,
  theme(
    plot.subtitle = ggtext::element_markdown(lineheight = 1.2),
    plot.margin = margin(.6, .6, 0.3, .6, "cm"),
    plot.title = element_text(size = rel(1.3), margin = margin(t = -5, b = 3)),
    legend.position = "none"
  )
)

p1 <- ag_plot_data %>%
  filter(variable == "pct") %>%
  ggplot() +
  plot_layer +
  scale_y_continuous(labels = function(x) paste0(x, " %")) +
  theme(axis.text.x = element_blank()) +
  labs(
    y = "Procent",
    x = "Dato",
    title = "Positivprocent"
  )

p2 <- ag_plot_data %>%
  filter(variable == "ix") %>%
  ggplot() +
  plot_layer +
  labs(
    y = "Antal",
    x = "Dato",
    title = "Testjusteret smittetal",
    subtitle = "Smittetal justeret til 100.000 testede = positive / (testede / 100.000)<sup>0.5</sup>"
  )

p1 / p2 + plot_annotation(
  title = "SARS-CoV-2 prævalens",
  subtitle = '<b style="color:#00BA38;">PCR inkl. Ag-spor</b> = PCR resultater inkl. Ag-testede der også PCR-testes (den "officielle" metode)<br><b style="color:#F8766D;">PCR fraregnet Ag-spor</b> = PCR resultater fraregnet Ag-testede der også PCR-testes<br><b style="color:#619CFF;">Total</b> = PCR og Ag lagt sammen (Ag-testede der også PCR-testes er kun medtalt én gang)',
  caption = standard_caption,
  theme = theme(
    plot.title = element_text(size = rel(1.3), face = "bold", margin = margin(b = 5)),
    plot.subtitle = element_markdown(size = rel(0.8), lineheight = 1.2),
    text = element_text(family = "lato"),
    plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
    plot.caption = element_text(color = "gray60", hjust = 0, size = 10),
  )
)

ggsave("../figures/ntl_ag_pct_method.png", width = 15, height = 20, units = "cm", dpi = 300)
