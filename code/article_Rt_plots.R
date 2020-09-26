
ra_lwd <- 3
cex_labels <- 1.4
cex_axis <- 1.4

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
  cex.axis = cex_axis,
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
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 4,
  cex = cex_labels,
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
  cex.axis = cex_axis,
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
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 5,
  cex = cex_labels,
  font = 2
)

points(tests$Date, tests$NewPositive, type = "b", pch = 19, col = alpha(pos_col, alpha = 0.3), cex = 1.2)
points(tests$Date, tests$running_avg_pos, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)
points(tests$Date, tests$running_avg_total, type = "l", pch = 19, col = test_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-08-02"), y = 50000, labels = "Antal testede", col = test_col, cex = cex_labels, font = 2)
text(x = as.Date("2020-06-18"), y = 3000, labels = "Antal positive", col = pos_col, cex = cex_labels, font = 2)
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
  cex.axis = cex_axis,
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
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Procent",
  side = 2, # side 1 = bottom
  line = 4,
  cex = cex_labels,
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
     cex.axis = cex_axis,
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
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Procent",
  side = 2, # side 1 = bottom
  line = 4,
  cex = cex_labels,
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
  cex.axis = cex_axis,
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
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 4,
  cex = cex_labels,
  font = 2,
  col = pos_col
)

points(tests_from_may$Date, tests_from_may$running_avg_pos, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)

par(new = TRUE)
plot(tests_from_may$Date, tests_from_may$pct_confirmed, type = "b", pch = 19, col = alpha(pct_col, alpha = 0.3), cex = 1.2, axes = FALSE, xlab = "", ylab = "")
points(tests_from_may$Date, tests_from_may$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-06-16"), y = 0.6, labels = "Procent positive", col = pct_col, cex = cex_labels, font = 2)
text(x = as.Date("2020-05-17"), y = 0.05, labels = "Antal positive", col = pos_col, cex = cex_labels, font = 2)

axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

text(par("usr")[2] * 1.0012,mean(par("usr")[3:4]), "Procent", srt = -90, xpd = TRUE, adj = 0.5, cex = cex_labels, font = 2, col = pct_col)

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
  cex.axis = cex_axis,
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
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 4,
  cex = cex_labels,
  font = 2
)

points(deaths$Date, deaths$Antal_døde,
  type = "b",
  pch = 19, cex = 1.2, col = alpha(death_col, alpha = 0.3)
)

points(admitted$Date, admitted$running_avg, type = "l", pch = 19, col = admit_col, cex = 1.2, lwd = ra_lwd)
points(deaths$Date, deaths$running_avg, type = "l", pch = 19, col = death_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-05-02"), y = 65, labels = "Nyindlagte", col = admit_col, cex = cex_labels, font = 2)
text(x = as.Date("2020-04-09"), y = 2, labels = "Døde", col = death_col, cex = cex_labels, font = 2)

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

# Pos, test, pct combined ------------------------------------------------------------------

png("../figures/pos_tests_pct.png", width = 22, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 6))

plot(c(as.Date("2020-02-15"), as.Date("2020-09-15")), rep(100000,2),
     type = "n",
     ylab = "",
     xlab = "",
     axes = TRUE,
     cex = 1.2,
     cex.axis = cex_axis,
     ylim = c(0, 60000),
     xlim = c(as.Date("2020-02-15"), as.Date(today) - 1),
     las = 1
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
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Antal testede, positive",
  side = 2, # side 1 = bottom
  line = 6,
  cex = cex_labels,
  font = 2
)

segments(tests$Date, 0, tests$Date, tests$Tested, lwd = 2, col = alpha(test_col, 0.6), lend = 1)
segments(tests$Date, 0, tests$Date, tests$NewPositive, lwd = 2, col = pos_col, lend = 1)

