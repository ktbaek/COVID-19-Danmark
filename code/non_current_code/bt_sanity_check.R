# Read -------------------------------------------------------

bt_1 <- read_csv2("../data/tidy_breakthru_table1.csv")
bt_2 <- read_csv2("../data/tidy_breakthru_table2.csv")
bt_2_extra <- read_csv2("../data/tidy_breakthru_table2_deduced.csv")

# check that cases and repositive numbers match between table 1 and 2
bt_2 %>%
  group_by(Week, Year, Type, Variable, Group, Vax_status) %>%
  summarize(Number_table2 = sum(Value, na.rm = TRUE)) %>%
  inner_join(filter(bt_1, Type == "antal" & Variable == "cases"), by = c("Week", "Year", "Type", "Variable", "Group", "Vax_status")) %>%
  mutate(Check = Number_table2 == Value) %>%
  pull(Check) %>%
  all() # -> they are identical in table 1 and 2, as expected.

# compare my calculation of population sizes with those in table 1

pop_check <- bt_2_extra %>%
  filter(Type != "incidence") %>%
  group_by(Week, Year, Vax_status, Type, Variable, Group) %>%
  summarize(
    Table2 = sum(Value, na.rm = TRUE)
  ) %>%
  inner_join(filter(bt_1, Type == "antal" & Variable == "personer"), by = c("Week", "Year", "Type", "Variable", "Group", "Vax_status")) %>%
  mutate(
    Diff = Table2 - Value,
    Diff_pct = round(abs(Diff / Table2) * 100, 2)
  ) %>% 
  arrange(desc(Diff_pct))

# compare my calculation of prev infection population with those calculated from table 1. Given that the above check was OK, this is just a double check.
prevpos_check <- bt_2_extra %>%
  filter(Type != "incidence") %>%
  group_by(Week, Year, Vax_status, Type, Variable, Group) %>%
  summarize(
    Table2 = sum(Value, na.rm = TRUE)
  ) %>%
  inner_join(filter(bt_1, Type == "antal" & Variable == "personer"), by = c("Week", "Year", "Type", "Variable", "Group", "Vax_status")) %>%
  rename(Table1 = Value) %>%
  # pivot swap
  pivot_wider(names_from = c(Variable, Group), values_from = c(Table1, Table2), names_sep = "_") %>%
  pivot_longer(c(-Week, -Year, -Vax_status, -Type), names_to = c("Dataset", "Variable", "Group"), values_to = "value", names_sep = "_") %>%
  pivot_wider(names_from = c(Variable, Group), values_from = value, names_sep = "_") %>%
  mutate(
    personer_prevpos = personer_alle - personer_notprevpos
  ) %>%
  select(-personer_alle, -personer_notprevpos) %>%
  pivot_wider(names_from = Dataset, values_from = personer_prevpos) %>%
  mutate(
    Diff = Table2 - Table1,
    Diff_pct = round(abs(Diff / Table2) * 100, 2)
  ) %>% 
  arrange(desc(Diff_pct))

bt_age_breaks <- c(-1, 5, 11, 15, 19, 29, 39, 49, 59, 64, 69, 79, 125)

pop <- read_tidy_age(bt_age_breaks) %>% 
  group_by(Year, Quarter, Age) %>% 
  summarize(Population = sum(Population, na.rm = TRUE))


pop_check_2 <- bt_2_extra %>%
  filter(
    Type == "antal",
    Variable == "personer",
    Group == "alle",
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Anden vaccination")
    ) %>%
  group_by(Aldersgruppe, Week, Year) %>%
  summarize(
    Table2 = sum(Value, na.rm = TRUE)
  ) %>%
  mutate(
    Date = as.Date(paste0(Year, sprintf("%02d", Week), "1"), "%Y%U%u"),
    Quarter = quarter(Date)
    ) %>%
  left_join(pop, by = c("Aldersgruppe" = "Age", "Year", "Quarter")) %>% 
  arrange(Date) %>% 
  group_by(Aldersgruppe) %>% 
  fill(Population) %>% 
  mutate(
    Diff = Table2 - Population,
    Diff_pct = round(abs(Diff / Table2) * 100, 2)
  ) %>% 
  arrange(desc(Diff_pct))






# Check how my calculations compare with total infected over time ------------

temp_df_2 <- prevpos_check %>%
  filter(Vax_status %in% c("Ingen vaccination", "Første vaccination", "Anden vaccination")) %>%
  group_by(Week, Year) %>%
  summarize(Table2 = sum(Table2, na.rm = TRUE)) %>%
  mutate(Date = as.Date(paste0(Year, sprintf("%02d", Week), "1"), "%Y%U%u"))

