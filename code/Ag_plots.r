if(!is.null(ag)) {
# Antigen -----------------------------------------------------------------

ag %>%
  select(Date, AGpos_minusPCRkonf, AGpos_PCRpos, AGpos_PCRneg) %>% 
  pivot_longer(c(-Date)) %>% 
  filter(Date > ymd("2021-01-31")) %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = name), width = 1) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 weeks") +
  scale_y_continuous(limits = c(0, NA)) +
  scale_fill_manual(
    name = "Heraf:", 
    labels = c("Ikke PCR testede", "PCR negative", "PCR positive"), 
    values = c(alpha("gray80", 0.7), alpha("gray55", 0.7), alpha(pos_col, 0.9))
  ) +
  labs(
    y = "Antal positive", 
    x = "Dato", 
    title = "Dagligt antal positive SARS-CoV-2 antigentestede", 
    caption = standard_caption
  ) +
  standard_theme  

ggsave("../figures/ntl_ag_pos.png", width = 18, height = 10, units = "cm", dpi = 300)


ag %>%
  full_join(tests, by = "Date") %>% 
  mutate(ag_testede = AG_testede - AGpos_PCRneg - AGpos_PCRpos - AGnegPCRneg - AGnegPCRpos) %>% 
  select(Date, ag_testede, Tested) %>% 
  pivot_longer(c(-Date)) %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = name), width = 1) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
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
  ) +
  standard_theme  

ggsave("../figures/ntl_ag_test.png", width = 18, height = 10, units = "cm", dpi = 300)


ag_plot_data <- 
  ag %>%
  full_join(tests, by = "Date") %>% 
  filter(
    Date > ymd("2021-01-31"),
    Date < ymd(today) - 2) %>% 
  mutate(
    total_testede = NotPrevPos + AG_testede - AGpos_PCRneg - AGpos_PCRpos - AGnegPCRneg - AGnegPCRpos,
    total_positive = NewPositive + AGpos_minusPCRkonf,
    PCRonly_testede = NotPrevPos - AGpos_PCRneg - AGpos_PCRpos - AGnegPCRpos - AGnegPCRneg,
    PCRonly_positive = NewPositive - AGnegPCRpos - AGpos_PCRpos,
    PCRAgneg_testede = NotPrevPos - AGpos_PCRneg - AGpos_PCRpos,
    PCRAgneg_positive = NewPositive - AGpos_PCRpos,
    daily_Antigen_pct = AG_pos / AG_testede * 100,
    daily_Antigen_zix = AG_pos / AG_testede ** 0.7,
    daily_PCRonly_pct = PCRonly_positive / PCRonly_testede * 100,
    daily_PCRonly_zix = PCRonly_positive / PCRonly_testede ** 0.7,
    daily_PCRAgneg_pct = PCRAgneg_positive / PCRAgneg_testede * 100,
    daily_PCRAgneg_zix = PCRAgneg_positive / PCRAgneg_testede ** 0.7,
    daily_PCRall_pct = NewPositive / NotPrevPos * 100,
    daily_PCRall_zix = NewPositive / NotPrevPos ** 0.7,
    daily_Total_pct = total_positive / total_testede * 100,
    daily_Total_zix = total_positive / total_testede ** 0.7) %>% 
  mutate(
    ra_Antigen_pct = ra(daily_Antigen_pct),
    ra_Antigen_zix = ra(daily_Antigen_zix),
    ra_PCRonly_pct = ra(daily_PCRonly_pct),
    ra_PCRonly_zix = ra(daily_PCRonly_zix),
    ra_PCRAgneg_pct = ra(daily_PCRAgneg_pct),
    ra_PCRAgneg_zix = ra(daily_PCRAgneg_zix),
    ra_PCRall_pct = ra(daily_PCRall_pct),
    ra_PCRall_zix = ra(daily_PCRall_zix),
    ra_Total_pct = ra(daily_Total_pct),
    ra_Total_zix = ra(daily_Total_zix)) %>% 
  select(Date, daily_Antigen_pct:ra_Total_zix) %>% 
  pivot_longer(-Date, names_to = c("type", "method", "variable"), values_to = "value", names_sep = "_") %>% 
  mutate(
    method = case_when(
      method == "PCRonly" ~ "PCR uden Ag-spor",
      method == "Antigen" ~ "Ag-spor",
      method == "PCRAgneg" ~ "PCR med pos fra Ag-spor",
      method == "PCRall" ~ "PCR med Ag-spor",
      TRUE ~ method
    )
  )


ag_plot_data %>% 
 # filter(str_detect(method, "PCR")) %>% 
  ggplot() +
  geom_line(aes(Date, value, color = variable, size = type, alpha = type)) +
  facet_grid(~ method) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", minor_breaks = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  scale_color_manual(
    name = "", 
    labels = c("Positivprocent", "Smitteindeks"), 
    values = c(lighten(pct_col, 0.3), darken(pct_col, 0.3))
  ) +
  scale_size_manual(
    name = "", 
    labels = c("Dagligt", "7-dages gennemsnit"), 
    values = c(0.3, 1)
  ) +
  scale_alpha_manual(
    name = "", 
    labels = c("Dagligt", "7-dages gennemsnit"), 
    values = c(0.6, 1)
  ) +
  labs(
    y = "Procent / Indeks", 
    x = "Dato", 
    title = "Antal SARS-CoV-2 positive justeret for antal testede", 
    caption = standard_caption, 
    subtitle = '<b style="color:#EFA722;">Positivprocent</b> = positive / testede \u00D7 100. <b style="color:#9D6C06;">Smitteindeks</b> = positive / testede<sup>0.7</sup>'
  ) +
  facet_theme + 
  theme(
    plot.subtitle = ggtext::element_markdown(),
    plot.margin = margin(.6, .6, 0.3, .6, "cm"),
    plot.title = element_text(),
    legend.position = "none"
  )

ggsave("../figures/ntl_ag_pct.png", width = 18, height = 10, units = "cm", dpi = 300)


ag %>%
  select(Date, AGnegPCRpos, AGnegPCRneg, AG_testede, AG_pos) %>% 
  mutate(share_PCR_pos = 100 * AGnegPCRpos / (AGnegPCRneg + AGnegPCRpos),
         share_PCR_test = 100 * (AGnegPCRneg + AGnegPCRpos) / (AG_testede - AG_pos)) %>% 
 # pivot_longer(c(-Date)) %>% 
  filter(Date > ymd("2021-01-31")) %>% 
  ggplot() +
  geom_line(aes(Date, share_PCR_test), size = 1) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 weeks") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Procent", 
    x = "Dato", 
    title = "Andel Ag-negative der dobbelttestes med PCR", 
    caption = standard_caption
  ) +
  standard_theme  



}