library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)
library(colorspace)
library(patchwork)
library(ggthemes)
library(magick)
library(ggrepel)
library(pdftools)
library(ggtext)
library(runner)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

SSI_files <- list.dirs(path="../data/", full.names = FALSE, recursive = FALSE)
last_file <- tail(SSI_files[str_starts(SSI_files, "SSIdata_")], 1)
today_string <- str_sub(last_file, 9, 15)
today <- paste0("20", str_sub(today_string, 1, 2), "-", str_sub(today_string, 3, 4), "-", str_sub(today_string, 5, 6))

source("functions.R")
source("plot_styles.R")
  
source("update_dashboard_data.R")
cat("Dashboard data updated\n")

source("read_tidy_national.R")
source("read_tidy_breakthru.R")
source("read_tidy_weekly_age.R")
source("Read_tidy_muni.R")
cat("Read and tidy DONE\n")

files_sources = list.files("current_plots", full.names = TRUE)
sapply(files_sources, source)
cat("Current plots DONE\n")

source("vax_plots_2.R")
cat("Vaxxxxxx plots DONE\n")

source("exp_admissions.R")
cat("admission plot DONE\n")

source("update_index_md.R")
cat("Index files updated\n")