read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name == "Positive") %>%
  select(Date, daily) %>%
  mutate(cum_daily = cumsum(daily)) %>%
  full_join(temp_df_2, by = "Date") %>%
  mutate(Table2 = lead(Table2, 32)) %>%
  select(-Week, -Year, -daily) %>% 
  filter(wday(Date) == 5) %>% 
  pivot_longer(-Date) %>% 
  ggplot() +
  geom_line(aes(Date, value, color = name), size = 1) +
  scale_y_continuous(limits = c(0, NA))


bt_2_extra <- read_csv2("../data/tidy_breakthru_table2_deduced.csv")

temp_df <- bt_2_extra %>%
  filter(
    Type == "antal",
    Variable == "cases",
    Group == "notprevpos",
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Anden vaccination")
    ) %>%
  mutate(Date = as.Date(paste0(Year, sprintf("%02d", Week), "1"), "%Y%U%u")) %>% 
  group_by(Date) %>%
  summarize(Table2 = sum(Value, na.rm = TRUE)) 
  

read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name == "Positive") %>%
  select(Date, daily) %>%
  group_by(Date = floor_date(Date, unit = "week", week_start = getOption("lubridate.week.start", 1))) %>%
  filter(!is.na(daily)) %>% 
  mutate(n = n()) %>% 
  filter(n == 7) %>% 
  summarize(`SSI daily data` = sum(daily, na.rm = TRUE)) %>% 
  full_join(temp_df, by = "Date") %>%
  pivot_longer(-Date) %>% 
  filter(Date > ymd("2021-09-01")) %>% 
  ggplot() +
  geom_line(aes(Date, value, color = name), size = 1) +
  scale_color_discrete(name = "Dataset") +
  scale_y_continuous(limits = c(0, NA), labels = scales::number) + 
  labs(
    y = "Cases, not previously positive",
    title = "Comparison of case numbers (notprevpos) in Table 2 and SSI daily files"
  ) +
  standard_theme


temp_df <- bt_1 %>% 
  filter(
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Anden vaccination"),
    Type == "antal",
    Variable == "personer"
    ) %>%
  group_by(Week, Year, Group) %>%
  summarize(Value = sum(Value, na.rm = TRUE)) %>% 
  pivot_wider(names_from = Group, values_from = Value) %>% 
  mutate(
    Table1 = alle - notprevpos
  )  %>%
  mutate(Date = as.Date(paste0(Year, sprintf("%02d", Week), "1"), "%Y%U%u")) %>% 
  select(-alle, -notprevpos)

p1 <- read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name == "Positive") %>%
  select(Date, daily) %>%
  mutate(`SSI daily cumulated` = cumsum(daily)) %>%
  full_join(temp_df, by = "Date") %>%
  mutate(Table1 = lead(Table1, 60)) %>%
  select(-Week, -Year, -daily) %>% 
  filter(wday(Date) == 5) %>% 
  pivot_longer(-Date) %>% 
  ggplot() +
  scale_color_discrete(name = "Dataset") +
  geom_line(aes(Date, value, color = name), size = 1.5) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Cases",
    title = "Prev pos moved back 60 days"
  ) 

p2 <- read_csv2("../data/SSI_daily_data.csv") %>%
  filter(name == "Positive") %>%
  select(Date, daily) %>%
  mutate(`SSI daily cumulated` = cumsum(daily)) %>%
  full_join(temp_df, by = "Date") %>%
  mutate(Table1 = lead(Table1, 30)) %>%
  select(-Week, -Year, -daily) %>% 
  filter(wday(Date) == 7) %>% 
  pivot_longer(-Date) %>% 
  ggplot() +
  scale_color_discrete(name = "Dataset") +
  geom_line(aes(Date, value, color = name), size = 1.5) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Cases",
    title = "Prev pos moved back 30 days"
  ) 

p1 + p2 + plot_layout(guides = "collect")

ggsave("../figures/bt_QC_prevpos_vs_cum.png", width = 27, height = 10, units = "cm", dpi = 300)




x <- bt_2 %>% 
  filter(
    Variable == "indlagte",
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Anden vaccination")
  ) %>% 
  pivot_wider(names_from = c(Type, Variable, Group), values_from = Value, names_sep = "_") %>%
  mutate(antal_personer = antal_indlagte_NA / incidence_indlagte_NA * 100000) %>% 
  group_by(Week, Year) %>% 
  summarize(antal_personer = sum(antal_personer, na.rm = TRUE))

y <- bt_1 %>% 
  filter(
    Variable == "personer",
    Vax_status %in% c("Ingen vaccination", "Første vaccination", "Anden vaccination")
  ) %>% 
  group_by(Group, Week, Year) %>% 
  summarize(Value = sum(Value, na.rm = TRUE))
  
  
