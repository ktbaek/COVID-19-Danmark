
ra_lwd <- 3
seg_lwd <- 1.5
cex_labels <- 1.4
cex_axis <- 1.4

max_pos <- ceiling(max(tests$NewPositive) / 100) * 100
max_test <- ceiling(max(tests$Tested) / 5000) * 5000
max_admit <- ceiling(max(admitted$Total) / 20) * 20
max_pct <- ceiling(max(tests_from_may$pct_confirmed, na.rm = TRUE) * 5) / 5

plot_data <-
  tests %>%
  full_join(admitted, by = "Date") %>%
  full_join(deaths, by = "Date") %>%
  filter(Date > as.Date("2020-02-14"))

# Pos ------------------------------------------------------------------

png("../figures/ntl_pos.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Dagligt antal nye positivt testede",
  max_y_value = max_pos,
  x_by = "2 months",
  y_label_dist = 4
)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = pretty(0:max_pos), labels = pretty(0:max_pos))

points(plot_data$Date, plot_data$NewPositive, type = "b", pch = 19, col = alpha(pos_col, alpha = 0.3), cex = 1.2)
points(plot_data$Date, plot_data$running_avg_pos, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)



dev.off()


# Tests ------------------------------------------------------------------

png("../figures/ntl_tests.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Dagligt antal testede",
  max_y_value = max_test,
  x_by = "2 months",
  y_label_dist = 5
)

points(plot_data$Date, plot_data$Tested, type = "b", pch = 19, col = alpha(test_col, alpha = 0.3), cex = 1.2)
points(plot_data$Date, plot_data$NewPositive, type = "b", pch = 19, col = alpha(pos_col, alpha = 0.3), cex = 1.2)
points(plot_data$Date, plot_data$running_avg_pos, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)
points(plot_data$Date, plot_data$running_avg_total, type = "l", pch = 19, col = test_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-11-28"), y = 96000, labels = "Antal testede", col = test_col, cex = cex_labels, font = 2, pos = 2)
text(x = as.Date("2020-10-25"), y = 6000, labels = "Antal positive", col = pos_col, cex = cex_labels, font = 2, pos = 2)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_test, by = 20000), labels = format(seq(0, max_test, by = 20000), scientific = FALSE ))

dev.off()


# Pos% maj ------------------------------------------------------------------

png("../figures/ntl_pct_2.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Daglig procent positivt testede",
  y_label_dist = 4,
  y_label = "Procent",
  max_y_value = max_pct,
  x_by = "2 months",
  start_date = "2020-05-01"
)

points(tests_from_may$Date, tests_from_may$pct_confirmed, type = "b", pch = 19, col = alpha(pct_col, alpha = 0.3), cex = 1.2)
points(plot_data$Date, plot_data$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_pct, by = 0.5), labels = seq(0, max_pct, by = 0.5))

dev.off()

# Pos% ------------------------------------------------------------------

png("../figures/ntl_pct_1.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Daglig procent positivt testede",
  max_y_value = 40,
  y_label_dist = 4,
  x_by = "2 months",
  y_label = "Procent"
)

points(plot_data$Date, plot_data$pct_confirmed, type = "b", pch = 19, col = alpha(pct_col, alpha = 0.3), cex = 1.2)
points(plot_data$Date, plot_data$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, 40, by = 10), labels = seq(0, 40, by = 10))


dev.off()

# Pos vs pos% ------------------------------------------------------------------

png("../figures/ntl_pos_pct.png", width = 22, height = 16, units = "cm", res = 300)

double_plot(
  title = "Procent vs. antal nye positivt testede",
  y_label = "Antal",
  y2_label = "Procent",
  y_label_dist = 4,
  max_y_value = max_pos,
  x_by = "1 month",
  start_date = "2020-05-01"
)

points(tests_from_may$Date, tests_from_may$NewPositive, type = "b", pch = 19, col = alpha(pos_col, alpha = 0.3), cex = 1.2)
points(tests_from_may$Date, tests_from_may$running_avg_pos, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = pretty(0:max_pos), labels = pretty(0:max_pos))
text(x = as.Date("2020-09-08"), y = 100, labels = "Antal positive", col = pos_col, cex = cex_labels, font = 2, pos = 4)

par(new = TRUE)

plot(NULL,
  type = "n",
  ylab = "",
  xlab = "",
  axes = FALSE,
  ylim = c(0, max_pct),
  xlim = c(as.Date("2020-05-01"), as.Date(today) - 1),
)

