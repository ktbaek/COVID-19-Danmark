# Read data files ---------------------------------------------------------
admitted <- read_data(paste0("../data/SSIdata_", today_string, "/Newly_admitted_over_time.csv"))
deaths <- read_data(paste0("../data/SSIdata_", today_string, "/Deaths_over_time.csv"))
tests <- read_data(paste0("../data/SSIdata_", today_string, "/Test_pos_over_time.csv"))
ag <- read_data(paste0("../data/SSIdata_", today_string, "/Antigentests_pr_dag.csv"))

dst_deaths <- read_data("../data/DST_daily_deaths.csv", col_names = FALSE)
dst_deaths_5yr <- read_data("../data/DST_daily_deaths_5yr.csv", col_names = TRUE)

read_data("../data/DST_deaths_daily_age.csv", col_names = FALSE)
dst_dd_age_5yr <- read_data("../data/DST_daily_deaths_age_5yr.csv", col_names = TRUE)

# Update list of SSI file dates
ssi_filer_date <- readRDS("../data/ssi_file_date.RDS")
ssi_filer_date %<>% c(ssi_filer_date, today_string)
ssi_filer_date %<>% unique()
saveRDS(ssi_filer_date, file = "../data/ssi_file_date.RDS")

# Tidy NATIONAL data ------------------------------------------------
if(!is.null(tests)) {
  tests %<>%
    slice(1:(n() - 4)) %>% # exclude last two days that may not be updated AND summary rows
    mutate(Date = ymd(Date))
}
  
if(!is.null(deaths)) {
  deaths %<>%
    slice(1:(n() - 2)) %>% # exclude summary row and last day that may not be updated
    rename(
      Date = Dato,
      Deaths = Antal_døde
    ) %>% 
    mutate(Date = ymd(Date))
}

if(!is.null(admitted)) {
  admitted %<>%
    rename(
      Date = Dato,
      Admitted = Total
      ) %>% 
    mutate(Date = ymd(Date))
}

if(!any(is.null(c(tests, deaths, admitted)))) {
  
  full_data <- 
    tests %>% 
    full_join(admitted, by = "Date") %>%
    full_join(deaths, by = "Date") %>%
    filter(Date > ymd("2020-02-14"))

}

if(!is.null(full_data)) {
  
  plot_data <- 
    full_data %>% 
    select(-Tested) %>% 
    rename(
      Positive = NewPositive,
      Tested = NotPrevPos,
      ) %>% 
    mutate(Percent = Positive / Tested * 100,
           Index = Positive / Tested**0.7) %>% 
    select(Date, Positive, Tested, Percent, Index, Admitted, Deaths) %>% 
    pivot_longer(-Date, values_to = "daily") %>% 
    group_by(name) %>% 
    mutate(ra = ra(daily)) %>% 
    ungroup() %>% 
    filter(Date > ymd("2020-02-14")) %>% 
    write_csv2("../data/SSI_daily_data.csv")
    
    
}

if(!is.null(ag)) {
ag %>%
  rename(Date = Dato) %>% 
  mutate(Date = ymd(Date)) %>%
  select(Date, everything()) %>% 
  rename(AGpos_PCRneg = AGposPCRneg) %>% 
  mutate(
    ra_ag_pos = ra(AG_pos),
    ra_ag_test = ra(AG_testede), 
    ra_ag_pos_pos = ra(AGpos_PCRpos)
    ) %>% 
    write_csv2("../data/SSI_Ag_data.csv")
  
}

dst_deaths %<>%
  select(-X1) %>%
  rename(
    Date = X2, 
    current = X3)

read_data("../data/DST_deaths_daily_age.csv", col_names = FALSE) %>% 
  select(-X2) %>% 
  rename(Date = X1) %>% 
  mutate(md = paste0(str_sub(Date, 6, 7), str_sub(Date, 9, 10))) %>%
  mutate(Date = ymd(paste0(str_sub(Date, 1, 4), "-", str_sub(Date, 6, 7), "-", str_sub(Date, 9, 10)))) %>% 
  select(-md) %>% 
  rename(
    "0-4" = X3,
    "5-9" = X4,
    "10-14" = X5,
    "15-19" = X6,
    "20-24" = X7,
    "25-29" = X8,
    "30-34" = X9,
    "35-39" = X10,
    "40-44" = X11,
    "45-49" = X12,
    "50-54" = X13,
    "55-59" = X14,
    "60-64" = X15,
    "65-69" = X16,
    "70-74" = X17,
    "75-79" = X18,
    "80-84" = X19,
    "85-89" = X20,
    "90-94" = X21,
    "95-99" = X22,
    "100+" = X23
  ) %>% 
  mutate(across(c(`0-4`:`100+`), as.numeric)) %>%
  pivot_longer(-Date, names_to = "Age", values_to = "Deaths") %>% 
  write_csv2("../data/DST_tidy_daily_deaths_age.csv")

dst_folk <- read_csv2("../data/DST_FOLK1_2015-21.csv", col_names = FALSE) 

