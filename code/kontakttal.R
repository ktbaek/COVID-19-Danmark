library(tidyverse)
library(magrittr)
library(runner)

tests <- read_csv2("../data/SSIdata_200820/Test_pos_over_time.csv")
rt_cases <- read_csv2("../data/SSIdata_200820/Rt_cases_2020_08_18.csv")

rt_cases %<>% rename(Date = date_sample)

tests %<>% 
  mutate(Date = as.Date(Date)) %>%
  mutate(pct_confirmed = NewPositive/Tested * 100)



tests %<>% full_join(rt_cases, by = "Date")

tests %<>% slice(96:(n()-4))

window = 10


tests %<>% mutate(slope = runner(
  x = tests,
  k = window,
  lag = 0,
  f = function(x) {
    model <- lm(NewPositive ~ Date, data = x)
    coefficients(model)["Date"]
  }
)) 


tests %<>%
  mutate(x1 = Date - window + 1,
         x2 = Date,
         y1 = NewPositive - slope * (window - 1),
         y2 = NewPositive)

ra <- function(x, n = window){stats::filter(x, rep(1 / n, n), sides = 2)}
tests %<>% mutate(running_avg_pct = ra(pct_confirmed),
                  running_avg_pos = ra(NewPositive))

tests %<>% slice(5:(n()))

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
     col = rgb(red = 1, green = 0, blue = 0, alpha = 0.2))

#points(tests$Date, tests$running_avg_pos, type = "l", pch = 19, col = "red", cex = 1.2, lwd = 2)

segments(tests$x1, tests$y1, tests$x2, tests$y2, col = "gray")

dev.off()





plot(tests$slope, tests$estimate, 
     type = "p", 
     pch = 19, 
     ylab = "", 
     xlab = "", 
     axes = TRUE,
     cex = 1.2, 
     cex.axis = 1.4, 
     las = 1,
     col = rgb(red = 1, green = 0, blue = 0, alpha = 0.7))

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
abline(v = 0, col = "gray", lty = 3)

print(summary(lm(tests$slope ~ tests$estimate)))






  