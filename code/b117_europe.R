library(ISOweek)
library(COVID19)
library(countrycode)

world <- covid19(level = 1)
world_2 <- covid19(level = 2)

country_list <- c("Denmark", "Ireland", "Netherlands","Portugal", "Switzerland", "United Kingdom")
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
  select(date, confirmed, administrative_area_level_2) %>%
  rename(Date = date,
         Positive = confirmed,
         Country = administrative_area_level_2)

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
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = variable), width = 5) +
  facet_wrap(~Country, scales = "free") +
  scale_fill_manual(name = "", labels = c("Andre varianter", "B.1.1.7"), values=c("gray70", pos_col))+
  scale_x_date(labels = my_date_labels, date_breaks = "2 month", limits = c(ymd("2020-10-12"), ymd("2021-02-08"))) +
  scale_y_continuous(
    limits = c(0, NA)
  ) +
  labs(y = "Antal positive", x = "Dato", title = "Ugentligt antal positivt testede og estimeret antal positive for B.1.1.7", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: covid19datahub.io, wikipedia.org/wiki/Lineage_B.1.1.7") +
  facet_theme  
  
ggsave("../figures/europe_b117_abs.png", width = 25, height = 13, units = "cm", dpi = 300)