text(x = as.Date("2020-04-20"), y = 40000, labels = "Procent positive", col = pct_col, cex = cex_labels, font = 2)
text(x = as.Date("2020-08-02"), y = 50000, labels = "Antal testede", col = alpha(test_col, 0.9), cex = 1.4, font = 2)
text(x = as.Date("2020-03-12"), y = 8200, labels = "Antal positive", col = pos_col, cex = cex_labels, font = 2)
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

text(par("usr")[2] * 1.0020,mean(par("usr")[3:4]), "Procent", srt = -90, xpd = TRUE, adj = 0.5, cex = cex_labels, font = 2)

dev.off()






# -------------------------------------------------------------------------


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

points(tests$Date, tests$NewPositive / 300, type = "b", pch = 19, col = alpha(pos_col, 0.3), cex = 1.2)
points(tests$Date, tests$running_avg_pos / 300, type = "l", pch = 19, col = pos_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-06-15"), y = 0.4, labels = "Antal positivt testede", col = pos_col, cex = cex_labels, font = 2)
text(x = as.Date("2020-07-10"), y = 1.4, labels = "Kontakttal: smittede", col = "darkgray", cex = cex_labels, font = 2, adj = 1)
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
  line = 4,
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Kontakttal-værdi",
  side = 2, # side 1 = bottom
  line = 4,
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
  line = 4,
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Kontakttal-værdi",
  side = 2, # side 1 = bottom
  line = 4,
  cex = cex_labels,
  font = 2
)


points(admitted$Date, admitted$Total / 24, type = "b", pch = 19, col = alpha(admit_col, 0.3), cex = 1.2)
points(admitted$Date, admitted$running_avg / 24, type = "l", pch = 19, col = admit_col, cex = 1.2, lwd = ra_lwd)

text(x = as.Date("2020-05-15"), y = 0.01, labels = "Nyindlagte", col = admit_col, cex = cex_labels, font = 2)
text(x = as.Date("2020-07-10"), y = 1.5, labels = "Kontakttal: indlagte", col = "darkgray", cex = cex_labels, font = 2, adj = 1)
abline(h = 1, col = "gray")
abline(v = as.Date("2020-05-28"), col = "gray", lty = 3)
abline(v = as.Date("2020-06-12") - 0.3, col = "gray", lty = 3)
abline(v = as.Date("2020-06-18") + 0.5, col = "gray", lty = 3)
abline(v = as.Date("2020-07-12"), col = "gray", lty = 3)
abline(v = as.Date("2020-08-09") + 0.5, col = "gray", lty = 3)

dev.off()






# -------------------------------------------------------------------------


# positive admitted barplot -----------------------------------------------


png("../figures/postest_admitted_barplot.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(0,
  type = "n",
  ylab = "",
  xlab = "",
  axes = FALSE,
  cex = 1.2,
  cex.axis = cex_axis,
  ylim = c(-100, 700),
  xlim = c(as.Date("2020-02-15"), as.Date(today) - 1)
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
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 4,
  cex = cex_labels,
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
), "%b"), cex.axis = cex_axis)
axis(2, at = c(-100, 0, 100, 200, 300, 400, 500, 600), label = c(100, 0, 100, 200, 300, 400, 500, 600), cex.axis = cex_axis, las = 1)


segments(tests$Date, 0, tests$Date, tests$NewPositive, lwd = 2, col = pos_col, lend=1)
segments(admitted$Date, 0, admitted$Date, -admitted$Total, lwd = 2, col = admit_col, lend=1)

text(x = as.Date(today) - 2, y = -70, labels = "Nyindlagte", col = admit_col, cex = cex_labels, font = 2, adj = 1)
text(x = as.Date(today) - 2, y = 630, labels = "Positivt testede", col = pos_col, cex = cex_labels, font = 2, adj = 1)

dev.off()


# positive admitted barplot 2 ------------------------------------------------------------------

