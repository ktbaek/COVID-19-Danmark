vax <- pdf_text(paste0("../data/Vax_data/Vaxdata_", today_string, ".pdf")) %>%
  read_lines()

tabel_4 <- which(str_detect(vax, "Tabel 4"))[2]

age_vax <- vax[(tabel_4 + 4):(tabel_4 + 13)]
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
       subtitle = paste0("Til og med ", str_to_lower(strftime(as.Date(today)-1, "%e. %b %Y")))) +
  scale_fill_manual(name = "", labels = c("Kvinder", "Mænd"), values=c("#11999e", "#30e3ca")) +
  standard_theme

ggsave("../figures/ntl_vax_age.png", width = 18, height = 10, units = "cm", dpi = 300)


tabel_2 <- max(which(str_detect(vax, "Tabel 2")))

days_since_start <- as.integer(as.Date(today) - as.Date("2020-12-27"))

time_vax <- vax[(tabel_2 + 5):(tabel_2 + 4 + days_since_start)]

time_vax %<>%
  str_squish() %>%
  strsplit(split = " ")

time_vax_df <- data.frame(matrix(unlist(time_vax), nrow=length(time_vax), byrow=T))


time_vax_df %>%
  as_tibble %>%
  select(X1, X3) %>%
  set_colnames(c("Date", "Antal")) %>%
  mutate_all(str_replace_all, "\\.", "") %>%
  mutate_all(str_replace_all, "\\,", ".") %>%
  mutate(across(c(Antal), as.double)) %>%
  mutate(Date = dmy(Date)) %>%
  ggplot() +
  geom_line(aes(Date, Antal), color = "#11999e", size = 2) +
  scale_x_date(labels = my_date_labels, date_breaks = "1 week") +
  scale_y_continuous(limits = c(0, NA), labels = scales::number) +
  labs(y = "Antal", title = "Kumuleret antal påbegyndt COVID-19 vaccinerede", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme

ggsave("../figures/ntl_vax_cum.png", width = 18, height = 10, units = "cm", dpi = 300)
