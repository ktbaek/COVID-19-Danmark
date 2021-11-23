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
                  ymd("2021-09-10"), "Alle restriktioner ophæves.",  "open",
                  ymd("2021-11-12"), "Coronapas natteliv/servering.",  "restrict",
)


plot_data <- read_csv2("../data/SSI_plot_data.csv") %>%
  filter(name %in% c("Admitted", "Deaths", "Index")) %>% 
  mutate(
    daily = ifelse(name == "Index", daily * 100, daily),
    ra = ifelse(name == "Index", ra * 100, ra)
  ) %>% 
  pivot_longer(c(daily, ra), names_to = "type") %>% 
  filter(Date > ymd("2021-01-31")) 

max_values <- plot_data %>%
  group_by(Date) %>% 
  summarize(value = max(value, na.rm = TRUE)) %>% 
  semi_join(tiltag, by = "Date")

plot_data %>% 
  ggplot() +
  geom_line(data = subset(plot_data, type ==  "daily"), aes(Date, value, color = name), size = 0.2, alpha = 0.6) +
  geom_line(data = subset(plot_data, type ==  "ra"), aes(Date, value, color = name), size = 1.2) +
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
  scale_x_date(labels = my_date_labels, date_breaks = "1 months", limits = c(ymd("2021-02-01"), ymd(today))) +
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
