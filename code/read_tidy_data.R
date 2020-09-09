
today_string <- paste0(str_sub(today, 3, 4), str_sub(today, 6, 7), str_sub(today, 9, 10))

admitted <- read_csv2(paste0("../data/SSIdata_", today_string, "/Newly_admitted_over_time.csv"))
deaths <- read_csv2(paste0("../data/SSIdata_", today_string, "/Deaths_over_time.csv"))
tests <- read_csv2(paste0("../data/SSIdata_", today_string, "/Test_pos_over_time.csv"))
rt_cases <- read_csv2(paste0("../data/SSIdata_", today_string, "/Rt_cases_2020_09_08.csv"))
rt_admitted <- read_csv2(paste0("../data/SSIdata_", today_string, "/Rt_indlagte_2020_09_08.csv"))
muni_pos <- read_csv2(paste0("../data/SSIdata_", today_string, "/Municipality_cases_time_series.csv"))
muni_tested <- read_csv2(paste0("../data/SSIdata_", today_string, "/Municipality_tested_persons_time_series.csv"))
early_data <- read_csv2("../data/early_age_reports.csv")

ssi_filer_date <- readRDS("../data/ssi_file_date.RDS")
ssi_filer_date %<>% c(ssi_filer_date, today_string)
ssi_filer_date %<>% unique()
saveRDS(ssi_filer_date, file = "../data/ssi_file_date.RDS")

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

# download SSI files -----------------------------------------------------------

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


# tidy NATIONAL data ------------------------------------------------

tests %<>%
  mutate(Date = as.Date(Date)) %>%
  mutate(pct_confirmed = NewPositive / Tested * 100)

deaths %<>%
  mutate(Date = as.Date(Dato))

admitted %<>%
  mutate(Date = as.Date(Dato))

deaths %<>% slice(1:(n() - 1)) # exclude summary row
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

# tidy AGE data --------------------------------------------------

age_df %<>%
  mutate(date_of_file = as.integer(date_of_file)) %>%
  rename(positive = `Antal_bekræftede_COVID-19`) %>%
  arrange(date_of_file) %>%
  mutate(Date = as.Date(Date))

abs(diff(unique(age_df$Date))) # test

# tidy MUNICIPALITY data -----------------------------------------

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

abs(diff(unique(muni_all$Date))) # test for daily continuity

# test that the numbers in 'test_pos_over_time' from SSI agree with the total for all municipalities in the municaplity files from SSI
tests_check <- tests %>%
  select(Date, NewPositive, Tested)

muni_tests_check <- muni_all %>%
  group_by(Date) %>%
  summarize(
    Pos_total = sum(Positive, na.rm = TRUE),
    Tested_total = sum(Tested, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  full_join(tests_check, by = "Date")

# Result: not 100% agree: numbers in the two datasets sometimes differ by a few cases. I don't know why, ask SSI.

# arrange AGE data weekly ------------------------------------------------------

week_df <- age_df %>%
  filter(wday(Date) == 4) # wednesday because it consistently appears throughout (e.g mondays can be holidays)

week_df %<>% bind_rows(early_data) %>% arrange(Date)

# arrange ADMITTED data weekly --------------------------------------------------

date_week <- admitted %>%
  select(Date, Total) %>%
  mutate(week = isoweek(Date - 4)) %>%
  mutate(wed = wday(Date) == 4) %>%
  filter(Date > as.Date("2020-03-11")) %>%
  filter(wed) %>%
  select(Date, week)

week_admitted <- admitted %>%
  mutate(week = isoweek(Date - 4)) %>%
  filter(Date > as.Date("2020-03-11")) %>%
  select(-Date) %>%
  full_join(date_week, by = "week") %>%
  group_by(Date) %>%
  summarise(value = sum(Total)) %>%
  ungroup() %>%
  mutate(variable = "admitted") %>%
  filter(!Date == "2020-03-18")

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
  select(-less_than, -date_of_file)

wk_df_group %<>%
  group_by(variable) %>%
  mutate(value = c(0, diff(positive))) %>%
  ungroup() %>%
  select(-positive, -Antal_testede)

age_data <- bind_rows(week_admitted, wk_df_group)

# arrange MUNICIPALITY data weekly -----------------------------------------------------

muni_pop <- muni_population %>%
  group_by(Kommune) %>%
  summarize(Befolkningstal = as.integer(mean(Befolkningstal))) %>%
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
    Positive_wk = sum(Positive, na.rm = TRUE),
    Tested_wk = sum(Tested, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  select(-Date, -Positive, -Tested) %>%
  distinct()