points(tests_from_may$Date, tests_from_may$pct_confirmed, type = "b", pch = 19, col = alpha(pct_col, alpha = 0.3), cex = 1.2)
points(tests_from_may$Date, tests_from_may$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-05-25"), y = max_pct/3, labels = "Procent positive", col = pct_col, cex = cex_labels, font = 2, pos = 4)


axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

dev.off()


# Nyindlagte ------------------------------------------------------------------

png("../figures/ntl_hosp.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Dagligt antal nyindlagte med positiv test",
  y_label_dist = 4,
  max_y_value = max_admit,
  x_by = "2 months",
  start_date = "2020-02-15"
)

# points(plot_data$Date, plot_data$Antal_døde, type = "b", pch = 19, cex = 1.2, col = alpha(death_col, alpha = 0.3))
points(plot_data$Date, plot_data$Total, type = "b", pch = 19, cex = 1.2, col = alpha(admit_col, alpha = 0.3))
points(plot_data$Date, plot_data$running_avg_admit, type = "l", pch = 19, col = admit_col, cex = 1.2, lwd = ra_lwd)
# points(plot_data$Date, plot_data$running_avg_deaths, type = "l", pch = 19, col = death_col, cex = 1.2, lwd = ra_lwd)

# text(x = as.Date("2020-04-06"), y = 65, labels = "Nyindlagte", col = admit_col, cex = cex_labels, font = 2, pos = 4)
# text(x = as.Date("2020-04-09"), y = 2, labels = "Døde", col = death_col, cex = cex_labels, font = 2)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_admit, by = 20), labels = seq(0, max_admit, by = 20))

dev.off()


# Døde ------------------------------------------------------------------

png("../figures/ntl_deaths.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Dagligt antal døde",
  y_label_dist = 4,
  max_y_value = 25,
  x_by = "2 months",
  start_date = "2020-02-15"
)

points(plot_data$Date, plot_data$Antal_døde, type = "b", pch = 19, cex = 1.2, col = alpha(death_col, alpha = 0.3))
# points(plot_data$Date, plot_data$Total, type = "b", pch = 19, cex = 1.2, col = alpha(admit_col, alpha = 0.3))
# points(plot_data$Date, plot_data$running_avg_admit, type = "l", pch = 19, col = admit_col, cex = 1.2, lwd = ra_lwd)
points(plot_data$Date, plot_data$running_avg_deaths, type = "l", pch = 19, col = death_col, cex = 1.2, lwd = ra_lwd)

# text(x = as.Date("2020-04-06"), y = 65, labels = "Nyindlagte", col = admit_col, cex = cex_labels, font = 2, pos = 4)
# text(x = as.Date("2020-04-09"), y = 2, labels = "Døde", col = death_col, cex = cex_labels, font = 2)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, 25, by = 5), labels = seq(0, 25, by = 5))

dev.off()


# Pos, test, pct combined ------------------------------------------------------------------

png("../figures/ntl_pos_tests_pct.png", width = 22, height = 16, units = "cm", res = 300)

double_plot(
  title = "Testede, positive og procent positive",
  y_label = "Antal testede, positive",
  y2_label = "Procent",
  y_label_dist = 5.8,
  max_y_value = max_test,
  x_by = "2 months",
  start_date = "2020-02-15"
)

segments(plot_data$Date, 0, plot_data$Date, plot_data$Tested, lwd = seg_lwd, col = alpha(test_col, 0.6), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$NewPositive, lwd = seg_lwd, col = pos_col, lend = 1)

text(x = as.Date("2020-03-15"), y = 77000, labels = "Procent positive", col = pct_col, cex = cex_labels, font = 2, pos = 4)
text(x = as.Date("2020-11-20"), y = 90000, labels = "Antal testede", col = alpha(test_col, 0.9), cex = 1.4, font = 2, pos = 2)
text(x = as.Date("2020-03-12"), y = 9200, labels = "Antal positive", col = pos_col, cex = cex_labels * 0.9, font = 2)
arrows(as.Date("2020-03-10"), 6300, as.Date("2020-03-10"), 1500, lwd = 1, col = pos_col, lend = 1, length = 0.1)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_test, by = 20000), labels = format(seq(0, max_test, by = 20000), scientific = FALSE ))

par(new = TRUE)

plot(NULL,
  type = "n",
  ylab = "",
  xlab = "",
  axes = FALSE,
  ylim = c(0, 19),
  xlim = c(as.Date("2020-02-15"), as.Date(today) - 1),
)

points(plot_data$Date, replace(plot_data$running_avg_pct, 1:17, NA), type = "l", pch = 19, lwd = 5, col = "white")
points(plot_data$Date, replace(plot_data$running_avg_pct, 1:17, NA), type = "l", pch = 19, lwd = 3, col = pct_col)

axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = c(0, 5, 10, 15), labels = c("0 %", "5 %", "10 %", "15 %"))

dev.off()







# -------------------------------------------------------------------------


# Rt cases pos ------------------------------------------------------------------

png("../figures/ntl_rt_cases_pos.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(rt_cases$date_sample, rt_cases$estimate,
  type = "l",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = cex_axis,
  ylim = c(0, 2),
  las = 1,
  col = "darkgray",
  lwd = 2,
  xlim = c(as.Date("2020-05-01"), as.Date(today) - 1)
)

mtext(
  text = "Kontakttal (smittede) vs. antal nye positive",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Kontakttal-værdi",
  side = 2, # side 1 = bottom
  line = 3,
  cex = cex_labels,
  font = 2
)

