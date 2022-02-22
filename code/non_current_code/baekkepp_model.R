# library(tidyverse)
# library(magrittr)
# library(lubridate)
# library(scales)
# library(colorspace)
library(runner)

# Settings ----------------------------------------------------------------
Sys.setlocale("LC_ALL", "da_DK.UTF-8")

source("plot_styles.R")
# running average function, backwards
ra_back <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 1)
}

# running average function, middle point
ra_mid <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 2)
}


# Read and tidy death data ------------------------------------------------

today_string <- paste0(str_sub(today, 3, 4), str_sub(today, 6, 7), str_sub(today, 9, 10))

deaths <- read_csv2(paste0("../data/SSIdata_", today_string, "/Deaths_over_time.csv"))

deaths %<>%
  mutate(Date = as.Date(Dato)) %>%
  select(Date, Antal_døde)

deaths %<>% slice(1:(n() - 2)) # exclude summary row and last day that may not be updated

# add missing leading dates to deaths dataframe
leading_dates <- tribble(~Date, ~Antal_døde,
                       as.Date("2020-02-10"), 0,
                       as.Date("2020-03-10"), 0)

leading_dates %<>% complete(Date = seq.Date(min(Date), max(Date), by="day"), fill = list(Antal_døde = 0)) 

deaths_w_lead <- deaths %>% 
  bind_rows(leading_dates) %>%
  arrange(Date)

unique(abs(diff(unique(deaths_w_lead$Date)))) == 1 # test for daily continuity

# Calculate model values --------------------------------------------------

lead_new <- 26
lag_active <- 5

# Calculate new infected. Date by infection time point (26 days prior to death running avg middle point)
model_data <- deaths_w_lead %>%
  mutate(running_avg_deaths = ra_back(Antal_døde)) %>%
  arrange(Date) %>%
  mutate(
    new_1 = lead(running_avg_deaths, lead_new) / 0.006,
    new_2 = lead(running_avg_deaths, lead_new) / 0.0037,
    new_3 = lead(running_avg_deaths, lead_new) / 0.0029,
    new_4 = lead(running_avg_deaths, lead_new) / 0.0024
  )

# Calculate running avg for new infected

model_data %<>%
  mutate(
    new_1_avg = ra_mid(new_1),
    new_2_avg = ra_mid(new_2),
    new_3_avg = ra_mid(new_3),
    new_4_avg = ra_mid(new_4)
  )

# Calculate cumulative sum for new infected

model_data %<>%
  mutate(
    sum_1 = cumsum(new_1),
    sum_2 = cumsum(new_2),
    sum_3 = cumsum(new_3),
    sum_4 = cumsum(new_4))

# Calculate active infected based on 10 day infection window. Date by symptom onset (5 days after infection time point)
active_period <- 10

model_data %<>%
  mutate(
    active_1 = sum_run(x = lag(model_data$new_1, lag_active), k = active_period, idx = as.Date(model_data$Date), na_rm = FALSE),
    active_2 = sum_run(x = lag(model_data$new_2, lag_active), k = active_period,idx = as.Date(model_data$Date), na_rm = FALSE),
    active_3 = sum_run(x = lag(model_data$new_3, lag_active), k = active_period,idx = as.Date(model_data$Date), na_rm = FALSE),
    active_4 = sum_run(x = lag(model_data$new_4, lag_active), k = active_period,idx = as.Date(model_data$Date), na_rm = FALSE)
  )



# Plotting settings ----------------------------------------------------------------

plot_data <- model_data %>%
  filter(Date > as.Date("2020-02-15"))


# Custom base plot functions -------------------------------------------------

