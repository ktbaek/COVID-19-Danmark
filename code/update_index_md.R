index_file  <- readLines("../index.md")
dateline  <- paste0("Senest opdateret", str_to_lower(format(as.Date(today), "%e. %B")), " efter kl 14.")
index_file[7] <- dateline
writeLines(index_file, con="../index.md")

Sys.setlocale("LC_ALL", "en_US.UTF-8")
index_en_file  <- readLines("../en.md")
dateline  <- paste0("Last updated", format(as.Date(today), "%e. %B"), " after 2 pm.")
index_en_file[7] <- dateline
writeLines(index_file, con="../en.md")
Sys.setlocale("LC_ALL", "da_DK.UTF-8")