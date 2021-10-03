plot_data <- read_csv2("../data/SSI_plot_data.csv")

# Pos ------------------------------------------------------------------

plot_data %>%
  filter(name == "Positive") %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily), fill = pos_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra), size = 1, color = pos_col) +
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
  filter(name %in% c("Positive", "Tested")) %>% 
  pivot_wider(names_from = name, values_from = c(daily, ra), names_sep = "_") %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Tested, fill = test_col), width = 1) +
  geom_line(aes(Date, ra_Tested), size = 1, color = test_col) +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Positive), fill = "white", width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Positive, fill = pos_col), width = 1) +
  geom_line(aes(Date, ra_Positive), size = 1, color = pos_col) +
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
  filter(name == "Percent") %>% 
  filter(Date > ymd("2020-04-30")) %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily), fill = pct_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra), size = 1, color = pct_col) +
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
  filter(name == "Percent") %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily), fill = pct_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra), color = pct_col) +
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
  filter(name %in% c("Index", "Percent")) %>% 
  mutate(
    daily = ifelse(name == "Index", daily * 4, daily),
    ra = ifelse(name == "Index", ra * 4, ra)
  ) %>% 
  pivot_longer(c(daily, ra), names_to = "type") %>% 
  filter(Date > ymd("2020-03-14")) %>% 
  ggplot() +
  geom_line(aes(Date, value, alpha = type, size = type, color = name)) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
  scale_y_continuous(
    limits = c(0, 5),
    name = "Positivprocent",
    labels = function(x) paste0(x, " %"),
    sec.axis = sec_axis(~ . / 4, name = "Index", breaks = c(0, 0.5, 1))
  ) +
  scale_size_manual(
    name = "", 
    labels = c("Dagligt", "7-dages gennemsnit"), 
    values = c(0.3, 1),
    guide = FALSE
  ) +
  scale_alpha_manual(
    name = "", 
    labels = c("Dagligt", "7-dages gennemsnit"), 
    values = c(0.6, 1),
    guide = FALSE
  ) +
  scale_color_manual(
    name = "", 
    labels = c("Index", "Percent"), 
    values = c(darken(pct_col, 0.3), lighten(pct_col, 0.3)),
    guide = FALSE
  ) +
  labs(
    y = "Indeks", 
    x = "Dato", 
    title = "Antal SARS-CoV-2 positive justeret for antal testede", 
    caption = standard_caption, 
    subtitle = '<b style="color:#EFA722;">Positivprocent</b> = positive / testede \u00D7 100. <b style="color:#9D6C06;">Smitteindeks</b> = positive / testede<sup>0.7</sup>'
    ) +
  standard_theme +
  theme(
    plot.subtitle = element_markdown()
  )

ggsave("../figures/ntl_index.png", width = 18, height = 10, units = "cm", dpi = 300)

# Pos vs pos% ------------------------------------------------------------------