points(tests$Date, tests$NewPositive / (max_pos / 2), type = "b", pch = 19, col = alpha(pos_col, 0.3), cex = 1.2)
points(tests$Date, tests$running_avg_pos / (max_pos / 2), type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-06-15"), y = 0.4, labels = "Antal positivt testede", col = pos_col, cex = cex_labels, font = 2)
text(x = as.Date("2020-07-10"), y = 1.4, labels = "Kontakttal: smittede", col = "darkgray", cex = cex_labels, font = 2, adj = 1)
abline(h = 1, col = "gray")


dev.off()


# Rt cases pct ------------------------------------------------------------

png("../figures/ntl_rt_cases_pct.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(rt_cases$date_sample, rt_cases$estimate,
  type = "l",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = cex_axis,
  ylim = c(0, 2),
  las = 1,
  col = "darkgray",
  lwd = 2,
  xlim = c(as.Date("2020-05-01"), as.Date(today) - 1)
)

mtext(
  text = "Kontakttal (smittede) vs. procent positive",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = cex_labels,
  font = 2
)


# axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

points(tests$Date, tests$pct_confirmed, type = "b", pch = 19, col = alpha(pct_col, 0.3), cex = 1.2)
points(tests$Date, tests$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)
# points(tests$Date, tests$NewPositive/100, type = "b", pch = 19, col = rgb(red = 1, green = 0, blue = 0, alpha = 0.2), cex = 1.2)
# points(tests$Date, tests$running_avg_pos/100, type = "l", pch = 19, col = "red", cex = 1.2, lwd = 2)
text(x = as.Date("2020-08-20"), y = 0.02, labels = "Procent positivt testede", col = pct_col, cex = cex_labels, font = 2)
text(x = as.Date("2020-07-10"), y = 1.4, labels = "Kontakttal: smittede", col = "darkgray", cex = cex_labels, font = 2, adj = 1)
abline(h = 1, col = "gray")


dev.off()


# Rt admitted -------------------------------------------------------------


png("../figures/ntl_rt_admitted.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(rt_admitted$date_sample, rt_admitted$estimate,
  type = "l",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = cex_axis,
  ylim = c(0, 2),
  las = 1,
  col = "darkgray",
  lwd = 2,
  xlim = c(as.Date("2020-05-01"), as.Date(today) - 1)
)

mtext(
  text = "Kontakttal (indlagte) vs. nyindlagte",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = cex_labels,
  font = 2
)

points(admitted$Date, admitted$Total / 24, type = "b", pch = 19, col = alpha(admit_col, 0.3), cex = 1.2)
points(admitted$Date, admitted$running_avg_admit / 24, type = "l", pch = 19, col = admit_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-05-15"), y = 0.01, labels = "Nyindlagte", col = admit_col, cex = cex_labels, font = 2)
text(x = as.Date("2020-07-10"), y = 1.5, labels = "Kontakttal: indlagte", col = "darkgray", cex = cex_labels, font = 2, adj = 1)
abline(h = 1, col = "gray")


dev.off()






# -------------------------------------------------------------------------


# positive admitted barplot -----------------------------------------------


# png("../figures/ntl_postest_admitted_barplot.png", width = 20, height = 16, units = "cm", res = 300)
# par(family = "lato", mar = c(5, 8, 5, 2))
# 
# plot(0,
#   type = "n",
#   ylab = "",
#   xlab = "",
#   axes = FALSE,
#   cex = 1.2,
#   cex.axis = cex_axis,
#   ylim = c(-100, max_pos + 100),
#   xlim = c(as.Date("2020-02-15"), as.Date(today) - 1)
# )
# 
# mtext(
#   text = "Nye positivt testede vs. nyindlagte med positiv test",
#   side = 3, # side 1 = bottom
#   line = 1,
#   cex = 1.5,
#   font = 2
# )
# 
# mtext(
#   text = "Dato",
#   side = 1, # side 1 = bottom
#   line = 3,
#   cex = cex_labels,
#   font = 2
# )
# 
# mtext(
#   text = "Antal",
#   side = 2, # side 1 = bottom
#   line = 4,
#   cex = cex_labels,
#   font = 2
# )
# 
# box(which = "plot", lty = "solid")
# 
# axis(1, c(
#   as.Date("2020-03-01"),
#   as.Date("2020-05-01"),
#   as.Date("2020-07-01"),
#   as.Date("2020-09-01")
# ), format(c(
#   as.Date("2020-03-01"),
#   as.Date("2020-05-01"),
#   as.Date("2020-07-01"),
#   as.Date("2020-09-01")
# ), "%b"), cex.axis = cex_axis)
# axis(2, at = seq(-100, max_pos + 100, by = 100), label = c(100, seq(0, max_pos + 100, by = 100)), cex.axis = cex_axis, las = 1)
# 
# 
# segments(tests$Date, 0, tests$Date, tests$NewPositive, lwd = 2, col = pos_col, lend = 1)
# segments(admitted$Date, 0, admitted$Date, -admitted$Total, lwd = 2, col = admit_col, lend = 1)
# 
# text(x = as.Date(today) - 2, y = -70, labels = "Nyindlagte", col = admit_col, cex = cex_labels, font = 2, adj = 1)
# text(x = as.Date(today) - 2, y = max_pos + 30, labels = "Positivt testede", col = pos_col, cex = cex_labels, font = 2, adj = 1)
# 
# dev.off()
# 

# positive admitted barplot 2 ------------------------------------------------------------------

png("../figures/ntl_postest_admitted_barplot_2.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Antal positivt testede vs. nyindlagte",
  y_label_dist = 4,
  max_y_value = max_pos,
  x_by = "2 months",
)

segments(plot_data$Date, 0, plot_data$Date, plot_data$NewPositive, lwd = seg_lwd, col = alpha(pos_col, 0.5), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total, lwd = seg_lwd, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total, lwd = seg_lwd, col = alpha(admit_col, 0.7), lend = 1)

points(plot_data$Date, plot_data$running_avg_pos,
  type = "l",
  pch = 19,
  lwd = 3,
  col = pos_col
)

points(plot_data$Date, plot_data$running_avg_admit,
  type = "l",
  pch = 19,
  lwd = 3,
  col = admit_col
)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = pretty(0:max_pos), labels = pretty(0:max_pos))

legend("topleft",
  inset = 0.04,
  legend = c("Positivt testede", "Nyindlagte"),
  col = c(pos_col, admit_col),
  lty = 1,
  cex = 1.2,
  box.lty = 0,
  lwd = 4
)

dev.off()




# Pct admitted barplot ----------------------------------------------------


# png("../figures/ntl_pct_admitted_barplot.png", width = 20, height = 16, units = "cm", res = 300)
# par(family = "lato", mar = c(5, 8, 5, 2))
# 
# plot(0,
#   type = "n",
#   ylab = "",
#   xlab = "",
#   axes = FALSE,
#   cex = 1.2,
#   cex.axis = cex_axis,
#   ylim = c(-100, 200),
#   xlim = c(as.Date("2020-02-15"), as.Date(today) - 1)
# )
# 
# mtext(
#   text = "Procent positivt testede vs. nyindlagte med positiv test",
#   side = 3, # side 1 = bottom
#   line = 1,
#   cex = 1.5,
#   font = 2
# )
# 
# mtext(
#   text = "Dato",
#   side = 1, # side 1 = bottom
#   line = 3,
#   cex = cex_labels,
#   font = 2
# )
# 
# mtext(
#   text = "Antal                            Procent            ",
#   side = 2, # side 1 = bottom
#   line = 4,
#   cex = cex_labels,
#   font = 2
# )
# 
# axis(1, c(
#   as.Date("2020-03-01"),
#   as.Date("2020-05-01"),
#   as.Date("2020-07-01"),
#   as.Date("2020-09-01")
# ), format(c(
#   as.Date("2020-03-01"),
#   as.Date("2020-05-01"),
#   as.Date("2020-07-01"),
#   as.Date("2020-09-01")
# ), "%b"), cex.axis = cex_axis)
# axis(2, at = c(-100, 0, 100, 200, 300, 400, 500), label = c(100, 0, "10 %", "20 %", 300, 400, 500), cex.axis = cex_axis, las = 1)
# 
# 
# segments(tests$Date, 0, tests$Date, tests$pct_confirmed * 10, lwd = 2, col = pct_col, lend = 1)
# segments(admitted$Date, 0, admitted$Date, -admitted$Total, lwd = 2, col = admit_col, lend = 1)
# 
# text(x = as.Date(today) - 2, y = -70, labels = "Nyindlagte", col = admit_col, cex = cex_labels, font = 2, adj = 1)
# text(x = as.Date(today) - 2, y = 70, labels = "Procent positivt testede", col = pct_col, cex = cex_labels, font = 2, adj = 1)
# 
# box(which = "plot", lty = "solid")
# 
# dev.off()

# pct admitted barplot 2 ------------------------------------------------------------------

png("../figures/ntl_pct_admitted_barplot_2.png", width = 22, height = 16, units = "cm", res = 300)

double_plot(
  title = "Procent positivt testede vs. nyindlagte",
  y_label = "Positivprocent",
  y2_label = "Antal nyindlagte",
  y_label_dist = 5,
  max_y_value = 20,
  x_by = "2 months",
  start_date = "2020-02-15"
)

segments(plot_data$Date, 0, plot_data$Date, plot_data$pct_confirmed, lwd = seg_lwd, col = alpha(pct_col, 0.5), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total / 15, lwd = seg_lwd, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total / 15, lwd = seg_lwd, col = alpha(admit_col, 0.7), lend = 1)

points(plot_data$Date, plot_data$running_avg_pct,
  type = "l",
  pch = 19,
  lwd = 3,
  col = pct_col
)

points(plot_data$Date, plot_data$running_avg_admit / 15,
  type = "l",
  pch = 19,
  lwd = 3,
  col = admit_col
)

legend("topright",
  inset = 0.04,
  legend = c("Positivprocent", "Nyindlagte"),
  col = c(pct_col, admit_col),
  lty = 1,
  cex = 1.2,
  box.lty = 0,
  lwd = 4
)

axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 6.7, 13.3, 20), labels = c(0, 100, 200, 300))
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 5, 10, 15, 20), labels = c(0, "5 %", "10 %", "15 %", "20 %"))


