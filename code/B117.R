library(ISOweek)

b117 <- pdf_text(paste0("../data/B117_SSI/B117_", today_string, ".pdf")) %>%
  read_lines()

tabel_1 <- which(str_detect(b117, "Tabel 1"))[1]

table_1 <- b117[(tabel_1 + 6):(tabel_1 + 17)]

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
  
plot_data <- tests %>%
  group_by(Date=floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 1))) %>%
  summarize(positive = sum(NewPositive, na.rm = TRUE),
            tested = sum(NotPrevPos, na.rm = TRUE)) %>% 
  full_join(table_1_df, by = "Date") %>%
  filter(Date > as.Date("2020-11-01")) %>%
  filter(!is.na(Week)) %>%
  mutate(share_est = positive * yes / total,
         pct_est = positive * yes / total / tested * 100,
         pos_pct = positive / tested * 100) %>%
  rowwise() %>%
  mutate(CI_lo = prop.test(yes, total)$conf.int[1],
         CI_hi = prop.test(yes, total)$conf.int[2]) %>%
  mutate(pct_lo = positive * CI_lo / tested * 100,
         pct_hi = positive * CI_hi / tested * 100) %>%
  mutate(share_lo = positive * CI_lo,
         share_hi = positive * CI_hi) %>%
  select(Date, positive, share_est, pct_est, pos_pct, pct_lo, pct_hi, share_lo, share_hi) %>%
  pivot_longer(-Date, names_to = "variable", values_to = "value") 


# Plot 1 ------------------------------------------------------------------

plot_data %>%
  filter(variable %in% c("share_est", "positive")) %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = variable), width = 5) +
  geom_text(data = subset(plot_data, variable == "share_est"), aes(Date, value + 500  ,label = round(value, 0)), vjust=0, family = "lato", color = darken('#E69F00',0.2), fontface = "bold", size = 3) +
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


# Plot 2 ------------------------------------------------------------------

plot_data %>%
  mutate(variable = ifelse(variable == "pct_est", "x_pct_est", variable)) %>%
  filter(variable %in% c("x_pct_est", "pos_pct")) %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = variable), width = 5) +
  geom_text(data = subset(plot_data, variable == "pct_est"), aes(Date, value + 0.06 ,label = round(value, 3)), vjust=0, family = "lato", color = darken('#E69F00',0.2), fontface = "bold", size = 3) +
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


# Plot 3 ------------------------------------------------------------------

plot_data %>%
  filter(variable %in% c("pct_est", "pct_lo", "pct_hi")) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  ggplot() +
  geom_ribbon(aes(Date, ymin=pct_lo, ymax=pct_hi), fill = alpha('#E69F00', 0.4)) +
  geom_line(aes(Date, pct_est), color = '#E69F00', size = 1.3) +
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


# Plot 4 ------------------------------------------------------------------

type <- c("Positivprocent", "Antal positivt testede")
names(type) <- c("x_pct", "share")

plot_data %>%
  filter(variable %in% c("pct_est", "pct_lo", "pct_hi", "share_est", "share_hi", "share_lo")) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  pivot_longer(-Date, names_to = c("variable_1", "variable_2"), names_sep = "_", values_to = "value") %>%
  pivot_wider(names_from = variable_2, values_from = value) %>%
  mutate(variable_1 = ifelse(variable_1 == "pct", "x_pct", variable_1)) %>%
  ggplot() +
  geom_ribbon(aes(Date, ymin=lo, ymax=hi, fill = variable_1)) +
  geom_line(aes(Date, est, color = variable_1), size = 1.3) +
  scale_fill_manual(name = "", values = c(alpha(pos_col, 0.4), alpha('#E69F00', 0.4))) +
  scale_color_manual(name = "", values = c(pos_col, '#E69F00')) +
  facet_wrap(~variable_1, scales = "free", labeller = labeller(variable_1 = type)) + 
  scale_x_date(labels = my_date_labels, date_breaks = "2 week") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Positivprocent/Antal positive", x = "Uge (startdato)", title = "Estimeret ugentlig udbredelse af B.1.1.7", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI", subtitle = "Antal positive med B.1.1.7 = antal positive \u00D7 antal B.1.1.7 genom / total antal genom\nPositivprocent for B.1.1.7 = antal positive med B.1.1.7 / antal testede \u00D7 100") +
  facet_theme  +
  theme(
    legend.position = "none",
    plot.caption = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    axis.title.y = element_blank(),
    strip.text = element_text(size = 9),
    axis.title.x = element_text(face = "bold", margin = margin(t = 0, r = 0, b = 8, l = 0)))

ggsave("../figures/ntl_b117_pct_pos.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data <- tests %>%
  group_by(Date=floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 1))) %>%
  summarize(positive = sum(NewPositive, na.rm = TRUE),
            tested = sum(NotPrevPos, na.rm = TRUE)) %>% 
  full_join(table_1_df, by = "Date") %>%
  filter(Date > as.Date("2020-11-29")) %>%
  filter(!is.na(Week)) %>%
  mutate(share_est = yes / total) %>%
  rowwise() %>%
  mutate(lo = prop.test(yes, total)$conf.int[1],
         hi = prop.test(yes, total)$conf.int[2]) 


