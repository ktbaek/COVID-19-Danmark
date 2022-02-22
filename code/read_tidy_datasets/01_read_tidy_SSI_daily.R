admitted <- read_data(paste0("../data/SSIdata_", today_string, "/Newly_admitted_over_time.csv"))
deaths <- read_data(paste0("../data/SSIdata_", today_string, "/Deaths_over_time.csv"))
tests <- read_data(paste0("../data/SSIdata_", today_string, "/Test_pos_over_time.csv"))
ag <- read_data(paste0("../data/SSIdata_", today_string, "/Antigentests_pr_dag.csv"))

if (!is.null(tests)) {
  tests %<>%
    slice(1:(n() - 4)) %>% # exclude last two days that may not be updated AND summary rows
    mutate(Date = ymd(Date))
}

if (!is.null(deaths)) {
  deaths %<>%
    slice(1:(n() - 2)) %>% # exclude summary row and last day that may not be updated
    rename(
      Date = Dato,
      Deaths = Antal_døde
    ) %>%
    mutate(Date = ymd(Date))
}

if (!is.null(admitted)) {
  admitted %<>%
    rename(
      Date = Dato,
      Admitted = Total
    ) %>%
    mutate(Date = ymd(Date))
}

if (!any(is.null(c(tests, deaths, admitted)))) {
  full_data <-
    tests %>%
    full_join(admitted, by = "Date") %>%
    full_join(deaths, by = "Date") %>%
    filter(Date > ymd("2020-02-14"))
}

if (!is.null(full_data)) {
  plot_data <-
    full_data %>%
    select(-Tested) %>%
    rename(
      Positive = NewPositive,
      Tested = NotPrevPos,
    ) %>%
    mutate(
      Percent = Positive / Tested * 100,
      Index = Positive / Tested**0.7
    ) %>%
    select(Date, Positive, Tested, Percent, Index, Admitted, Deaths) %>%
    pivot_longer(-Date, values_to = "daily") %>%
    group_by(name) %>%
    mutate(ra = ra(daily)) %>%
    ungroup() %>%
    filter(Date > ymd("2020-02-14")) %>%
    write_csv2("../data/SSI_daily_data.csv")
}

if (!is.null(ag)) {
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

cat("Test continuity:", 1 == unique(abs(diff(unique(tests$Date)))), "\n") # test for daily continuity in test_pos_over_time data
