read_data <- function(path, type = 2, ...) {
  
  if(file.exists(path)){
    if(type == 1) return(readr::read_csv(path, ...))
    if(type == 2) return(readr::read_csv2(path, ...))
    }
}

source_echo <- function(filepath) {
  
  print(filepath)
  source(filepath)
  
}

ra <- function(x, n = 7, s = 2) {
  stats::filter(x, rep(1 / n, n), sides = s)
}

last_wday_date <- function(today_date, weekday) {
  
  days_subtract <- dplyr::case_when(
  lubridate::wday(today_date) == weekday ~ 0,
  lubridate::wday(today_date) < weekday ~ 7 + lubridate::wday(today_date) - weekday,
  lubridate::wday(today_date) > weekday ~ lubridate::wday(today_date) - weekday
)

  as.character(lubridate::ymd(today_date) - days_subtract)

}

date_to_yymmdd <- function(date) {
  
  paste0(stringr::str_sub(date, 3, 4), stringr::str_sub(date, 6, 7), stringr::str_sub(date, 9, 10))

  }

week_to_date <- function(year, week, day = "1"){
  
  as.Date(paste0(year, sprintf("%02d", week), day), "%Y%U%u")
  
}

floor_date_monday <- function(date) {
  
  lubridate::floor_date(date, unit = "week", week_start = getOption("lubridate.week.start", 1))
  
}

fix_week_2020 <- function(year, week, date) {
  
  dplyr::case_when(
  year == 2020 & week == 53 ~ lubridate::ymd("2020-12-28"),
  year == 2020 & week < 53 ~ date - lubridate::days(7),
  TRUE ~ date
  )
  
}

DSTdate_to_date <- function(DSTdate) {
  
  date <- paste0(stringr::str_sub(DSTdate, 1, 4), "-", stringr::str_sub(DSTdate, 6, 7), "-", stringr::str_sub(DSTdate, 9, 10))
  
  lubridate::ymd(date)
  
}

get_age_breaks <- function(maxage = 100, agesplit = 10) c(seq(-1, maxage - 1, agesplit), 125)

get_pop_by_breaks <- function(my_breaks) {
  
  maxage <- my_breaks[length(my_breaks)-1] + 1
  
  readr::read_csv2("../data/tidy_DST_pop.csv") %>%
    dplyr::group_by(Year, Quarter, Sex, Age_cut = cut(Age, breaks = my_breaks)) %>%
    dplyr::summarize(Population = sum(Population)) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      from = as.double(stringr::str_split(stringr::str_replace_all(Age_cut, "[\\(\\]]", ""), ",")[[1]][1]) + 1,
      to = as.double(stringr::str_split(stringr::str_replace_all(Age_cut, "[\\(\\]]", ""), ",")[[1]][2]),
      Age = dplyr::case_when(
        from == maxage ~ paste0(maxage, "+"),
        TRUE ~ paste(from, to, sep = "-")
      )
    ) %>%
    dplyr::select(-from, -to, -Age_cut)
}