dashboard_data <- data.frame(
  "Date" = c("2020-09-24", "2020-09-25"),
  "NewPositive" = c(559, 678),
  "NotPrevPos" = c(53885, 57368),
  "Antal_døde" = c(2, 2),
  "Indlæggelser" = c(22, 21)
)

dashboard_data %<>%
  mutate(Date = as.Date(Date),
         pct_confirmed = NewPositive / NotPrevPos * 100)

temp_tests <- bind_rows(tests, dashboard_data)
temp_deaths <- bind_rows(deaths, dashboard_data)

temp_tests %<>% 
  mutate(running_avg_pct = ra(pct_confirmed),
         running_avg_pos = ra(NewPositive),
         running_avg_total = ra(Tested)) %>%
  select(-Antal_døde, Indlæggelser)

temp_deaths %<>%
  select(Date, Antal_døde) %>%
  mutate(running_avg = ra(Antal_døde))

png("../figures/pct_with_dashboard_data.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 2))

plot(temp_tests$Date, temp_tests$pct_confirmed,
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

points(temp_tests$Date, temp_tests$running_avg_pct, type = "l", pch = 19, col = pct_col, cex = 1.2, lwd = ra_lwd)


dev.off()

png("../figures/pct_deaths_with_dashboard_data.png", width = 22, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 6))

plot(temp_tests$Date, rep(1000, length(temp_tests$Date)),
     ylab = "",
     xlab = "",
     axes = FALSE,
     cex = 1.2,
     cex.axis = cex_axis,
     ylim = c(0, 20),
     xlim = c(as.Date("2020-02-15"), as.Date(today) - 1),
     las = 1,
     col = "white"
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

segments(temp_tests$Date, 0, temp_tests$Date, temp_tests$pct_confirmed, lwd = 2, col = alpha(pct_col, 0.5), lend = 1)
segments(temp_deaths$Date, 0, temp_deaths$Date, temp_deaths$Antal_døde/5, lwd = 2, col = "white", lend = 1)
segments(temp_deaths$Date, 0, temp_deaths$Date, temp_deaths$Antal_døde/5, lwd = 2, col = alpha(death_col, 0.7), lend = 1)

points(temp_tests$Date, temp_tests$running_avg_pct,
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = pct_col)

points(temp_deaths$Date, temp_deaths$running_avg/5,
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

# positive deaths barplot 2 ------------------------------------------------------------------

png("../figures/postest_deaths_with_dashboard.png", width = 22, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5, 8, 5, 6))

plot(0,
     type = "n",
     ylab = "",
     xlab = "",
     axes = FALSE,
     cex = 1.2,
     cex.axis = cex_axis,
     ylim = c(0, 700),
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


segments(temp_tests$Date, 0, temp_tests$Date, temp_tests$NewPositive, lwd = 2, col = alpha(pos_col,0.5), lend = 1)
segments(temp_deaths$Date, 0, temp_deaths$Date, temp_deaths$Antal_døde * 10, lwd = 2, col = "white", lend = 1)
segments(temp_deaths$Date, 0, temp_deaths$Date, temp_deaths$Antal_døde * 10, lwd = 2, col = alpha(death_col, 0.7), lend = 1)

points(temp_tests$Date, replace(temp_tests$running_avg_pos, 1:25, NA),
       type = "l", 
       pch = 19, 
       lwd = 3, 
       col = pos_col)

points(temp_deaths$Date, temp_deaths$running_avg * 10,
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

axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 100, 200, 300, 400, 500, 600, 700), labels = c(0, 10, 20, 30, 40, 50, 60, 70))
axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = c(0, 100, 200, 300, 400, 500, 600, 700), labels = c(0, 100, 200, 300, 400, 500, 600, 700))


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








