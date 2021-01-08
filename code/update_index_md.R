index_file  <- readLines("../index.md")
dateline  <- paste0("Senest opdateret ", str_to_lower(format(as.Date(today), "%e. %B %Y")), " efter kl 14.")
index_file[8] <- dateline
writeLines(index_file, con="../index.md")

model_file  <- readLines("../model.md")
dateline  <- paste0("Senest opdateret ", str_to_lower(format(as.Date(today), "%e. %B %Y")), ".")
model_file[10] <- dateline
writeLines(model_file, con="../model.md")

  