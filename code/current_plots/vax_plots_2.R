vax_files <- list.dirs(path = "../data/Vax_data/", full.names = FALSE, recursive = FALSE)
last_file <- tail(vax_files[str_starts(vax_files, "Vaccine_")], 1)
vax_today_string <- str_sub(last_file, 12, 17)
vax_today <- paste0("20", str_sub(vax_today_string, 1, 2), "-", str_sub(vax_today_string, 3, 4), "-", str_sub(vax_today_string, 5, 6))

age_vax_df <- read_csv2(paste0("../data/Vax_data/Vaccine_DB_", vax_today_string, "/Vaccinationer_region_aldgrp_koen.csv"), locale = locale(encoding = "ISO-8859-1"))
begun_vax_df <- read_csv2(paste0("../data/Vax_data/Vaccine_DB_", vax_today_string, "/FoersteVacc_region_dag.csv"), locale = locale(encoding = "ISO-8859-1"))
done_vax_df <- read_csv2(paste0("../data/Vax_data/Vaccine_DB_", vax_today_string, "/FaerdigVacc_region_dag.csv"), locale = locale(encoding = "ISO-8859-1"))
revax_df <- read_csv2(paste0("../data/Vax_data/Vaccine_DB_", vax_today_string, "/Revacc1_region_dag.csv"), locale = locale(encoding = "ISO-8859-1"))
age_time_df <- read_csv2(paste0("../data/Vax_data/Vaccine_DB_", vax_today_string, "/FoersteVacc_FaerdigVacc_region_fnkt_alder_dag.csv"), locale = locale(encoding = "ISO-8859-1"))

age_vax_df %>%
  set_colnames(c("Region", "Aldersgruppe", "Sex", "Begun", "Done")) %>%
  filter(!is.na(Aldersgruppe)) %>%
  group_by(Aldersgruppe, Sex) %>%
  summarize(
    Begun = sum(Begun, na.rm = TRUE),
    Done = sum(Done, na.rm = TRUE)
  ) %>%
  ggplot() +
  geom_bar(aes(Aldersgruppe, Begun, fill = Sex), stat = "identity", position = "dodge") +
  scale_y_continuous(limits = c(0, NA), labels = scales::number) +
  labs(
    y = "Antal",
    title = "Antal påbegyndt COVID-19 vaccinerede per køn og alder",
    caption = standard_caption,
    subtitle = paste0("Til og med ", str_to_lower(strftime(as.Date(vax_today) - 1, "%e. %b %Y")))
  ) +
  scale_fill_manual(name = "", labels = c("Kvinder", "Mænd"), values = c("#11999e", "#30e3ca")) +
  standard_theme

ggsave("../figures/ntl_vax_age.png", width = 18, height = 10, units = "cm", dpi = 300)

pop <- get_pop_by_breaks(age_breaks = get_age_breaks(maxage = 90, agesplit = 10)) %>%
  filter(Year == 2021, Quarter == 4) %>%
  mutate(Sex = ifelse(Sex == "Male", "M", "K")) %>%
  ungroup() %>%
  select(-Year, -Quarter)

age_vax_df %>%
  set_colnames(c("Region", "Aldersgruppe", "Sex", "Begun", "Done")) %>%
  filter(!is.na(Aldersgruppe)) %>%
  group_by(Aldersgruppe, Sex) %>%
  summarize(
    Begun = sum(Begun, na.rm = TRUE),
    Done = sum(Done, na.rm = TRUE)
  ) %>%
  full_join(pop, by = c("Aldersgruppe" = "Age", "Sex")) %>%
  mutate(Incidense = Begun / Population * 100) %>%
  ggplot() +
  geom_bar(aes(Aldersgruppe, Incidense, fill = Sex), stat = "identity", position = "dodge") +
  scale_y_continuous(limits = c(0, 105), labels = function(x) paste0(x, " %")) +
  labs(
    y = "Andel",
    title = "Andel af personer som er påbegyndt COVID-19 vaccination",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik og SSI",
    subtitle = paste0("Til og med ", str_to_lower(strftime(as.Date(vax_today) - 1, "%e. %b %Y")))
  ) +
  scale_fill_manual(name = "", labels = c("Kvinder", "Mænd"), values = c("#11999e", "#30e3ca")) +
  standard_theme

ggsave("../figures/ntl_vax_age_pct.png", width = 18, height = 10, units = "cm", dpi = 300)


begun_vax_df %<>%
  set_colnames(c("Date", "X1", "Region", "Begun", "X2")) %>%
  select(Date, Region, Begun) %>%
  group_by(Date) %>%
  summarize(Begun = sum(Begun, na.rm = TRUE))

done_vax_df %<>%
  set_colnames(c("Date", "X1", "Region", "Done", "X2")) %>%
  select(Date, Region, Done) %>%
  group_by(Date) %>%
  summarize(Done = sum(Done, na.rm = TRUE))

revax_df %<>%
  rename(
    Date = `Revacc. 1 dato`,
    Antal = `Antal revacc. 1`
  ) %>%
  group_by(Date) %>%
  summarize(Revax = sum(Antal, na.rm = TRUE))

