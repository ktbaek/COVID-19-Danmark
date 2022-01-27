read_data <- function(path, type = 2, ...) {
  
  if(file.exists(path)){
    if(type == 1) return(readr::read_csv(path, ...))
    if(type == 2) return(readr::read_csv2(path, ...))
    }
}

ra <- function(x, n = 7, s = 2) {
  stats::filter(x, rep(1 / n, n), sides = s)
}

last_wday_date <- function(today_date, weekday) {
  
  days_subtract <- case_when(
  wday(today_date) == weekday ~ 0,
  wday(today_date) < weekday ~ 7 + wday(today_date) - weekday,
  wday(today_date) > weekday ~ wday(today_date) - weekday
)

  as.character(ymd(today_date) - days_subtract)

}

date_to_yymmdd <- function(date) {
  
  paste0(str_sub(date, 3, 4), str_sub(date, 6, 7), str_sub(date, 9, 10))

  }

week_to_date <- function(year, week, day = "1"){
  
  as.Date(paste0(year, sprintf("%02d", week), day), "%Y%U%u")
  
}

fix_week_2020 <- function(year, week, date) {
  
  case_when(
  year == 2020 & week == 53 ~ ymd("2020-12-28"),
  year == 2020 & week < 53 ~ date - days(7),
  TRUE ~ date
  )
  
}

get_age_breaks <- function(maxage = 100, agesplit = 10) c(seq(-1, maxage - 1, agesplit), 125)

read_tidy_age <- function(my_breaks) {
  
  maxage <- my_breaks[length(my_breaks)-1] + 1
  
  read_csv2("../data/DST_pop_age_sex_19_20_21.csv", col_names = FALSE) %>%
    rename(
      Sex = X3,
      Age = X4,
      `2015_1` = X5,
      `2015_2` = X6,
      `2015_3` = X7,
      `2015_4` = X8,
      `2016_1` = X9,
      `2016_2` = X10,
      `2016_3` = X11,
      `2016_4` = X12,
      `2017_1` = X13,
      `2017_2` = X14,
      `2017_3` = X15,
      `2017_4` = X16,
      `2018_1` = X17,
      `2018_2` = X18,
      `2018_3` = X19,
      `2018_4` = X20,
      `2019_1` = X21,
      `2019_2` = X22,
      `2019_3` = X23,
      `2019_4` = X24,
      `2020_1` = X25,
      `2020_2` = X26,
      `2020_3` = X27,
      `2020_4` = X28,
      `2021_1` = X29,
      `2021_2` = X30,
      `2021_3` = X31,
      `2021_4` = X32,
    ) %>%
    select(-X1, -X2) %>%
    rowwise() %>%
    mutate(
      Age = as.double(str_split(Age, " ")[[1]][1]),
      Sex = str_sub(Sex, 1, 1),
      Sex = ifelse(Sex == "M", "Male", "Female")
    ) %>%
    pivot_longer(-c(Sex, Age), names_to = "Kvartal", values_to = "Population") %>%
    separate(Kvartal, c("Year", "Quarter"), sep = "_") %>%
    mutate(
      Quarter = as.integer(Quarter),
      Year = as.integer(Year)
    ) %>%
    group_by(Year, Quarter, Sex, Age_cut = cut(Age, breaks = my_breaks)) %>%
    summarize(Population = sum(Population)) %>%
    rowwise() %>%
    mutate(
      from = as.double(str_split(str_replace_all(Age_cut, "[\\(\\]]", ""), ",")[[1]][1]) + 1,
      to = as.double(str_split(str_replace_all(Age_cut, "[\\(\\]]", ""), ",")[[1]][2]),
      Age = case_when(
        from == maxage ~ paste0(maxage, "+"),
        TRUE ~ paste(from, to, sep = "-")
      )
    ) %>%
    select(-from, -to, -Age_cut)
}