
ra_lwd <- 3

quartzFonts(lato = c("Lato-Regular", "Lato-Bold", "Lato-Italic", "Lato-BoldItalic"))

# Figure 1 ------------------------------------------------------------------

png("../figures/fig_1_test_pos.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(tests$Date, tests$NewPositive,
  type = "b",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = 1.4,
  ylim = c(0, 600),
  xlim = c(as.Date("2020-02-01"), as.Date(today) - 1),
  las = 1,
  col = alpha(pos_col, alpha = 0.3)
)

mtext(
  text = "Dagligt antal nye positivt testede",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = 1.4,
  font = 2
)

mtext(
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 4,
  cex = 1.4,
  font = 2
)

points(tests$Date, tests$running_avg_pos, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)

# text(x = as.Date("2020-06-01"), y = 300, labels = "Antal positive tests", col = "red", cex = 1.5, font = 2)
dev.off()


# Figure 2 ------------------------------------------------------------------

png("../figures/fig_2_tests.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(tests$Date, tests$Tested,
  type = "b",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = 1.4,
  ylim = c(0, 60000),
  xlim = c(as.Date("2020-02-01"), as.Date(today) - 1),
  las = 1,
  col = alpha(test_col, alpha = 0.3)
)

mtext(
  text = "Dagligt antal testede",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = 1.4,
  font = 2
)

mtext(
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 5,
  cex = 1.4,
  font = 2
)

points(tests$Date, tests$NewPositive, type = "b", pch = 19, col = alpha(pos_col, alpha = 0.3), cex = 1.2)
points(tests$Date, tests$running_avg_pos, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)
points(tests$Date, tests$running_avg_total, type = "l", pch = 19, col = test_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-07-28"), y = 45000, labels = "Antal testede", col = test_col, cex = 1.4, font = 2)
text(x = as.Date("2020-06-18"), y = 3000, labels = "Antal positive", col = pos_col, cex = 1.4, font = 2)
dev.off()


# Figure 3 ------------------------------------------------------------------

png("../figures/fig_3_pct.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(tests_from_may$Date, tests_from_may$pct_confirmed,
  type = "b",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = 1.4,
  ylim = c(0, 1.2),
  las = 1,
  col = alpha(pct_col, alpha = 0.3)
)

mtext(
  text = "Daglig procent positivt testede",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = 1.4,
  font = 2
)

mtext(
  text = "Procent",
  side = 2, # side 1 = bottom
  line = 4,
  cex = 1.4,
  font = 2
)

points(tests$Date, tests$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)


# text(x = as.Date("2020-06-25"), y = 0.6, labels = "Procent positive tests", col = "blue", cex = 1.5, font = 2)
dev.off()

# Figure 3A ------------------------------------------------------------------

png("../figures/fig_3A_pct.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(tests$Date, tests$pct_confirmed,
     type = "b",
     pch = 19,
     ylab = "",
     xlab = "",
     axes = TRUE,
     cex = 1.2,
     cex.axis = 1.4,
     ylim = c(0, 40),
     las = 1,
     col = alpha(pct_col, alpha = 0.3)
)

mtext(
  text = "Daglig procent positivt testede",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = 1.4,
  font = 2
)

mtext(
  text = "Procent",
  side = 2, # side 1 = bottom
  line = 4,
  cex = 1.4,
  font = 2
)

points(tests$Date, tests$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)


# text(x = as.Date("2020-06-25"), y = 0.6, labels = "Procent positive tests", col = "blue", cex = 1.5, font = 2)
dev.off()

# Figure 4 ------------------------------------------------------------------

png("../figures/fig_4_tests_pct.png", width = 22, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 6))

plot(tests_from_may$Date, tests_from_may$NewPositive,
  type = "b",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = 1.2,
  ylim = c(0, 600),
  las = 1,
  col = alpha(pos_col, alpha = 0.3)
)

mtext(
  text = "Procent vs. antal nye positivt testede",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = 1.2,
  font = 2
)

mtext(
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 4,
  cex = 1.2,
  font = 2,
  col = pos_col
)

points(tests_from_may$Date, tests_from_may$running_avg_pos, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)

