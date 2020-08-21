library(tidyverse)
library(magrittr)

today <- "2020-08-21"

admitted <- read_csv2("../data/SSIdata_200821/Newly_admitted_over_time.csv")
deaths <- read_csv2("../data/SSIdata_200821/Deaths_over_time.csv")
tests <- read_csv2("../data/SSIdata_200821/Test_pos_over_time.csv")
rt_cases <- read_csv2("../data/SSIdata_200821/Rt_cases_2020_08_18.csv")
rt_admitted <- read_csv2("../data/SSIdata_200821/Rt_indlagte_2020_08_18.csv")

tests %<>% 
  mutate(Date = as.Date(Date)) %>%
  mutate(pct_confirmed = NewPositive/Tested * 100)

deaths %<>% 
  mutate(Dato = as.Date(Dato)) 

admitted %<>% slice(1:(n())) 
deaths %<>% slice(1:(n()-1)) #exclude summary row
tests %<>% slice(1:(n()-4)) #exclude last two days that may not be updated AND summary rows

tests_from_may <- tests %>% slice(96:(n())) #exclude data before May

quartzFonts(lato = c("Lato-Regular", "Lato-Bold", "Lato-Italic", "Lato-BoldItalic"))

# Figure 1 ------------------------------------------------------------------

png("../figures/fig_1_test_pos.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))

plot(tests$Date, tests$NewPositive, 
     type = "b", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,500),
     xlim = c(as.Date("2020-02-01"), as.Date(today) - 1),
     las = 1,
     col = "red")

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4, 
      font = 2)

mtext(text = "Antal",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.4,
      font = 2)

text(x = as.Date("2020-06-01"), y = 300, labels = "Antal positive tests", col = "red", cex = 1.5, font = 2)
dev.off()

# Figure 2 ------------------------------------------------------------------

png("../figures/fig_2_tests.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))

plot(tests$Date, tests$Tested, 
     type = "b", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,38000),
     xlim = c(as.Date("2020-02-01"), as.Date(today) - 1),
     las = 1)

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4, 
      font = 2)

mtext(text = "Antal",
      side = 2,#side 1 = bottom
      line = 5,
      cex = 1.4,
      font = 2)

points(tests$Date, tests$NewPositive, type = "b", pch = 19, col = "red", cex = 1.2)

text(x = as.Date("2020-05-05"), y = 21000, labels = "Total antal tests", col = "black", cex = 1.5, font = 2)
text(x = as.Date("2020-06-10"), y = 2000, labels = "Antal positive tests", col = "red", cex = 1.5, font = 2)
dev.off()


# Figure 3 ------------------------------------------------------------------

png("../figures/fig_3_pct.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))

plot(tests_from_may$Date, tests_from_may$pct_confirmed, 
     type = "b", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,1.2),
     las = 1, 
     col = "blue")

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

mtext(text = "Procent",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.4,
      font = 2)


text(x = as.Date("2020-06-20"), y = 0.6, labels = "Procent positive tests", col = "blue", cex = 1.5, font = 2)
dev.off()

# Figure 4 ------------------------------------------------------------------

png("../figures/fig_4_tests_pct.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,6))

plot(tests_from_may$Date, tests_from_may$NewPositive,
     type = "b",
     pch = 19,
     ylab = "",
     xlab = "",
     axes = TRUE,
     cex = 1.2,
     cex.axis = 1.2,
     ylim = c(0,300),
     las = 1,
     col = "red")

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3,
      cex = 1.2,
      font = 2)

mtext(text = "Antal",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.2,
      font = 2,
      col = "red")

par(new = TRUE)
plot(tests_from_may$Date, tests_from_may$pct_confirmed, type = "b", pch = 19, col = "blue", cex = 1.2, axes = FALSE, xlab = "", ylab = "")

text(x = as.Date("2020-06-16"), y = 0.6, labels = "Procent positive", col = "blue", cex = 1.5, font = 2)
text(x = as.Date("2020-05-17"), y = 0.07, labels = "Antal positive", col = "red", cex = 1.5, font = 2)

axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

mtext(text = "Procent",
      side = 4,#side 1 = bottom
      line = 4,
      cex = 1.2,
      col = "blue",
      font = 2)

dev.off()


