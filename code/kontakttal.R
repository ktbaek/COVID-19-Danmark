library(tidyverse)
library(magrittr)
library(runner)

today <- "2020-08-21"

quartzFonts(lato = c("Lato-Regular", "Lato-Bold", "Lato-Italic", "Lato-BoldItalic"))

tests <- read_csv2("../data/SSIdata_200820/Test_pos_over_time.csv")
rt_cases <- read_csv2("../data/SSIdata_200820/Rt_cases_2020_08_18.csv")

rt_cases %<>% rename(Date = date_sample)

tests %<>% 
  mutate(Date = as.Date(Date)) %>%
  mutate(pct_confirmed = NewPositive/Tested * 100)



tests %<>% full_join(rt_cases, by = "Date")

tests %<>% slice(96:(n()-4))

window = 11


tests %<>% mutate(slope = runner(
  x = tests,
  k = window,
  lag = 0,
  f = function(x) {
    model <- lm(NewPositive ~ Date, data = x)
    coefficients(model)["Date"]
  }
)) %>% mutate(slope_pct = runner(
  x = tests,
  k = window,
  lag = 0,
  f = function(x) {
    model <- lm(pct_confirmed ~ Date, data = x)
    coefficients(model)["Date"]
  }
)) 





R2 <- function(window, l, df) {

  df %<>% mutate(s = runner(
    x = df,
    k = window,
    lag = l,
    f = function(x) {
      model <- lm(pct_confirmed ~ Date, data = x)
      coefficients(model)["Date"]
    }
  )) 
    
  df %<>% slice(5:(n())) %>% mutate(s = 2^(s*20))

  return(summary(lm(estimate ~ s, df))$adj.r.squared)

}

#combos <- expand(data.frame("window" = c(7:14), "delay" = c(0:7)), window,delay)

#combos %<>% rowwise() %>% mutate(R2 = R2(window, delay, tests)) %>% data.frame %>% arrange(desc(R2))


tests %<>%
  mutate(x1 = Date - window + 1,
         x2 = Date,
         y1 = NewPositive - slope * (window - 1),
         y2 = NewPositive)

ra <- function(x, n = window){stats::filter(x, rep(1 / n, n), sides = 2)}
tests %<>% mutate(running_avg_pct = ra(pct_confirmed),
                  running_avg_pos = ra(NewPositive))

tests %<>% slice(5:(n()))

tests %<>% mutate(slope_2 = 2^(slope/10),
                  slope_pct_2 = 2^(slope_pct * 20))

png("../figures/pos_slopes.png", width = 20, height = 14, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))
plot(tests$Date, tests$NewPositive, 
     type = "b", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,200),
     xlim = c(as.Date("2020-05-01"), as.Date(today) - 1),
     las = 1,
     col = rgb(red = 1, green = 0, blue = 0, alpha = 0.6))

segments(tests$x1, tests$y1, tests$x2, tests$y2, col = "gray")

mtext(text = "Antal positive tests",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.4,
      font = 2,
      col = "black")

dev.off()



png("../figures/slope_rt_regression.png", width = 20, height = 14, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))
plot(tests$slope_pct_2, tests$estimate, 
     type = "p", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     las = 1,
     xlim = c(0,2), 
     col = rgb(red = 1, green = 0, blue = 0, alpha = 0.6))

mtext(text = "Hældning (positive tests per dag)",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

mtext(text = "Kontakttal",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.4,
      font = 2)

abline(h = 1, col = "gray", lty = 3)
abline(v = 1, col = "gray", lty = 3)

abline(lm(estimate ~ slope_pct_2, tests), col = "gray", lty = 1)
legend("topleft", bty="n", legend=paste0("R2 = ", format(summary(lm(estimate ~ slope_pct_2, tests))$adj.r.squared, digits=2)), cex = 1.5)

dev.off()

# res <- as.double(summary(lm(estimate ~ slope, tests))$residual)
# par(family = "lato", mar = c(5,8,1,2))
# plot(tests$Date, tests$estimate - 1,
#      type = "l",
#      pch = 19,
#      ylab = "", 
#      xlab = "", 
#      axes = TRUE,
#      cex = 1.2, 
#      cex.axis = 1.4, 
#      las = 1,
#      lwd = 2, 
#      col = "darkgray",
#      ylim = c(-0.5, 0.5),
#      xlim = c(as.Date("2020-05-01"), as.Date(today) - 1))
# 
# mtext(text = "Hældning (positive tests per dag)",
#       side = 1,#side 1 = bottom
#       line = 3, 
#       cex = 1.4,
#       font = 2)
# 
# mtext(text = "Kontakttal",
#       side = 2,#side 1 = bottom
#       line = 4,
#       cex = 1.4,
#       font = 2)
# 
# 
# arrows(tests$Date,0, tests$Date, res, lwd = 2, col = "lightgray", code = 0)
# 
# 
# 
png("../figures/rt_vs_slope.png", width = 20, height = 14, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,6))
plot(tests$Date, tests$slope, 
     type = "l", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(-10,10),
     xlim = c(as.Date("2020-05-01"), as.Date(today) - 1),
     las = 1,
     lwd = 2, 
     col = "red")

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

