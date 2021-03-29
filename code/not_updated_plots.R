source("read_tidy_national.R")
source("national_plots.R")

plot_data <-
  tests %>%
  full_join(admitted, by = "Date") %>%
  full_join(deaths, by = "Date") %>%
  filter(Date > as.Date("2020-02-14"))




# tiltag plot fra april -------------------------------------------------------------
x <- plot_data %>%
  rename(daily_admit = Total,
         daily_deaths = Antal_døde,
         daily_pct = pct_confirmed,
         ra_admit = running_avg_admit,
         ra_deaths = running_avg_deaths,
         ra_pct = running_avg_pct) %>% 
  mutate(daily_pct = daily_pct * 100,
         ra_pct = ra_pct * 100) %>% 
  mutate(daily_ix = NewPositive / NotPrevPos ** 0.7 * 100,
         ra_ix = ra(daily_ix)) %>% 
  select(Date, daily_ix, ra_ix, daily_admit, ra_admit, daily_deaths, ra_deaths) %>% 
  pivot_longer(-Date, names_to = c("type", "variable"), names_sep = "_") 

spring_2020 <- x %>% 
  filter(
    Date > as.Date("2020-03-31"),
    Date < as.Date("2020-08-02")
  ) 

max_values <- spring_2020 %>%
  group_by(Date) %>% 
  summarize(value = max(value)) %>% 
  semi_join(tiltag, by = "Date")

