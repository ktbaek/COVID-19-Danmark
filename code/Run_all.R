library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)
library(colorspace)
library(ggthemes)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

today <- "2020-10-05"

source("read_tidy_data.R")
cat("Read and tidy DONE\n")

source("plot_styles.R")

source("article_Rt_plots.R")
cat("Whole country plots DONE\n")

source("municipality_plots.R")
cat("Municipality plots DONE\n")

source("age_plots.R")
cat("Age plots DONE\n")
