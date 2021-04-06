
plot_data <-
  tests %>%
  full_join(admitted, by = "Date") %>%
  full_join(deaths, by = "Date") %>%
  filter(Date > ymd("2020-02-14"))
  
# Pos ------------------------------------------------------------------

plot_data %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, NewPositive), fill = pos_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, running_avg_pos), size = 1, color = pos_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Antal positive", 
    x = "Dato", 
    title = "Dagligt antal positivt SARS-CoV-2 testede", 
    caption = standard_caption
    ) +
  standard_theme  

ggsave("../figures/ntl_pos.png", width = 18, height = 10, units = "cm", dpi = 300)



# Tests ------------------------------------------------------------------

plot_data %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, Tested, fill = test_col), width = 1) +
  geom_line(aes(Date, running_avg_total), size = 1, color = test_col) +
  geom_bar(stat = "identity", position = "stack", aes(Date, NewPositive), fill = "white", width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, NewPositive, fill = pos_col), width = 1) +
  geom_line(aes(Date, running_avg_pos), size = 1, color = pos_col) +
  scale_fill_manual(
    name = "", 
    labels = c("Testede", "Positive"), 
    values = c(alpha(test_col, 0.6), alpha(pos_col, 0.6))
    ) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 month") +
  scale_y_continuous(
    limits = c(0, NA),
    labels = scales::number
  ) +
  labs(
    y = "Antal", 
    x = "Dato", 
    title = "Dagligt antal SARS-CoV-2 testede og positive", 
    caption = standard_caption
    ) +
  standard_theme + 
  theme(
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, 'cm')
    )

ggsave("../figures/ntl_tests.png", width = 18, height = 12, units = "cm", dpi = 300)



# Pos% maj ------------------------------------------------------------------

plot_data %>%
  filter(Date > ymd("2020-04-30")) %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, pct_confirmed), fill = pct_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, running_avg_pct), size = 1, color = pct_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
  scale_y_continuous(
    limits = c(0, NA),
    labels = function(x) paste0(x, " %")
  ) +
  labs(
    y = "Positivprocent", 
    x = "Dato", 
    title = "Daglig procent positivt SARS-CoV-2 testede", 
    caption = standard_caption
    ) +
  standard_theme + 
  theme(panel.grid.minor.x = element_blank())

ggsave("../figures/ntl_pct_2.png", width = 18, height = 10, units = "cm", dpi = 300)

# Pos% ------------------------------------------------------------------

plot_data %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, pct_confirmed), fill = pct_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, running_avg_pct), size = 1, color = pct_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(
    limits = c(0, NA),
    labels = function(x) paste0(x, " %")
  ) +
  labs(
    y = "Positivprocent", 
    x = "Dato", 
    title = "Daglig procent positivt SARS-CoV-2 testede", 
    caption = standard_caption
    ) +
  standard_theme

ggsave("../figures/ntl_pct_1.png", width = 18, height = 10, units = "cm", dpi = 300)



# Smitteindex -------------------------------------------------------------

plot_data %>%
  mutate(ix = NewPositive / NotPrevPos ** 0.7) %>% 
  filter(Date > ymd("2020-03-14")) %>% 
  ggplot() +
  geom_line(aes(Date, ix), size = 1, color = darken(pct_col, 0.1)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Indeks", 
    x = "Dato", 
    title = "Dagligt SARS-CoV-2 smitteindeks", 
    subtitle = bquote('Indeks = positive /' ~testede^0.7), 
    caption = standard_caption
    ) +
  standard_theme

ggsave("../figures/ntl_index.png", width = 18, height = 10, units = "cm", dpi = 300)



# Antigen -----------------------------------------------------------------

ag %>%
  select(Date, AGpos_minusPCRkonf, AGpos_PCRpos, AGpos_PCRneg) %>% 
  pivot_longer(c(-Date)) %>% 
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
      method == "PCRonly" ~ "PCR uden antigen",
      method == "PCRAgneg" ~ "PCR uden positive antigen",
      method == "PCRall" ~ "PCR med alle antigen",
      TRUE ~ method
    )
  )
  

