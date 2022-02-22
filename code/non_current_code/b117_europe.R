library(ISOweek)
library(COVID19)
library(countrycode)

world <- covid19(level = 1)
world_2 <- covid19(level = 2)

country_list <- c("Denmark", "Ireland", "Netherlands","Portugal", "Switzerland", "United Kingdom", "Germany", "Belgium", "Norway")

country_list_2 <- c("England", "Wales", "Scotland")

select_countries <- world %>%
  ungroup() %>%
  filter(administrative_area_level_1 %in% country_list) 

select_countries_2 <- world_2 %>%
  ungroup() %>%
  filter(administrative_area_level_2 %in% country_list_2) 

b117_eu <- read_csv2("../data/B117_SSI/B117_europe.csv")

b117_eu %<>%
  pivot_longer(-Country, "Week", values_to = "Share") %>%
  filter(Country %in% c(country_list, country_list_2)) %>%
  mutate(Week = str_sub(Week, 6, 7)) %>%
  mutate(year = ifelse(Week %in% seq(42,53), 2020, 2021)) %>%
  mutate(Week = sprintf("%02s", Week)) %>%
  mutate(Date = ISOweek2date(paste0(year, "-W", Week, "-1"))) %>%
  select(Date, Country, Share) %>%
  mutate(Share = as.double(Share)) 


select_countries_2 %<>%
  select(date, confirmed, tests, administrative_area_level_2, population) %>%
  rename(Date = date,
         Positive = confirmed,
         Country = administrative_area_level_2)

Sys.setlocale("LC_ALL", "en_US.UTF-8")

x <- select_countries %>%
  select(date, confirmed, administrative_area_level_1, population) %>%
  rename(Date = date,
         Positive = confirmed,
         Country = administrative_area_level_1) %>%
  bind_rows(select_countries_2) %>%
  mutate(Positive = Positive / population * 100000) %>% 
  group_by(Country) %>%
  mutate(Positive = c(0, diff(Positive))) %>%
  ungroup() %>%
  group_by(Country, Date=floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 1))) %>%
  summarize(total_pos = sum(Positive, na.rm = TRUE)) %>%
  filter(Date > ymd("2020-10-12")) %>%
  full_join(b117_eu, by = c("Date", "Country")) %>% 
  mutate(variant_abs = total_pos * Share,
         normal_abs = total_pos - variant_abs) %>% 
  mutate(z_total_pos = ifelse(is.na(Share), total_pos, NA)) %>% #data.frame
  pivot_longer(c(-Date, -Country), "variable", values_to = "value") %>%
  filter(variable %in% c("variant_abs", "normal_abs", "z_total_pos")) %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = variable, color = variable), width = 5, size = 0.4) +
  facet_wrap(~Country, scales = "free") +
  scale_fill_manual(name = "", labels = c("Other variants", "B.1.1.7", "All variants (when lacking B.1.1.7 data)"), values=c("gray70", pos_col, "white"))+
  scale_color_manual(name = "", labels = c("Other variants", "B.1.1.7", "All variants (when lacking B.1.1.7 data)"),values=c(NA, NA, "gray70"))+
  scale_x_date(date_labels = "%e %b", date_breaks = "2 month", limits = c(ymd("2020-10-12"), ymd("2021-03-06"))) +
  scale_y_continuous(
    limits = c(0, NA)
  ) +
  labs(y = "Cases per 100,000", x = "Dato", title = "Weekly total incidence and estimated incidence of B.1.1.7", caption = "Kristoffer T. Bæk, covid19danmark.dk, data sources: covid19datahub.io, wikipedia.org/wiki/Lineage_B.1.1.7") +
  facet_theme  
  
ggsave("../figures/europe_b117_abs.png", width = 25, height = 13, units = "cm", dpi = 300)