dst_folk %<>% 
  select(-X2, -X3, -X4) %>% 
  rename(
    Kvartal = X1, 
    "0-4" = X5,
    "5-9" = X6,
    "10-14" = X7,
    "15-19" = X8,
    "20-24" = X9,
    "25-29" = X10,
    "30-34" = X11,
    "35-39" = X12,
    "40-44" = X13,   
    "45-49" = X14,
    "50-54" = X15,
    "55-59" = X16,
    "60-64" = X17,   
    "65-69" = X18,
    "70-74" = X19,
    "75-79" = X20,
    "80-84" = X21,
    "85-89" = X22,
    "90-94" = X23,
    "95-99" = X24,
    "100-104" = X25,
    "105-109" = X26,
    "110+" = X27
  ) %>% 
  pivot_longer(-Kvartal, names_to = "Aldersgruppe", values_to = "Befolkning") %>% 
  mutate(
    Aldersgruppe = case_when(
      Aldersgruppe == "0-4" ~ "0-49",
      Aldersgruppe =="5-9" ~ "0-49",
      Aldersgruppe =="10-14" ~ "0-49",
      Aldersgruppe =="15-19" ~ "0-49",
      Aldersgruppe =="20-24" ~ "0-49",
      Aldersgruppe =="25-29" ~ "0-49",
      Aldersgruppe =="30-34" ~ "0-49",
      Aldersgruppe =="35-39" ~ "0-49",
      Aldersgruppe =="40-44" ~ "0-49",
      Aldersgruppe =="45-49" ~ "0-49",
      Aldersgruppe =="50-54" ~ "50-59",
      Aldersgruppe =="55-59" ~ "50-59",
      Aldersgruppe =="60-64" ~ "60-69",
      Aldersgruppe =="65-69" ~ "60-69",
      Aldersgruppe =="70-74" ~ "70-79",
      Aldersgruppe =="75-79" ~ "70-79",
      Aldersgruppe =="80-84" ~ "80-89",
      Aldersgruppe =="85-89" ~ "80-89",
      Aldersgruppe =="90-94" ~ "90+",
      Aldersgruppe =="95-99" ~ "90+",
      Aldersgruppe =="100-104" ~ "90+",
      Aldersgruppe =="105-109" ~ "90+",
      Aldersgruppe =="110+" ~ "90+",
      TRUE ~ Aldersgruppe
    )) %>% 
  group_by(Aldersgruppe, Kvartal) %>% 
  summarize(Befolkning = sum(Befolkning, na.rm = TRUE)) %>% 
  mutate(year = str_sub(Kvartal, 1, 4)) %>% 
  select(-Kvartal) %>% 
  group_by(Aldersgruppe, year) %>% 
  summarize(Befolkning = mean(Befolkning, na.rm = TRUE)) 

dst_folk_ratio <- dst_folk %>% 
  mutate(niveau_2020 = ifelse(year == 2020, Befolkning, NA)) %>% 
  group_by(Aldersgruppe) %>% 
  fill(niveau_2020, .direction = "updown") %>% 
  ungroup() %>% 
  mutate(ratio_2020 = niveau_2020 / Befolkning) %>% 
  select(Aldersgruppe, year, ratio_2020) %>% 
  mutate(year = as.double(year))

dst_dd_age_5yr <- read_csv2("../data/DST_daily_deaths_age_5yr.csv", col_names = TRUE)

dst_dd_age_5yr %<>% 
  pivot_longer(-Aldersgruppe, names_to = "Date", values_to = "deaths") %>% 
  mutate(year = as.double(str_sub(Date, 1, 4)),
         Month = as.double(str_sub(Date, 6, 7)),
         Day = str_sub(Date, 8, 10)) %>% 
  select(-Date) %>% 
  mutate(
    Aldersgruppe = case_when(
      Aldersgruppe == "0-4" ~ "0-49",
      Aldersgruppe =="5-9" ~ "0-49",
      Aldersgruppe =="10-14" ~ "0-49",
      Aldersgruppe =="15-19" ~ "0-49",
      Aldersgruppe =="20-24" ~ "0-49",
      Aldersgruppe =="25-29" ~ "0-49",
      Aldersgruppe =="30-34" ~ "0-49",
      Aldersgruppe =="35-39" ~ "0-49",
      Aldersgruppe =="40-44" ~ "0-49",
      Aldersgruppe =="45-49" ~ "0-49",
      Aldersgruppe =="50-54" ~ "50-59",
      Aldersgruppe =="55-59" ~ "50-59",
      Aldersgruppe =="60-64" ~ "60-69",
      Aldersgruppe =="65-69" ~ "60-69",
      Aldersgruppe =="70-74" ~ "70-79",
      Aldersgruppe =="75-79" ~ "70-79",
      Aldersgruppe =="80-84" ~ "80-89",
      Aldersgruppe =="85-89" ~ "80-89",
      Aldersgruppe =="90-94" ~ "90+",
      Aldersgruppe =="95-99" ~ "90+",
      Aldersgruppe =="100+" ~ "90+",
      TRUE ~ Aldersgruppe
    )) %>% 
  full_join(dst_folk_ratio, by = c("Aldersgruppe", "year")) %>% 
  mutate(adj_deaths = deaths * ratio_2020) %>% 
  group_by(Aldersgruppe, Month, Day) %>% 
  summarize(deaths = sum(adj_deaths, na.rm = TRUE) / 5) %>% 
  mutate(md = paste0(sprintf("%02d", Month), str_sub(Day, 2, 3))) %>% 
  ungroup() %>% 
  select(-Month, -Day)


# Tests -------------------------------------------------------------------

cat("Test continuity:", 1 == unique(abs(diff(unique(tests$Date)))), "\n") # test for daily continuity in test_pos_over_time data