ag_plot_data %>% 
  filter(str_detect(method, "PCR")) %>% 
  ggplot() +
  geom_line(aes(Date, value, color = variable, size = type, alpha = type)) +
  facet_grid(~ method) +
  scale_x_date(labels = my_date_labels, date_breaks = "3 week", minor_breaks = "1 week") +
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
    #plot.title.position = 'plot',
    plot.title = element_text(),
    legend.position = "none"
    )

ggsave("../figures/ntl_ag_pct.png", width = 18, height = 10, units = "cm", dpi = 300)

# Pos vs pos% ------------------------------------------------------------------

plot_data %>%
  filter(Date > ymd("2020-04-30")) %>%
  ggplot() +
  geom_point(aes(Date, pct_confirmed * 1000), color = pct_col, alpha = 0.3, size = 2) +
  geom_point(aes(Date, NewPositive), color = pos_col, alpha = 0.3, size = 2) +
  geom_line(aes(Date, running_avg_pct * 1000), size = 1, color = pct_col) +
  geom_line(aes(Date, running_avg_pos), size = 1, color = pos_col) +
  scale_color_manual(
    name = "", 
    labels = c("Positivprocent", "Positive"), 
    values = c(alpha(pct_col, 0.3), 
               alpha(pos_col, 0.3))
    ) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 months") +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Antal",
    sec.axis = sec_axis(~ . / 1000, name = "Positivprocent", labels = function(x) paste0(x, " %")),
  ) +
  labs(
    y = "Positivprocent", 
    x = "Dato", 
    title = "Procent vs. antal positivt SARS-CoV-2 testede", 
    caption = standard_caption
    ) +
  standard_theme + 
  theme(panel.grid.minor.x = element_blank())

ggsave("../figures/ntl_pos_pct.png", width = 18, height = 12, units = "cm", dpi = 300)

# Nyindlagte ------------------------------------------------------------------

plot_data %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, Total), fill = admit_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, running_avg_admit), size = 1, color = admit_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Antal", 
    x = "Dato", 
    title = "Dagligt antal nyindlagte med positiv SARS-CoV-2 test", 
    caption = standard_caption
    ) +
  standard_theme

ggsave("../figures/ntl_hosp.png", width = 18, height = 10, units = "cm", dpi = 300)


# Døde ------------------------------------------------------------------


plot_data %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, Antal_døde), fill = death_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, running_avg_deaths), size = 1, color = death_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Antal", 
    x = "Dato", 
    title = "Daglig antal døde med positiv SARS-CoV-2 test", 
    caption = standard_caption
    ) +
  standard_theme

ggsave("../figures/ntl_deaths.png", width = 18, height = 10, units = "cm", dpi = 300)

# positive admitted barplot ------------------------------------------------------------------


plot_data %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, NewPositive, fill = pos_col), width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, Total * 10), fill = "white", width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, Total * 10, fill = admit_col), width = 1) +
  geom_line(aes(Date, running_avg_admit * 10), size = 1, color = admit_col) +
  geom_line(aes(Date, running_avg_pos), size = 1, color = pos_col) +
  scale_fill_manual(
    name = "", 
    labels = c("Nyindlæggelser", "Positive"), 
    values = c(alpha(admit_col, 0.6), alpha(pos_col, 0.6))
    ) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Positive",
    sec.axis = sec_axis(~ . / 10, name = "Nyindlæggelser")
  ) +
  labs(
    y = "Antal", 
    x = "Dato", 
    title = "Nyindlagte med positiv SARS-CoV-2 test vs. positivt SARS-CoV-2 testede", 
    caption = standard_caption
    ) +
  standard_theme + 
  theme(
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, 'cm')
    )

ggsave("../figures/ntl_postest_admitted_barplot_2.png", width = 18, height = 12, units = "cm", dpi = 300 )




