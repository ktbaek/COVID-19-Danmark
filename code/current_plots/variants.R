
read_csv2("../data/SSI_omikron.csv") %>% 
  mutate(
    Date = dmy(Date),
    pct = as.double(pct)
  ) %>% 
  full_join(read_csv2("../data/SSI_daily_data.csv"), by = "Date") %>% 
  filter(name == "Positive") %>% 
  mutate(
    omikron = daily * pct / 100,
    delta = daily - omikron
    ) %>% 
  select(-ra, -name, -pct, -daily) %>% 
  pivot_longer(-Date) %>% 
  filter(Date >= ymd("2021-11-01")) %>% 
  ggplot() +
  geom_bar(aes(Date, value, fill = name), width = 1, stat = "identity", position = "stack") +
  scale_fill_manual(name = "", labels = c("Delta", "Omikron"), values=c("gray85", pos_col))+
  scale_x_date(labels = my_date_labels, date_breaks = "1 week") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Antal positive",
    title = "Dagligt antal positivt testede opdelt på variant", 
    caption = standard_caption
  ) +
  standard_theme  

ggsave("../figures/ntl_omikron_daily_pos.png", width = 18, height = 10, units = "cm", dpi = 300)

alpha_delta <- read_csv2("../data/SSI_alpha_delta.csv") %>% 
  mutate(
    Date = as.Date(paste0(Year, sprintf("%02d", Week), "1"), "%Y%U%u"),
    Date = case_when(
      Year == 2020 & Week == 53 ~ ymd("2020-12-28"),
      Year == 2020 & Week < 53 ~ Date - days(7),
      TRUE ~ Date
    )) %>% 
  select(-Year, -Week) 

omikron <- read_csv2("../data/SSI_omikron.csv") %>% 
  mutate(
    Date = dmy(Date),
    pct = as.double(pct)
  ) %>% 
  inner_join(read_csv2("../data/SSI_daily_data.csv"), by = "Date") %>% 
  filter(name == "Positive") %>% 
  mutate(
    Omikron_cases = daily * pct / 100
  ) %>% 
  group_by(Date=floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 1))) %>% 
  summarize(
    Omikron_cases = sum(Omikron_cases, na.rm = TRUE),
    cases = sum(daily, na.rm = TRUE),
    Omikron = Omikron_cases / cases * 100
  ) %>% 
  select(Date, Omikron)

plot_data <- read_csv2("../data/SSI_daily_data.csv") %>% 
  filter(name == "Positive") %>% 
  group_by(Date=floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 1))) %>% 
  summarize(cases = sum(daily, na.rm = TRUE)) %>% 
  full_join(alpha_delta, by = "Date") %>% 
  fill(Delta) %>% 
  full_join(omikron, by = "Date") %>% 
  mutate(
    across(c(Alpha, Delta, Omikron), .fns = ~replace_na(.,0)),
    Delta = Delta - Omikron,
    Omikron_cases = Omikron * cases / 100,
    Delta_cases = Delta * cases / 100,
    Alpha_cases = Alpha * cases / 100,
    Other = cases - Alpha_cases - Delta_cases - Omikron_cases
  ) %>% 
  select(-cases, -Alpha, -Delta, -Omikron) %>% 
  rename(
    Alfa = Alpha_cases,
    Delta = Delta_cases,
    Omikron = Omikron_cases,
    Andre = Other
  ) %>% 
  filter(!is.na(Date)) %>% 
  pivot_longer(-Date)

plot_data$name <- factor(plot_data$name, levels = c("Andre", "Alfa", "Delta", "Omikron"))

plot_data %>% 
filter(
  Date >= ymd("2020-11-01"),
  Date != max(Date)) %>% 
  ggplot() +
  geom_area(aes(Date, value, fill = name), width = 5, stat = "identity", position = "stack") +
  scale_fill_manual(name = "", values=c("gray45", "gray65", "gray85", pos_col))+
  scale_x_date(labels = my_date_labels, date_breaks = "2 months", expand = expansion(mult = c(0.01, 0))) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Positive",
    title = "Ugentligt antal positivt testede opdelt på variant", 
    caption = standard_caption
  ) +
  standard_theme  

ggsave("../figures/ntl_all_variants_pos.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>% 
  filter(
    Date >= ymd("2020-11-01"),
    Date != max(Date)) %>% 
  ggplot() +
  geom_area(aes(Date, value, fill = name), width = 5, stat = "identity", position = "fill") +
  scale_fill_manual(name = "", values=c("gray45", "gray65", "gray85", pos_col))+
  scale_x_date(labels = my_date_labels, date_breaks = "2 months", expand = expansion(mult = c(0.01, 0))) +
  scale_y_continuous(limits = c(0, NA), labels = function(x) paste0(x * 100, " %")) +
  labs(
    y = "Andel",
    title = "Ugentligt andel af varianter", 
    caption = standard_caption
  ) +
  standard_theme  

ggsave("../figures/ntl_all_variants_proportion.png", width = 18, height = 10, units = "cm", dpi = 300)

Sys.setlocale("LC_ALL", "en_US.UTF-8")

plot_data %>% 
  filter(
    Date >= ymd("2020-11-01"),
    Date != max(Date)) %>% 
  ggplot() +
  geom_area(aes(Date, value, fill = name), width = 5, stat = "identity", position = "stack") +
  scale_fill_manual(name = "", labels = c("Other", "Alpha", "Delta", "Omicron"), values=c("gray45", "gray65", "gray85", pos_col))+
  scale_x_date(labels = my_date_labels, date_breaks = "2 months", expand = expansion(mult = c(0.01, 0))) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    y = "Cases",
    title = "Weekly cases by variant in Denmark", 
    caption = standard_caption_en
  ) +
  standard_theme  

ggsave("../figures/ntl_all_variants_pos_EN.png", width = 18, height = 10, units = "cm", dpi = 300)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")
