SSI_files <- list.dirs(path="../data/", full.names = FALSE, recursive = FALSE)
last_file <- tail(SSI_files[str_starts(SSI_files, "SSIdata_")], 1)
today_string <- str_sub(last_file, 9, 15)
today <- paste0("20", str_sub(today_string, 1, 2), "-", str_sub(today_string, 3, 4), "-", str_sub(today_string, 5, 6))

# Update list of SSI file dates
ssi_filer_date <- readRDS("../data/ssi_file_date.RDS")
ssi_filer_date %<>% c(ssi_filer_date, today_string)
ssi_filer_date %<>% unique()
saveRDS(ssi_filer_date, file = "../data/ssi_file_date.RDS")