begun_vax_df %>%
  full_join(done_vax_df, by = "Date") %>%
  full_join(revax_df, by = "Date") %>%
  pivot_longer(-Date) %>%
  replace_na(list(value = 0)) %>%
  group_by(name) %>%
  mutate(cum_value = cumsum(value)) %>%
  mutate(cum_value = ifelse(cum_value == 0, NA, cum_value)) %>%
  ggplot() +
  geom_line(aes(Date, cum_value, color = name), size = 2) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 months", minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
  scale_y_continuous(limits = c(0, NA), labels = scales::number) +
  scale_color_manual(name = "", labels = c("Første dose", "Anden dose", "Tredje dose"), values = c("#30e3ca", "#11999e", "#1c3499")) +
  labs(y = "Antal", title = "Kumuleret antal COVID-19 vaccinerede", caption = standard_caption) +
  standard_theme

ggsave("../figures/ntl_vax_cum.png", width = 18, height = 10, units = "cm", dpi = 300)

fnkt_age_breaks <- c(-1, 5, 11, 15, 19, 39, 64, 79, 125)

pop <- get_pop_by_breaks(age_breaks = fnkt_age_breaks) %>%
  group_by(Year, Quarter, Age) %>%
  summarize(Population = sum(Population, na.rm = TRUE))

bt_2_extra <- read_csv2("../data/tidy_breakthru_table2_deduced.csv")

booster <- bt_2_extra %>%
  filter(
    Variable == "personer",
    Group == "alle"
  ) %>%
  filter(Vax_status == "Fuld effekt efter revaccination") %>%
  mutate(Date = as.Date(paste0(Year, sprintf("%02d", Week), "1"), "%Y%U%u")) %>%
  select(-Vax_status, -Week, -Year, -Type, -Variable, -Group) %>%
  mutate(Age = case_when(
    Age == "20-29" ~ "20-39",
    Age == "30-39" ~ "20-39",
    Age == "40-49" ~ "40-64",
    Age == "50-59" ~ "40-64",
    Age == "60-64" ~ "40-64",
    Age == "65-69" ~ "65-79",
    Age == "70-79" ~ "65-79",
    TRUE ~ Age
  )) %>%
  group_by(Date, Age) %>%
  summarize(Value = sum(Value, na.rm = TRUE)) %>%
  mutate(
    Year = year(Date),
    Quarter = quarter(Date)
  ) %>%
  left_join(pop, by = c("Age", "Year", "Quarter")) %>%
  arrange(Date) %>%
  group_by(Age) %>%
  fill(Population) %>%
  mutate(
    cum_pct = Value / Population * 100,
    Dose = "Third"
  ) %>%
  select(-Value)

plot_data <- age_time_df %>%
  rename(
    Date = Dato,
    Age = Aldersgruppe,
    First = `Antal første vacc.`,
    Second = `Antal færdigvacc.`
  ) %>%
  pivot_longer(c(First, Second), names_to = "Dose") %>%
  filter(!is.na(Age)) %>%
  mutate(Age = case_when(
    Age == "0-2" ~ "0-5",
    Age == "3-5" ~ "0-5",
    TRUE ~ Age
  )) %>%
  group_by(Date, Age, Dose) %>%
  summarize(value = sum(value, na.rm = TRUE)) %>%
  mutate(
    Year = year(Date),
    Quarter = quarter(Date)
  ) %>%
  left_join(pop, by = c("Age", "Year", "Quarter")) %>%
  group_by(Age) %>%
  fill(Population) %>%
  mutate(pct = value / Population * 100) %>%
  group_by(Age, Dose) %>%
  arrange(Date) %>%
  mutate(
    cum = cumsum(value),
    cum_pct = cumsum(pct)
  ) %>%
  select(-value, -pct, -cum) %>%
  bind_rows(booster)


plot_data$Age <- factor(plot_data$Age, levels = c("0-5", "6-11", "12-15", "16-19", "20-39", "40-64", "65-79", "80+"))

plot_data %>%
  ggplot() +
  geom_line(aes(Date, cum_pct, color = Dose), size = rel(0.8)) +
  scale_x_date(labels = my_date_labels, breaks = c(ymd("2021-07-01"), ymd("2022-01-01")), minor_breaks = "1 month", expand = expansion(mult = 0.03)) +
  scale_y_continuous(limits = c(0, NA), labels = function(x) paste0(x, " %")) +
  scale_color_manual(name = "", labels = c("Første dose", "Anden dose", "Fuld effekt tredje dose"), values = c("#30e3ca", "#11999e", "#1c3499")) +
  guides(color = guide_legend(override.aes = list(size = 1.6))) +
  labs(y = "Procent", title = "Andel af COVID-19 vaccinerede opdelt på alder", caption = standard_caption) +
  facet_wrap(~Age, ncol = 4) +
  standard_theme +
  theme(
    panel.grid.minor.x = element_line(size = 0.1),
    panel.grid.major.x = element_line(size = 0.3)
  )

ggsave("../figures/ntl_vax_cum_age.png", width = 18, height = 10, units = "cm", dpi = 300)


if (today != vax_today) {
  index_file <- readLines("../index.md")
  dateline <- paste0("Senest opdateret ", str_to_lower(format(as.Date(today), "%e. %B %Y")), " efter kl 14.<br>*Vaccinationsplots dog opdateret ", str_to_lower(format(as.Date(vax_today), "%e. %B %Y")), "*")
  index_file[8] <- dateline
  writeLines(index_file, con = "../index.md")
}
