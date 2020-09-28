# Read data files ---------------------------------------------------------

today_string <- paste0(str_sub(today, 3, 4), str_sub(today, 6, 7), str_sub(today, 9, 10))

admitted <- read_csv2(paste0("../data/SSIdata_", today_string, "/Newly_admitted_over_time.csv"))
deaths <- read_csv2(paste0("../data/SSIdata_", today_string, "/Deaths_over_time.csv"))
tests <- read_csv2(paste0("../data/SSIdata_", today_string, "/Test_pos_over_time.csv"))
rt_cases <- read_csv2(paste0("../data/SSIdata_", today_string, "/Rt_cases_2020_09_22.csv"))
rt_admitted <- read_csv2(paste0("../data/SSIdata_", today_string, "/Rt_indlagte_2020_09_22.csv"))
muni_pos <- read_csv2(paste0("../data/SSIdata_", today_string, "/Municipality_cases_time_series.csv"))
muni_tested <- read_csv2(paste0("../data/SSIdata_", today_string, "/Municipality_tested_persons_time_series.csv"))
early_data <- read_csv2("../data/early_age_reports.csv")
dst_age <- read_csv2("../data/DST_age_group_data.csv")

# Update list of SSI file dates
ssi_filer_date <- readRDS("../data/ssi_file_date.RDS")
ssi_filer_date %<>% c(ssi_filer_date, today_string)
ssi_filer_date %<>% unique()
saveRDS(ssi_filer_date, file = "../data/ssi_file_date.RDS")

# Read AGE data files
read_age_csv <- function(x) {
  file <- read_csv2(paste0("../data/SSIdata_", x, "/Cases_by_age.csv"))
  file %<>%
    mutate(date_of_file = x) %>%
    select(-Procent_positive) %>%
    mutate(Date = paste0("2020-", str_sub(date_of_file, 3, 4), "-", str_sub(date_of_file, 5, 6)))

  return(file)
}

csv_list <- lapply(ssi_filer_date, read_age_csv)

age_df <- bind_rows(csv_list)

# Read MUNICIPALITY data for population numbers. Test data are used from files read above (they don't include population data).
read_muni_csv <- function(x) {
  file <- read_csv2(paste0("../data/SSIdata_", x, "/Municipality_test_pos.csv"))
  file %<>%
    mutate(date_of_file = x) %>%
    select(date_of_file, `Kommune_(navn)`, Befolkningstal) %>%
    mutate(Date = paste0("2020-", str_sub(date_of_file, 3, 4), "-", str_sub(date_of_file, 5, 6))) %>%
    select(-date_of_file) %>%
    rename(Kommune = `Kommune_(navn)`)

  return(file)
}

csv_list <- lapply(ssi_filer_date, read_muni_csv)

muni_population <- bind_rows(csv_list)

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

tests %<>%
  mutate(Date = as.Date(Date)) %>%
  mutate(pct_confirmed = NewPositive / NotPrevPos * 100)

deaths %<>%
  mutate(Date = as.Date(Dato)) %>%
  select(-Dato)

admitted %<>%
  mutate(Date = as.Date(Dato)) %>%
  select(-Dato)

deaths %<>% slice(1:(n() - 2)) # exclude summary row and last day that may not be updated
tests %<>% slice(1:(n() - 4)) # exclude last two days that may not be updated AND summary rows

ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 2)
}
tests %<>% mutate(
  running_avg_pct = ra(pct_confirmed),
  running_avg_pos = ra(NewPositive),
  running_avg_total = ra(Tested)
)

admitted %<>%
  mutate(running_avg = ra(Total))

deaths %<>% mutate(running_avg = ra(Antal_døde))

tests_from_may <- tests %>% slice(96:(n())) # exclude data before May

# Tidy AGE data --------------------------------------------------

age_df %<>%
  mutate(date_of_file = as.integer(date_of_file)) %>%
  rename(positive = `Antal_bekræftede_COVID-19`) %>%
  arrange(date_of_file) %>%
  mutate(Date = as.Date(Date))

abs(diff(unique(age_df$Date))) # test

# Tidy MUNICIPALITY data -----------------------------------------

muni_pos %<>%
  mutate(Date = as.Date(date_sample)) %>%
  select(-date_sample) %>%
  pivot_longer(cols = -(Date), names_to = "Kommune", values_to = "Positive") %>%
  mutate(Kommune = ifelse(Kommune == "Copenhagen", "København", Kommune))

muni_tested %<>%
  mutate(Date = as.Date(PrDate_adjusted)) %>%
  select(-PrDate_adjusted, -X101) %>%
  pivot_longer(cols = -(Date), names_to = "Kommune", values_to = "Tested") %>%
  mutate(Kommune = ifelse(Kommune == "Copenhagen", "København", Kommune))

muni_population %<>%
  mutate(Kommune = ifelse(Kommune == "Copenhagen", "København", Kommune))

muni_all <- muni_tested %>%
  full_join(muni_pos, by = c("Kommune", "Date")) %>%
  filter(Date > as.Date("2020-02-29"))

# Tests -------------------------------------------------------------------