standard_plot <- function(title,
                          max_y_value,
                          y_label = "Antal",
                          x_label = "Dato",
                          y_label_dist = 4,
                          x_by = "2 months",
                          start_date = "2020-02-15",
                          end_date = today) {
  
  par(family = "lato", mar = c(5, 8, 5, 2))
  
  plot(NULL,
       type = "n",
       ylab = "",
       xlab = "",
       axes = FALSE,
       cex = 1.2,
       cex.axis = cex_axis,
       ylim = c(0, max_y_value),
       xlim = c(as.Date(start_date), as.Date(end_date) - 1),
  )
  
  
  mtext(
    text = title,
    side = 3, # side 1 = bottom
    line = 1,
    cex = 1.5,
    font = 2
  )
  
  mtext(
    text = x_label,
    side = 1, # side 1 = bottom
    line = 3,
    cex = cex_labels,
    font = 2
  )
  
  mtext(
    text = y_label,
    side = 2, # side 1 = bottom
    line = y_label_dist,
    cex = cex_labels,
    font = 2
  )
  
  box(which = "plot", lty = "solid")
  
  axis.Date(1, at = seq(as.Date("2020-03-01"), as.Date(end_date) - 1, x_by), format = "%b", cex.axis = cex_axis)
  axis.Date(1, at = seq(as.Date("2020-03-01"), as.Date(end_date) - 1, "1 month"), labels = FALSE, cex.axis = cex_axis)
  
  
}

double_plot <- function(title,
                        max_y_value,
                        y_label = "Antal",
                        x_label = "Dato",
                        y2_label,
                        y_label_dist = 4,
                        x_by = "2 months",
                        start_date = "2020-02-15",
                        end_date = today) {
  
  y2_label_pos <- as.double(0.21 * (as.Date(end_date) - as.Date(start_date)))
  
  par(family = "lato", mar = c(5, 8, 5, 6))
  
  plot(NULL,
       type = "n",
       ylab = "",
       xlab = "",
       axes = FALSE,
       cex = 1.2,
       cex.axis = cex_axis,
       ylim = c(0, max_y_value),
       xlim = c(as.Date(start_date), as.Date(end_date) - 1),
  )
  
  
  mtext(
    text = title,
    side = 3, # side 1 = bottom
    line = 1,
    cex = 1.5,
    font = 2
  )
  
  mtext(
    text = x_label,
    side = 1, # side 1 = bottom
    line = 3,
    cex = cex_labels,
    font = 2
  )
  
  mtext(
    text = y_label,
    side = 2, # side 1 = bottom
    line = y_label_dist,
    cex = cex_labels,
    font = 2
  )
  
  
  box(which = "plot", lty = "solid")
  
  axis.Date(1, at = seq(as.Date("2020-03-01"), as.Date(end_date) - 1, x_by), format = "%b", cex.axis = cex_axis)
  axis.Date(1, at = seq(as.Date("2020-03-01"), as.Date(end_date) - 1, "1 month"), labels = FALSE, cex.axis = cex_axis)
  
  text(par("usr")[2] + y2_label_pos, mean(par("usr")[3:4]), y2_label, srt = -90, xpd = TRUE, adj = 0.5, cex = cex_labels, font = 2)
}

ra_lwd  <- 4
cex_labels <- 1.4
cex_axis <- 1.4

max_new <- ceiling(max(plot_data$new_3_avg, na.rm = TRUE) / 1000) * 1000
max_new_2 <- ceiling(max(plot_data$new_2_avg, na.rm = TRUE) / 1000) * 1000
max_active <- ceiling(max(plot_data$active_3, na.rm = TRUE) / 10000) * 10000
max_active_2 <- ceiling(max(plot_data$active_2, na.rm = TRUE) / 10000) * 10000

# Plot new infected -------------------------------------------------------

png("../figures/BK_new_infected.png", width = 20, height = 16, units = "cm", res = 300)

standard_plot(
  title = "Estimeret dagligt antal nye smittede",
  max_y_value = max_new,
  y_label_dist = 5,
  x_by = "1 month"
)


abline(h=seq(2000,max_new, by = 2000) , col="gray", lty=3)

