
# Read AGE data -------------------------------------------------------------------------

early_data <- read_csv2("../data/early_age_reports.csv")
dst_age <- read_csv2("../data/DST_age_group_data.csv")

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

# Tidy AGE data --------------------------------------------------

age_df %<>%
  mutate(date_of_file = as.integer(date_of_file)) %>%
  rename(positive = `Antal_bekræftede_COVID-19`) %>%
  arrange(date_of_file) %>%
  mutate(Date = as.Date(Date))

abs(diff(unique(age_df$Date))) # test

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

over_50 <- c("50-59", "60-69", "70-79", "80-89", "90+")
over_60 <- c("60-69", "70-79", "80-89", "90+")
over_70 <- c("70-79", "80-89", "90+")

wk_df_group <- week_df %>%
  filter(!Aldersgruppe == "I alt") %>%
  mutate("50" = ifelse(Aldersgruppe %in% over_50, "Over", "Under"),
         "60" = ifelse(Aldersgruppe %in% over_60, "Over", "Under"),
         "70" = ifelse(Aldersgruppe %in% over_70, "Over", "Under")) %>%
  select(-Aldersgruppe, -Antal_testede) %>%
  pivot_longer(-c(Date, positive), names_to = "age_limit", values_to = "where") %>%
  group_by(age_limit, where, Date) %>%
  summarise_all(sum) %>% 
  ungroup()

wk_df_group %<>%
  group_by(age_limit, where) %>%
  mutate(value = c(0, diff(positive))) %>%
  ungroup() %>%
  select(-positive) %>%
  mutate(variable = "positive") %>%
  filter(!Date == "2020-03-18")

week_admitted %<>%
  filter(!Date == "2020-03-18", Date <= max(wk_df_group$Date)) 

week_admitted %<>%
  full_join(expand_grid("age_limit" = c("50", "60", "70"), "where" = c("Under", "Over"), "Date" = week_admitted$Date), by = "Date") 


age_data <- bind_rows(week_admitted, wk_df_group)