x <- select_countries %>%
  select(date, confirmed, administrative_area_level_1, tests) %>%
  rename(Date = date,
         Positive = confirmed,
         Country = administrative_area_level_1) %>%
  bind_rows(select_countries_2) %>%
  filter(!Country %in% c("Belgium", "Scotland", "Wales")) %>% 
  #group_by(Country) %>%
  #mutate(Positive = c(0, diff(Positive))) %>%
  #ungroup() %>%
  mutate(Sunday=floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 7))) %>%
  filter(Date == Sunday) %>% 
  group_by(Country) %>% 
  mutate(Positive = c(0, diff(Positive)),
         tests = c(0, diff(tests))) %>%
  filter(Date > ymd("2020-10-12")) %>%
  mutate(Date = Date + 1) %>% 
  left_join(b117_eu, by = c("Date", "Country")) %>% 
  mutate(variant_pct = Positive / tests * Share * 100,
         normal_pct = Positive / tests * 100 - variant_pct) %>% 
  mutate(z_total_pct = ifelse(is.na(Share), Positive / tests * 100, NA)) %>% 
  select(-Sunday) %>%
  pivot_longer(c(-Date, -Country), "variable", values_to = "value") %>%
  filter(variable %in% c("variant_pct", "normal_pct", "z_total_pct")) %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = variable, color = variable), width = 5, size = 0.4) +
  facet_wrap(~Country, scales = "free") +
  scale_fill_manual(name = "", labels = c("Other variants", "B.1.1.7", "All variants (when lacking B.1.1.7 data)"), values=c("gray80", '#E69F00', "white"))+
  scale_color_manual(name = "", labels = c("Other variants", "B.1.1.7", "All variants (when lacking B.1.1.7 data)"),values=c(NA, NA, "gray75"))+
  scale_x_date(date_labels = "%e %b", date_breaks = "2 month", limits = c(ymd("2020-10-12"), ymd("2021-03-06"))) +
  scale_y_continuous(
    limits = c(0, NA),
    labels = function(x) paste0(x, " %")
  ) +
  labs(y = "Percentage", x = "Dato", title = "Weekly positivity rate and estimated positivity rate for B.1.1.7", caption = "Kristoffer T. Bæk, covid19danmark.dk, data sources: covid19datahub.io, wikipedia.org/wiki/Lineage_B.1.1.7") +
  facet_theme  

ggsave("../figures/europe_b117_pct.png", width = 25, height = 13, units = "cm", dpi = 300)





select_countries %>%
  select(date, confirmed, administrative_area_level_1) %>%
  rename(Date = date,
         Positive = confirmed,
         Country = administrative_area_level_1) %>%
  bind_rows(select_countries_2) %>%
  group_by(Country) %>%
  mutate(Positive = c(0, diff(Positive))) %>%
  ungroup() %>%
  group_by(Country, Date=floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 1))) %>%
  summarize(total_pos = sum(Positive, na.rm = TRUE)) %>%
  filter(Date > ymd("2020-10-12")) %>%
  full_join(b117_eu, by = c("Date", "Country")) %>%
  mutate(variant_abs = total_pos * Share,
         normal_abs = total_pos - variant_abs) %>%
  pivot_longer(c(-Date, -Country), "variable", values_to = "value") %>%
  filter(variable %in% c("variant_abs", "normal_abs")) %>%
  ggplot() +
  geom_line(aes(Date, value, color = variable), size = 0.7) +
  facet_wrap(~Country, scales = "free") +
  scale_color_manual(name = "", labels = c("Andre varianter", "B.1.1.7"), values=c("gray60", pos_col))+
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", limits = c(ymd("2020-10-12"), ymd("2021-02-08"))) +
  scale_y_continuous(
    limits = c(0, 320000)
  ) +
  labs(y = "Antal positive", x = "Dato", title = "Ugentligt antal positivt testede og estimeret antal positive for B.1.1.7", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: covid19datahub.io, wikipedia.org/wiki/Lineage_B.1.1.7") +
  facet_theme  

ggsave("../figures/europe_b117_abs_2.png", width = 25, height = 13, units = "cm", dpi = 300)
ggsave("../figures/europe_b117_abs_3.png", width = 25, height = 13, units = "cm", dpi = 300)



world %>%
  ungroup() %>%
  filter(administrative_area_level_1 %in% c("Denmark", "Czech Republic", "Estonia")) %>%
  select(date, tests, confirmed, deaths, administrative_area_level_1, population) %>%
  rename(Date = date,
         Positive = confirmed,
         Country = administrative_area_level_1) %>%
  group_by(Country) %>%
  mutate(Positive = c(0, diff(Positive)),
         tests = c(0, diff(tests)),
         deaths = c(0, diff(deaths))) %>%
  ungroup() %>%
  group_by(Country, Date=floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 1))) %>%
  summarize(pos = sum(Positive, na.rm = TRUE),
            test = sum(tests, na.rm = TRUE),
            death = sum(deaths, na.rm = TRUE),
            population = mean(population)) %>%
  filter(Date > ymd("2020-09-30")) %>%
  ggplot() +
  geom_line(aes(Date, death / population * 100000, color = Country))