points(plot_data$Date, plot_data$new_1_avg, type = "l", col = alpha(pos_col, alpha = 0.6), cex = 1.2, lwd = ra_lwd, lend = 1)
points(plot_data$Date, plot_data$new_2_avg, type = "l", col = alpha(pos_col, alpha = .8), cex = 1.2, lwd = ra_lwd, lend = 1)
points(plot_data$Date, plot_data$new_3_avg, type = "l", col = alpha(pos_col, alpha = 1), cex = 1.2, lwd = ra_lwd, lend = 1)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_new, by = 2000), labels = seq(0, max_new, by = 2000))

legend("topleft",
  title = "Scenarier",
  inset = 0.04,
  legend = c("Scenarie 1 (IFR = 0.6 %)", "Scenarie 2 (IFR = 0.37 %)", "Scenarie 3 (IFR = 0.29 %)"),
  col = c(alpha(pos_col, alpha = .6), alpha(pos_col, alpha = .8), alpha(pos_col, alpha = 1)),
  lty = 1,
  cex = 1,
  box.lty = 0,
  lwd = 4
)

text_lead = lead_new

text(x = as.Date(today) - text_lead, y = tail(na.omit(plot_data$new_3_avg), 1) + 50, labels = round(tail(na.omit(plot_data$new_3_avg), 1)/100) * 100, col = alpha(pos_col, alpha = 1), cex = 0.8, font = 2, adj = 0)
text(x = as.Date(today) - text_lead, y = tail(na.omit(plot_data$new_2_avg), 1), labels = round(tail(na.omit(plot_data$new_2_avg), 1)/100) * 100, col = alpha(pos_col, alpha = .8), cex = 0.8, font = 2, adj = 0)
text(x = as.Date(today) - text_lead, y = tail(na.omit(plot_data$new_1_avg), 1), labels = round(tail(na.omit(plot_data$new_1_avg), 1)/100) * 100, col = alpha(pos_col, alpha = .6), cex = 0.8, font = 2, adj = 0)

dev.off()


# Plot active infected ----------------------------------------------------

png("../figures/BK_active_infected.png", width = 20, height = 16, units = "cm", res = 300)


standard_plot(
  title = "Estimeret antal aktivt smittede",
  max_y_value = max_active,
  y_label_dist = 6,
  x_by = "1 month"
)

abline(h=seq(20000,max_active, by = 20000) , col="gray", lty=3)
points(plot_data$Date, plot_data$active_1, type = "l", col = alpha(pos_col, alpha = 0.6), cex = 1.2, lwd = ra_lwd, lend = 1)
points(plot_data$Date, plot_data$active_2, type = "l", col = alpha(pos_col, alpha = 0.8), cex = 1.2, lwd = ra_lwd, lend = 1)
points(plot_data$Date, plot_data$active_3, type = "l", col = alpha(pos_col, alpha = 1), cex = 1.2, lwd = ra_lwd, lend = 1)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_active, by = 20000), labels = seq(0, max_active, by = 20000))

legend("topleft",
       title = "Scenarier",
       inset = 0.04,
       legend = c("Scenarie 1 (IFR = 0.6 %)", "Scenarie 2 (IFR = 0.37 %)", "Scenarie 3 (IFR = 0.29 %)"),
       col = c(alpha(pos_col, alpha = .6), alpha(pos_col, alpha = .8), alpha(pos_col, alpha = 1)),
       lty = 1,
       cex = 1,
       box.lty = 0,
       lwd = 4
)


text_lead = lead_new - lag_active

