library(tidyverse)
library(magrittr)
library(runner)

today <- "2020-09-03"

quartzFonts(lato = c("Lato-Regular", "Lato-Bold", "Lato-Italic", "Lato-BoldItalic"))

tests <- read_csv2("../data/SSIdata_200903/Test_pos_over_time.csv")
rt_cases <- read_csv2("../data/SSIdata_200903/Rt_cases_2020_09_01.csv")

rt_cases %<>% rename(Date = date_sample)

tests %<>% 
  mutate(Date = as.Date(Date)) %>%
  mutate(pct_confirmed = NewPositive/Tested * 100)



tests %<>% full_join(rt_cases, by = "Date")

tests %<>% slice(96:(n()-4))

window = 8


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




png(paste0("../figures/rt_vs_slope_2_",window - 1,"d.png"), width = 20, height = 14, units = "cm", res = 300)
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

mtext(text = "2^hældning (antal positive)",
      side = 2,#side 1 = bottom
      line = 3,
      cex = 1.4,
      font = 2,
      col = "red")

mtext(text = "Kontakttal",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.4,
      font = 2,
      col = "blue")

points(tests$Date, tests$estimate, type = "l", pch = 19, col = "blue", cex = 1.2, lwd = 2)

abline(h = 1, col = "gray", lty = 3)

points(as.Date("2020-05-11"), 1.9, pch = 15, col = "red", cex = 1.5)
segments(as.Date("2020-05-01"), 1.9, as.Date("2020-05-11"), 1.9, col = "red", lwd = 2)
text(x = as.Date("2020-05-01"), y = 2, labels = paste0("Vindue: ", window - 1, " dage"), col = "red", cex = 1.2, font = 1,  adj = 0)

dev.off()


png(paste0("../figures/rt_vs_slope_pct_2_", window - 1, "d.png"), width = 20, height = 14, units = "cm", res = 300)
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

mtext(text = "2^hældning (andel positive)",
      side = 2,#side 1 = bottom
      line = 3,
      cex = 1.4,
      font = 2,
      col = "orange")

mtext(text = "Kontakttal",
      side = 2,#side 1 = bottom
      line = 4,
      cex = 1.4,
      font = 2,
      col = "blue")

points(tests$Date, tests$estimate, type = "l", pch = 19, col = "blue", cex = 1.2, lwd = 2)

abline(h = 1, col = "gray", lty = 3)

points(as.Date("2020-05-11"), 1.9, pch = 15, col = "orange", cex = 1.5)
segments(as.Date("2020-05-01"), 1.9, as.Date("2020-05-11"), 1.9, col = "orange", lwd = 2)
text(x = as.Date("2020-05-01"), y = 2, labels = paste0("Vindue: ", window - 1, " dage"), col = "orange", cex = 1.2, font = 1,  adj = 0)
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


fdr = function(p, fpr) {
  
  fdr = 1 - (p/(p + (fpr * (1 - p))))
  
  return(fdr)
}


png("../figures/fdr_vs_prev.png", width = 20, height = 14, units = "cm", res = 300)
par(family = "lato", mar = c(5,8,1,2))
plot(seq(0:1000)/10000, fdr(seq(0:1000)/10000, 0.01),
     type = "l", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = FALSE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,1),
     xlim = c(0,0.1),
     las = 1,
     lwd = 5,
     col = rgb(red = 0.6, green = 0, blue = 0.4, alpha = 1))

points(seq(0:1000)/10000, fdr(seq(0:1000)/10000, 0.001), type = "l", lwd = 5, pch = 19, cex = 1.2, col = rgb(red = 0, green = 0.6, blue = 0.4, alpha = 1))

box(which = "plot", lty = "solid")

axis(2, at = c(0, 0.2, 0.4, 0.6, 0.8, 1), labels=c("0", "20%", "40%", "60%", "80%", "100%"), cex.axis = 1.4, las = 1)
axis(1, at = c(0, 0.02, 0.04, 0.06, 0.08, 0.1), labels=c("0", "2%", "4%", "6%", "8%", "10%"), cex.axis = 1.4, las = 1)