spring_2020 %>% 
  ggplot() +
  geom_line(data = subset(spring_2020, type ==  "daily"), aes(Date, value, color = variable), size = 0.2, alpha = 0.6) +
  geom_line(data = subset(spring_2020, type ==  "ra"), aes(Date, value, color = variable), size = 1.2) +
  geom_label_repel(data = subset(tiltag, Date > ymd("2020-03-31") & Date < ymd("2020-08-02")),
                   aes(Date, 0, label = tiltag),
                   color = "white", 
                   verbose = TRUE,
                   fill = "grey40", 
                   size = 2.5, 
                   ylim = c(0, NA), 
                   xlim = c(-Inf, Inf),
                   nudge_y = max_values$value + 30,
                   direction = "y",
                   force_pull = 0, 
                   box.padding = 0.1, 
                   max.overlaps = Inf, 
                   segment.size = 0.32,
                   segment.color = "grey40"
  ) +
  scale_color_manual(name = "", labels = c("Nyindlæggelser", "Døde", "Smitteindeks"), values = c(admit_col, death_col, pct_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 months") +
  scale_y_continuous(
    limits = c(0, 100),
    name = "Antal",
    sec.axis = sec_axis(~ . / 100, name = "Smitteindeks")
  ) +
  labs(y = "Antal", x = "Dato", title = "Epidemi-indikatorer og genåbning #1 (forår/sommer 2020)", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI", subtitle = '<b style="color:#4393C3;">Nyindlæggelser</b>,  <b style="color:#777777;">døde</b>, og <b style="color:#E69F00;">smitteindeks</b> (PCR positive justeret for antal tests: positive / testede<sup>0.7</sup>)') +
  standard_theme +
  theme(
    plot.subtitle = element_markdown(),
    legend.position = "none"
  )

ggsave("../figures/ntl_tiltag_april.png", width = 18, height = 10, units = "cm", dpi = 300)


fall_2020 <- x %>% 
  filter(
    Date > as.Date("2020-07-31"),
    Date < as.Date("2021-02-01")
  ) 

max_values <- fall_2020 %>%
  group_by(Date) %>% 
  summarize(value = max(value)) %>% 
  semi_join(tiltag, by = "Date")

fall_2020 %>% 
  ggplot() +
  geom_line(data = subset(fall_2020, type ==  "daily"), aes(Date, value, color = variable), size = 0.2, alpha = 0.6) +
  geom_line(data = subset(fall_2020, type ==  "ra"), aes(Date, value, color = variable), size = 1.2) +
  geom_label_repel(data = subset(tiltag, Date > ymd("2020-07-31") & Date < ymd("2021-02-01")),
                   aes(Date, 0, label = tiltag),
                   color = "white", 
                   verbose = TRUE,
                   fill = "grey40", 
                   size = 2.5, 
                   ylim = c(0, NA), 
                   xlim = c(-Inf, Inf),
                   nudge_y = max_values$value  * 2 + 50,
                   direction = "y",
                   force_pull = 0, 
                   box.padding = 0.1, 
                   max.overlaps = Inf, 
                   segment.size = 0.32,
                   segment.color = "grey40"
  ) +
  scale_color_manual(name = "", labels = c("Nyindlæggelser", "Døde", "Smitteindeks"), values = c(admit_col, death_col, pct_col)) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 months") +
  scale_y_continuous(
    limits = c(0, 400),
    name = "Antal",
    sec.axis = sec_axis(~ . / 100, name = "Smitteindeks")
  ) +
  labs(y = "Antal", x = "Dato", title = "Epidemi-indikatorer og restriktioner (efterår 2020)", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI", subtitle = '<b style="color:#4393C3;">Nyindlæggelser</b>,  <b style="color:#777777;">døde</b>, og <b style="color:#E69F00;">smitteindeks</b> (PCR positive justeret for antal tests: positive / testede<sup>0.7</sup>)') +
  standard_theme +
  theme(
    plot.subtitle = element_markdown(),
    legend.position = "none"
  )

ggsave("../figures/ntl_tiltag_july.png", width = 18, height = 12, units = "cm", dpi = 300)



















# cols <- c("A" = alpha(pos_col, 0.6), "B" = alpha(pct_col, 0.6), "C" = alpha(admit_col, 0.6), "D" = alpha(death_col, 0.6))
# 
# x %>%
#   ggplot() +
#   geom_bar(stat = "identity", position = "stack", aes(Date, pct_confirmed * 100, fill = "B"), width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, NewPositive), fill = "white", width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, NewPositive, fill = "A"), width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Total), fill = "white", width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Total, fill = "C"), width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Antal_døde), fill = "white", width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Antal_døde, fill = "D"), width = 1) +
#   geom_line(aes(Date, running_avg_pos), size = 1, color = darken(pos_col, 0)) +
#   geom_line(aes(Date, running_avg_pct * 100), size = 1, color = darken(pct_col, 0)) +
#   geom_line(aes(Date, running_avg_admit), size = 1, color = darken(admit_col, 0)) +
#   geom_line(aes(Date, running_avg_deaths), size = 1, color = darken(death_col, 0)) +
#   geom_label_repel(
#     aes(Date, 0, label = tiltag),
#     color = "white",
#     fill = "grey40",
#     size = 2.5,
#     ylim = c(0, NA),
#     nudge_y = x$running_avg_pct * 400 + 100,
#     direction = "y",
#     force_pull = 0,
#     box.padding = 0.2,
#     max.overlaps = Inf,
#     segment.size = 0.32,
#     segment.color = "grey40"
#   ) +
#   scale_fill_manual(name = "", labels = c("Positive", "Positivprocent", "Nyindlæggelser", "Døde"), values = cols) +
#   scale_x_date(labels = my_date_labels, date_breaks = "1 months") +
#   scale_y_continuous(
#     limits = c(0, 1000),
#     name = "Antal",
#     sec.axis = sec_axis(~ . / 100, name = "Positivprocent", labels = function(x) paste0(x, " %")),
#   ) +
#   labs(y = "Antal", x = "Dato", title = "Epidemi-indikatorer og genåbning #1 (forår/sommer 2020)", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
#   standard_theme +
#   theme(
#     panel.grid.minor.x = element_blank(),
#     legend.text = element_text(size = 11),
#     legend.key.size = unit(0.4, "cm")
#   )
# 
# ggsave("../figures/ntl_tiltag_april.png", width = 18, height = 12, units = "cm", dpi = 300)
# 
# x <- plot_data %>%
#   full_join(tiltag, by = "Date") %>%
#   filter(
#     Date > as.Date("2020-03-01"),
#     Date < as.Date("2020-08-02")
#   )
# 
# 
# x %>%
#   ggplot() +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Total), fill = "white", width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Total, fill = "C"), width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Antal_døde), fill = "white", width = 1) +
#   geom_bar(stat = "identity", position = "stack", aes(Date, Antal_døde, fill = "D"), width = 1) +
#   geom_line(aes(Date, running_avg_admit), size = 1, color = darken(admit_col, 0)) +
#   geom_line(aes(Date, running_avg_deaths), size = 1, color = darken(death_col, 0)) +
#   geom_label_repel(
#     aes(Date, 0, label = tiltag),
#     color = "white",
#     fill = "grey40",
#     size = 2.5,
#     ylim = c(0, NA),
#     nudge_y = x$running_avg_admit * 2.5 + 25,
#     direction = "y",
#     force_pull = 0,
#     box.padding = 0.2,
#     max.overlaps = Inf,
#     segment.size = 0.32,
#     segment.color = "grey40"
#   ) +
#   scale_fill_manual(name = "", labels = c("Nyindlæggelser", "Døde"), values = cols[3:4]) +
#   scale_x_date(labels = my_date_labels, date_breaks = "1 months") +
#   scale_y_continuous(limits = c(0, 100)) +
#   labs(y = "Antal", x = "Dato", title = "Genåbning #1 (forår/sommer 2020)", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
#   standard_theme +
#   theme(
#     panel.grid.minor.x = element_blank(),
#     legend.text = element_text(size = 11),
#     legend.key.size = unit(0.4, "cm")
#   )
# 
# ggsave("../figures/ntl_tiltag_april_hosp_deaths.png", width = 18, height = 12, units = "cm", dpi = 300)

# tiltag relative plots ---------------------------------------------------

# index_plot <- function(dataframe, tiltag_df) {
#   df <- dataframe %>%
#     select(Date, running_avg_pos, running_avg_pct, running_avg_admit) %>%
#     mutate(day = Date - as.Date(tiltag_df$Date)) %>%
#     select(-Date) %>%
#     mutate(running_avg_pct = as.double(running_avg_pct),
#            running_avg_admit = as.double(running_avg_admit),
#            running_avg_pos = as.double(running_avg_pos)) %>%
#     mutate(pct_index = 100 * (running_avg_pct/running_avg_pct[which(day == 0)]),
#            admit_index = 100 * (running_avg_admit/running_avg_admit[which(day == 0)]),
#            pos_index = 100 * (running_avg_pos/running_avg_pos[which(day == 0)])) %>%
#     select(-running_avg_pct, -running_avg_pos, -running_avg_admit) %>%
#     filter(day > -15, day < 29) %>%
#     pivot_longer(-day, names_to = "variable", values_to = "value") %>%
#     mutate(tiltag = tiltag_df$tiltag, type = tiltag_df$type)
#   
#   return(df)
# }
# 
# df <- tests %>%
#   full_join(admitted, by = "Date")
# 
# plot_data <- index_plot(df, filter(tiltag, tiltag == "Masker i off. transport"))
# plot_data %<>% bind_rows(index_plot(df, filter(tiltag, tiltag == "Nedlukning 1")))
# plot_data %<>% bind_rows(index_plot(df, filter(tiltag, tiltag == "Masker + lukketid restauranter")))
# plot_data %<>% bind_rows(index_plot(df, filter(tiltag, tiltag == "Privat forsamling: 50")))
# plot_data %<>% bind_rows(index_plot(df, filter(tiltag, tiltag == "Masker alle off. steder")))
# 
# plot_data %<>% bind_rows(index_plot(df, filter(tiltag, tiltag == "Forsamling op til 100")))
# plot_data %<>% bind_rows(index_plot(df, filter(tiltag, tiltag == "Fase 3")))
# plot_data %<>% bind_rows(index_plot(df, filter(tiltag, tiltag == "Fase 2, del 2")))
# plot_data %<>% bind_rows(index_plot(df, filter(tiltag, tiltag == "Fase 2, del 1")))
# plot_data %<>% bind_rows(index_plot(df, filter(tiltag, tiltag == "Fase 1")))
# 
# baseplot <- function(data, text_positions) {
#   ggplot(data, aes(day, value)) +
#     geom_vline(xintercept = 0) +
#     geom_segment(aes(x = -14, y = 100, xend = 28, yend = 100)) +
#     geom_line(stat = "identity", position = "identity", size = 1.5, aes(color = tiltag)) +
#     coord_cartesian(xlim = c(-14, 28), # This focuses the x-axis on the range of interest
#                     clip = 'off') +
#     geom_text(data = text_positions,  size = 4, aes(x = 29, y = value, color = tiltag, label = str_wrap(tiltag, 25)), hjust = "outward", lineheight = 0.8) +
#     facet_wrap(~type, scales = "free") +
#     scale_color_discrete(guide = FALSE) +
#     scale_x_continuous(breaks = c(-14,-7,0,7,14,21,28), limits = c(-14, 44)) +
#     scale_y_continuous(trans = "log10", limits = c(12, 700)) + 
#     labs(y = "Procent af værdi da tiltaget trådte i kraft", x = "Dage", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI")
#   
# }
# 
# theme <- standard_theme + 
#   theme(strip.text = element_blank(),
#         axis.text.x = element_text(size = 12),
#         axis.text.y = element_text(size = 12),
#         axis.title.x = element_text(size = 12),
#         axis.title.y = element_text(size = 12),
#         plot.title = element_text(size = 16),
#         plot.margin = margin(1, 5, 1, 1, "cm"),
#         plot.caption = element_text(size = 10),
#         panel.spacing.x = unit(4, "cm"),
#         panel.grid.minor.y = element_blank(),
#         panel.grid.minor.x = element_blank())
# 
# subset_data <- plot_data %>% filter(variable == "pos_index")
# 
# max_day <- subset_data %>% 
#   filter(!is.na(value)) %>%
#   group_by(tiltag) %>%
#   mutate(max = day == max(day)) %>%
#   filter(max)
# 
# max_day$value[which(max_day$tiltag == "Fase 1")] <- 34
# max_day$value[which(max_day$tiltag == "Privat forsamling: 50")] <- 165
# max_day$value[which(max_day$tiltag == "Masker alle off. steder")] <- 122
# max_day$value[which(max_day$tiltag == "Masker + lukketid restauranter")] <- 92
# 
# baseplot(subset_data, max_day) +
#   labs(title = "Hvad sker der med antal positive efter et tiltag?") +
#   theme
# 
# ggsave("../figures/ntl_tiltag_pos.png", width = 30, height = 14, units = "cm", dpi = 300)
# 
# subset_data <- plot_data %>% filter(variable == "pct_index")
# 
# max_day <- subset_data %>% 
#   filter(!is.na(value)) %>%
#   group_by(tiltag) %>%
#   mutate(max = day == max(day)) %>%
#   filter(max)
# 
# max_day$value[which(max_day$tiltag == "Privat forsamling: 50")] <- 190
# 
# baseplot(subset_data, max_day) +
#   labs(title = "Hvad sker der med positivprocenten efter et tiltag?") +
#   theme
# 
# 
# ggsave("../figures/ntl_tiltag_pct.png", width = 30, height = 14, units = "cm", dpi = 300)
# 
# 
# subset_data <- plot_data %>% filter(variable == "admit_index")
# 
# max_day <- subset_data %>% 
#   filter(!is.na(value)) %>%
#   group_by(tiltag) %>%
#   mutate(max = day == max(day)) %>%
#   filter(max)
# 
# max_day$value[which(max_day$tiltag == "Privat forsamling: 50")] <- 140
# max_day$value[which(max_day$tiltag == "Masker + lukketid restauranter")] <- 107
# max_day$value[which(max_day$tiltag == "Fase 3")] <- 53
# max_day$value[which(max_day$tiltag == "Masker alle off. steder")] <- 82
# 
# 
# baseplot(subset_data, max_day) +
#   labs(title = "Hvad sker der med nyindlæggelser efter et tiltag?") +
#   theme
# 
# ggsave("../figures/ntl_tiltag_admitted.png", width = 30, height = 14, units = "cm", dpi = 300)