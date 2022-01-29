# Download SSI files from SSI website. Done once. -----------------------------------------------------------

ssi_filer <-  read_csv("../data/ssifiler.txt", col_names = FALSE) #liste over links til filer fra SSI

#correct messy SSI file names
ssi_filer %<>% mutate(files = paste0(X1, ".zip"),
                      date = str_sub(X1, str_length(X1)-12, str_length(X1)-5),
                      date = paste0(20, str_sub(date, 3, 4), str_sub(date, 1, 2)),
                      date = ifelse(date == "2020-2", "200622", date),
                      date = ifelse(date == "203.f4", "200728", date),
                      date = ifelse(date == "205260", "200516", date),
                      date = ifelse(date == "20g.7j", "200727", date),
                      date = ifelse(date == "20t.3y", "200813", date),
                      date = ifelse(date == "202007", "200707", date))

# dl <- function(x, y) {
#
#   try(download.file(x, paste0("../data/SSIdata_", y, ".zip"), mode="wb"))
#
#   print(y)
#
# }

# mapply(dl , ssi_filer$files, ssi_filer$date)
# unzip("../data/test.zip", "../data/test")

ssi_filer <- ssi_filer[!(ssi_filer$date=="200728"),] #indeholder ikke aldersgruppe data
ssi_filer <- ssi_filer[!(ssi_filer$date=="200622"),] #indeholder ikke aldersgruppe data

ssi_filer_date <- ssi_filer$date
ssi_filer_date %<>% c(ssi_filer_date, "200903", "200904", "200907")

saveRDS(ssi_filer_date, file = "../data/ssi_file_date.RDS")