# Logistisk plot af andel -------------------------------------------------

plot_data %>%  
ggplot() +
  geom_point(aes(Date, share_est), size = 4, color = alpha(pos_col, 0.4)) +
  geom_smooth(aes(Date, share_est), method="glm", method.args = list(family = "binomial"), se = FALSE, color = pos_col, fullrange=TRUE) + 
  scale_x_date(labels = my_date_labels, date_breaks = "2 week", limits = c(as.Date("2020-11-29"), as.Date("2021-04-01"))) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0,1, by = .10)) +
  labs(y = "Andel", x = "Uge (startdato)", title = "Andel af B.1.1.7 af alle varianter", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme + 
  theme(axis.title.x = element_text(face = "bold", margin = margin(t = 8, r = 0, b = 3, l = 0)))

ggsave("../figures/ntl_b117_share.png", width = 18, height = 10, units = "cm", dpi = 300)



# # Delta PCR ---------------------------------------------------------------
# 
# delta <- pdf_text(paste0("../data/B117_SSI/DeltaPCR_", today_string, ".pdf")) %>%
#   read_lines()
# 
# tabel_start <- which(str_detect(delta, "Prøvedato"))[1]
# tabel_slut <- which(str_detect(delta, "19-01-2021"))[1]
# 
# table_d <- delta[(tabel_start + 1):(tabel_slut)]
# 
# table_d %<>%
#   str_squish() %>%
#   strsplit(split = " ")
# 
# table_d <- lapply(table_d, function(x) x[1:3])
# 
# table_d_df <- tibble(data.frame(matrix(unlist(table_d), nrow = length(table_d), byrow=T)))
# 
# table_d_df %<>%
#   set_colnames(c("Date", "total", "yes")) %>%
#   mutate_all(str_replace_all, "\\.", "") %>%
#   mutate_all(str_replace_all, "\\*", "") %>%
#   mutate(Date = dmy(Date)) %>%
#   mutate(across(c(total, yes), as.double))
# 
# plot_data <- tests %>%
#   full_join(table_d_df, by = "Date") %>%
#   filter(Date > as.Date("2021-01-18")) %>%
#   mutate(share_est = NewPositive * yes / total,
#          pct_est = NewPositive * yes / total / NotPrevPos * 100,
#          pos_pct = NewPositive / NotPrevPos * 100) %>%
#   rowwise() %>%
#   mutate(CI_lo = prop.test(yes, total)$conf.int[1],
#          CI_hi = prop.test(yes, total)$conf.int[2]) %>%
#   mutate(pct_lo = NewPositive * CI_lo / NotPrevPos * 100,
#          pct_hi = NewPositive * CI_hi / NotPrevPos * 100) %>%
#   mutate(share_lo = NewPositive * CI_lo,
#          share_hi = NewPositive * CI_hi) %>%
#   select(Date, NewPositive, share_est, pct_est, pos_pct, pct_lo, pct_hi, share_lo, share_hi) %>%
#   pivot_longer(-Date, names_to = "variable", values_to = "value") 
# 
# type <- c("Positivprocent", "Antal positivt testede")
# names(type) <- c("x_pct", "share")
# 
# plot_data %>%
#   filter(variable %in% c("pct_est", "pct_lo", "pct_hi", "share_est", "share_hi", "share_lo")) %>%
#   pivot_wider(names_from = variable, values_from = value) %>%
#   pivot_longer(-Date, names_to = c("variable_1", "variable_2"), names_sep = "_", values_to = "value") %>%
#   pivot_wider(names_from = variable_2, values_from = value) %>%
#   mutate(variable_1 = ifelse(variable_1 == "pct", "x_pct", variable_1)) %>%
#   ggplot() +
#   geom_ribbon(aes(Date, ymin=lo, ymax=hi, fill = variable_1)) +
#   geom_line(aes(Date, est, color = variable_1), size = 1.3) +
#   scale_fill_manual(name = "", values = c(alpha(pos_col, 0.4), alpha('#E69F00', 0.4))) +
#   scale_color_manual(name = "", values = c(pos_col, '#E69F00')) +
#   facet_wrap(~variable_1, scales = "free", labeller = labeller(variable_1 = type)) + 
#   scale_x_date(labels = my_date_labels, date_breaks = "1 week") +
#   scale_y_continuous(limits = c(0, NA)) +
#   labs(y = "Positivprocent/Antal positive", x = "Uge (startdato)", title = "Estimeret daglig udbredelse af B.1.1.7 og lignende varianter (S:69-70del)", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI", subtitle = "Antal positive med S:69-70del = antal positive \u00D7 antal med S:69-70del / antal testet for S:69-70del\nPositivprocent for S:69-70del = antal positive med S:69-70del / antal testede \u00D7 100") +
#   facet_theme  +
#   theme(
#     legend.position = "none",
#     plot.caption = element_text(size = 8),
#     plot.subtitle = element_text(size = 8),
#     axis.title.y = element_blank(),
#     strip.text = element_text(size = 9),
#     axis.title.x = element_text(face = "bold", margin = margin(t = 0, r = 0, b = 8, l = 0)))
# 
# ggsave("../figures/ntl_deltaPCR_pct_pos.png", width = 18, height = 10, units = "cm", dpi = 300)
