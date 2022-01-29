# Read MUNICIPALITY data ----------------------------------------------------------------

muni_pos <- read_csv2(paste0("../data/SSIdata_", today_string, "/Municipality_cases_time_series.csv"))
muni_tested <- read_csv2(paste0("../data/SSIdata_", today_string, "/Municipality_tested_persons_time_series.csv"))

geo <- read_csv2("../data/DST_geografisk_hieraki.csv")

# Read MUNICIPALITY data for population numbers. Test data are used from files read above (they don't include population data).
read_muni_csv <- function(x) {
  file <- read_csv2(paste0("../data/SSIdata_", x, "/Municipality_test_pos.csv"))
  file %<>%
    mutate(date_of_file = x) %>%
    select(date_of_file, `Kommune_(navn)`, Befolkningstal) %>%
    mutate(Date = paste0("20", str_sub(date_of_file, 1, 2), "-", str_sub(date_of_file, 3, 4), "-", str_sub(date_of_file, 5, 6))) %>%
    select(-date_of_file) %>%
    rename(Kommune = `Kommune_(navn)`)
  
  return(file)
}

csv_list <- lapply(ssi_filer_date, read_muni_csv)

muni_population <- bind_rows(csv_list)

muni_population %<>%
  mutate(Date = ymd(Date))

# Tidy MUNICIPALITY data -----------------------------------------

muni_pos %<>%
  mutate(Date = ymd(SampleDate)) %>%
  select(-SampleDate) %>%
  pivot_longer(-Date, names_to = "Kommune", values_to = "Positive") %>%
  mutate(Kommune = ifelse(Kommune == "Copenhagen", "København", Kommune))

muni_tested %<>%
  mutate(Date = ymd(PrDate_adjusted)) %>%
  select(-PrDate_adjusted, -X101) %>%
  pivot_longer(-Date, names_to = "Kommune", values_to = "Tested") %>%
  mutate(Kommune = ifelse(Kommune == "Copenhagen", "København", Kommune))

muni_population %<>%
  mutate(Kommune = ifelse(Kommune == "Copenhagen", "København", Kommune))

muni_all <- muni_tested %>%
  full_join(muni_pos, by = c("Kommune", "Date")) %>%
  filter(!Kommune == "X100") %>%
  filter(Date > ymd("2020-02-29")) 

# Tests -------------------------------------------------------------------

cat("Muni continuity:", 1 == unique(abs(diff(unique(muni_all$Date)))), "\n") # test for daily continuity in municipality data from march 1
cat("Muni # pos:", length(unique(muni_pos$Kommune)), "\n") #test number of kommuner
cat("Muni # tested:", length(unique(muni_tested$Kommune)), "\n") #test number of kommuner
cat("Missing muni in pos:", setdiff(unique(muni_tested$Kommune), unique(muni_pos$Kommune)), "\n") # test missing kommuner

# test that the numbers in 'test_pos_over_time' from SSI agree with the total for all municipalities in the municipality files from SSI:

tests_check <- read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name %in% c("Positive", "Tested")) %>% 
  select(-ra) %>% 
  pivot_wider(values_from = "daily") 

muni_tests_check <- muni_all %>%
  group_by(Date) %>%
  summarize(
    Pos_total = sum(Positive, na.rm = TRUE),
    Tested_total = sum(Tested, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  full_join(tests_check, by = "Date") %>%
  mutate(
    Pos_diff = Positive - Pos_total,
    Test_diff = Tested - Tested_total
  )

muni_tests_check %>%
  select(-Date) %>%
  colSums(na.rm = TRUE)

# Result: not 100% agree: numbers in the two datasets sometimes differ by a few cases and tests (0.5 - 1% difference). I don't know why, ask SSI.

# Arrange MUNICIPALITY data weekly -----------------------------------------------------

muni_pop <- muni_population %>%
  group_by(Kommune) %>%
  summarize(Befolkningstal = as.integer(mean(Befolkningstal))) %>% #population numbers change very little over the period so I use the mean.
  ungroup()
  
muni_all %<>%
  filter(Date < ymd(today) - 1) # remove last two days

muni_all %>%
  full_join(muni_population, by = c("Date", "Kommune")) %>% 
  arrange(Date) %>% 
  group_by(Kommune) %>% 
  fill(Befolkningstal, .direction = "downup") %>% 
  write_csv2("../data/tidy_muni_data.csv")

muni_wk <- muni_all %>%
  mutate(Week_end_Date = ceiling_date(Date, unit = "week", getOption("lubridate.week.start", 0)))

muni_wk %<>%
  full_join(muni_pop, by = c("Kommune"))

muni_wk %<>%
  filter(Week_end_Date < today) %>% # remove current week
  group_by(Week_end_Date, Kommune) %>%
  mutate(
    Positive_wk = sum(Positive, na.rm = FALSE),
    Tested_wk = sum(Tested, na.rm = FALSE)
  ) %>%
  ungroup() %>%
  select(-Date, -Positive, -Tested) %>%
  distinct()
# Arrange by LANDSDELE ----------------------------------------------------

landsdele_order <- geo %>%
  select(KODE, NIVEAU, Landsdel) %>%
  filter(NIVEAU == 2) %>%
  select(-NIVEAU, -KODE) %>%
  pull(Landsdel)

geo %<>%
  select(NIVEAU,TITEL, Region, Landsdel) %>%
  filter(NIVEAU == 3) %>%
  select(-NIVEAU) %>%
  rename(Kommune = TITEL)

landsdele <- muni_all %>%
  full_join(geo, by = "Kommune") %>%
  group_by(Landsdel, Date) %>%
  mutate(
    Tested = sum(Tested, na.rm = TRUE),
    Positive = sum(Positive, na.rm = TRUE)) %>%
  ungroup() %>%
  select(-Kommune) %>%
  distinct()

landsdele$Landsdel <- factor(landsdele$Landsdel, levels = landsdele_order)

landsdele %>% 
  write_csv2("../data/tidy_landsdele_data.csv")


# REGION data -------------------------------------------------------------

admitted %>%
  select(-Admitted) %>%
  rename(Ukendt_region = `Ukendt Region`) %>% 
  pivot_longer(-Date, names_to = "Region", values_to = "Admitted") %>% 
  write_csv2("../data/tidy_admitted_region.csv")
