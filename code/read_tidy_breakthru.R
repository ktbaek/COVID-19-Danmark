library(tidyverse)
library(magrittr)

# get last tuesday's date
lasttue <- last_wday_date(today, 3)
lasttue <- paste0(str_sub(lasttue, 3, 4), str_sub(lasttue, 6, 7), str_sub(lasttue, 9, 10))

if (file.exists(paste0("../data/SSIdata_", lasttue, "/gennembrudsinfektioner_table1.csv"))) {

  # read and tidy table 1
  read_csv2(paste0("../data/SSIdata_", lasttue, "/gennembrudsinfektioner_table1.csv")) %>%
    pivot_longer(-Ugenummer, names_to = c("Variable", "Vax_status"), values_to = "Value", names_sep = "_[A-Z]") %>%
    separate(Variable, c("Type", "Variable"), sep = "_", extra = "merge") %>%
    mutate(
      Variable = str_replace(Variable, "_", "."),
      # rename some SSI variables for better consistency
      Variable = case_when(
        Variable == "personer" ~ "personer.notprevpos",
        Variable == "cases" ~ "cases.notprevpos",
        Variable == "repositive" ~ "cases.prevpos",
        Variable == "tests" ~ "tests.alle",
        TRUE ~ Variable
      ),
      # fix loss of first letter caused by pivoting
      Vax_status = case_when(
        Vax_status == "ngen vaccination" ~ "Ingen vaccination",
        Vax_status == "ørste vaccination" ~ "Første vaccination",
        Vax_status == "nden vaccination" ~ "Anden vaccination",
        Vax_status == "uld effekt efter primært forløb" ~ "Fuld effekt efter primært forløb",
        Vax_status == "uld effekt efter revaccination" ~ "Fuld effekt efter revaccination",
      ),
      Week = as.integer(str_sub(Ugenummer, 5, 6)),
      Year = as.integer(str_sub(Ugenummer, 8, 11))
    ) %>%
    select(-Ugenummer) %>%
    separate(Variable, c("Variable", "Group"), "\\.") %>%
    select(Type, Variable, Group, Week, Year, everything()) %>%
    write_csv2("../data/tidy_breakthru_table1.csv")

  # read and tidy table 2
  read_tidy_table2 <- function(filename) {
    type <- str_split(filename, "_")[[1]][4]
    variable <- str_split(filename, paste0(type, "_"))[[1]][2] %>%
      str_sub(1, length(.) - 6)

    read_csv2(filename) %>%
      pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Value", names_sep = "_") %>%
      mutate(
        Year = as.integer(str_sub(Week, 8, 11)),
        Week = as.integer(str_sub(Week, 5, 6))
      ) %>%
      # remove the two summarizing age categories
      filter(
        !Aldersgruppe %in% c("12+", "Alle")
      ) %>%
      mutate(
        Type = type,
        Variable = variable
      ) %>%
      mutate(
        Variable = str_replace(Variable, "_", "."),
        # rename some SSI variables for better consistency
        Variable = case_when(
          Variable == "tests" ~ "tests.alle",
          Variable == "cases" ~ "cases.notprevpos",
          Variable == "repositive" ~ "cases.prevpos",
          Variable == "alle" ~ "cases.alle",
          TRUE ~ Variable
        ),
      ) %>%
      separate(Variable, c("Variable", "Group"), "\\.") %>%
      rename(Age = Aldersgruppe) %>%
      select(Type, Variable, Group, Week, Year, everything())
  }

  list.files(paste0("../data/SSIdata_", lasttue), pattern = "gennembrudsinfektioner_table2", full.names = TRUE) %>%
    lapply(read_tidy_table2) %>%
    bind_rows() %T>%
    write_csv2("../data/tidy_breakthru_table2.csv")

  tai <- function(pop, pos, tests, beta) {
    pos / (pop * (tests / pop)**beta) * 100000
  }

  beta <- 0.5

  read_csv2("../data/tidy_breakthru_table2.csv") %>%
    filter(Variable %in% c("cases", "tests")) %>%
    pivot_wider(names_from = c(Type, Variable, Group), values_from = Value, names_sep = "_") %>%
    select(-antal_tests_total) %>%
    mutate(
      antal_personer_notprevpos = antal_cases_notprevpos / incidence_cases_notprevpos * 100000,
      antal_personer_alle = antal_tests_alle / incidence_tests_alle * 100000,
      antal_personer_prevpos = antal_personer_alle - antal_personer_notprevpos,
      antal_tests_prevpos = antal_tests_alle - antal_tests_notprevpos,
      incidence_tests_prevpos = antal_tests_prevpos / antal_personer_prevpos * 100000,
      incidence_tests_notprevpos = antal_tests_notprevpos / antal_personer_notprevpos * 100000,
      incidence_tac_notprevpos = tai(antal_personer_notprevpos, antal_cases_notprevpos, antal_tests_notprevpos, beta)
    ) %>%
    pivot_longer(c(antal_cases_notprevpos:incidence_tac_notprevpos), names_to = c("Type", "Variable", "Group"), values_to = "Value", names_sep = "_") %>%
    arrange(Age, Week, Year, Vax_status, Type, Variable, Group) %T>%
    write_csv2("../data/tidy_breakthru_table2_deduced.csv")
}