dev.off()


# -------------------------------------------------------------------------


# positive deaths barplot -----------------------------------------------


# png("../figures/ntl_postest_deaths_barplot.png", width = 20, height = 16, units = "cm", res = 300)
# par(family = "lato", mar = c(5, 8, 5, 2))
# 
# plot(0,
#   type = "n",
#   ylab = "",
#   xlab = "",
#   axes = FALSE,
#   cex = 1.2,
#   cex.axis = cex_axis,
#   ylim = c(-100, max_pos + 100),
#   xlim = c(as.Date("2020-02-15"), as.Date(today) - 1)
# )
# 
# mtext(
#   text = "Antal positivt testede vs. døde",
#   side = 3, # side 1 = bottom
#   line = 1,
#   cex = 1.5,
#   font = 2
# )
# 
# mtext(
#   text = "Dato",
#   side = 1, # side 1 = bottom
#   line = 3,
#   cex = cex_labels,
#   font = 2
# )
# 
# mtext(
#   text = "Antal",
#   side = 2, # side 1 = bottom
#   line = 4,
#   cex = cex_labels,
#   font = 2
# )
# 
# box(which = "plot", lty = "solid")
# 
# axis(1, c(
#   as.Date("2020-03-01"),
#   as.Date("2020-05-01"),
#   as.Date("2020-07-01"),
#   as.Date("2020-09-01")
# ), format(c(
#   as.Date("2020-03-01"),
#   as.Date("2020-05-01"),
#   as.Date("2020-07-01"),
#   as.Date("2020-09-01")
# ), "%b"), cex.axis = cex_axis)
# axis(2, at = seq(-100, max_pos + 100, by = 100), label = c(100, seq(0, max_pos + 100, by = 100)), cex.axis = cex_axis, las = 1)
# 
# 
# segments(tests$Date, 0, tests$Date, tests$NewPositive, lwd = 2, col = pos_col, lend = 1)
# segments(deaths$Date, 0, deaths$Date, -deaths$Antal_døde, lwd = 2, col = death_col, lend = 1)
# 
# text(x = as.Date(today) - 2, y = -70, labels = "Døde", col = death_col, cex = cex_labels, font = 2, adj = 1)
# text(x = as.Date(today) - 2, y = max_pos + 30, labels = "Positivt testede", col = pos_col, cex = cex_labels, font = 2, adj = 1)
# 
# dev.off()



# positive deaths barplot 2 ------------------------------------------------------------------

png("../figures/ntl_postest_deaths_barplot_2.png", width = 22, height = 16, units = "cm", res = 300)

double_plot(
  title = "Antal positivt testede vs. døde",
  y_label = "Antal positivt testede",
  y2_label = "Antal døde",
  y_label_dist = 5,
  max_y_value = max_pos,
  x_by = "2 months",
  start_date = "2020-02-15"
)

segments(plot_data$Date, 0, plot_data$Date, plot_data$NewPositive, lwd = seg_lwd, col = alpha(pos_col, 0.5), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde * 10, lwd = seg_lwd, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde * 10, lwd = seg_lwd, col = alpha(death_col, 0.7), lend = 1)

