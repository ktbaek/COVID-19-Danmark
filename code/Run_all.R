library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)
library(colorspace)
library(ggthemes)
library(magick)
library(ggrepel)
library(pdftools)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

SSI_files <- list.dirs(path="../data/", full.names = FALSE, recursive = FALSE)
last_file <- tail(SSI_files[str_starts(SSI_files, "SSIdata_")], 1)
today_string <- str_sub(last_file, 9, 15)
today <- paste0("20", str_sub(today_string, 1, 2), "-", str_sub(today_string, 3, 4), "-", str_sub(today_string, 5, 6))

source("plot_styles.R")
  
source("update_dashboard_data.R")
cat("Dashboard data updated\n")

source("read_tidy_national.R")
cat("Read and tidy, national DONE\n")

source("national_plots.R")
cat("Whole country plots DONE\n")

source("vax_plots_2.R")
cat("Vaxxxxxx plots DONE\n")

if(wday(as.Date(today)) %in% c(1, 4:7)){ 
  
  source("B117.R")
  cat("Bri'ish mu'ant DONE\n")

  }

source("Read_tidy_muni.R")
cat("Read and tidy, municipality DONE\n")
 
source("municipality_plots.R")
cat("Municipality plots DONE\n")

source("exp_admissions.R")
cat("admission plot DONE\n")

if(wday(as.Date(today)) == 5){ 
  
  source("Read_tidy_age.R")
  cat("Read and tidy, age DONE\n")
  
  source("age_plots.R")
  cat("Age plots DONE\n")
  
  
}

source("baekkepp_model.R")
cat("Model updated\n")

source("update_index_md.R")
cat("Index files updated\n")





