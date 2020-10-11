index_file  <- readLines("../index.md")
dateline  <- paste0("Senest opdateret", str_to_lower(format(as.Date(today), "%e. %B")), " efter kl 14.")
index_file[7] <- dateline
writeLines(index_file, con="../index.md")