# Figure 5 ------------------------------------------------------------------

png("../figures/fig_5_hosp.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))

plot(admitted$Dato, admitted$Total, 
     type = "b", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,100),
     xlim = c(as.Date("2020-02-01"), as.Date(today)),
     las = 1, 
     col = "#2D708EFF")

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

mtext(text = "Antal",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.4,
      font = 2)

points(deaths$Dato, deaths$Antal_døde,  type = "b", 
       pch = 19, cex = 1.2, col = "#661313")

text(x = as.Date("2020-04-29"), y = 65, labels = "Nyindlagte", col = "#2D708EFF", cex = 1.5, font = 2)
text(x = as.Date("2020-04-09"), y = 2, labels = "Døde", col = "#661313", cex = 1.5, font = 2)

dev.off()


# Figure 6 ------------------------------------------------------------------

png("../figures/fig_6_postest_hosp.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))

plot(tests$Date, tests$NewPositive, 
     type = "b", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.2, 
     ylim = c(0,500),
     xlim = c(as.Date("2020-02-01"), as.Date(today) - 1),
     las = 1,
     col = "red")

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.2, 
      font = 2)

mtext(text = "Antal",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.2,
      font = 2)


points(admitted$Dato, admitted$Total, type = "b", pch = 19, col = "#2D708EFF", cex = 1.2)
text(x = as.Date("2020-04-05"), y = -2, labels = "Nyindlagte", col = "#2D708EFF", cex = 1.4, font = 2)
text(x = as.Date("2020-05-10"), y = 400, labels = "Positive tests", col = "red", cex = 1.5, font = 2)
text(x = as.Date("2020-04-05"), y = 110, labels = "25. marts", col = "#2D708EFF", cex = 0.8, font = 4)
text(x = as.Date("2020-04-13"), y = 485, labels = "3. april", col = "red", cex = 0.8, font = 4)

dev.off()

# Extra ------------------------------------------------------------------

png("../figures/pct_hosp_deaths.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))

plot(tests$Date + 1, tests$pct_confirmed * 10, 
     type = "b", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,200),
     las = 1, 
     col = "blue",
     yaxt='n')

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

