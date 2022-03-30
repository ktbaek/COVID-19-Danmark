Sys.setlocale("LC_ALL", "da_DK.UTF-8")

source("load_libraries.R")
source("set_latest_ssi_date.R")
source("set_latest_ssi_vax_date.R")
source("plot_styles.R")

files_sources <- list.files("read_tidy_datasets", full.names = TRUE)
sapply(files_sources, source_echo)

files_sources <- list.files("current_plots", full.names = TRUE)
sapply(files_sources, source_echo)

source("update_index_md.R")
cat("Index updated\n")
