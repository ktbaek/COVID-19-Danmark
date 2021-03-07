vax_files <- list.dirs(path="../data/Vax_data/", full.names = FALSE, recursive = FALSE)
last_file <- tail(vax_files[str_starts(vax_files, "Vaccine_")], 1)
vax_today_string <- str_sub(last_file, 12, 17)
vax_today <- paste0("20", str_sub(vax_today_string, 1, 2), "-", str_sub(vax_today_string, 3, 4), "-", str_sub(vax_today_string, 5, 6))

age_vax_df <- read_csv(paste0("../data/Vax_data/Vaccine_DB_", vax_today_string, "/Vaccinationer_region_aldgrp_koen.csv"), locale = locale(encoding = "ISO-8859-1"))

begun_vax_df <- read_csv(paste0("../data/Vax_data/Vaccine_DB_", vax_today_string, "/FoersteVacc_region_dag.csv"), locale = locale(encoding = "ISO-8859-1"))

done_vax_df <- read_csv(paste0("../data/Vax_data/Vaccine_DB_", vax_today_string, "/FaerdigVacc_region_dag.csv"), locale = locale(encoding = "ISO-8859-1"))

age_vax_df %>%
  set_colnames(c("Region", "Aldersgruppe", "Sex", "Begun", "Done")) %>%
  filter(!is.na(Aldersgruppe)) %>%
  group_by(Aldersgruppe, Sex) %>%
  summarize(Begun = sum(Begun, na.rm = TRUE),
            Done = sum(Done, na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(aes(Aldersgruppe, Begun, fill = Sex), stat = "identity", position = "dodge") +
  labs(y = "Antal", 
       title = "Antal påbegyndt COVID-19 vaccinerede per køn og alder", 
       caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI",
       subtitle = paste0("Til og med ", str_to_lower(strftime(as.Date(vax_today)-1, "%e. %b %Y")))) +
  scale_fill_manual(name = "", labels = c("Kvinder", "Mænd"), values=c("#11999e", "#30e3ca")) +
  standard_theme

ggsave("../figures/ntl_vax_age.png", width = 18, height = 10, units = "cm", dpi = 300)

dst_age_sex <- read_csv2("../data/DST_age_sex_group_data.csv")

dst_age_sex %<>%
  set_colnames(c("Aldersgruppe", "M", "K")) %>%
  pivot_longer(-Aldersgruppe, "Sex", values_to = "Population")

age_vax_df %>%
  set_colnames(c("Region", "Aldersgruppe", "Sex", "Begun", "Done")) %>%
  filter(!is.na(Aldersgruppe)) %>%
  group_by(Aldersgruppe, Sex) %>%
  summarize(Begun = sum(Begun, na.rm = TRUE),
            Done = sum(Done, na.rm = TRUE)) %>%
  full_join(dst_age_sex, by = c("Aldersgruppe", "Sex")) %>% 
  mutate(Incidense = Begun / Population * 100) %>%
  ggplot() +
  geom_bar(aes(Aldersgruppe, Incidense, fill = Sex), stat = "identity", position = "dodge") +
  scale_y_continuous(labels = function(x) paste0(x, " %")) +
  labs(y = "Andel", 
       title = "Andel af personer som er påbegyndt COVID-19 vaccination", 
       caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik og SSI",
       subtitle = paste0("Til og med ", str_to_lower(strftime(as.Date(vax_today)-1, "%e. %b %Y")))) +
  scale_fill_manual(name = "", labels = c("Kvinder", "Mænd"), values=c("#11999e", "#30e3ca")) +
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


begun_vax_df %>%
  full_join(done_vax_df, by = "Date") %>%
  pivot_longer(-Date) %>%
  replace_na(list(value = 0)) %>%
  group_by(name) %>%
  mutate(cum_value = cumsum(value)) %>% 
  ggplot() +
  geom_line(aes(Date, cum_value, color = name), size = 2) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
  scale_y_continuous(limits = c(0, NA), labels = scales::number) +
  scale_color_manual(name = "", labels = c("Påbegyndt", "Færdigvaccineret"), values=c("#11999e", "#30e3ca")) +
  labs(y = "Antal", title = "Kumuleret antal COVID-19 vaccinerede", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme

ggsave("../figures/ntl_vax_cum.png", width = 18, height = 10, units = "cm", dpi = 300)

if(today != vax_today){
index_file  <- readLines("../index.md")
dateline  <- paste0("Senest opdateret ", str_to_lower(format(as.Date(today), "%e. %B %Y")), " efter kl 14.<br>*Vaccinationsplots dog opdateret ", str_to_lower(format(as.Date(vax_today), "%e. %B %Y")), "*")
index_file[8] <- dateline
writeLines(index_file, con="../index.md")
}