points(plot_data$Date, plot_data$running_avg_pos,
  type = "l",
  pch = 19,
  lwd = 3,
  col = pos_col
)

points(plot_data$Date, plot_data$running_avg_deaths * 10,
  type = "l",
  pch = 19,
  lwd = 3,
  col = darken(death_col, 0.4)
)



axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = pretty(0:max_pos), labels = pretty(0:max_pos)/10)
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = pretty(0:max_pos), labels = pretty(0:max_pos))


legend("topleft",
  inset = 0.04,
  legend = c("Positivt testede", "Døde"),
  col = c(pos_col, darken(death_col, 0.4)),
  lty = 1,
  cex = 1.2,
  box.lty = 0,
  lwd = 4
)


dev.off()



# Pct deaths barplot ----------------------------------------------------


# png("../figures/ntl_pct_deaths_barplot.png", width = 20, height = 16, units = "cm", res = 300)
# par(family = "lato", mar = c(5, 8, 5, 2))
# 
# plot(0,
#   type = "n",
#   ylab = "",
#   xlab = "",
#   axes = FALSE,
#   cex = 1.2,
#   cex.axis = cex_axis,
#   ylim = c(-25, 100),
#   xlim = c(as.Date("2020-02-15"), as.Date(today) - 1)
# )
# 
# mtext(
#   text = "Procent positivt testede vs. døde",
#   side = 3, # side 1 = bottom
#   line = 1,
#   cex = 1.5,
#   font = 2
# )
# 
# mtext(
#   text = "Dato",
#   side = 1, # side 1 = bottom
#   line = 3,
#   cex = cex_labels,
#   font = 2
# )
# 
# mtext(
#   text = "Antal                             Procent                        ",
#   side = 2, # side 1 = bottom
#   line = 4,
#   cex = cex_labels,
#   font = 2
# )
# 
# axis(1, c(
#   as.Date("2020-03-01"),
#   as.Date("2020-05-01"),
#   as.Date("2020-07-01"),
#   as.Date("2020-09-01")
# ), format(c(
#   as.Date("2020-03-01"),
#   as.Date("2020-05-01"),
#   as.Date("2020-07-01"),
#   as.Date("2020-09-01")
# ), "%b"), cex.axis = cex_axis)
# axis(2, at = c(-25, 0, 50, 100), label = c(25, 0, "10 %", "20 %"), cex.axis = cex_axis, las = 1)
# 
# 
# segments(tests$Date, 0, tests$Date, tests$pct_confirmed * 5, lwd = 2, col = pct_col, lend = 1)
# segments(deaths$Date, 0, deaths$Date, -deaths$Antal_døde, lwd = 2, col = death_col, lend = 1)
# 
# text(x = as.Date(today) - 2, y = -18, labels = "Døde", col = death_col, cex = cex_labels, font = 2, adj = 1)
# text(x = as.Date(today) - 2, y = 20, labels = "Procent positivt testede", col = pct_col, cex = cex_labels, font = 2, adj = 1)
# 
# box(which = "plot", lty = "solid")
# 
# dev.off()
# 



# pct deaths barplot 2 ------------------------------------------------------------------

png("../figures/ntl_pct_deaths_barplot_2.png", width = 22, height = 16, units = "cm", res = 300)

double_plot(
  title = "Procent positivt testede vs. døde",
  y_label = "Positivprocent",
  y2_label = "Antal døde",
  y_label_dist = 5,
  max_y_value = 20,
  x_by = "2 months",
  start_date = "2020-02-15"
)

segments(plot_data$Date, 0, plot_data$Date, plot_data$pct_confirmed, lwd = seg_lwd, col = alpha(pct_col, 0.5), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde / 5, lwd = seg_lwd, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde / 5, lwd = seg_lwd, col = alpha(death_col, 0.7), lend = 1)

points(plot_data$Date, plot_data$running_avg_pct,
  type = "l",
  pch = 19,
  lwd = 3,
  col = pct_col
)

points(plot_data$Date, plot_data$running_avg_deaths / 5,
  type = "l",
  pch = 19,
  lwd = 3,
  col = darken(death_col, 0.4)
)

legend("topright",
  inset = 0.04,
  legend = c("Positivprocent", "Døde"),
  col = c(pct_col, darken(death_col, 0.4)),
  lty = 1,
  cex = 1.2,
  box.lty = 0,
  lwd = 4
)


axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 5, 10, 15, 20), labels = c(0, 25, 50, 75, 100))
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 5, 10, 15, 20), labels = c(0, "5 %", "10 %", "15 %", "20 %"))


dev.off()



# Twitter card ------------------------------------------------------------------

png("../figures/twitter_card.png", width = 15, height = 8, units = "cm", res = 300)
par(family = "lato", mar = c(2, 2, 2, 2))

plot(0,
  type = "n",
  ylab = "",
  xlab = "",
  axes = FALSE,
  cex = 1.2,
  cex.axis = cex_axis,
  ylim = c(0, 600),
  xlim = c(as.Date("2020-02-15"), as.Date(today) - 1),
)



segments(tests$Date, 0, tests$Date, tests$NewPositive, lwd = 1, col = alpha(pos_col, 0.5), lend = 1)
segments(admitted$Date, 0, admitted$Date, admitted$Total, lwd = 1, col = "white", lend = 1)
segments(admitted$Date, 0, admitted$Date, admitted$Total, lwd = 1, col = alpha(admit_col, 0.7), lend = 1)

points(tests$Date, replace(tests$running_avg_pos, 1:25, NA),
  type = "l",
  pch = 19,
  lwd = 3,
  col = pos_col
)

points(admitted$Date, admitted$running_avg_admit,
  type = "l",
  pch = 19,
  lwd = 3,
  col = admit_col
)


dev.off()