png("../figures/postest_admitted_barplot_2.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

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

mtext(
  text = "Antal positivt testede vs. nyindlagte",
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
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 4,
  cex = cex_labels,
  font = 2
)


segments(tests$Date, 0, tests$Date, tests$NewPositive, lwd = 2, col = alpha(pos_col,0.5), lend = 1)
segments(admitted$Date, 0, admitted$Date, admitted$Total, lwd = 2, col = "white", lend = 1)
segments(admitted$Date, 0, admitted$Date, admitted$Total, lwd = 2, col = alpha(admit_col, 0.7), lend = 1)

points(tests$Date, replace(tests$running_avg_pos, 1:25, NA),
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = pos_col)

points(admitted$Date, admitted$running_avg,
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = admit_col)

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
), "%b"), cex.axis = cex_axis)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 100, 200, 300, 400, 500, 600), labels = c(0, 100, 200, 300, 400, 500, 600))


legend("topleft",
       inset = 0.04,
       legend=c("Positivt testede", "Nyindlagte"),
       col=c(pos_col, admit_col), 
       lty=1, 
       cex=1.2,
       box.lty=0, 
       lwd = 4)


dev.off()




# Pct admitted barplot ----------------------------------------------------


png("../figures/pct_admitted_barplot.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(0,
     type = "n",
     ylab = "",
     xlab = "",
     axes = FALSE,
     cex = 1.2,
     cex.axis = cex_axis,
     ylim = c(-100, 200),
     xlim = c(as.Date("2020-02-15"), as.Date(today) - 1)
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
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Antal                            Procent            ",
  side = 2, # side 1 = bottom
  line = 4,
  cex = cex_labels,
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
), "%b"), cex.axis = cex_axis)
axis(2, at = c(-100, 0, 100, 200, 300, 400, 500), label = c(100, 0, "10 %", "20 %", 300, 400, 500), cex.axis = cex_axis, las = 1)


segments(tests$Date, 0, tests$Date, tests$pct_confirmed * 10, lwd = 2, col = pct_col, lend = 1)
segments(admitted$Date, 0, admitted$Date, -admitted$Total, lwd = 2, col = admit_col, lend = 1)

text(x = as.Date(today) - 2, y = -70, labels = "Nyindlagte", col = admit_col, cex = cex_labels, font = 2, adj = 1)
text(x = as.Date(today) - 2, y = 70, labels = "Procent positivt testede", col = pct_col, cex = cex_labels, font = 2, adj = 1)

box(which = "plot", lty = "solid")

dev.off()

# pct admitted barplot 2 ------------------------------------------------------------------

png("../figures/pct_admitted_barplot_2.png", width = 22, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 6))

plot(0,
     type = "n",
     ylab = "",
     xlab = "",
     axes = FALSE,
     cex = 1.2,
     cex.axis = cex_axis,
     ylim = c(0, 20),
     xlim = c(as.Date("2020-02-15"), as.Date(today) - 1)
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
  cex = cex_labels,
  font = 2
)

mtext(
  text = "Positivprocent",
  side = 2, # side 1 = bottom
  line = 5,
  cex = cex_labels,
  font = 2
)

segments(tests$Date, 0, tests$Date, tests$pct_confirmed, lwd = 2, col = alpha(pct_col, 0.5), lend = 1)
segments(admitted$Date, 0, admitted$Date, admitted$Total/15, lwd = 2, col = "white", lend = 1)
segments(admitted$Date, 0, admitted$Date, admitted$Total/15, lwd = 2, col = alpha(admit_col, 0.7), lend = 1)

points(tests$Date, tests$running_avg_pct,
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = pct_col)

points(admitted$Date, admitted$running_avg/15,
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = admit_col)

legend("topright",
       inset = 0.04,
       legend=c("Positivprocent", "Nyindlagte"),
       col=c(pct_col, admit_col), 
       lty=1, 
       cex=1.2,
       box.lty=0, 
       lwd = 4)

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
), "%b"), cex.axis = cex_axis)

axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 6.7, 13.3, 20), labels = c(0, 100,  200, 300))
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 5, 10, 15, 20), labels = c(0, "5 %", "10 %", "15 %", "20 %"))


text(par("usr")[2]* 1.0021,mean(par("usr")[3:4]), "Antal nyindlagte", srt = -90, xpd = TRUE, adj = 0.5, cex = cex_labels, font = 2)


dev.off()





# -------------------------------------------------------------------------


# positive deaths barplot -----------------------------------------------


png("../figures/postest_deaths_barplot.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(0,
     type = "n",
     ylab = "",
     xlab = "",
     axes = FALSE,
     cex = 1.2,
     cex.axis = cex_axis,
     ylim = c(-100, 700),
     xlim = c(as.Date("2020-02-15"), as.Date(today) - 1)
)

mtext(
  text = "Antal positivt testede vs. døde",
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
  text = "Antal",
  side = 2, # side 1 = bottom
  line = 4,
  cex = cex_labels,
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
), "%b"), cex.axis = cex_axis)
axis(2, at = c(-100, 0, 100, 200, 300, 400, 500, 600), label = c(100, 0, 100, 200, 300, 400, 500, 600), cex.axis = cex_axis, las = 1)


segments(tests$Date, 0, tests$Date, tests$NewPositive, lwd = 2, col = pos_col, lend=1)
segments(deaths$Date, 0, deaths$Date, -deaths$Antal_døde, lwd = 2, col = death_col, lend=1)

text(x = as.Date(today) - 2, y = -70, labels = "Døde", col = death_col, cex = cex_labels, font = 2, adj = 1)
text(x = as.Date(today) - 2, y = 630, labels = "Positivt testede", col = pos_col, cex = cex_labels, font = 2, adj = 1)

dev.off()



# positive deaths barplot 2 ------------------------------------------------------------------

png("../figures/postest_deaths_barplot_2.png", width = 22, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 6))

plot(0,
     type = "n",
     ylab = "",
     xlab = "",
     axes = FALSE,
     cex = 1.2,
     cex.axis = cex_axis,
     ylim = c(0, 600),
     xlim = c(as.Date("2020-02-15"), as.Date(today) - 1)
)

mtext(
  text = "Antal positivt testede vs. døde",
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
  text = "Antal positivt testede",
  side = 2, # side 1 = bottom
  line = 5,
  cex = cex_labels,
  font = 2
)


segments(tests$Date, 0, tests$Date, tests$NewPositive, lwd = 2, col = alpha(pos_col,0.5), lend = 1)
segments(deaths$Date, 0, deaths$Date, deaths$Antal_døde * 10, lwd = 2, col = "white", lend = 1)
segments(deaths$Date, 0, deaths$Date, deaths$Antal_døde * 10, lwd = 2, col = alpha(death_col, 0.7), lend = 1)

points(tests$Date, replace(tests$running_avg_pos, 1:25, NA),
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = pos_col)

points(deaths$Date, deaths$running_avg * 10,
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = darken(death_col, 0.4))

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
), "%b"), cex.axis = cex_axis)

axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 100, 200, 300, 400, 500, 600), labels = c(0, 10, 20, 30, 40, 50, 60))
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 100, 200, 300, 400, 500, 600), labels = c(0, 100, 200, 300, 400, 500, 600))


text(par("usr")[2]* 1.0021,mean(par("usr")[3:4]), "Antal døde", srt = -90, xpd = TRUE, adj = 0.5, cex = cex_labels, font = 2)


legend("topleft",
       inset = 0.04,
       legend=c("Positivt testede", "Døde"),
       col=c(pos_col, darken(death_col, 0.4)), 
       lty=1, 
       cex=1.2,
       box.lty=0, 
       lwd = 4)


dev.off()



# Pct deaths barplot ----------------------------------------------------


