library(ISOweek)

b117 <- pdf_text(paste0("../data/B117_SSI/B117_", today_string, ".pdf")) %>%
  read_lines()

tabel_1 <- which(str_detect(b117, "Tabel 1"))[1]

table_1 <- b117[(tabel_1 + 6):(tabel_1 + 16)]

table_1 %<>%
  str_squish() %>%
  strsplit(split = " ")

table_1 <- lapply(table_1, function(x) x[1:7])

table_1_df <- tibble(data.frame(matrix(unlist(table_1), nrow = length(table_1), byrow=T)))

table_1_df %<>%
  select(X2, X4, X6) %>%
  set_colnames(c("Week", "total", "yes")) %>%
  mutate_all(str_replace_all, "\\.", "") %>%
  mutate_all(str_replace_all, "\\*", "") %>%
  mutate_all(as.double) %>%
  mutate(year = ifelse(Week %in% seq(46,53), 2020, 2021)) %>%
  mutate(Week = sprintf("%02d", Week)) %>%
  mutate(Date = ISOweek2date(paste0(year, "-W", Week, "-1"))) %>%
  select(-year) 
  #slice(1:nrow(.)-1) 
  
plot_data <- tests %>%
  group_by(Date=floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 1))) %>%
  summarize(positive = sum(NewPositive, na.rm = TRUE),
            tested = sum(NotPrevPos, na.rm = TRUE)) %>% 
  full_join(table_1_df, by = "Date") %>%
  filter(Date > as.Date("2020-11-01")) %>%
  filter(!is.na(Week)) %>%
  mutate(share = positive * yes / total,
         share_pct = positive * yes / total / tested * 100,
         pos_pct = positive / tested * 100) %>%
  rowwise() %>%
  mutate(CI_lo = prop.test(yes, total)$conf.int[1] * 100,
         CI_hi = prop.test(yes, total)$conf.int[2] * 100) %>%
  mutate(share_pct_lo = positive * CI_lo / tested,
         share_pct_hi = positive * CI_hi / tested) %>%
  select(Date, positive, share, share_pct, pos_pct, share_pct_lo, share_pct_hi) %>%
  pivot_longer(-Date, names_to = "variable", values_to = "value") 



plot_data %>%
  filter(variable %in% c("share", "positive")) %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = variable), width = 5) +
  geom_text(data = subset(plot_data, variable == "share"), aes(Date, value + 500  ,label = round(value, 0)), vjust=0, family = "lato", color = darken('#E69F00',0.2), fontface = "bold", size = 3) +
  scale_fill_manual(name = "", labels = c("Andre varianter", "B.1.1.7"), values=c("gray85",'#E69F00'))+
  scale_x_date(labels = my_date_labels, date_breaks = "2 week") +
  scale_y_continuous(
    limits = c(0, NA)
  ) +
  labs(y = "Antal positive", x = "Uge (startdato)", title = "Ugentligt antal positivt testede og estimeret antal positive for B.1.1.7", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI", subtitle = "Estimeret antal B.1.1.7 = antal positive \u00D7 antal B.1.1.7 genom / total antal genom") +
  standard_theme  +
  theme(
        axis.title.x = element_text(face = "bold", margin = margin(t = 0, r = 0, b = 8, l = 0)))

ggsave("../figures/ntl_b117.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(variable %in% c("share_pct", "pos_pct")) %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = variable), width = 5) +
  geom_text(data = subset(plot_data, variable == "share_pct"), aes(Date, value + 0.06 ,label = round(value, 3)), vjust=0, family = "lato", color = darken('#E69F00',0.2), fontface = "bold", size = 3) +
  scale_fill_manual(name = "", labels = c("Andre varianter", "B.1.1.7"), values=c("gray85",'#E69F00'))+
  scale_x_date(labels = my_date_labels, date_breaks = "2 week") +
  scale_y_continuous(
    limits = c(0, NA),
    labels = function(x) paste0(x, " %")
  ) +
  labs(y = "Positivprocent", x = "Uge (startdato)", title = "Total positivprocent og estimeret positivprocent for B.1.1.7", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI", subtitle = "Positivprocent for B.1.1.7 = antal positive \u00D7 antal B.1.1.7 genom / total antal genom / antal testede \u00D7 100") +
  standard_theme  +
  theme(
        axis.title.x = element_text(face = "bold", margin = margin(t = 0, r = 0, b = 8, l = 0)))

ggsave("../figures/ntl_b117_pct.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %>%
  filter(variable %in% c("share_pct", "share_pct_lo", "share_pct_hi")) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  ggplot() +
  geom_ribbon(aes(Date, ymin=share_pct_lo, ymax=share_pct_hi), fill = alpha('#E69F00', 0.4)) +
  geom_line(aes(Date, share_pct), color = '#E69F00', size = 1.3) +
  #geom_point(aes(Date, share_pct), color = '#E69F00', size = 2.5) +
  #geom_errorbar(aes(Date, share_pct, ymin=share_pct_lo, ymax=share_pct_hi), size = 0.5, width=1, color = '#E69F00') +
  
  scale_x_date(labels = my_date_labels, date_breaks = "2 week") +
  scale_y_continuous(
    limits = c(0, NA),
    labels = function(x) paste0(x, " %")
  ) +
  labs(y = "Positivprocent", x = "Uge (startdato)", title = "Estimeret positivprocent for B.1.1.7", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI", subtitle = "Positivprocent for B.1.1.7 = antal positive \u00D7 antal B.1.1.7 genom / total antal genom / antal testede \u00D7 100") +
  standard_theme  +
  theme(
        axis.title.x = element_text(face = "bold", margin = margin(t = 0, r = 0, b = 8, l = 0)))

ggsave("../figures/ntl_b117_pct_alone.png", width = 18, height = 10, units = "cm", dpi = 300)