mtext(text = "Hældning (positive tests per dag)",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.4,
      font = 2,
      col = "red")



abline(h = 0, col = "gray", lty = 3)

par(new = TRUE)
plot(tests$Date, tests$estimate, type = "l", pch = 19, col = "blue", cex = 1.2, axes = FALSE, xlab = "", ylab = "", ylim = c(0,2), lwd = 2)

points(as.Date("2020-06-15"), 1.7, pch = 19, col = "red", cex = 2)
segments(as.Date("2020-06-05"), 1.7, as.Date("2020-06-15"), 1.7, col = "red", lwd = 2)
text(x = as.Date("2020-06-10"), y = 1.8, labels = "Vindue: 10 dage", col = "red", cex = 1.2, font = 1)

axis(side = 4, las = 1, cex.axis = 1.2, at = c(0,1,2))

mtext(text = "Kontakttal",
      side = 4,#side 1 = bottom
      line = 3,
      cex = 1.2,
      col = "blue",
      font = 2)

dev.off()




png("../figures/rt_vs_slope_2.png", width = 20, height = 14, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))
plot(tests$Date, tests$slope_2, 
     type = "l", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,2),
     xlim = c(as.Date("2020-05-01"), as.Date(today) - 1),
     las = 1,
     lwd = 2, 
     col = "red")

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

mtext(text = "2^hældning (antal positive) eller kontakttal",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.4,
      font = 2)

points(tests$Date, tests$estimate, type = "l", pch = 19, col = "blue", cex = 1.2, lwd = 2)

abline(h = 1, col = "gray", lty = 3)

points(as.Date("2020-06-15"), 1.7, pch = 19, col = "red", cex = 2)
segments(as.Date("2020-06-05"), 1.7, as.Date("2020-06-15"), 1.7, col = "red", lwd = 2)
text(x = as.Date("2020-06-10"), y = 1.8, labels = "Vindue: 10 dage", col = "red", cex = 1.2, font = 1)

dev.off()


png("../figures/rt_vs_slope_pct_2.png", width = 20, height = 14, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))
plot(tests$Date, tests$slope_pct_2,
     type = "l", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,2),
     xlim = c(as.Date("2020-05-01"), as.Date(today) - 1),
     las = 1,
     lwd = 2, 
     col = "orange")

mtext(text = "Dato",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

mtext(text = "2^hældning (andel positive) eller kontakttal",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.4,
      font = 2)

points(tests$Date, tests$estimate, type = "l", pch = 19, col = "blue", cex = 1.2, lwd = 2)

abline(h = 1, col = "gray", lty = 3)

points(as.Date("2020-06-15"), 1.7, pch = 19, col = "orange", cex = 2)
segments(as.Date("2020-06-05"), 1.7, as.Date("2020-06-15"), 1.7, col = "orange", lwd = 2)
text(x = as.Date("2020-06-10"), y = 1.8, labels = "Vindue: 10 dage", col = "orange", cex = 1.2, font = 1)
dev.off()


df <- data.frame("dag" = c(0:11), "antal" = rep(100, 12))
#df <- data.frame("dag" = c(0:11), "antal" = c(100, 120, 160, 170, 180, 220, 280, 300, 240, 180, 125, 102))


png("../figures/rt_eksempel_2.png", width = 20, height = 14, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))
plot(df$dag, df$antal, 
     type = "b", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,300),
     las = 1,
     col = rgb(red = 1, green = 0, blue = 0, alpha = 0.7))

mtext(text = "Dag",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

mtext(text = "Antal smittede",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.4,
      font = 2,
      col = "black")

text(x = 10.5, y = 70, labels = "Rt = 1.0", cex = 1.4, font = 2)
arrows(10.5, 80, 10.9, 95, length = 0.1)

dev.off()

df %<>% mutate(slope = runner(
  x = df,
  k = window,
  lag = 0,
  f = function(x) {
    model <- lm(antal ~ dag, data = x)
    coefficients(model)["dag"]
  }
  )) %>%
  mutate(slope = round(slope, 2))

print(df$slope[12])