mtext(text = "Relativ skala",
      side = 2,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

#axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

points(admitted$Dato, admitted$Total, type = "b", pch = 19, col = "#2D708EFF", cex = 1.2)
points(deaths$Dato -8, deaths$Antal_døde * 4, type = "b", pch = 21, col = "red", cex = 1.2)
text(x = as.Date("2020-03-29"), y = 5, labels = "Nyindlagte", col = "#2D708EFF", cex = 1, font = 2)
text(x = as.Date("2020-04-30"), y = 140, labels = "Procent positive tests", col = "blue", cex = 1, font = 2)
text(x = as.Date("2020-05-28"), y = 45, labels = "Døde (forskudt 8 dage)", col = "red", cex = 1, font = 2)

dev.off()




ra <- function(x, n = 7){stats::filter(x, rep(1 / n, n), sides = 2)}
tests %<>% mutate(running_avg_pct = ra(pct_confirmed),
                  running_avg_pos = ra(NewPositive))

admitted %<>% mutate(running_avg = ra(Total))

png("../figures/rt_cases_pos.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))

plot(rt_cases$date_sample, rt_cases$estimate, 
     type = "l", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,2),
     las = 1, 
     col = "darkgray",
     lwd = 2,
     xlim = c(as.Date("2020-05-01"), as.Date(today) - 1))

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

mtext(text = "Kontakttal-værdi",
      side = 2,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

#axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

#points(tests$Date, tests$pct_confirmed, type = "b", pch = 19, col = rgb(red = 0, green = 0, blue = 1, alpha = 0.2), cex = 1.2)
#points(tests$Date, tests$running_avg_pct, type = "l", pch = 19, col = "blue", cex = 1.2, lwd = 2)
points(tests$Date, tests$NewPositive/170, type = "b", pch = 19, col = rgb(red = 1, green = 0, blue = 0, alpha = 0.2), cex = 1.2)
points(tests$Date, tests$running_avg_pos/170, type = "l", pch = 19, col = "red", cex = 1.2, lwd = 2)
text(x = as.Date("2020-05-15"), y = 0.05, labels = "Antal positive tests", col = "red", cex = 1, font = 2)
text(x = as.Date("2020-06-26"), y = 1.3, labels = "Kontakttal: smittede", col = "darkgray", cex = 1, font = 2)
abline(h = 1, col = "gray")
abline(v = as.Date("2020-06-13"), col = "gray", lty = 3)
abline(v = as.Date("2020-06-23"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-09"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-23"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-27"), col = "gray", lty = 3)

dev.off()

png("../figures/rt_cases_pct.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))

plot(rt_cases$date_sample, rt_cases$estimate, 
     type = "l", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,2),
     las = 1, 
     col = "darkgray",
     lwd = 2,
     xlim = c(as.Date("2020-05-01"), as.Date(today ) - 1))

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 4, 
      cex = 1.4,
      font = 2)

mtext(text = "Kontakttal-værdi",
      side = 2,#side 1 = bottom
      line = 4, 
      cex = 1.4,
      font = 2)

#axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

points(tests$Date, tests$pct_confirmed, type = "b", pch = 19, col = rgb(red = 0, green = 0, blue = 1, alpha = 0.2), cex = 1.2)
points(tests$Date, tests$running_avg_pct, type = "l", pch = 19, col = "blue", cex = 1.2, lwd = 2)
#points(tests$Date, tests$NewPositive/100, type = "b", pch = 19, col = rgb(red = 1, green = 0, blue = 0, alpha = 0.2), cex = 1.2)
#points(tests$Date, tests$running_avg_pos/100, type = "l", pch = 19, col = "red", cex = 1.2, lwd = 2)
text(x = as.Date("2020-05-15"), y = 0.2, labels = "Procent positive tests", col = "blue", cex = 1, font = 2)
text(x = as.Date("2020-06-24"), y = 1.4, labels = "Kontakttal: smittede", col = "darkgray", cex = 1, font = 2)
abline(h = 1, col = "gray")
abline(v = as.Date("2020-06-13"), col = "gray", lty = 3)
abline(v = as.Date("2020-06-23"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-09"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-23"), col = "gray", lty = 3)
abline(v = as.Date("2020-07-27"), col = "gray", lty = 3)

dev.off()


png("../figures/rt_admitted.png", width = 20, height = 16, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))

plot(rt_admitted$date_sample, rt_admitted$estimate, 
     type = "l", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,2),
     las = 1, 
     col = "darkgray",
     lwd = 2,
     xlim = c(as.Date("2020-05-01"), as.Date(today) - 1))

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 4, 
      cex = 1.4,
      font = 2)

mtext(text = "Kontakttal-værdi",
      side = 2,#side 1 = bottom
      line = 4, 
      cex = 1.4,
      font = 2)

#axis(side = 4, col.axis = "black", las = 1, cex.axis = 1.2, at = pretty(range(tests_from_may$pct_confirmed)))

points(admitted$Dato, admitted$Total/24, type = "b", pch = 19, col = rgb(red = 0, green = 0.4, blue = 0.6, alpha = 0.2), cex = 1.2)
points(admitted$Dato, admitted$running_avg/24, type = "l", pch = 19, col = "#2D708EFF", cex = 1.2, lwd = 2)
#points(tests$Date, tests$NewPositive/100, type = "b", pch = 19, col = rgb(red = 1, green = 0, blue = 0, alpha = 0.2), cex = 1.2)
#points(tests$Date, tests$running_avg_pos/100, type = "l", pch = 19, col = "red", cex = 1.2, lwd = 2)
text(x = as.Date("2020-05-15"), y = 0.03, labels = "Nyindlagte", col = "#2D708EFF", cex = 1, font = 2)
text(x = as.Date("2020-06-27"), y = 1.5, labels = "Kontakttal: indlagte", col = "darkgray", cex = 1, font = 2)
abline(h = 1, col = "gray")
abline(v = as.Date("2020-05-28"), col = "gray", lty = 3)
abline(v = as.Date("2020-06-12")-0.3, col = "gray", lty = 3)
abline(v = as.Date("2020-06-18")+0.5, col = "gray", lty = 3)
abline(v = as.Date("2020-07-12"), col = "gray", lty = 3)
abline(v = as.Date("2020-08-09")+0.5, col = "gray", lty = 3)

dev.off()



                 