# -------------------------------------------------------------------------

# tiltag plot fra juli -------------------------------------------------------------


png("../figures/ntl_tiltag_july.png", width = 22, height = 16, units = "cm", res = 300)

double_plot(
  title = "Epidemi-indikatorer og politiske tiltag",
  y_label = "Antal",
  y2_label = "Positivprocent",
  y_label_dist = 5,
  max_y_value = max_pos + 100,
  x_by = "1 month",
  start_date = "2020-07-01"
)

segments(plot_data$Date, 0, plot_data$Date, plot_data$NewPositive, lwd = 3, col = alpha(pos_col, 0.5), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$pct_confirmed * 100, lwd = 3, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$pct_confirmed * 100, lwd = 3, alpha(pct_col, 0.7), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total, lwd = 3, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total, lwd = 3, col = alpha(admit_col, 0.7), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde, lwd = 3, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde, lwd = 3, col = alpha(death_col, 0.7), lend = 1)

points(plot_data$Date, replace(plot_data$running_avg_pos, 1:25, NA),
  type = "l",
  pch = 19,
  lwd = 3,
  col = pos_col
)

points(plot_data$Date, plot_data$running_avg_deaths,
  type = "l",
  pch = 19,
  lwd = 3,
  col = darken(death_col, 0.4)
)

points(plot_data$Date, plot_data$running_avg_admit,
  type = "l",
  pch = 19,
  lwd = 3,
  col = admit_col
)

points(plot_data$Date, plot_data$running_avg_pct * 100,
  type = "l",
  pch = 19,
  lwd = 3,
  col = pct_col
)


axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_pos + 100, by = 500), labels = paste0(seq(0, max_pos + 100, by = 500) / 100, " %"))
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_pos + 100, by = 500), labels = seq(0, max_pos + 100, by = 500))

