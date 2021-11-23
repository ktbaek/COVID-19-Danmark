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
                        ymd("2021-09-10"), "All restrictions removed",  "open",
                        ymd("2021-11-12"), "Covid passport reinstated\nfor nightlife, dining",  "restricted",
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
  semi_join(restrictions, by = "Date")

Sys.setlocale("LC_ALL", "en_US.UTF-8")

plot_data %>% 
  ggplot() +
  geom_line(data = subset(plot_data, type ==  "daily"), aes(Date, value, color = name), size = 0.2, alpha = 0.6) +
  geom_line(data = subset(plot_data, type ==  "ra"), aes(Date, value, color = name), size = 1.2) +
  geom_label_repel(
    data = restrictions,
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
  scale_x_date(date_labels = "%e %b", date_breaks = "1 months", limits = c(ymd("2021-01-22"), ymd(today))) +
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