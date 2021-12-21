index_file  <- readLines("../index.md")
dateline  <- paste0("Senest opdateret ", str_to_lower(format(as.Date(today), "%e. %B %Y")), " kl. ", hour(now()), ":", minute(now()))
index_file[8] <- dateline
writeLines(index_file, con="../index.md")