#points(seq(0:1000)/1000, fdr(seq(0:1000)/1000, 0.0001), type = "b", pch = 19, cex = 1.2, col = rgb(red = 0.4, green = 0.6, blue = 0, alpha = 0.7))

text(x = 0.006, y = 0.8, labels = "99 %", cex = 1.4, adj = 0, font = 2, col = rgb(red = 0.6, green = 0, blue = 0.4, alpha = 1))

text(x = 0.008, y = 0.18, labels = "99,9 %", cex = 1.4, adj = 0, font = 2, col = rgb(red = 0, green = 0.6, blue = 0.4, alpha = 1))


mtext(text = "Prævalens",
      side = 1,#side 1 = bottom
      line = 3, 
      cex = 1.4,
      font = 2)

mtext(text = "Falsk opdagelsesrate",
      side = 2,#side 1 = bottom
      line = 5,
      cex = 1.4,
      font = 2,
      col = "black")

  
dev.off()
 
  
  df <- data.frame(p = rep(seq(1:100)/1000, 1, each = 100), fpr = rep(seq(1:100)/1000, 100, each = 1))
  
  df %<>% mutate(ratio = p/fpr, fdr = fdr(p, fpr))
  
  png("../figures/fdr_vs_ratio.png", width = 20, height = 14, units = "cm", res = 300)
  par(family = "lato", mar = c(5,8,1,2))
  plot(0,
       type = "p", 
       pch = 19, 
       ylab = "", 
      xlab = "", 
       axes = FALSE,
       cex = 1.2, 
       cex.axis = 1.4, 
       ylim = c(0,1),
       xlim = c(0.01,100),
      log = "x",
      
       
       las = 1,
       col = "white")
  
  abline(v = 0.01, col = "gray", lty = 3)
  abline(v = 0.1, col = "gray", lty = 3)
  abline(v = 1, col = "gray", lty = 3)
  abline(v = 10, col = "gray", lty = 3)
  abline(v = 100, col = "gray", lty = 3)
  abline(h = 0.5, col = "gray", lty = 3)
  abline(h = 0, col = "gray", lty = 3)
  abline(h = 1, col = "gray", lty = 3)
  
  
  points(df$ratio, df$fdr, type = "p", pch = 19, cex = 1.2,  col = rgb(red = df$fdr, green = 0.8-df$fdr/1.5, blue = 0.4, alpha = 0.2))
  
  
  box(which = "plot", lty = "solid")
  
  axis(1, at = c(0.01, 0.1, 1, 10, 100), labels=c("0,01", "0,1", "1", "10", "100"), cex.axis = 1.4)
  axis(2, at = c(0, 0.2, 0.4, 0.6, 0.8, 1), labels=c("0", "20%", "40%", "60%", "80%", "100%"), cex.axis = 1.4, las = 1)
  
  
  
  mtext(text = "Prævalens : falsk-positivrate",
        side = 1,#side 1 = bottom
        line = 3, 
        cex = 1.4,
        font = 2)
  
  mtext(text = "Falsk opdagelsesrate",
        side = 2,#side 1 = bottom
        line = 5,
        cex = 1.4,
        font = 2,
        col = "black")
  
  dev.off()



plot(seq(0:1000)/1000, fdr(seq(0:1000)/1000, 0.01),
     type = "b", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     ylim = c(0,1),
     xlim = c(0,0.2),
     las = 1,
     col = rgb(red = 1, green = 0, blue = 0, alpha = 0.7))

points(seq(0:1000)/1000, fdr(seq(0:1000)/1000, 0.001), type = "b", pch = 19, cex = 1.2, col = rgb(red = 0.7, green = 0.3, blue = 0, alpha = 0.7))

#points(seq(0:1000)/1000, fdr(seq(0:1000)/1000, 0.0001), type = "b", pch = 19, cex = 1.2, col = rgb(red = 0.4, green = 0.6, blue = 0, alpha = 0.7))

text(x = 0.025, y = 0.5, labels = "FPR = 1 %", cex = 1.4, font = 2, col = rgb(red = 1, green = 0, blue = 0, alpha = 0.9))

text(x = 0.024, y = 0.13, labels = "FPR = 0,1 %", cex = 1.4, font = 2, col = rgb(red = 0.7, green = 0.3, blue = 0, alpha = 0.9))