cat("Muni continuity:", 1 == unique(abs(diff(unique(muni_all$Date)))), "\n") # test for daily continuity in municipality data from march 1
cat("Test continuity:", 1 == unique(abs(diff(unique(tests$Date)))), "\n") # test for daily continuity in test_pos_over_time data
cat("Muni # pos:", length(unique(muni_pos$Kommune)), "\n") #test number of kommuner
cat("Muni # tested:", length(unique(muni_tested$Kommune)), "\n") #test number of kommuner
cat("Missing muni in pos:", setdiff(unique(muni_tested$Kommune), unique(muni_pos$Kommune)), "\n") # test missing kommuner

# test that the numbers in 'test_pos_over_time' from SSI agree with the total for all municipalities in the municipality files from SSI:

tests_check <- tests %>%
  select(Date, NewPositive, Tested, NotPrevPos, PrevPos)

muni_tests_check <- muni_all %>%
  group_by(Date) %>%
  summarize(
    Pos_total = sum(Positive, na.rm = TRUE),
    Tested_total = sum(Tested, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  full_join(tests_check, by = "Date") %>%
  mutate(
    Pos_diff = NewPositive - Pos_total,
    Test_diff = NotPrevPos - Tested_total
  )

muni_tests_check %>%
  select(-Date) %>%
  colSums(na.rm = TRUE)

# Result: not 100% agree: numbers in the two datasets sometimes differ by a few cases and tests (0.5 - 1% difference). I don't know why, ask SSI.

# Arrange AGE data weekly ------------------------------------------------------

week_df_1 <- age_df %>%
  filter(Date < as.Date("2020-07-02")) %>%
  filter(wday(Date) == 4)# wednesday because it consistently appears throughout in the beginning of the period

week_df_2 <- age_df %>%
  filter(Date > as.Date("2020-07-02")) %>%
  filter(wday(Date) == 5) # thursday because it consistently appears throughout later in the period

week_df <- bind_rows(early_data, week_df_1, week_df_2) %>% arrange(Date) %>% select(-date_of_file)

week_df %<>%
  mutate(Week_end_Date = ceiling_date(Date, unit = "week", getOption("lubridate.week.start", 0))  -4)  %>% #adjust end-date to get equally separated bars on plots
  select(-Date) %>%
  rename(Date = Week_end_Date) 




#tests
abs(diff(unique(week_df$Date)))
as_date(min(week_df$Date))
as_date(max(week_df$Date))

# Arrange ADMITTED data weekly --------------------------------------------------

week_admitted <- admitted %>%
  mutate(Week_end_Date = ceiling_date(Date + 4, unit = "week", getOption("lubridate.week.start", 0)) - 4) %>%
  select(Week_end_Date, Total) %>%
  filter(Week_end_Date > as.Date("2020-03-11")) %>%
  rename(Date = Week_end_Date) %>%
  group_by(Date) %>%
  summarise(value = sum(Total)) %>%
  ungroup() %>%
  mutate(variable = "admitted") 

# Combine AGE, ADMITTED and group into old and young --------------------------------

young_group <- c("0-9", "10-19", "20-29", "30-39", "40-49") # , "50-59", "60-69")

wk_df_group <- week_df %>%
  filter(!Aldersgruppe == "I alt") %>%
  mutate(less_than = ifelse(Aldersgruppe %in% young_group, TRUE, FALSE)) %>%
  select(-Aldersgruppe) %>%
  group_by(less_than, Date) %>%
  summarise_all(sum) %>%
  mutate(variable = ifelse(less_than, "young", "old")) %>%
  ungroup() %>%
  select(-less_than)

wk_df_group %<>%
  group_by(variable) %>%
  mutate(value = c(0, diff(positive))) %>%
  ungroup() %>%
  select(-positive, -Antal_testede) %>%
  filter(!Date == "2020-03-18")

week_admitted %<>%
  filter(!Date == "2020-03-18", Date <= max(wk_df_group$Date))

age_data <- bind_rows(week_admitted, wk_df_group)

# Arrange MUNICIPALITY data weekly -----------------------------------------------------

muni_pop <- muni_population %>%
  group_by(Kommune) %>%
  summarize(Befolkningstal = as.integer(mean(Befolkningstal))) %>% #population numbers change very little over the period so I use the mean.
  ungroup()

muni_all %<>%
  filter(Date < as.Date(today) - 1) # remove last two days

muni_wk <- muni_all %>%
  mutate(Week = isoweek(Date)) %>%
  mutate(Week_end_Date = ceiling_date(Date, unit = "week", getOption("lubridate.week.start", 0)))

muni_wk %<>%
  full_join(muni_pop, by = c("Kommune"))

muni_wk %<>%
  filter(Week < isoweek(as.Date(today) - 1)) %>% # remove current week
  group_by(Week, Kommune) %>%
  mutate(
    Positive_wk = sum(Positive, na.rm = FALSE),
    Tested_wk = sum(Tested, na.rm = FALSE)
  ) %>%
  ungroup() %>%
  select(-Date, -Positive, -Tested) %>%
  distinct()

