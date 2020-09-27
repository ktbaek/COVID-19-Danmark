library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)
library(colorspace)
library(ggthemes)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

today <- "2020-09-25"

date_txt <- str_to_lower(format(as.Date(today), "%d. %B, %Y"))
writeLines(date_txt, "../data/today.txt")

source("read_tidy_data.R")
cat("Read and tidy DONE\n")

source("plot_colors.R")

source("article_Rt_plots.R")
cat("Article and Rt plots DONE\n")

source("municipality_plots.R")
cat("Municipality plots DONE\n")

source("age_plots.R")
cat("Age plots DONE\n")
