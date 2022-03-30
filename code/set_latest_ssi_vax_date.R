vax_files <- list.dirs(path = "../data/Vax_data/", full.names = FALSE, recursive = FALSE)
last_file <- tail(vax_files[str_starts(vax_files, "Vaccine_")], 1)
vax_today_string <- str_sub(last_file, 12, 17)
vax_today <- paste0("20", str_sub(vax_today_string, 1, 2), "-", str_sub(vax_today_string, 3, 4), "-", str_sub(vax_today_string, 5, 6))