y <- 60
arrows(as.Date("2020-07-07"), y + max_pos/14, as.Date("2020-07-07"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-07-08"), y + max_pos/16, "Forsamling: 100", cex = 0.9, adj = 0)

y <- 170
arrows(as.Date("2020-08-14"), y + max_pos/12, as.Date("2020-08-14"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-08-13"), y + max_pos/14, "Lukketid udvides", cex = 0.9, adj = 1)

y <- 140
arrows(as.Date("2020-08-22"), y + max_pos/6, as.Date("2020-08-22"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-08-21"), y + max_pos/7, "Masker i off. transport", cex = 0.9, adj = 1)

#y <- 400
#arrows(as.Date("2020-09-09"), y + max_pos/7, as.Date("2020-09-09"), y, lwd = 1, lend = 1, length = 0.1)
#text(as.Date("2020-09-08"), y + max_pos/8, "Restriktioner natteliv, Kbh/Odense", cex = 0.9, adj = 1)

y <- 600
arrows(as.Date("2020-09-18"), y + max_pos/7, as.Date("2020-09-18"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-09-17"), y + max_pos/10, "Restriktioner\nrestauranter mv.", cex = 0.9, adj = 1)

y <- 680
arrows(as.Date("2020-09-26"), y + max_pos/5, as.Date("2020-09-26"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-09-25"), y + max_pos/6, "Restriktioner\nprivate fester", cex = 0.9, adj = 1)

y <- 1230
arrows(as.Date("2020-10-29"), y + max_pos/7, as.Date("2020-10-29"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-10-28"), y + max_pos/10, "Masker alle off. steder,\nforsamling 10 mv.", cex = 0.9, adj = 1)






legend("topleft",
  inset = 0.04,
  legend = c("Positivt testede", "Positivprocent", "Nyindlagte", "Døde"),
  col = c(pos_col, pct_col, admit_col, darken(death_col, 0.4)),
  lty = 1,
  cex = 1.2,
  box.lty = 0,
  lwd = 4
)


dev.off()



# tiltag plot fra april -------------------------------------------------------------


png("../figures/ntl_tiltag_april.png", width = 22, height = 16, units = "cm", res = 300)

par(lheight = 0.9)

double_plot(
  title = "Epidemi-indikatorer og genåbningsfaser",
  y_label = "Antal",
  y2_label = "Positivprocent",
  y_label_dist = 5,
  max_y_value = 600,
  x_by = "1 month",
  start_date = "2020-04-01",
  end_date = "2020-08-02"
)


segments(plot_data$Date, 0, plot_data$Date, plot_data$NewPositive, lwd = 3.7, col = alpha(pos_col, 0.5), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$pct_confirmed * 40, lwd = 3.7, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$pct_confirmed * 40, lwd = 3.7, alpha(pct_col, 0.7), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total, lwd = 3.7, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total, lwd = 3.7, col = alpha(admit_col, 0.7), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde, lwd = 3.7, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde, lwd = 3.7, col = alpha(death_col, 0.7), lend = 1)

points(plot_data$Date, replace(plot_data$running_avg_pos, 1:25, NA),
  type = "l",
  pch = 19,
  lwd = 3,
  col = pos_col
)

points(plot_data$Date, plot_data$running_avg_deaths,
  type = "l",
  pch = 19,
  lwd = 3,
  col = darken(death_col, 0.4)
)

points(plot_data$Date, plot_data$running_avg_admit,
  type = "l",
  pch = 19,
  lwd = 3,
  col = admit_col
)

points(plot_data$Date, plot_data$running_avg_pct * 40,
  type = "l",
  pch = 19,
  lwd = 3,
  col = pct_col
)



axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, 600, by = 200), labels = paste0(seq(0, 600, by = 200) / 40, " %"))
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, 600, by = 100), labels = seq(0, 600, by = 100))

arrows(as.Date("2020-04-15"), 420, as.Date("2020-04-15"), 320, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-04-16"), 400, "Små klasser,\nliberale erhverv", cex = 0.9, adj = 0)

arrows(as.Date("2020-05-07"), 250, as.Date("2020-05-07"), 150, lwd = 1, lend = 1, length = 0.1)
arrows(as.Date("2020-05-11"), 170, as.Date("2020-05-11"), 150, lwd = 1, lend = 1, length = 0.1)
arrows(as.Date("2020-05-18"), 170, as.Date("2020-05-18"), 150, lwd = 1, lend = 1, length = 0.1)
arrows(as.Date("2020-05-21"), 170, as.Date("2020-05-21"), 150, lwd = 1, lend = 1, length = 0.1)
arrows(as.Date("2020-05-27"), 170, as.Date("2020-05-27"), 150, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-05-08"), 217, "Store klasser, gymnasier,\ndetailhandel, kultur,\nidræt, restauranter", cex = 0.9, adj = 0)

arrows(as.Date("2020-06-08"), 160, as.Date("2020-06-08"), 60, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-06-09"), 127, "Forsamling: 50,\nsvømmehaller,\nfitness", cex = 0.9, adj = 0)

arrows(as.Date("2020-07-07"), 160, as.Date("2020-07-07"), 60, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-07-08"), 150, "Forsamling: 100", cex = 0.9, adj = 0)


legend("topright",
  inset = 0.04,
  legend = c("Positivt testede", "Positivprocent", "Nyindlagte", "Døde"),
  col = c(pos_col, pct_col, admit_col, darken(death_col, 0.4)),
  lty = 1,
  cex = 1.2,
  box.lty = 0,
  lwd = 4
)


dev.off()

# tiltag relative plots ---------------------------------------------------

index_plot <- function(dataframe, name, date, type) {
  df <- dataframe %>%
    select(Date, running_avg_pos, running_avg_pct, running_avg_admit) %>%
    mutate(day = Date - as.Date(date)) %>%
    select(-Date) %>%
    mutate(running_avg_pct = as.double(running_avg_pct),
           running_avg_admit = as.double(running_avg_admit),
           running_avg_pos = as.double(running_avg_pos)) %>%
    mutate(pct_index = 100 * (running_avg_pct/running_avg_pct[which(day == 0)]),
           admit_index = 100 * (running_avg_admit/running_avg_admit[which(day == 0)]),
           pos_index = 100 * (running_avg_pos/running_avg_pos[which(day == 0)])) %>%
    select(-running_avg_pct, -running_avg_pos, -running_avg_admit) %>%
    filter(day > -15, day < 29) %>%
    pivot_longer(-day, names_to = "variable", values_to = "value") %>%
    mutate(tiltag = name, type = type)
  
  return(df)
}

df <- tests %>%
  full_join(admitted, by = "Date")

plot_data <- index_plot(df, "Masker offentlig transport", "2020-08-22", "restrict")
plot_data %<>% bind_rows(index_plot(df, "Nedlukning", "2020-03-12",  "restrict"))
plot_data %<>% bind_rows(index_plot(df, "Masker + lukketid restauranter mv.", "2020-09-18",  "restrict"))
plot_data %<>% bind_rows(index_plot(df, "Privat forsamling 50", "2020-09-25", "restrict"))
plot_data %<>% bind_rows(index_plot(df, "Masker off. steder mv", "2020-10-29", "restrict"))

plot_data %<>% bind_rows(index_plot(df, "Forsamling op til 100", "2020-07-07", "open"))
plot_data %<>% bind_rows(index_plot(df, "Forsamling op til 50", "2020-06-08", "open"))
plot_data %<>% bind_rows(index_plot(df, "Fase 2, del 1", "2020-05-09", "open"))
plot_data %<>% bind_rows(index_plot(df, "Fase 2, del 2", "2020-05-22", "open"))
plot_data %<>% bind_rows(index_plot(df, "Fase 1", "2020-04-17", "open"))

baseplot <- function(data, text_positions) {
  ggplot(data, aes(day, value)) +
    geom_vline(xintercept = 0) +
    geom_segment(aes(x = -14, y = 100, xend = 28, yend = 100)) +
    geom_line(stat = "identity", position = "identity", size = 1.5, aes(color = tiltag)) +
    coord_cartesian(xlim = c(-14, 28), # This focuses the x-axis on the range of interest
                    clip = 'off') +
    geom_text(data = text_positions,  size = 4, aes(x = 29, y = value, color = tiltag, label = str_wrap(tiltag, 25)), hjust = "outward", lineheight = 0.8) +
    facet_wrap(~type, scales = "free") +
    scale_color_discrete(guide = FALSE) +
    scale_x_continuous(breaks = c(-14,-7,0,7,14,21,28), limits = c(-14, 44)) +
    scale_y_continuous(trans = "log10", limits = c(12, 700)) + 
    labs(y = "Procent af værdi da tiltaget trådte i kraft", x = "Dage")
  
}

theme <- standard_theme + 
  theme(strip.text = element_blank(),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        plot.title = element_text(size = 16),
        plot.margin = margin(1, 5, 1, 1, "cm"),
        panel.spacing.x = unit(4, "cm"),
        panel.grid.minor.y = element_blank(),
        panel.grid.minor.x = element_blank())

subset_data <- plot_data %>% filter(variable == "pos_index")

max_day <- subset_data %>% 
  filter(!is.na(value)) %>%
  group_by(tiltag) %>%
  mutate(max = day == max(day)) %>%
  filter(max)

max_day$value[which(max_day$tiltag == "Fase 1")] <- 34
max_day$value[which(max_day$tiltag == "Privat forsamling 50")] <- 165
max_day$value[which(max_day$tiltag == "Masker off. steder mv")] <- 122
max_day$value[which(max_day$tiltag == "Masker + lukketid restauranter mv.")] <- 92

baseplot(subset_data, max_day) +
  labs(title = "Hvad sker der med antal positive efter et tiltag?") +
  theme

ggsave("../figures/ntl_tiltag_pos.png", width = 30, height = 14, units = "cm", dpi = 300)

subset_data <- plot_data %>% filter(variable == "pct_index")

max_day <- subset_data %>% 
  filter(!is.na(value)) %>%
  group_by(tiltag) %>%
  mutate(max = day == max(day)) %>%
  filter(max)

max_day$value[which(max_day$tiltag == "Privat forsamling 50")] <- 190

#subset_data %<>% filter(tiltag == "Masker off. steder mv")
#max_day %<>% filter(tiltag == "Masker off. steder mv")

baseplot(subset_data, max_day) +
#  geom_line(stat = "identity", position = "identity", size = 3, color = "#00B0F6") +
#  geom_text(data = max_day,  size = 4, aes(x = 29, y = value, label = str_wrap(tiltag, 25)), color = "#00B0F6", hjust = "outward", lineheight = 0.8) +
#  scale_y_continuous(trans = "log10", limits = c(50, 200)) + 
  labs(title = "Hvad sker der med positivprocenten efter et tiltag?") +
  theme



ggsave("../figures/ntl_tiltag_pct.png", width = 30, height = 14, units = "cm", dpi = 300)


subset_data <- plot_data %>% filter(variable == "admit_index")

max_day <- subset_data %>% 
  filter(!is.na(value)) %>%
  group_by(tiltag) %>%
  mutate(max = day == max(day)) %>%
  filter(max)

max_day$value[which(max_day$tiltag == "Privat forsamling 50")] <- 140
max_day$value[which(max_day$tiltag == "Masker + lukketid restauranter mv.")] <- 107
max_day$value[which(max_day$tiltag == "Forsamling op til 50")] <- 53
max_day$value[which(max_day$tiltag == "Masker off. steder mv")] <- 82


baseplot(subset_data, max_day) +
  labs(title = "Hvad sker der med nyindlæggelser efter et tiltag?") +
  theme

ggsave("../figures/ntl_tiltag_admitted.png", width = 30, height = 14, units = "cm", dpi = 300)






# zip vs dashboard ---------------------------------------------------


x <- tests %>% select(Date, NewPositive, NotPrevPos)
x %<>% pivot_longer(-Date, names_to = "variable", values_to = "values")
x %<>% mutate(dataset = "test_pos")
y <- dashboard_data %>% mutate(dataset = "dashboard")
plot_data <- bind_rows(x,y)
plot_data %<>% filter(Date > as.Date(today) - weeks(4),
              !variable %in% c("Antal_døde", "Indlæggelser", "NotPrevPos"))


ggplot(plot_data, aes(Date, values)) +
  geom_line(stat = "identity", position = "identity" , size = 1.2, aes(color = dataset)) +
  labs(y = "Antal", x = "Dato", title = "Positivt testede: dato for prøvetagning vs. dato for prøvesvar") +
  scale_color_manual(name = "", labels = c("Svar (SSI's dashboard)", "Prøvetagning"), values = binary_col) +
  scale_x_date(date_labels = "%e. %b", date_breaks = "1 week") +
  scale_y_continuous(
    limits = c(0, ceiling(max(plot_data$values) / 1000) * 1000)
  ) +
  standard_theme

ggsave("../figures/ntl_test_pos_vs_dashboard.png", width = 18, height = 12, units = "cm", dpi = 300)

x <- tests %>% select(Date, NewPositive, NotPrevPos)
x %<>% pivot_longer(-Date, names_to = "variable", values_to = "values")
x %<>% mutate(dataset = "test_pos")
y <- dashboard_data %>% mutate(dataset = "dashboard")
plot_data <- bind_rows(x,y)
plot_data %<>% filter(Date > as.Date(today) - weeks(4),
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

dst_deaths_5yr %>%
  mutate(Date = paste0("2020M", sprintf("%02d", Month), Day)) %>%
  select(-Month, -Day) %>%
  pivot_longer(-Date, names_to = "year", values_to = "Deaths") %>%
  mutate(Deaths = ifelse(Deaths == "..", NA, Deaths),
         Deaths = as.double(Deaths)) %>%
  group_by(Date) %>%
  summarize(avg_5yr = mean(Deaths, na.rm = TRUE),
            max_5yr = max(Deaths, na.rm = TRUE),
            min_5yr = min(Deaths, na.rm = TRUE)) %>%
  ungroup() %>%
  full_join(dst_deaths, by = "Date") %>%
  filter(!is.na(Y2020)) %>%
  mutate(Date = as.Date(paste0("2020-", str_sub(Date, 6, 7), "-", str_sub(Date, 9, 10)))) %>%
  full_join(deaths, by = "Date") %>%
  ggplot() +
  geom_bar(stat="identity",position = "identity", aes(Date, Y2020, fill = "all"), width = 1) +
  geom_bar(stat="identity",position = "identity", aes(Date, Antal_døde, fill = "covid"), width = 1) +
  #geom_ribbon(aes(x=Date, ymax=max_5yr, ymin=min_5yr, fill="average"), alpha=.4) +
  #geom_line(aes(Date, ra(avg_5yr)), color = "red") +
  stat_smooth(se = FALSE, aes(Date, avg_5yr, color = "average"), span = 0.05) +  #, color = variable))+
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  labs(x = "Dato", y = "Antal døde", title = "Daglige dødsfald i Danmark") + #, caption = "Graf: covid19danmark.dk\nData: Danmarks Statistik og SSI") +
  scale_fill_manual(name = "", labels = c("Alle i 2020", "COVID-19"), values = cols[1:2]) +
  scale_color_manual(name = "", labels = c("Gennemsnit 2015-19", "Gennemsnit alle 2020"), values = cols[3:4]) +
  standard_theme + 
  theme(legend.position = "top",
        plot.caption = element_text(color = "gray"))

ggsave("../figures/dst_deaths_covid_all.png", width = 18, height = 14, units = "cm", dpi = 300)