png("../figures/pct_deaths_barplot.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(0,
     type = "n",
     ylab = "",
     xlab = "",
     axes = FALSE,
     cex = 1.2,
     cex.axis = cex_axis,
     ylim = c(-25, 100),
     xlim = c(as.Date("2020-02-15"), as.Date(today) - 1)
)

mtext(
  text = "Procent positivt testede vs. døde",
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
  text = "Antal                             Procent                        ",
  side = 2, # side 1 = bottom
  line = 4,
  cex = cex_labels,
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
), "%b"), cex.axis = cex_axis)
axis(2, at = c(-25, 0, 50, 100), label = c(25, 0, "10 %", "20 %"), cex.axis = cex_axis, las = 1)


segments(tests$Date, 0, tests$Date, tests$pct_confirmed * 5, lwd = 2, col = pct_col, lend = 1)
segments(deaths$Date, 0, deaths$Date, -deaths$Antal_døde, lwd = 2, col = death_col, lend = 1)

text(x = as.Date(today) - 2, y = -18, labels = "Døde", col = death_col, cex = cex_labels, font = 2, adj = 1)
text(x = as.Date(today) - 2, y = 20, labels = "Procent positivt testede", col = pct_col, cex = cex_labels, font = 2, adj = 1)

box(which = "plot", lty = "solid")

dev.off()




# pct deaths barplot 2 ------------------------------------------------------------------

png("../figures/pct_deaths_barplot_2.png", width = 22, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 6))

plot(0,
     type = "n",
     ylab = "",
     xlab = "",
     axes = FALSE,
     cex = 1.2,
     cex.axis = cex_axis,
     ylim = c(0, 20),
     xlim = c(as.Date("2020-02-15"), as.Date(today) - 1)
)

mtext(
  text = "Procent positivt testede vs. døde",
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
  text = "Positivprocent",
  side = 2, # side 1 = bottom
  line = 5,
  cex = cex_labels,
  font = 2
)

segments(tests$Date, 0, tests$Date, tests$pct_confirmed, lwd = 2, col = alpha(pct_col, 0.5), lend = 1)
segments(deaths$Date, 0, deaths$Date, deaths$Antal_døde/5, lwd = 2, col = "white", lend = 1)
segments(deaths$Date, 0, deaths$Date, deaths$Antal_døde/5, lwd = 2, col = alpha(death_col, 0.7), lend = 1)

points(tests$Date, tests$running_avg_pct,
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = pct_col)

points(deaths$Date, deaths$running_avg/5,
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = darken(death_col, 0.4))

legend("topright",
       inset = 0.04,
       legend=c("Positivprocent", "Døde"),
       col=c(pct_col, darken(death_col, 0.4)), 
       lty=1, 
       cex=1.2,
       box.lty=0, 
       lwd = 4
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
), "%b"), cex.axis = cex_axis)

axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 5, 10, 15, 20), labels = c(0, 25,  50, 75, 100))
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 5, 10, 15, 20), labels = c(0, "5 %", "10 %", "15 %", "20 %"))


text(par("usr")[2]* 1.0021,mean(par("usr")[3:4]), "Antal døde", srt = -90, xpd = TRUE, adj = 0.5, cex = cex_labels, font = 2)


dev.off()







# Figure 3A ------------------------------------------------------------------

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




segments(tests$Date, 0, tests$Date, tests$NewPositive, lwd = 2, col = alpha(pos_col,0.5), lend = 1)
segments(admitted$Date, 0, admitted$Date, admitted$Total, lwd = 2, col = "white", lend = 1)
segments(admitted$Date, 0, admitted$Date, admitted$Total, lwd = 2, col = alpha(admit_col, 0.7), lend = 1)

points(tests$Date, replace(tests$running_avg_pos, 1:25, NA),
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = pos_col)

points(admitted$Date, admitted$running_avg,
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = admit_col)





dev.off()