plot_data %>%
  filter(name %in% c("Positive", "Percent")) %>% 
  filter(Date > ymd("2020-04-30")) %>%
  pivot_wider(names_from = name, values_from = c(daily, ra), names_sep = "_") %>% 
  ggplot() +
  geom_point(aes(Date, daily_Percent * 1000), color = pct_col, alpha = 0.3, size = 2) +
  geom_point(aes(Date, daily_Positive), color = pos_col, alpha = 0.3, size = 2) +
  geom_line(aes(Date, ra_Percent * 1000), size = 1, color = pct_col) +
  geom_line(aes(Date, ra_Positive), size = 1, color = pos_col) +
  scale_color_manual(
    name = "", 
    labels = c("Positivprocent", "Positive"), 
    values = c(alpha(pct_col, 0.3), 
               alpha(pos_col, 0.3))
    ) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months") +
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
  filter(name == "Admitted") %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily), fill = admit_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra), size = 1, color = admit_col) +
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
  filter(name == "Deaths") %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily), fill = death_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra), size = 1, color = death_col) +
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
  filter(name %in% c("Positive", "Admitted")) %>% 
  pivot_wider(names_from = name, values_from = c(daily, ra), names_sep = "_") %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Positive, fill = pos_col), width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Admitted * 10), fill = "white", width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Admitted * 10, fill = admit_col), width = 1) +
  geom_line(aes(Date, ra_Admitted * 10), size = 1, color = admit_col) +
  geom_line(aes(Date, ra_Positive), size = 1, color = pos_col) +
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
  filter(name %in% c("Percent", "Admitted")) %>% 
  pivot_wider(names_from = name, values_from = c(daily, ra), names_sep = "_") %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Percent), fill = pct_col, alpha = 0.6, width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Admitted / 20), fill = "white", width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Admitted / 20), fill = admit_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra_Percent), size = 1, color = pct_col) +
  geom_line(aes(Date, ra_Admitted / 20), size = 1, color = admit_col) +
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
  filter(name %in% c("Positive", "Deaths")) %>% 
  pivot_wider(names_from = name, values_from = c(daily, ra), names_sep = "_") %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Positive), fill = pos_col, alpha = 0.7, width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Deaths * 100), fill = "white", width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Deaths * 100), fill = death_col, alpha = 0.7, width = 1) +
  geom_line(aes(Date, ra_Deaths * 100), size = 1, color = death_col) +
  geom_line(aes(Date, ra_Positive), size = 1, color = pos_col) +
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
  filter(name %in% c("Percent", "Deaths")) %>% 
  pivot_wider(names_from = name, values_from = c(daily, ra), names_sep = "_") %>% 
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Percent), fill = pct_col, alpha = 0.6, width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Deaths / 5), fill = "white", width = 1) +
  geom_bar(stat = "identity", position = "stack", aes(Date, daily_Deaths / 5), fill = death_col, alpha = 0.6, width = 1) +
  geom_line(aes(Date, ra_Percent), size = 1, color = pct_col) +
  geom_line(aes(Date, ra_Deaths / 5), size = 1, color = death_col) +
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
  filter(name %in% c("Positive", "Percent")) %>% 
  filter(Date > ymd("2020-04-30")) %>%
  pivot_wider(names_from = name, values_from = c(daily, ra), names_sep = "_") %>% 
  ggplot() +
  geom_point(aes(Date, daily_Percent * 1000), color = pct_col, alpha = 0.3, size = 2) +
  geom_point(aes(Date, daily_Positive), color = pos_col, alpha = 0.3, size = 2) +
  geom_line(aes(Date, ra_Percent * 1000), size = 1, color = pct_col) +
  geom_line(aes(Date, ra_Positive), size = 1, color = pos_col) +
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
                  ymd("2021-04-06"), "Mere fysisk fremmøde 5-8. kl\n + andre udd., liberale erhverv,\ncoronapas indføres",  "open",
                  ymd("2021-04-21"), "Større genåbning,\nforsamling op til hhv 10/50",  "open",
                  ymd("2021-05-06"), "Indendørs servering/idræt mv.",  "open",
                  ymd("2021-05-21"), "Øvrige idræts/\nkulturfaciliteter mv.",  "open",
                  ymd("2021-06-14"), "Større genåbning,\nfjernelse af maskekrav",  "open",
                  ymd("2021-08-01"), "Coronapas fjernes for zoo m.fl.",  "open",
                  ymd("2021-09-01"), "Natklubber genåbner,\ncoronapas fjernes for servering mv.",  "open",
                  ymd("2021-09-10"), "Alle restriktioner ophæves.",  "open"
                  )

cols <- c(
  "A" = alpha(pos_col, 0.6), 
  "B" = alpha(pct_col, 0.6), 
  "C" = alpha(admit_col, 0.6), 
  "D" = alpha(death_col, 0.6)
  )



# Tiltag fra januar -------------------------------------------------------

x <- plot_data %>%
  filter(name %in% c("Admitted", "Deaths", "Index")) %>% 
  mutate(
    daily = ifelse(name == "Index", daily * 100, daily),
    ra = ifelse(name == "Index", ra * 100, ra)
    ) %>% 
  pivot_longer(c(daily, ra), names_to = "type") %>% 
  filter(Date > ymd("2021-01-31")) 

max_values <- x %>%
  group_by(Date) %>% 
  summarize(value = max(value, na.rm = TRUE)) %>% 
  semi_join(tiltag, by = "Date")

