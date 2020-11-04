
ra_lwd <- 3
cex_labels <- 1.4
cex_axis <- 1.4

max_pos <- ceiling(max(tests$NewPositive) / 100) * 100
max_test <- ceiling(max(tests$Tested) / 5000) * 5000
max_pct <- ceiling(max(tests_from_may$pct_confirmed, na.rm = TRUE) * 5) / 5

plot_data <-
  tests %>%
  full_join(admitted, by = "Date") %>%
  full_join(deaths, by = "Date") %>%
  filter(Date > as.Date("2020-02-14"))

Sys.setlocale("LC_ALL", "en_US.UTF-8")

# Figure 1 ------------------------------------------------------------------

png("../figures/en_test_pos.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Daily new cases",
  y_label = "Number",
  x_label = "Date", 
  max_y_value = max_pos,
  y_label_dist = 4
)

points(plot_data$Date, plot_data$NewPositive, type = "b", pch = 19, col = alpha(pos_col, alpha = 0.3), cex = 1.2)
points(plot_data$Date, plot_data$running_avg_pos, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_pos, by = 100), labels = seq(0, max_pos, by = 100))

dev.off()


# Figure 2 ------------------------------------------------------------------

png("../figures/en_tests.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Daily tested and cases",
  y_label = "Number",
  x_label = "Date", 
  max_y_value = max_test,
  y_label_dist = 5
)

points(plot_data$Date, plot_data$Tested, type = "b", pch = 19, col = alpha(test_col, alpha = 0.3), cex = 1.2)
points(plot_data$Date, plot_data$NewPositive, type = "b", pch = 19, col = alpha(pos_col, alpha = 0.3), cex = 1.2)
points(plot_data$Date, plot_data$running_avg_pos, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)
points(plot_data$Date, plot_data$running_avg_total, type = "l", pch = 19, col = test_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-09-01"), y = 52000, labels = "Tested", col = test_col, cex = cex_labels, font = 2, pos = 2)
text(x = as.Date("2020-09-01"), y = 3000, labels = "Cases", col = pos_col, cex = cex_labels, font = 2, pos = 2)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_test, by = 10000), labels = seq(0, max_test, by = 10000))

dev.off()


# Figure 3 ------------------------------------------------------------------

png("../figures/en_pct.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Daily percentage positive tests",
  y_label_dist = 4,
  y_label = "Procent",
  x_label = "Date", 
  max_y_value = max_pct,
  x_by = "1 month",
  start_date = "2020-05-01"
)

points(tests_from_may$Date, tests_from_may$pct_confirmed, type = "b", pch = 19, col = alpha(pct_col, alpha = 0.3), cex = 1.2)
points(plot_data$Date, plot_data$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_pct, by = 0.2), labels = seq(0, max_pct, by = 0.2))

dev.off()

# Figure 3A ------------------------------------------------------------------

png("../figures/en_pct_2.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Daily percentage positive tests",
  x_label = "Date", 
  max_y_value = 40,
  y_label_dist = 4,
  y_label = "Procent"
)

points(plot_data$Date, plot_data$pct_confirmed, type = "b", pch = 19, col = alpha(pct_col, alpha = 0.3), cex = 1.2)
points(plot_data$Date, plot_data$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, 40, by = 10), labels = seq(0, 40, by = 10))


dev.off()

# Figure 5 ------------------------------------------------------------------

png("../figures/en_hosp.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Daily hospital admissions",
  y_label = "Number",
  x_label = "Date", 
  y_label_dist = 4,
  max_y_value = 100,
  x_by = "2 months",
  start_date = "2020-02-15"
)

# points(plot_data$Date, plot_data$Antal_døde, type = "b", pch = 19, cex = 1.2, col = alpha(death_col, alpha = 0.3))
points(plot_data$Date, plot_data$Total, type = "b", pch = 19, cex = 1.2, col = alpha(admit_col, alpha = 0.3))
points(plot_data$Date, plot_data$running_avg_admit, type = "l", pch = 19, col = admit_col, cex = 1.2, lwd = ra_lwd)
# points(plot_data$Date, plot_data$running_avg_deaths, type = "l", pch = 19, col = death_col, cex = 1.2, lwd = ra_lwd)

# text(x = as.Date("2020-04-06"), y = 65, labels = "Nyindlagte", col = admit_col, cex = cex_labels, font = 2, pos = 4)
# text(x = as.Date("2020-04-09"), y = 2, labels = "Døde", col = death_col, cex = cex_labels, font = 2)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, 100, by = 20), labels = seq(0, 100, by = 20))

dev.off()


# Figure 5A ------------------------------------------------------------------

