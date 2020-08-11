library(tidyverse)
library(magrittr)


admitted <- read_csv2("../data/SSIdata_200811/newly_admitted_over_time.csv")
deaths <- read_csv2("../data/SSIdata_200811/deaths_over_time.csv")
tests <- read_csv2("../data/SSIdata_200811/test_pos_over_time.csv")

tests %<>% 
  mutate(Date = as.Date(Date)) %>%
  mutate(pct_confirmed = NewPositive/Tested * 100)

deaths %<>% 
  mutate(Dato = as.Date(Dato)) 

admitted %<>% slice(1:(n()-2)) #exclude last two days that may not be updated
deaths %<>% slice(1:(n()-3)) #exclude last two days that may not be updated AND summary row
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
     cex.axis = 1.2, 
     ylim = c(0,500),
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
     cex.axis = 1.2, 
     ylim = c(0,27000),
     las = 1)

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.2, 
      font = 2)

mtext(text = "Antal",
      side = 2,#side 1 = bottom
      line = 5,
      cex = 1.2,
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

text(x = as.Date("2020-06-14"), y = 0.6, labels = "Procent positive", col = "blue", cex = 1.5, font = 2)
text(x = as.Date("2020-05-16"), y = 0.07, labels = "Antal positive", col = "red", cex = 1.5, font = 2)

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

text(x = as.Date("2020-04-27"), y = 65, labels = "Nyindlagte", col = "#2D708EFF", cex = 1.5, font = 2)
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