text(x = as.Date(today) - text_lead, y = tail(na.omit(plot_data$active_3), 1) + 1000, labels = round(tail(na.omit(plot_data$active_3), 1)/1000) * 1000, col = alpha(pos_col, alpha = 1), cex = 0.8, font = 2, adj = 0)
text(x = as.Date(today) - text_lead, y = tail(na.omit(plot_data$active_2), 1) , labels = round(tail(na.omit(plot_data$active_2), 1)/1000) * 1000, col = alpha(pos_col, alpha = .8), cex = 0.8, font = 2, adj = 0)
text(x = as.Date(today) - text_lead, y = tail(na.omit(plot_data$active_1), 1) - 800, labels = round(tail(na.omit(plot_data$active_1), 1)/1000) * 1000, col = alpha(pos_col, alpha = .6), cex = 0.8, font = 2, adj = 0)

dev.off()


# Plot cumulative ---------------------------------------------------------

png("../figures/BK_cumulated.png", width = 20, height = 16, units = "cm", res = 300)

max_y <- ceiling(max(plot_data$sum_3, na.rm = TRUE) / 50000) * 50000

standard_plot(
  title = "Estimeret kumuleret antal smittede",
  max_y_value = max_y,
  y_label_dist = 6,
  x_by = "1 month"
)

abline(h=seq(100000,800000, by = 100000) , col="gray", lty=3)
points(plot_data$Date, plot_data$sum_1, type = "l", col = alpha(pos_col, alpha = 0.6), cex = 1.2, lwd = ra_lwd, lend = 1)
points(plot_data$Date, plot_data$sum_2, type = "l", col = alpha(pos_col, alpha = 0.8), cex = 1.2, lwd = ra_lwd, lend = 1)
points(plot_data$Date, plot_data$sum_3, type = "l", col = alpha(pos_col, alpha = 1), cex = 1.2, lwd = ra_lwd, lend = 1)


axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_y, by = 100000), labels = format(seq(0, max_y, by = 100000), scientific = FALSE))

legend("topleft",
       title = "Scenarier",
       inset = 0.04,
       legend = c("Scenarie 1 (IFR = 0.6 %)", "Scenarie 2 (IFR = 0.37 %)", "Scenarie 3 (IFR = 0.29 %)"),
       col = c(alpha(pos_col, alpha = .6), alpha(pos_col, alpha = .8), alpha(pos_col, alpha = 1)),
       lty = 1,
       cex = 1,
       box.lty = 0,
       lwd = 4
)

dev.off()


# Plot new infected vs admitted -------------------------------------------

png("../figures/BK_new_infected_admitted.png", width = 20, height = 16, units = "cm", res = 300)

double_plot(
  title = "Estimeret dagligt antal nye smittede og\nobserveret antal nyindlæggelser",
  max_y_value = max_new_2,
  y_label_dist = 6,
  y_label = "Antal nye smittede",
  y2_label = "Nyindlæggelser"
)

abline(h=seq(1000,max_new_2, by = 1000) , col="gray", lty=3)
points(plot_data$Date, plot_data$new_2_avg, type = "l", col = "#ff7356", cex = 1.2, lwd = ra_lwd, lend = 1)
points(admitted$Date, admitted$running_avg_admit * 50, type = "l", col = admit_col, cex = 1.2, lwd = ra_lwd, lend = 1)

axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_new_2, by = 1000), labels = seq(0, max_new_2, by = 1000))
axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_new_2, by = 1000), labels = seq(0, max_new_2/50, by = 20))

legend("topleft",
  # title = "Overall IFR",
  inset = 0.04,
  legend = c("Scenarie 2 (IFR: 0.37 %)", "Nyindlæggelser"),
  col = c(alpha(pos_col, alpha = 0.8), admit_col, pct_col),
  lty = 1,
  cex = 1,
  box.lty = 0,
  lwd = 4
)

dev.off()


# Plot active infected vs cases --------------------------------------------




png("../figures/BK_active_infected_cases.png", width = 20, height = 16, units = "cm", res = 300)



double_plot(
  title = "Estimeret antal aktive smittede og\nobserveret antal positivt testede",
  max_y_value = max_active_2,
  y_label_dist = 6,
  y_label = "Antal smittede",
  y2_label = "Antal positivt testede"
)