png("../figures/en_deaths.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Daily deaths",
  y_label = "Number",
  x_label = "Date", 
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


# -------------------------------------------------------------------------

# positive admitted barplot 2 ------------------------------------------------------------------

png("../figures/en_postest_admitted_barplot_2.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Daily cases vs. admissions",
  x_label = "Date", 
  y_label_dist = 4,
  y_label = "Number",
  max_y_value = max_pos,
  x_by = "2 months"
)

segments(plot_data$Date, 0, plot_data$Date, plot_data$NewPositive, lwd = 2, col = alpha(pos_col, 0.5), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total, lwd = 2, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total, lwd = 2, col = alpha(admit_col, 0.7), lend = 1)

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

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_pos, by = 100), labels = seq(0, max_pos, by = 100))

legend("topleft",
  inset = 0.04,
  legend = c("Cases", "Admissions"),
  col = c(pos_col, admit_col),
  lty = 1,
  cex = 1.2,
  box.lty = 0,
  lwd = 4
)

dev.off()




# pct admitted barplot 2 ------------------------------------------------------------------

png("../figures/en_pct_admitted_barplot_2.png", width = 22, height = 16, units = "cm", res = 300)

double_plot(
  title = "Daily percentage positives vs. admissions",
  y_label = "Percentage",
  x_label = "Date", 
  y2_label = "Number of admissions",
  y_label_dist = 5,
  max_y_value = 20,
  x_by = "2 months",
  start_date = "2020-02-15"
)

segments(plot_data$Date, 0, plot_data$Date, plot_data$pct_confirmed, lwd = 2, col = alpha(pct_col, 0.5), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total / 15, lwd = 2, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total / 15, lwd = 2, col = alpha(admit_col, 0.7), lend = 1)

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
  legend = c("Percentage positives", "Admissions"),
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

# positive deaths barplot 2 ------------------------------------------------------------------

png("../figures/en_postest_deaths_barplot_2.png", width = 22, height = 16, units = "cm", res = 300)

double_plot(
  title = "Daily cases vs. deaths",
  y_label = "Number of cases",
  x_label = "Date", 
  y2_label = "Number of deaths",
  y_label_dist = 5,
  max_y_value = max_pos,
  x_by = "2 months",
  start_date = "2020-02-15"
)

segments(plot_data$Date, 0, plot_data$Date, plot_data$NewPositive, lwd = 2, col = alpha(pos_col, 0.5), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde * 10, lwd = 2, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde * 10, lwd = 2, col = alpha(death_col, 0.7), lend = 1)

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



axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_pos, by = 100), labels = seq(0, max_pos / 10, by = 10))
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_pos, by = 100), labels = seq(0, max_pos, by = 100))


legend("topleft",
  inset = 0.04,
  legend = c("Cases", "Deaths"),
  col = c(pos_col, darken(death_col, 0.4)),
  lty = 1,
  cex = 1.2,
  box.lty = 0,
  lwd = 4
)


dev.off()



# pct deaths barplot 2 ------------------------------------------------------------------

png("../figures/en_pct_deaths_barplot_2.png", width = 22, height = 16, units = "cm", res = 300)

double_plot(
  title = "Daily percentage positive vs. deaths",
  y_label = "Percent",
  y2_label = "Number of deaths",
  x_label = "Date", 
  y_label_dist = 5,
  max_y_value = 20,
  x_by = "2 months",
  start_date = "2020-02-15"
)

segments(plot_data$Date, 0, plot_data$Date, plot_data$pct_confirmed, lwd = 2, col = alpha(pct_col, 0.5), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde / 5, lwd = 2, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde / 5, lwd = 2, col = alpha(death_col, 0.7), lend = 1)

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
  legend = c("Percentage positives", "Deaths"),
  col = c(pct_col, darken(death_col, 0.4)),
  lty = 1,
  cex = 1.2,
  box.lty = 0,
  lwd = 4
)


axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 5, 10, 15, 20), labels = c(0, 25, 50, 75, 100))
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 5, 10, 15, 20), labels = c(0, "5 %", "10 %", "15 %", "20 %"))


dev.off()



# -------------------------------------------------------------------------

# tiltag plot fra juli -------------------------------------------------------------


png("../figures/en_tiltag_july.png", width = 22, height = 16, units = "cm", res = 300)

double_plot(
  title = "Indicators and political actions",
  y_label = "Number",
  y2_label = "Percentage",
  x_label = "Date",
  y_label_dist = 5,
  max_y_value = max_pos + 100,
  x_by = "1 month",
  start_date = "2020-07-01"
)