# pct admitted barplot ------------------------------------------------------------------

plot_data %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, pct_confirmed), fill = pct_col, alpha = 0.6, width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, Total / 20), fill = "white", width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, Total / 20), fill = admit_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, running_avg_pct), size = 1, color = pct_col) +
  geom_line(aes(Date, running_avg_admit / 20), size = 1, color = admit_col) +
  scale_fill_manual(
    name = "", 
    labels = c("Nyindlæggelser", "Positivprocent"), 
    values = c(alpha(admit_col, 0.6), alpha(pct_col, 0.6))
    ) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Positivprocent",
    labels = function(x) paste0(x, " %"),
    sec.axis = sec_axis(~ . * 20, name = "Nyindlæggelser")
  ) +
  labs(
    y = "Antal", 
    x = "Dato", 
    title = "Nyindlagte med positiv SARS-CoV-2 test vs. procent positivt SARS-CoV-2 testede", 
    caption = standard_caption
    ) +
  standard_theme + 
  theme(
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, 'cm')
    )

ggsave("../figures/ntl_pct_admitted_barplot_2.png", width = 18, height = 12, units = "cm", dpi = 300)


# -------------------------------------------------------------------------

# positive deaths barplot ------------------------------------------------------------------


plot_data %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, NewPositive), fill = pos_col, alpha = 0.7, width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, Antal_døde * 100), fill = "white", width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, Antal_døde * 100), fill = death_col, alpha = 0.7, width = 1) +
  geom_line(aes(Date, running_avg_deaths * 100), size = 1, color = death_col) +
  geom_line(aes(Date, running_avg_pos), size = 1, color = pos_col) +
  scale_fill_manual(
    name = "", 
    labels = c("Døde", "Positive"), 
    values = c(alpha(death_col, 0.6), alpha(pos_col, 0.6))
    ) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Positive",
    sec.axis = sec_axis(~ . / 100, name = "Døde")
  ) +
  labs(
    y = "Antal", 
    x = "Dato", 
    title = "Døde med positiv SARS-CoV-2 test vs. antal positivt SARS-CoV-2 testede", 
    caption = standard_caption
    ) +
  standard_theme + 
  theme(
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, 'cm')
    )

ggsave("../figures/ntl_postest_deaths_barplot_2.png", width = 18, height = 12, units = "cm", dpi = 300)

# pct deaths barplot ------------------------------------------------------------------

plot_data %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, pct_confirmed), fill = pct_col, alpha = 0.6, width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, Antal_døde / 5), fill = "white", width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, Antal_døde / 5), fill = death_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, running_avg_pct), size = 1, color = pct_col) +
  geom_line(aes(Date, running_avg_deaths / 5), size = 1, color = death_col) +
  scale_fill_manual(
    name = "", 
    labels = c("Døde", "Positivprocent"), 
    values = c(alpha(death_col, 0.6), alpha(pct_col, 0.6))
    ) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Procent",
    labels = function(x) paste0(x, " %"),
    sec.axis = sec_axis(~ . * 5, name = "Døde")
  ) +
  labs(
    y = "Antal", 
    x = "Dato", 
    title = "Døde med positiv SARS-CoV-2 test vs. procent positivt SARS-CoV-2 testede", 
    caption = standard_caption
    ) +
  standard_theme + 
  theme(
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, 'cm')
    )

ggsave("../figures/ntl_pct_deaths_barplot_2.png", width = 18, height = 12, units = "cm", dpi = 300)


# Twitter card ------------------------------------------------------------------

