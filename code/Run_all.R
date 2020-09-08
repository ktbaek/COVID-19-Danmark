library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)
library(colorspace)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

today <- "2020-09-08"

source("read_tidy_data.R")
source("plot_colors.R")
source("article_Rt_plots.R")
source("age_municipality_plots.R")