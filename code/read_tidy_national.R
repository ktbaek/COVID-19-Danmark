# Read data files ---------------------------------------------------------

admitted <- read_csv2(paste0("../data/SSIdata_", today_string, "/Newly_admitted_over_time.csv"))
deaths <- read_csv2(paste0("../data/SSIdata_", today_string, "/Deaths_over_time.csv"))
tests <- read_csv2(paste0("../data/SSIdata_", today_string, "/Test_pos_over_time.csv"))
ag <- read_csv2(paste0("../data/SSIdata_", today_string, "/Antigentests_pr_dag.csv"))

dst_deaths <- read_csv2("../data/DST_daily_deaths.csv", col_names = FALSE)
dst_deaths_5yr <- read_csv2("../data/DST_daily_deaths_5yr.csv", col_names = TRUE)

# Update list of SSI file dates
ssi_filer_date <- readRDS("../data/ssi_file_date.RDS")
ssi_filer_date %<>% c(ssi_filer_date, today_string)
ssi_filer_date %<>% unique()
saveRDS(ssi_filer_date, file = "../data/ssi_file_date.RDS")

# Download SSI files from SSI website. Done once. -----------------------------------------------------------

# ssi_filer <-  read_csv("../data/ssifiler.txt", col_names = FALSE) #liste over links til filer fra SSI
#
# #correct messy SSI file names
# ssi_filer %<>% mutate(files = paste0(X1, ".zip"),
#                       date = str_sub(X1, str_length(X1)-12, str_length(X1)-5),
#                       date = paste0(20, str_sub(date, 3, 4), str_sub(date, 1, 2)),
#                       date = ifelse(date == "2020-2", "200622", date),
#                       date = ifelse(date == "203.f4", "200728", date),
#                       date = ifelse(date == "205260", "200516", date),
#                       date = ifelse(date == "20g.7j", "200727", date),
#                       date = ifelse(date == "20t.3y", "200813", date),
#                       date = ifelse(date == "202007", "200707", date))
#
# # dl <- function(x, y) {
# #
# #   try(download.file(x, paste0("../data/SSIdata_", y, ".zip"), mode="wb"))
# #
# #   print(y)
# #
# # }
#
# # mapply(dl , ssi_filer$files, ssi_filer$date)
# # unzip("../data/test.zip", "../data/test")
#
# ssi_filer <- ssi_filer[!(ssi_filer$date=="200728"),] #indeholder ikke aldersgruppe data
# ssi_filer <- ssi_filer[!(ssi_filer$date=="200622"),] #indeholder ikke aldersgruppe data
#
# ssi_filer_date <- ssi_filer$date
# ssi_filer_date %<>% c(ssi_filer_date, "200903", "200904", "200907")
#
# saveRDS(ssi_filer_date, file = "../data/ssi_file_date.RDS")


# Tidy NATIONAL data ------------------------------------------------
ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 2)
}

tests %<>%
  slice(1:(n() - 4)) %>% # exclude last two days that may not be updated AND summary rows
  mutate(Date = ymd(Date)) %>%
  mutate(pct_confirmed = ifelse(NotPrevPos > 0, NewPositive / NotPrevPos * 100, NA))

deaths %<>%
  slice(1:(n() - 2)) %>% # exclude summary row and last day that may not be updated
  mutate(Date = ymd(Dato)) %>%
  select(-Dato)

admitted %<>%
  mutate(Date = ymd(Dato)) %>%
  select(-Dato)

ag %<>%
  mutate(Date = ymd(Dato)) %>%
  select(-Dato) %>% 
  select(Date, everything()) %>% 
  rename(AGpos_PCRneg = AGposPCRneg) %>% 
  mutate(
    ra_ag_pos = ra(AG_pos),
    ra_ag_test = ra(AG_testede), 
    ra_ag_pos_pos = ra(AGpos_PCRpos))
  
tests %<>% 
  mutate(
    running_avg_pct = ra(pct_confirmed),
    running_avg_pos = ra(NewPositive),
    running_avg_total = ra(Tested)
)

admitted %<>%
  mutate(running_avg_admit = ra(Total))

deaths %<>% 
  mutate(running_avg_deaths = ra(Antal_døde))

dst_deaths %<>%
  select(-X1) %>%
  rename(
    Date = X2, 
    current = X3)

# Tests -------------------------------------------------------------------

cat("Test continuity:", 1 == unique(abs(diff(unique(tests$Date)))), "\n") # test for daily continuity in test_pos_over_time data