plot_data %>%
  filter(Date > ymd("2020-04-30")) %>%
  ggplot() +
  geom_point(aes(Date, pct_confirmed * 1000), size = 2, color = alpha(pct_col, 0.3)) +
  geom_point(aes(Date, NewPositive), size = 2, color = alpha(pos_col, 0.3)) +
  geom_line(aes(Date, running_avg_pct * 1000), size = 1, color = pct_col) +
  geom_line(aes(Date, running_avg_pos), size = 1, color = pos_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 months") +
  scale_y_continuous(
    limits = c(0, NA),
    name = "Antal",
    sec.axis = sec_axis(~ . / 1000, name = "Positivprocent", labels = function(x) paste0(x, " %")),
  ) +
  theme_void()
 
ggsave("../figures/twitter_card.png", width = 15, height = 8, units = "cm", dpi = 300) 

# -------------------------------------------------------------------------

# tiltag -------------------------------------------------------------

tiltag <- tribble(~Date, ~tiltag, ~type,
                  ymd("2020-03-12"), "Nedlukning 1", "restrict",
                  ymd("2020-04-17"), "Fase 1: Små klasser,\ndagtilbud, liberale erhverv", "open",
                  ymd("2020-05-09"), "Fase 2, del 1: Idræt,\nforeningsliv, detailhandel", "open",
                  ymd("2020-05-22"), "Fase 2, del 2: Alle uddannelser,\nkulturliv, natteliv", "open",
                  ymd("2020-06-08"), "Fase 3: Forsamling op til 50,\nindendørs idræt", "open",
                  ymd("2020-07-07"), "Forsamling op til 100", "open", 
                  ymd("2020-08-14"), "Lukketid udvides", "open",
                  ymd("2020-08-22"), "Masker i off. transport", "restrict",
                  ymd("2020-09-18"), "Masker + lukketid restauranter", "restrict",
                  ymd("2020-09-19"), "Forsamling ned til 50", "restrict",
                  ymd("2020-09-25"), "Privat forsamling: 50", "restrict",
                  ymd("2020-10-26"), "Forsamling ned til 10 mv.", "restrict",
                  ymd("2020-10-29"), "Masker alle off. steder", "restrict",
                  ymd("2020-12-07"), "Restriktioner Hovedstaden", "restrict",
                  ymd("2020-12-09"), "Delvis nedluk 38 komm.", "restrict",
                  ymd("2020-12-11"), "Delvis nedluk 69 komm.", "restrict",
                  ymd("2020-12-17"), "Nedlukning 2-1", "restrict",
                  ymd("2020-12-21"), "Nedlukning 2-2", "restrict",
                  ymd("2020-12-25"), "Nedlukning 2-3", "restrict",
                  ymd("2021-01-05"), "Forsamling ned til 5", "restrict",
                  ymd("2021-02-08"), "0-4. kl åbner", "open",
                  ymd("2021-03-01"), "Noget detailhandel,\nudendørs kultur/idræt", "open",
                  ymd("2021-03-15"), "Høj- og efterskoler,\nbegrænset åbning ældre klasser",  "open",
                  )

cols <- c(
  "A" = alpha(pos_col, 0.6), 
  "B" = alpha(pct_col, 0.6), 
  "C" = alpha(admit_col, 0.6), 
  "D" = alpha(death_col, 0.6)
  )

# x <- plot_data %>%
#   full_join(tiltag, by = "Date")  %>%
#   filter(Date > ymd("2020-06-20"),
#          Date < ymd("2021-02-02"))
#   
# x %>%
#   ggplot() +
#   geom_bar(stat = "identity", position = "stack", aes(Date, NewPositive, fill = "A"), width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, pct_confirmed * 200), fill = "white", width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, pct_confirmed * 200, fill = "B"), width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Total), fill = "white", width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Total, fill = "C"), width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Antal_døde), fill = "white", width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Antal_døde, fill = "D"), width = 1) +
#   geom_line(aes(Date, running_avg_pos), size = 1, color = darken(pos_col, 0)) +
#   geom_line(aes(Date, running_avg_pct * 200), size = 1, color = darken(pct_col, 0)) +
#   geom_line(aes(Date, running_avg_admit), size = 1, color = darken(admit_col, 0)) +
#   geom_line(aes(Date, running_avg_deaths), size = 1, color = darken(death_col, 0)) +
#   geom_label_repel(
#     aes(Date, 0, label = tiltag),
#     color = "white", 
#     verbose = TRUE,
#     fill = "grey40", 
#     size = 2.5, 
#     ylim = c(0, NA), 
#     xlim = c(-Inf, Inf),
#     nudge_y = x$running_avg_pos * 1.4 + 2000,
#     direction = "y",
#     force_pull = 0, 
#     box.padding = 0.1, 
#     max.overlaps = Inf, 
#     segment.size = 0.32,
#     segment.color = "grey40"
#   ) +
#   scale_fill_manual(name = "", labels = c("Positive", "Positivprocent", "Nyindlæggelser", "Døde"), values = cols) +
#   scale_x_date(labels = my_date_labels, date_breaks = "1 months") +
#   scale_y_continuous(
#     limits = c(0, 8000),
#     name = "Antal",
#     sec.axis = sec_axis(~ . / 200, name = "Positivprocent", labels = function(x) paste0(x, " %")),
#   ) +
#   labs(y = "Antal", x = "Dato", title = "Epidemi-indikatorer og tiltag (juli 2020 - februar 2021)", caption = standard_caption) +
#   standard_theme +
#   theme(
#     panel.grid.minor.x = element_blank(),
#     legend.text = element_text(size = 11),
#     legend.key.size = unit(0.4, "cm")
#   )
# 
#   ggsave("../figures/ntl_tiltag_july.png", width = 18, height = 12, units = "cm", dpi = 300)
#   
  

# Tiltag fra januar -------------------------------------------------------

x <- plot_data %>%
  rename(
    daily_admit = Total,
    daily_deaths = Antal_døde,
    daily_pct = pct_confirmed,
    ra_admit = running_avg_admit,
    ra_deaths = running_avg_deaths,
    ra_pct = running_avg_pct) %>% 
  mutate(
    daily_pct = daily_pct * 100,
    ra_pct = ra_pct * 100,
    daily_ix = NewPositive / NotPrevPos ** 0.7 * 100,
    ra_ix = ra(daily_ix)) %>% 
  select(Date, daily_ix, ra_ix, daily_admit, ra_admit, daily_deaths, ra_deaths) %>% 
  pivot_longer(-Date, names_to = c("type", "variable"), names_sep = "_") %>% 
  filter(Date > ymd("2021-01-31")) 

max_values <- x %>%
  group_by(Date) %>% 
  summarize(value = max(value)) %>% 
  semi_join(tiltag, by = "Date")

x %>% 
  ggplot() +
  geom_line(data = subset(x, type ==  "daily"), aes(Date, value, color = variable), size = 0.2, alpha = 0.6) +
  geom_line(data = subset(x, type ==  "ra"), aes(Date, value, color = variable), size = 1.2) +
  geom_label_repel(
    data = subset(tiltag, Date >=  ymd("2021-02-01")),
    aes(Date, 0, label = tiltag),
    color = "white", 
    verbose = TRUE,
    fill = "grey40", 
    size = 2.5, 
    ylim = c(0, NA), 
    xlim = c(-Inf, Inf),
    nudge_y = max_values$value + 40,
    direction = "y",
    force_pull = 0, 
    box.padding = 0.1, 
    max.overlaps = Inf, 
    segment.size = 0.32,
    segment.color = "grey40"
  ) +
  scale_color_manual(
    name = "", 
    labels = c("Nyindlæggelser", "Døde", "Smitteindeks"), 
    values = c(admit_col, death_col, pct_col)
    ) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 months") +
  scale_y_continuous(
    limits = c(0, 100),
    name = "Antal",
    sec.axis = sec_axis(~ . / 100, name = "Smitteindeks")
  ) +
  labs(
    y = "Antal", 
    x = "Dato", 
    title = "Epidemi-indikatorer og genåbning #2 (vinter/forår 2021)", 
    caption = standard_caption, 
    subtitle = '<b style="color:#4393C3;">Nyindlæggelser</b>,  <b style="color:#777777;">døde</b>, og <b style="color:#E69F00;">smitteindeks</b> (PCR positive justeret for antal tests: positive / testede<sup>0.7</sup>)'
    ) +
  standard_theme +
  theme(
    plot.subtitle = element_markdown(),
    legend.position = "none"
  )


ggsave("../figures/ntl_tiltag_january.png", width = 18, height = 10, units = "cm", dpi = 300)
  


# zip vs dashboard ---------------------------------------------------
plot_data <-
  tests %>%
  full_join(admitted, by = "Date") %>%
  full_join(deaths, by = "Date") %>%
  filter(Date > ymd("2020-02-14"))

x <- plot_data %>% select(Date, NewPositive, NotPrevPos, Total, Antal_døde) %>%
  rename(Indlæggelser = Total) %>%
  pivot_longer(-Date, names_to = "variable", values_to = "values") %>%
  mutate(dataset = "zip")

y <- dashboard_data %>% mutate(dataset = "dashboard")

plot_data <- bind_rows(x,y)

DB <- read_csv2("../data/Dashboard/Covid-19_dashboard_210319/Kommunalt_DB/01_noegletal.csv", locale = locale(encoding = "latin1"))

DB %>% 
  rename(Date = IndberetningDato,
         Positive = "Antal bekræftede tilfælde",
         Tested = "Antal prøver siden sidst") %>% 
  select(Date, Positive, Tested) %>% 
  mutate(Positive = c(0, diff(Positive))) %>%
  filter(Date > ymd("2021-01-31")) %>% 
  pivot_longer(-Date) %>% 
  ggplot(aes(Date, value, color = name)) +
  geom_line(size = 1.2) +
  scale_x_date(labels = my_date_labels, breaks = "1 week") +
  standard_theme
  
plot_data %>%
  filter(variable == "NewPositive") %>%
  filter(Date > ymd(today) - months(2)) %>%
  ggplot(aes(Date, values)) +
  geom_line(stat = "identity", position = "identity" , size = 1.2, aes(color = dataset)) +
  labs(y = "Antal", x = "Dato", title = "Positivt testede: Antal fra dashboard vs antal fra datafiler") +
  scale_color_manual(name = "", labels = c("SSI's dashboard", "datafiler"), values = binary_col) +
  scale_x_date(labels = my_date_labels, breaks = "1 week") +
  scale_y_continuous(
    limits = c(0, ceiling(max(plot_data$values) / 1000) * 1000)
  ) +
  standard_theme

ggsave("../figures/ntl_test_pos_vs_dashboard.png", width = 18, height = 10, units = "cm", dpi = 300)

x <- tests %>% select(Date, NewPositive, NotPrevPos)
x %<>% pivot_longer(-Date, names_to = "variable", values_to = "values")
x %<>% mutate(dataset = "test_pos")
y <- dashboard_data %>% mutate(dataset = "dashboard")
plot_data <- bind_rows(x,y)
plot_data %<>% filter(Date > ymd(today) - weeks(4),
                      variable %in% c("NotPrevPos"))

ggplot(plot_data, aes(Date, values)) +
  geom_line(stat = "identity", position = "identity" , size = 1.2, aes(color = dataset)) +
  labs(y = "Antal", x = "Dato", title = "Testede: 'Prøver' vs. testede personer") +
  scale_color_manual(name = "", labels = c("Prøvesvar", "Prøvetagning"), values = c(darken(test_col, 0.6), lighten(test_col, 0.6))) +
  scale_x_date(date_labels = "%e. %b", date_breaks = "1 week") +
  scale_y_continuous(
    limits = c(0, ceiling(max(plot_data$values) / 10000) * 10000)
  ) +
  standard_theme

ggsave("../figures/ntl_test_vs_dashboard.png", width = 18, height = 12, units = "cm", dpi = 300)



# Deaths all vs covid -----------------------------------------------------

cols <- c("all" = lighten("#16697a", 0.4),"covid" = "#ffa62b", "average" = darken("#16697a", .4))

dst_deaths_5yr %<>%
  mutate(md = paste0(sprintf("%02d", Month), str_sub(Day, 2, 3))) %>%
  select(-Month, -Day) %>%
  pivot_longer(-md, names_to = "year", values_to = "Deaths") %>%
  mutate(
    Deaths = ifelse(Deaths == "..", NA, Deaths),
    Deaths = as.double(Deaths)) %>%
  group_by(md) %>%
  summarize(
    avg_5yr = mean(Deaths, na.rm = TRUE),
    max_5yr = max(Deaths, na.rm = TRUE),
    min_5yr = min(Deaths, na.rm = TRUE)
    ) %>%
  ungroup()

plot_data <- dst_deaths %>%
  mutate(md = paste0(str_sub(Date, 6, 7), str_sub(Date, 9, 10))) %>%
  mutate(Date = ymd(paste0(str_sub(Date, 1, 4), "-", str_sub(Date, 6, 7), "-", str_sub(Date, 9, 10)))) %>%
  full_join(deaths, by = "Date") %>%
  full_join(dst_deaths_5yr, by = "md") %>%
  group_by(Date_wk = floor_date(Date + 4, "1 week")) %>%
  mutate(smooth_avg = mean(avg_5yr, na.rm = TRUE)) %>%
  mutate(smooth_avg = ifelse(Date == Date_wk, smooth_avg, NA)) %>%
  ungroup() %>%
  select(-Date_wk)

plot_data %>%
  ggplot() +
  geom_bar(stat="identity",position = "identity", aes(Date, current, fill = "all"), width = 1) +
  geom_bar(stat="identity",position = "identity", aes(Date, Antal_døde, fill = "covid"), width = 1) +
  geom_line(data = plot_data[!is.na(plot_data$smooth_avg), ], aes(Date, smooth_avg, color = "average"), size = 1) +
  #stat_smooth(se = FALSE, aes(Date, avg_5yr, color = "average"), span = 0.05) + 
  scale_x_date(labels = my_date_labels, breaks = "2 months") +
  labs(x = "Dato", y = "Antal døde", title = "Daglige dødsfald i Danmark", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik og SSI") +
  scale_fill_manual(name = "", labels = c("Alle", "COVID-19"), values = cols[1:2]) +
  scale_color_manual(name = "", labels = c("Gennemsnit 2015-19", "Gennemsnit alle 2020"), values = cols[3:4]) +
  standard_theme 

ggsave("../figures/dst_deaths_covid_all.png", width = 18, height = 12, units = "cm", dpi = 300)


plot_data <- dst_deaths %>%
  mutate(md = paste0(str_sub(Date, 6, 7), str_sub(Date, 9, 10))) %>%
  mutate(Date = ymd(paste0(str_sub(Date, 1, 4), "-", str_sub(Date, 6, 7), "-", str_sub(Date, 9, 10)))) %>%
  full_join(deaths, by = "Date") %>%
  full_join(dst_deaths_5yr, by = "md") %>%
  group_by(Date=floor_date(Date + 4, "1 week")) %>%
  summarize(across(where(is.numeric), sum)) %>%
  mutate(Antal_døde = ifelse(is.na(Antal_døde), 0, Antal_døde)) %>%
  mutate(Non_covid = current - Antal_døde) %>%
  select(-current) %>%
  filter(!is.na(Non_covid)) %>%
  pivot_longer(-Date, names_to = "variable", values_to = "value") 

cols <- c("all" = lighten("#16697a", 0.4),"covid" = "#ffa62b", "average" = darken("#16697a", .4))

  ggplot(plot_data) +
  geom_bar(data = subset(plot_data, variable %in% c("Non_covid", "Antal_døde")), stat="identity", position = "stack", aes(Date, value, fill = variable)) +
  #geom_line(data = subset(plot_data, variable %in% c("max_5yr", "min_5yr")), aes(Date, value, color = variable), size = 0.5) + 
  geom_line(data = subset(plot_data, variable == "avg_5yr"), aes(Date, value, color = "average"), size = 1) + 
  scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
  labs(x = "Dato", y = "Antal døde", title = "Ugentlige dødsfald i Danmark", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik og SSI") +
  scale_fill_manual(name = "", labels = c("COVID-19", "Ikke COVID-19"), values = c("#ffa62b", lighten("#16697a", 0.4))) +
  scale_color_manual(name = "", labels = c("Gennemsnit 2015-19", "", ""), values = rep(cols[3],3)) +
  standard_theme  +
    theme(panel.grid.minor.x = element_blank())

  ggsave("../figures/dst_deaths_covid_all_wk.png", width = 18, height = 12, units = "cm", dpi = 300)
  
  
  plot_data <- dst_deaths %>%
    mutate(md = paste0(str_sub(Date, 6, 7), str_sub(Date, 9, 10))) %>%
    mutate(Date = ymd(paste0(str_sub(Date, 1, 4), "-", str_sub(Date, 6, 7), "-", str_sub(Date, 9, 10)))) %>%
    full_join(deaths, by = "Date") %>%
    full_join(dst_deaths_5yr, by = "md") %>%
    group_by(Date_wk = floor_date(Date + 4, "1 week")) %>%
    mutate(smooth_avg = mean(avg_5yr, na.rm = TRUE)) %>%
    mutate(smooth_avg = ifelse(Date == Date_wk, smooth_avg, NA)) %>%
    ungroup() %>%
    select(-Date_wk) %>%
    mutate(Antal_døde = ifelse(is.na(Antal_døde), 0, Antal_døde)) %>%
    mutate(Non_covid = current - Antal_døde) %>%
    select(-current, -md) %>%
    filter(!is.na(Non_covid)) %>%
    pivot_longer(-Date, names_to = "variable", values_to = "value") 
  
  cols <- c("all" = lighten("#16697a", 0.4),"covid" = "#ffa62b", "average" = darken("#16697a", .4))
  
  ggplot(plot_data) +
    geom_bar(data = subset(plot_data, variable %in% c("Non_covid", "Antal_døde")), stat="identity", position = "stack", aes(Date, value, fill = variable), width = 1) +
    #geom_line(data = subset(plot_data, variable == "ra_avg"), aes(Date, value, color = "average"), size = 1) + 
    geom_line(data = plot_data[plot_data$variable == "smooth_avg" & !is.na(plot_data$value), ], aes(Date, value, color = "average"), size = 1) +
    #stat_smooth(data = subset(plot_data, variable == "avg_5yr"), se = FALSE, aes(Date, value, color = "average"), span = 0.05) +
    #stat_smooth(data = subset(plot_data, variable == "min_5yr"), se = FALSE, aes(Date, value, color = "average"), span = 0.05, size = 0.3) +
    #stat_smooth(data = subset(plot_data, variable == "max_5yr"), se = FALSE, aes(Date, value, color = "average"), span = 0.05, size = 0.3) +
    scale_x_date(labels = my_date_labels, date_breaks = "2 month") +
    labs(x = "Dato", y = "Antal døde", title = "Daglige dødsfald i Danmark", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik og SSI") +
    scale_fill_manual(name = "", labels = c("COVID-19", "Ikke COVID-19"), values = c("#ffa62b", lighten("#16697a", 0.4))) +
    scale_color_manual(name = "", labels = c("Gennemsnit 2015-19", "", ""), values = rep(cols[3],3)) +
    standard_theme  
  
  ggsave("../figures/dst_deaths_covid_all_2.png", width = 18, height = 12, units = "cm", dpi = 300)
  
  
