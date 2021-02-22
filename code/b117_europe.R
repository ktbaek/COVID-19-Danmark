library(ISOweek)
library(COVID19)
library(countrycode)

world <- covid19(level = 1)

country_list <- c("Denmark", "France", "Ireland", "Luxembourg", "Netherlands","Portugal", "Switzerland", "United Kingdom")

select_countries <- world %>%
  filter(administrative_area_level_1 %in% country_list) 

b117_eu <- read_csv2("../data/B117_SSI/B117_europe.csv")

b117_eu %>%
  pivot_longer(-Country, "Week", values_to = "Share") %>%
  mutate(Week = str_sub(Week, 6, 7)) %>%
  mutate(year = ifelse(Week %in% seq(42,53), 2020, 2021)) %>%
  mutate(Week = sprintf("%02s", Week)) %>%
  mutate(Date = ISOweek2date(paste0(year, "-W", Week, "-1"))) %>%
  select(Date, Country, Share) %>%
  mutate(Share = as.double(Share)) %>%
  ggplot() +
  geom_line(aes(Date, Share, color = Country))