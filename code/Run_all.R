library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)
library(colorspace)
library(ggthemes)
library(magick)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

today <- "2020-10-20"

source("update_dashboard_data.R")
cat("Dashboard data updated\n")

source("read_tidy_data.R")
cat("Read and tidy DONE\n")

source("plot_styles.R")

source("article_Rt_plots.R")
cat("Whole country plots DONE\n")

source("municipality_plots.R")
cat("Municipality plots DONE\n")

source("age_plots.R")
cat("Age plots DONE\n")

source("English_plots.R")
cat("English plots DONE\n")

source("add_image_text.R")
cat("Image text added\n")

source("exp_baekkepp_model.R")
cat("Model updated\n")

source("update_index_md.R")
cat("Index files updated\n")