abline(h=seq(20000,max_active_2, by = 20000) , col="gray", lty=3)
points(tests$Date, tests$running_avg_pos * 10, type = "l", col = "gray", cex = 1.2, lwd = ra_lwd, lend = 1)
points(plot_data$Date, plot_data$active_2, type = "l", col = "#ff7356", cex = 1.2, lwd = ra_lwd, lend = 1)


axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_active_2, by = 20000), labels = seq(0, max_active_2, by = 20000))
axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_active_2, by = 20000), labels = seq(0, max_active_2/10, by = 2000))

legend("topright",
  # title = "Overall IFR",
  inset = 0.04,
  legend = c("Scenarie 2 (IFR: 0.37 %)", "positivt testede"),
  col = c(alpha(pos_col, alpha = 0.8), "gray"),
  lty = 1,
  cex = 1,
  box.lty = 0,
  lwd = 4
)

dev.off()



png("../figures/BK_active_infected_pct.png", width = 20, height = 16, units = "cm", res = 300)



double_plot(
  title = "Estimeret antal aktive smittede og\nobserveret positivprocent",
  max_y_value = max_active_2,
  y_label_dist = 6,
  y_label = "Antal smittede",
  y2_label = "Positivprocent"
)


abline(h=seq(10000,max_active_2, by = 10000) , col="gray", lty=3)
points(tests$Date, tests$running_avg_pct * 5000, type = "l", col = "gray", cex = 1.2, lwd = ra_lwd, lend = 1)
points(plot_data$Date, plot_data$active_2, type = "l", col = "#ff7356", cex = 1.2, lwd = ra_lwd, lend = 1)




axis(side = 2, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_active_2, by = 10000), labels = seq(0, max_active_2, by = 10000))
axis(side = 4, col.axis = "black", las = 1, cex.axis = cex_axis, at = seq(0, max_active_2, by = 10000), labels = paste0(seq(0, max_active_2/5000, by = 2), "%"))

legend("topright",
       # title = "Overall IFR",
       inset = 0.04,
       legend = c("Scenarie 2 (IFR: 0.37 %)", "Positivprocent"),
       col = c(alpha(pos_col, alpha = 0.8), "lightgray"),
       lty = 1,
       cex = 1,
       box.lty = 0,
       lwd = 4
)

dev.off()



png("../figures/model_twitter_card.png", width = 15, height = 8, units = "cm", res = 300)


par(family = "lato", mar = c(2, 2, 2, 1))

plot(NULL,
     type = "n",
     ylab = "",
     xlab = "",
     axes = FALSE,
     cex = 1.2,
     cex.axis = cex_axis,
     ylim = c(0, max_active),
     xlim = c(as.Date("2020-02-15"), as.Date(today) - 1),
)


points(plot_data$Date, plot_data$active_1, type = "l", col = alpha(pos_col, alpha = 0.6), cex = 1.2, lwd = ra_lwd, lend = 1)
points(plot_data$Date, plot_data$active_2, type = "l", col = alpha(pos_col, alpha = 0.8), cex = 1.2, lwd = ra_lwd, lend = 1)
points(plot_data$Date, plot_data$active_3, type = "l", col = alpha(pos_col, alpha = 1), cex = 1.2, lwd = ra_lwd, lend = 1)

dev.off()

#write_csv2(model_data, "../data/kaspers_data.csv")

image_files <- list.files(path="../figures/")


image_files <- image_files[str_detect(image_files, "^BK")]

add_image_text <- function(filename) {

  img <- image_read(paste0("../figures/", filename))

  img %<>% image_annotate("Kristoffer T. Bæk, Kasper P. Kepp, covid19danmark.dk/model",
                          size = 34,
                          gravity = "southwest",
                          font = "lato",
                          location = geometry_point(30, 30),
                          weight = 300)

  image_write(img, path = paste0("../figures/", filename), format = "png")
}


lapply(image_files, function(x) add_image_text(x))