segments(plot_data$Date, 0, plot_data$Date, plot_data$NewPositive, lwd = 4, col = alpha(pos_col, 0.5), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$pct_confirmed * 100, lwd = 4, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$pct_confirmed * 100, lwd = 4, alpha(pct_col, 0.7), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total, lwd = 4, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Total, lwd = 4, col = alpha(admit_col, 0.7), lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde, lwd = 4, col = "white", lend = 1)
segments(plot_data$Date, 0, plot_data$Date, plot_data$Antal_døde, lwd = 4, col = alpha(death_col, 0.7), lend = 1)

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


axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_pos + 100, by = 200), labels = paste0(seq(0, max_pos + 100, by = 200) / 100, " %"))
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_pos + 100, by = 200), labels = seq(0, max_pos + 100, by = 200))




y <- 60
arrows(as.Date("2020-07-07"), y + max_pos/14, as.Date("2020-07-07"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-07-08"), y + max_pos/16, "Gathering limit: 100", cex = 0.9, adj = 0)

y <- 170
arrows(as.Date("2020-08-14"), y + max_pos/13, as.Date("2020-08-14"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-08-13"), y + max_pos/15, "Extended closing hrs", cex = 0.9, adj = 1)

y <- 120
arrows(as.Date("2020-08-22"), y + max_pos/7, as.Date("2020-08-22"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-08-22"), y + max_pos/5, "Mask mandate\npublic transport", cex = 0.9)

y <- 400
arrows(as.Date("2020-09-09"), y + max_pos/7, as.Date("2020-09-09"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-09-08"), y + max_pos/10, "Restrictions night life\nCopenhagen/Odense", cex = 0.9, adj = 1)

y <- 600
arrows(as.Date("2020-09-18"), y + max_pos/7, as.Date("2020-09-18"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-09-17"), y + max_pos/10, "Restrictions\nrestaurants etc.", cex = 0.9, adj = 1)

y <- 680
arrows(as.Date("2020-09-26"), y + max_pos/7, as.Date("2020-09-26"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-09-27"), y + max_pos/10, "Restrictions\nprivate parties", cex = 0.9, adj = 0)

y <- 1230
arrows(as.Date("2020-10-29"), y + max_pos/7, as.Date("2020-10-29"), y, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-10-28"), y + max_pos/10, "Masks all public indoors,\ngathering limit 10 etc.", cex = 0.9, adj = 1)




legend("topleft",
  inset = 0.04,
  legend = c("Cases", "Percentage positives", "Admissions", "Deaths"),
  col = c(pos_col, pct_col, admit_col, darken(death_col, 0.4)),
  lty = 1,
  cex = 1.2,
  box.lty = 0,
  lwd = 4
)


dev.off()



# tiltag plot fra april -------------------------------------------------------------


png("../figures/en_tiltag_april.png", width = 22, height = 16, units = "cm", res = 300)

par(lheight = 0.9)

double_plot(
  title = "Indicators and reopening",
  y_label = "Number",
  y2_label = "Percentage",
  x_label = "Date",
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
text(as.Date("2020-04-16"), 400, "Schools,\nsmall businesses", cex = 0.9, adj = 0)

arrows(as.Date("2020-05-07"), 250, as.Date("2020-05-07"), 150, lwd = 1, lend = 1, length = 0.1)
arrows(as.Date("2020-05-11"), 170, as.Date("2020-05-11"), 150, lwd = 1, lend = 1, length = 0.1)
arrows(as.Date("2020-05-18"), 170, as.Date("2020-05-18"), 150, lwd = 1, lend = 1, length = 0.1)
arrows(as.Date("2020-05-21"), 170, as.Date("2020-05-21"), 150, lwd = 1, lend = 1, length = 0.1)
arrows(as.Date("2020-05-27"), 170, as.Date("2020-05-27"), 150, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-05-08"), 217, "High schools,\nretail, culture,\nsport, restaurants", cex = 0.9, adj = 0)

arrows(as.Date("2020-06-08"), 200, as.Date("2020-06-08"), 60, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-06-09"), 167, "Gathering limit: 50,\npools,\nfitness", cex = 0.9, adj = 0)

arrows(as.Date("2020-07-07"), 160, as.Date("2020-07-07"), 60, lwd = 1, lend = 1, length = 0.1)
text(as.Date("2020-07-08"), 150, "Gathering limit:\n100", cex = 0.9, adj = 0)


legend("topright",
  inset = 0.04,
  legend = c("Cases", "Percentage positives", "Admissions", "Deaths"),
  col = c(pos_col, pct_col, admit_col, darken(death_col, 0.4)),
  lty = 1,
  cex = 1.2,
  box.lty = 0,
  lwd = 4
)


dev.off()

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

