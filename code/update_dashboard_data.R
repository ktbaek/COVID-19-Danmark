# get dashboard file list
dash_files <- list.files(path="../data/Dashboard")
dash_files <- dash_files[str_detect(dash_files, "^D")] 
# subset dates from filenames
dates <- sapply(dash_files, function(x) str_sub(x, 11, 16))
#get dashboard data file and find dates not already in the df
dashboard_data <- read_csv2("../data/Dashboard/Dashboard_data.csv")
already_dates <- unique(paste0(str_sub(dashboard_data$Date, 3, 4), str_sub(dashboard_data$Date, 6, 7), str_sub(dashboard_data$Date, 9, 10)))
new_dates <- setdiff(dates, already_dates) 

#function to add new dashboard data to data in df
tidy_data <- function(dashboard_data, date){
  
dashboard_new_data <- read_csv(paste0("../data/Dashboard/Dashboard_", date, ".csv"))

dashboard_new_data %<>% 
  slice(1:5) %>%
  select(-X1) %>%
  mutate(values = as.integer(str_remove(values, "[.]"))) %>%
  mutate(variable = ifelse(variable == "Prøver", "NotPrevPos", variable),
         variable = ifelse(variable == "Bekræftede tilfælde", "NewPositive", variable),
         variable = ifelse(variable == "Dødsfald", "Antal_døde", variable),
         variable = ifelse(variable == "Nye indlæggelser", "Indlæggelser", variable)) %>%
  filter(!variable == "Førstegangstestede") %>%
  mutate(Date = as.Date(paste0("2020-", str_sub(date, 3, 4), "-", str_sub(date, 5, 6))))

dashboard_data <- bind_rows(dashboard_data, dashboard_new_data)

dashboard_data %<>% distinct()

return(dashboard_data)
  
}

#add new dashboard data to data df
if(length(new_dates) > 0) {
  for(date in new_dates) {
    dashboard_data <- tidy_data(dashboard_data, date)
    
  }
 
}else{
  print("No dashboard changes added to file")
}

#write new data df to file
dashboard_data %>% distinct() %T>%
write_csv2("../data/Dashboard/Dashboard_data.csv")
