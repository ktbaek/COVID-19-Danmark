library(tidyverse)
library(magrittr)

# get last tuesday's date
days_subtract <- case_when(
  wday(today) == 3 ~ 0,
  wday(today) <= 2 ~ wday(today) + 4,
  wday(today) >= 2 ~ wday(today) - 3
)
lasttue <- as.character(ymd(today) - days_subtract)
lasttue <- paste0(str_sub(lasttue, 3, 4), str_sub(lasttue, 6, 7), str_sub(lasttue, 9, 10))

# read and tidy table 1
x <- read_csv2(paste0("../data/SSIdata_", lasttue, "/gennembrudsinfektioner_table1.csv")) %>%
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
    Week = as.integer(str_sub(Ugenummer, 5, 6))
  ) %>%
  select(-Ugenummer) %>%
  separate(Variable, c("Variable", "Group"), "\\.") %>% 
  select(Type, Variable, Group, Week, everything()) %>%
  write_csv2("../data/tidy_breakthru_table1.csv")

# read and tidy table 2
read_tidy_table2 <- function(filename) {
  type <- str_split(filename, "_")[[1]][4]
  variable <- str_split(filename, paste0(type, "_"))[[1]][2] %>%
    str_sub(1, length(.) - 6)

  read_csv2(filename) %>%
    pivot_longer(-Aldersgruppe, names_to = c("Week", "Vax_status"), values_to = "Value", names_sep = "_") %>%
    mutate(Week = as.integer(str_sub(Week, 5, 6))) %>%
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
    select(Type, Variable, Group, everything())
}

list.files(paste0("../data/SSIdata_", lasttue), pattern = "gennembrudsinfektioner_table2", full.names = TRUE) %>%
  lapply(read_tidy_table2) %>%
  bind_rows() %>%
  write_csv2("../data/tidy_breakthru_table2.csv")