x %>% 
  ggplot() +
  geom_line(data = subset(x, type ==  "daily"), aes(Date, value, color = name), size = 0.2, alpha = 0.6) +
  geom_line(data = subset(x, type ==  "ra"), aes(Date, value, color = name), size = 1.2) +
  geom_label_repel(
    data = subset(tiltag, Date >=  ymd("2021-02-01")),
    aes(Date, 0, label = tiltag),
    color = "white", 
    verbose = TRUE,
    fill = "grey40", 
    size = 2.2, 
    ylim = c(0, NA), 
    xlim = c(-Inf, Inf),
    nudge_y = max_values$value + 60,
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
  scale_x_date(labels = my_date_labels, date_breaks = "1 months", limits = c(ymd("2021-02-01"), ymd("2021-10-01"))) +
  scale_y_continuous(
    limits = c(0, 125),
    name = "Antal",
    sec.axis = sec_axis(~ . / 100, name = "Smitteindeks")
  ) +
  labs(
    y = "Antal", 
    x = "Dato", 
    title = "Smittens udvikling ved genåbning #2 (vinter/forår 2021)", 
    caption = standard_caption, 
    subtitle = '<b style="color:#4393C3;">Nyindlæggelser</b>,  <b style="color:#777777;">døde</b>, og <b style="color:#E69F00;">smitteindeks</b> (PCR positive justeret for antal tests: positive / testede<sup>0.7</sup>)'
    ) +
  standard_theme +
  theme(
    plot.subtitle = element_markdown(),
    panel.grid.minor.x = element_blank(),
    legend.position = "none"
  )


ggsave("../figures/ntl_tiltag_january.png", width = 18, height = 10, units = "cm", dpi = 300)
  


# tiltag ENG-------------------------------------------------------------

restrictions <- tribble(~Date, ~tiltag, ~type,
                  ymd("2021-02-08"), "In-person schooling:\nup to 4th grade", "open",
                  ymd("2021-03-01"), "Some retail,\noutdoor culture/sports", "open",
                  ymd("2021-03-15"), "Outdoor schooling once/week:\ngrades 5 and up",  "open",
                  ymd("2021-04-06"), "Hybrid-schooling: grades 5 and up + universities,\nsmall businesses,\ncovid passport requirement",  "open",
                  ymd("2021-04-21"), "Larger reopening,\ngatherings up to 10/50",  "open",
                  ymd("2021-05-06"), "Indoor dining/sports",  "open",
                  ymd("2021-05-21"), "All other sports + culture",  "open",
                  ymd("2021-06-14"), "Larger reopening,\nmasks no longer required",  "open",
                  ymd("2021-08-01"), "Covid passport no longer required for zoos etc.",  "open",
                  ymd("2021-09-01"), "Night clubs, covid passport\nno longer required for indoor dining etc.",  "open",
                  ymd("2021-09-10"), "All restrictions removed",  "open"
)

cols <- c(
  "A" = alpha(pos_col, 0.6), 
  "B" = alpha(pct_col, 0.6), 
  "C" = alpha(admit_col, 0.6), 
  "D" = alpha(death_col, 0.6)
)



# Tiltag fra januar ENG-------------------------------------------------------

x <- plot_data %>%
  filter(name %in% c("Admitted", "Deaths", "Index")) %>% 
  mutate(
    daily = ifelse(name == "Index", daily * 100, daily),
    ra = ifelse(name == "Index", ra * 100, ra)
  ) %>% 
  pivot_longer(c(daily, ra), names_to = "type") %>% 
  filter(Date > ymd("2021-01-31")) 

max_values <- x %>%
  group_by(Date) %>% 
  summarize(value = max(value, na.rm = TRUE)) %>% 
  semi_join(tiltag, by = "Date")

Sys.setlocale("LC_ALL", "en_US.UTF-8")

x %>% 
  ggplot() +
  geom_line(data = subset(x, type ==  "daily"), aes(Date, value, color = name), size = 0.2, alpha = 0.6) +
  geom_line(data = subset(x, type ==  "ra"), aes(Date, value, color = name), size = 1.2) +
  geom_label_repel(
    data = subset(restrictions, Date >=  ymd("2021-02-01")),
    aes(Date, 0, label = tiltag),
    color = "white", 
    verbose = TRUE,
    fill = "grey40", 
    size = 2.2, 
    ylim = c(0, NA), 
    xlim = c(-Inf, Inf),
    nudge_y = max_values$value + 60,
    direction = "y",
    force_pull = 0, 
    box.padding = 0.1, 
    max.overlaps = Inf, 
    segment.size = 0.32,
    segment.color = "grey40"
  ) +
  scale_color_manual(
    name = "", 
    labels = c("Admissions", "Deaths", "Test adjusted cases"), 
    values = c(admit_col, death_col, pct_col)
  ) +
  scale_x_date(date_labels = "%e %b", date_breaks = "1 months", limits = c(ymd("2021-01-22"), ymd("2021-10-01"))) +
  scale_y_continuous(
    limits = c(0, 125),
    name = "Admissions, deaths",
    sec.axis = sec_axis(~ . / 100, name = "Test adjusted cases")
  ) +
  labs(
    y = "Admissions, deaths", 
    x = "Date", 
    title = "Reopening 2021, Denmark", 
    caption = standard_caption, 
    subtitle = '<b style="color:#4393C3;">Admissions</b>,  <b style="color:#777777;">deaths</b>, and <b style="color:#E69F00;">test adjusted cases</b> (PCR positive / tested<sup>0.7</sup>)'
  ) +
  standard_theme +
  theme(
    plot.subtitle = element_markdown(),
    panel.grid.minor.x = element_blank(),
    legend.position = "none"
  )


ggsave("../figures/ntl_tiltag_january_EN.png", width = 18, height = 10, units = "cm", dpi = 300)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")
#  2020 vs 2021 -------------------------------------------------------

x <- plot_data %>%
  filter(Date > ymd("2020-03-15")) %>% 
  filter(name %in% c("Admitted", "Deaths", "Index")) %>% 
  pivot_longer(c(daily, ra), names_to = "type") %>% 
  mutate(
    year = as.character(year(ymd(Date))),
    Date = `year<-`(Date, 2021)) %>% 
  filter(Date > ymd("2021-01-01")) 

max_values <- x %>%
  group_by(Date) %>% 
  summarize(value = max(value)) %>% 
  semi_join(tiltag, by = "Date")

x %>% 
  filter(Date < ymd("2021-06-30")) %>% 
  filter(name == "Index") %>% 
  ggplot() +
  geom_line(aes(Date, value, color = year, alpha = type, size = type)) +
  scale_color_manual(
   name = "", 
    labels = c("2020", "2021"), 
    values = c("#e78ac3", "#66c2a5")
  ) +
scale_alpha_manual(
  name = "", 
  labels = c("Dagligt", "7-dages gennemsnit"), 
  values = c(0.5, 1),
  guide = FALSE
) +
  scale_size_manual(
    name = "", 
    labels = c("Dagligt", "7-dages gennemsnit"), 
    values = c(0.3, 1), 
    guide = FALSE
  ) +
  scale_x_date(date_labels = "%e %b", date_breaks = "1 months", minor_breaks = "1 month") +
  labs(
    y = "Indeks", 
    x = "Dato", 
    title = "Smittens udvikling 2021 vs 2020", 
    caption = standard_caption, 
    subtitle = 'Kurven angiver smitteindeks (PCR positive justeret for antal tests = positive / testede<sup>0.7</sup>)'
  ) +
  standard_theme +
theme(
  plot.subtitle = element_markdown()
)


ggsave("../figures/ntl_tiltag_20v21.png", width = 18, height = 10, units = "cm", dpi = 300)


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
  geom_bar(stat="identity", position = "identity", aes(x = Date, y = current, fill = "all"), width = 1) +
  geom_bar(stat="identity", position = "identity", aes(Date, Deaths, fill = "covid"), width = 1) +
  geom_line(data = plot_data[!is.na(plot_data$smooth_avg), ], aes(Date, smooth_avg, color = "average"), size = 1) +
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
    group_by(Date_wk = floor_date(Date + 4, "1 week")) %>%
    mutate(smooth_avg = mean(avg_5yr, na.rm = TRUE)) %>%
    mutate(smooth_avg = ifelse(Date == Date_wk, smooth_avg, NA)) %>%
    ungroup() %>%
    select(-Date_wk) %>%
    mutate(Antal_døde = ifelse(is.na(Deaths), 0, Deaths)) %>%
    mutate(Non_covid = current - Deaths) %>%
    select(-current, -md) %>%
    filter(!is.na(Non_covid)) %>%
    pivot_longer(-Date, names_to = "variable", values_to = "value") 
  
  cols <- c("all" = lighten("#16697a", 0.4),"covid" = "#ffa62b", "average" = darken("#16697a", .4))
  
  ggplot(plot_data) +
    geom_bar(data = subset(plot_data, variable %in% c("Non_covid", "Deaths")), stat="identity", position = "stack", aes(Date, value, fill = variable), width = 1) +
    geom_line(data = plot_data[plot_data$variable == "smooth_avg" & !is.na(plot_data$value), ], aes(Date, value, color = "average"), size = 1) +
    scale_x_date(labels = my_date_labels, date_breaks = "2 month") +
    labs(x = "Dato", y = "Antal døde", title = "Daglige dødsfald i Danmark", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik og SSI") +
    scale_fill_manual(name = "", labels = c("COVID-19", "Ikke COVID-19"), values = c("#ffa62b", lighten("#16697a", 0.4))) +
    scale_color_manual(name = "", labels = c("Gennemsnit 2015-19", "", ""), values = rep(cols[3],3)) +
    standard_theme  
  
  ggsave("../figures/dst_deaths_covid_all_2.png", width = 18, height = 12, units = "cm", dpi = 300)
  
  # døde i alt alder --------------------------------------------------------
  
  
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
  
  
