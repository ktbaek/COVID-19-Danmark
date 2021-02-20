vax_files <- list.files(path="../data/Vax_data/", full.names = FALSE, recursive = FALSE)
last_file <- tail(vax_files[str_starts(vax_files, "Vaxdata_")], 1)
vax_today_string <- str_sub(last_file, 9, 14)
vax_today <- paste0("20", str_sub(vax_today_string, 1, 2), "-", str_sub(vax_today_string, 3, 4), "-", str_sub(vax_today_string, 5, 6))

vax <- pdf_text(paste0("../data/Vax_data/Vaxdata_", vax_today_string, ".pdf")) %>%
  read_lines()

tabel_3 <- which(str_detect(vax, "Tabel 3"))[2]

age_vax <- vax[(tabel_3 + 4):(tabel_3 + 13)]
#age_vax_colnames <- vax[(tabel_4 + 1)]

age_vax %<>%
  str_squish() %>%
  strsplit(split = " ")

# age_vax_colnames %<>%
#   str_squish() %>%
#   strsplit(split = " ")

age_vax_df <- data.frame(matrix(unlist(age_vax), nrow=length(age_vax), byrow=T))

#colnames(age_vax_df) <- c(unlist(age_vax_colnames)[1:3], "Total")


age_vax_df %>%
  as_tibble %>%
  set_colnames(c("Aldersgruppe", "Female_start", "Female_done", "Male_start", "Male_done", "Total")) %>%
  mutate_all(str_replace_all, "\\.", "") %>%
  mutate(across(-Aldersgruppe, as.double)) %>%
  select(-Total) %>%
  pivot_longer(-Aldersgruppe, names_to = "sex", values_to = "value") %>%
  filter(sex %in% c("Female_start", "Male_start")) %>%
  ggplot() +
  geom_bar(aes(Aldersgruppe, value, fill = sex), stat = "identity", position = "dodge") +
  labs(y = "Antal", 
       title = "Antal påbegyndt COVID-19 vaccinerede per køn og alder", 
       caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI",
       subtitle = paste0("Til og med ", str_to_lower(strftime(as.Date(vax_today)-1, "%e. %b %Y")))) +
  scale_fill_manual(name = "", labels = c("Kvinder", "Mænd"), values=c("#11999e", "#30e3ca")) +
  standard_theme

ggsave("../figures/ntl_vax_age.png", width = 18, height = 10, units = "cm", dpi = 300)

dst_age_sex <- read_csv2("../data/DST_age_sex_group_data.csv")


age_vax_df %>%
  as_tibble %>%
  set_colnames(c("Aldersgruppe", "Female_start", "Female_done", "Male_start", "Male_done", "Total")) %>%
  mutate_all(str_replace_all, "\\.", "") %>%
  mutate(across(-Aldersgruppe, as.double)) %>%
  select(-Total) %>%
  full_join(dst_age_sex, by = "Aldersgruppe") %>%
  mutate(Female_start_pct = Female_start / Female * 100,
         Female_done_pct = Female_done / Female * 100,
         Male_start_pct = Male_start / Male * 100,
         Male_done_pct = Male_done / Male * 100) %>%
  pivot_longer(-Aldersgruppe, names_to = "sex", values_to = "value") %>%
  filter(sex %in% c("Female_start_pct", "Male_start_pct")) %>%
  ggplot() +
  geom_bar(aes(Aldersgruppe, value, fill = sex), stat = "identity", position = "dodge") +
  scale_y_continuous(labels = function(x) paste0(x, " %")) +
  labs(y = "Andel", 
       title = "Andel af personer som er påbegyndt COVID-19 vaccination", 
       caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: Danmarks Statistik og SSI",
       subtitle = paste0("Til og med ", str_to_lower(strftime(as.Date(vax_today)-1, "%e. %b %Y")))) +
  scale_fill_manual(name = "", labels = c("Kvinder", "Mænd"), values=c("#11999e", "#30e3ca")) +
  standard_theme

ggsave("../figures/ntl_vax_age_pct.png", width = 18, height = 10, units = "cm", dpi = 300)




tabel_2 <- max(which(str_detect(vax, "Tabel 2")))

days_since_start <- as.integer(as.Date(vax_today) - as.Date("2020-12-27"))

time_vax <- vax[(tabel_2 + 5):(tabel_2 + 4 + days_since_start)]

time_vax %<>%
  str_squish() %>%
  strsplit(split = " ")

time_vax_df <- data.frame(matrix(unlist(time_vax), nrow=length(time_vax), byrow=T))


time_vax_df %>%
  as_tibble %>%
  # select(X2, X5) %>%
  # mutate(Date = as.Date(seq(from = ymd("2020-12-27"), to = ymd("2021-02-15"), by = 1))) %>%
  # select(Date, X2, X5) %>%
  select(X1, X3, X6) %>%
  set_colnames(c("Date", "Begun", "Done")) %>%
  mutate_all(str_replace_all, "\\.", "") %>%
  mutate_all(str_replace_all, "\\,", ".") %>%
  mutate(across(c(Begun, Done), as.double)) %>%
  #mutate(Date = ymd(Date)) %>%
  mutate(Date = dmy(Date)) %>%
  pivot_longer(-Date, names_to = "variable", values_to = "value") %>%
  ggplot() +
  geom_line(aes(Date, value, color = variable), size = 2) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 week") +
  scale_y_continuous(limits = c(0, NA), labels = scales::number) +
  scale_color_manual(name = "", labels = c("Påbegyndt", "Færdigvaccineret"), values=c("#11999e", "#30e3ca")) +
  labs(y = "Antal", title = "Kumuleret antal COVID-19 vaccinerede", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme

ggsave("../figures/ntl_vax_cum.png", width = 18, height = 10, units = "cm", dpi = 300)