par(new = TRUE)
plot(tests_from_may$Date, tests_from_may$pct_confirmed, type = "b", pch = 19, col = alpha(pct_col, alpha = 0.3), cex = 1.2, axes = FALSE, xlab = "", ylab = "")
points(tests_from_may$Date, tests_from_may$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-06-16"), y = 0.6, labels = "Procent positive", col = pct_col, cex = 1.4, font = 2)
text(x = as.Date("2020-05-17"), y = 0.05, labels = "Antal positive", col = pos_col, cex = 1.4, font = 2)

axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

mtext(
  text = "Procent",
  side = 4, # side 1 = bottom
  line = 4,
  cex = 1.2,
  col = pct_col,
  font = 2
)

dev.off()


# Figure 5 ------------------------------------------------------------------

png("../figures/fig_5_hosp.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(admitted$Date, admitted$Total,
  type = "b",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = 1.4,
  ylim = c(0, 100),
  xlim = c(as.Date("2020-02-01"), as.Date(today)),
  las = 1,
  col = alpha(admit_col, alpha = 0.3)
)

mtext(
  text = "Dagligt antal nyindlagte og døde",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = 1.4,
  font = 2
)

mtext(
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 4,
  cex = 1.4,
  font = 2
)

points(deaths$Date, deaths$Antal_døde,
  type = "b",
  pch = 19, cex = 1.2, col = alpha(death_col, alpha = 0.3)
)

points(admitted$Date, admitted$running_avg, type = "l", pch = 19, col = admit_col, cex = 1.2, lwd = ra_lwd)
points(deaths$Date, deaths$running_avg, type = "l", pch = 19, col = death_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-05-02"), y = 65, labels = "Nyindlagte", col = admit_col, cex = 1.4, font = 2)
text(x = as.Date("2020-04-09"), y = 2, labels = "Døde", col = death_col, cex = 1.4, font = 2)

dev.off()


# Figure 6 ------------------------------------------------------------------

png("../figures/fig_6_postest_hosp.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(tests$Date, tests$NewPositive,
  type = "b",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = 1.2,
  ylim = c(0, 500),
  xlim = c(as.Date("2020-02-01"), as.Date(today) - 1),
  las = 1,
  col = alpha(pos_col, alpha = 0.3)
)

mtext(
  text = "Nyindlagte vs. antal positive",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = 1.2,
  font = 2
)

mtext(
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 4,
  cex = 1.2,
  font = 2
)

points(admitted$Date, admitted$running_avg, type = "l", pch = 19, col = admit_col, cex = 1.2, lwd = ra_lwd)
points(tests$Date, tests$running_avg_pos, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)
points(admitted$Date, admitted$Total, type = "b", pch = 19, col = alpha(admit_col, 0.3), cex = 1.2)
text(x = as.Date("2020-04-05"), y = -2, labels = "Nyindlagte", col = admit_col, cex = 1.4, font = 2)
text(x = as.Date("2020-05-14"), y = 400, labels = "Positivt testede", col = pos_col, cex = 1.4, font = 2)
text(x = as.Date("2020-04-05"), y = 110, labels = "25. marts", col = admit_col, cex = 0.8, font = 4)
text(x = as.Date("2020-04-13"), y = 485, labels = "3. april", col = pos_col, cex = 0.8, font = 4)

dev.off()

# Rt cases pos ------------------------------------------------------------------

png("../figures/rt_cases_pos.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(rt_cases$date_sample, rt_cases$estimate,
  type = "l",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = 1.4,
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
  cex = 1.4,
  font = 2
)

mtext(
  text = "Kontakttal-værdi",
  side = 2, # side 1 = bottom
  line = 3,
  cex = 1.4,
  font = 2
)

# axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

# points(tests$Date, tests$pct_confirmed, type = "b", pch = 19, col = rgb(red = 0, green = 0, blue = 1, alpha = 0.2), cex = 1.2)
# points(tests$Date, tests$running_avg_pct, type = "l", pch = 19, col = "blue", cex = 1.2, lwd = 2)
points(tests$Date, tests$NewPositive / 300, type = "b", pch = 19, col = alpha(pos_col, 0.3), cex = 1.2)
points(tests$Date, tests$running_avg_pos / 300, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-06-15"), y = 0.4, labels = "Antal positivt testede", col = pos_col, cex = 1.4, font = 2)
text(x = as.Date("2020-07-10"), y = 1.4, labels = "Kontakttal: smittede", col = "darkgray", cex = 1.4, font = 2, adj = 1)
abline(h = 1, col = "gray")
abline(v = as.Date("2020-06-13"), col = "gray", lty = 3)
abline(v = as.Date("2020-06-23"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-09"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-23"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-27"), col = "gray", lty = 3)
abline(v = as.Date("2020-08-15"), col = "gray", lty = 3)
abline(v = as.Date("2020-08-30"), col = "gray", lty = 3)

dev.off()


# Rt cases pct ------------------------------------------------------------

png("../figures/rt_cases_pct.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(rt_cases$date_sample, rt_cases$estimate,
  type = "l",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = 1.4,
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
  line = 4,
  cex = 1.4,
  font = 2
)

mtext(
  text = "Kontakttal-værdi",
  side = 2, # side 1 = bottom
  line = 4,
  cex = 1.4,
  font = 2
)

# axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

points(tests$Date, tests$pct_confirmed, type = "b", pch = 19, col = alpha(pct_col, 0.3), cex = 1.2)
points(tests$Date, tests$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)
# points(tests$Date, tests$NewPositive/100, type = "b", pch = 19, col = rgb(red = 1, green = 0, blue = 0, alpha = 0.2), cex = 1.2)
# points(tests$Date, tests$running_avg_pos/100, type = "l", pch = 19, col = "red", cex = 1.2, lwd = 2)
text(x = as.Date("2020-05-28"), y = 0.02, labels = "Procent positivt testede", col = pct_col, cex = 1.4, font = 2)
text(x = as.Date("2020-07-10"), y = 1.4, labels = "Kontakttal: smittede", col = "darkgray", cex = 1.4, font = 2, adj = 1)
abline(h = 1, col = "gray")
abline(v = as.Date("2020-06-13"), col = "gray", lty = 3)
abline(v = as.Date("2020-06-23"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-09"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-23"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-27"), col = "gray", lty = 3)
abline(v = as.Date("2020-08-15"), col = "gray", lty = 3)
abline(v = as.Date("2020-08-30"), col = "gray", lty = 3)

dev.off()


# Rt admitted -------------------------------------------------------------


png("../figures/rt_admitted.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(rt_admitted$date_sample, rt_admitted$estimate,
  type = "l",
  pch = 19,
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = 1.4,
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
  line = 4,
  cex = 1.4,
  font = 2
)

mtext(
  text = "Kontakttal-værdi",
  side = 2, # side 1 = bottom
  line = 4,
  cex = 1.4,
  font = 2
)

# axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

points(admitted$Date, admitted$Total / 24, type = "b", pch = 19, col = alpha(admit_col, 0.3), cex = 1.2)
points(admitted$Date, admitted$running_avg / 24, type = "l", pch = 19, col = admit_col, cex = 1.2, lwd = ra_lwd)
# points(tests$Date, tests$NewPositive/100, type = "b", pch = 19, col = rgb(red = 1, green = 0, blue = 0, alpha = 0.2), cex = 1.2)
# points(tests$Date, tests$running_avg_pos/100, type = "l", pch = 19, col = "red", cex = 1.2, lwd = 2)
text(x = as.Date("2020-05-15"), y = 0.01, labels = "Nyindlagte", col = admit_col, cex = 1.4, font = 2)
text(x = as.Date("2020-07-10"), y = 1.5, labels = "Kontakttal: indlagte", col = "darkgray", cex = 1.4, font = 2, adj = 1)
abline(h = 1, col = "gray")
abline(v = as.Date("2020-05-28"), col = "gray", lty = 3)
abline(v = as.Date("2020-06-12") - 0.3, col = "gray", lty = 3)
abline(v = as.Date("2020-06-18") + 0.5, col = "gray", lty = 3)
abline(v = as.Date("2020-07-12"), col = "gray", lty = 3)
abline(v = as.Date("2020-08-09") + 0.5, col = "gray", lty = 3)

dev.off()


# positive admitted barplot -----------------------------------------------


png("../figures/postest_hosp_barplot.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(tests$Date, rep(600, length(tests$Date)),
  ylab = "",
  xlab = "",
  axes = FALSE,
  cex = 1.2,
  cex.axis = 1.2,
  ylim = c(-100, 700),
  xlim = c(as.Date("2020-02-15"), as.Date(today) - 1),
  las = 1,
  col = "white"
)

mtext(
  text = "Nye positivt testede vs. nyindlagte",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = 1.2,
  font = 2
)

mtext(
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 4,
  cex = 1.2,
  font = 2
)

box(which = "plot", lty = "solid")

axis(1, c(
  as.Date("2020-03-01"),
  as.Date("2020-05-01"),
  as.Date("2020-07-01"),
  as.Date("2020-09-01")
), format(c(
  as.Date("2020-03-01"),
  as.Date("2020-05-01"),
  as.Date("2020-07-01"),
  as.Date("2020-09-01")
), "%b"), cex.axis = 1.4)
axis(2, at = c(-100, 0, 100, 200, 300, 400, 500, 600), label = c(100, 0, 100, 200, 300, 400, 500, 600), cex.axis = 1.4, las = 1)


segments(tests$Date, 0, tests$Date, tests$NewPositive, lwd = 2, col = pos_col, lend=1)
segments(admitted$Date, 0, admitted$Date, -admitted$Total, lwd = 2, col = admit_col, lend=1)

text(x = as.Date(today) - 2, y = -70, labels = "Nyindlagte", col = admit_col, cex = 1.4, font = 2, adj = 1)
text(x = as.Date(today) - 2, y = 600, labels = "Positivt testede", col = pos_col, cex = 1.4, font = 2, adj = 1)

dev.off()


# Pct admitted barplot ----------------------------------------------------


png("../figures/pct_hosp_barplot.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(tests$Date, rep(600, length(tests$Date)),
  ylab = "",
  xlab = "",
  axes = FALSE,
  cex = 1.2,
  cex.axis = 1.2,
  ylim = c(-100, 200),
  xlim = c(as.Date("2020-02-15"), as.Date(today) - 1),
  las = 1,
  col = "white"
)

mtext(
  text = "Procent positivt testede vs. nyindlagte",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = 1.2,
  font = 2
)

mtext(
  text = "Antal                                     Procent               ",
  side = 2, # side 1 = bottom
  line = 4,
  cex = 1.2,
  font = 2
)

axis(1, c(
  as.Date("2020-03-01"),
  as.Date("2020-05-01"),
  as.Date("2020-07-01"),
  as.Date("2020-09-01")
), format(c(
  as.Date("2020-03-01"),
  as.Date("2020-05-01"),
  as.Date("2020-07-01"),
  as.Date("2020-09-01")
), "%b"), cex.axis = 1.4)
axis(2, at = c(-100, 0, 100, 200, 300, 400, 500), label = c(100, 0, "10 %", "20 %", 300, 400, 500), cex.axis = 1.4, las = 1)


segments(tests$Date, 0, tests$Date, tests$pct_confirmed * 10, lwd = 2, col = pct_col, lend = 1)
segments(admitted$Date, 0, admitted$Date, -admitted$Total, lwd = 2, col = admit_col, lend = 1)

text(x = as.Date(today) - 2, y = -70, labels = "Nyindlagte", col = admit_col, cex = 1.4, font = 2, adj = 1)
text(x = as.Date(today) - 2, y = 70, labels = "Procent positivt testede", col = pct_col, cex = 1.4, font = 2, adj = 1)

box(which = "plot", lty = "solid")

dev.off()

# Pos, test, pct combined ------------------------------------------------------------------

png("../figures/pos_tests_pct.png", width = 22, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 6))

plot(tests$Date, rep(50000, length(tests$Date)),
  ylab = "",
  xlab = "",
  axes = TRUE,
  cex = 1.2,
  cex.axis = 1.2,
  ylim = c(0, 60000),
  xlim = c(as.Date("2020-02-15"), as.Date(today) - 1),
  las = 1,
  col = "white"
)

mtext(
  text = "Testede, positive og procent positive",
  side = 3, # side 1 = bottom
  line = 1,
  cex = 1.5,
  font = 2
)

mtext(
  text = "Dato",
  side = 1, # side 1 = bottom
  line = 3,
  cex = 1.2,
  font = 2
)

mtext(
  text = "Antal testede, positive",
  side = 2, # side 1 = bottom
  line = 5,
  cex = 1.2,
  font = 2
)

segments(tests$Date, 0, tests$Date, tests$Tested, lwd = 2, col = test_col, lend = 1)
segments(tests$Date, 0, tests$Date, tests$NewPositive, lwd = 2, col = pos_col, lend = 1)

text(x = as.Date("2020-04-20"), y = 40000, labels = "Procent positive", col = pct_col, cex = 1.4, font = 2)
text(x = as.Date("2020-08-02"), y = 45000, labels = "Antal testede", col = test_col, cex = 1.4, font = 2)
text(x = as.Date("2020-03-12"), y = 8200, labels = "Antal positive", col = pos_col, cex = 1.4, font = 2)
arrows(as.Date("2020-03-10"), 6300, as.Date("2020-03-10"), 1500, lwd = 1, col = pos_col, lend = 1, length = 0.1)

par(new = TRUE)
plot(tests$Date, replace(tests$running_avg_pct, 1:37, NA), 
     xlim = c(as.Date("2020-02-15"), as.Date(today) - 1), 
     type = "l", 
     pch = 19, 
     lwd = 4.5, 
     col = "white", 
     cex = 1.2, 
     axes = FALSE, 
     xlab = "", 
     ylab = "")

points(tests$Date, replace(tests$running_avg_pct, 1:37, NA),
     type = "l", 
     pch = 19, 
     lwd = 3, 
     col = pct_col)

axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = c(0, 5, 10, 15), labels = c("0 %", "5 %", "10 %", "15 %"))

mtext(
  text = "Procent",
  side = 4, # side 1 = bottom
  line = 4,
  cex = 1.2,
  font = 2
)

dev.off()


