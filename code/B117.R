library(ISOweek)

b117 <- pdf_text(paste0("../data/B117_SSI/B117_", today_string, ".pdf")) %>%
  read_lines()

tabel_1 <- which(str_detect(b117, "Tabel 1"))

weeks_since_start <- isoweek(today) - 1 + 53 - 46

table_1 <- b117[(tabel_1 + 8):(tabel_1 + 8 + weeks_since_start)]

table_1 %<>%
  str_squish() %>%
  strsplit(split = " ")

table_1 <- lapply(table_1, function(x) x[1:8])

table_1_df <- tibble(data.frame(matrix(unlist(table_1), nrow = length(table_1), byrow=T)))

table_1_df %<>%
  select(X2, X6, X8) %>%
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
  summarize(total_pos = sum(NewPositive, na.rm = TRUE),
            tested = sum(NotPrevPos, na.rm = TRUE)) %>% 
  full_join(table_1_df, by = "Date") %>%
  filter(Date > as.Date("2020-11-01")) %>%
  filter(!is.na(Week)) %>%
  mutate(variant_abs_est = total_pos * yes / total,
         normal_abs_est = total_pos * (1 - yes / total),
         total_pos_pct = total_pos / tested * 100,
         variant_pct_est = total_pos_pct * yes / total,
         normal_pct_est = total_pos_pct * (1 - yes / total)) %>%
  rowwise() %>%
  mutate(CI_lo = prop.test(yes, total)$conf.int[1],
         CI_hi = prop.test(yes, total)$conf.int[2]) %>%
  mutate(variant_pct_lo = total_pos_pct * CI_lo,
         variant_pct_hi = total_pos_pct * CI_hi,
         normal_pct_lo = total_pos_pct * (1 - CI_hi),
         normal_pct_hi = total_pos_pct * (1 - CI_lo)) %>%
  mutate(variant_abs_lo = total_pos * CI_lo,
         variant_abs_hi = total_pos * CI_hi,
         normal_abs_lo = total_pos * (1 - CI_hi),
         normal_abs_hi = total_pos * (1 - CI_lo)) %>%
  select(Date,
         total_pos,
         total_pos_pct,
         variant_abs_est,
         variant_pct_est,
         normal_abs_est,
         normal_pct_est,
         variant_pct_lo,
         variant_pct_hi,
         variant_abs_lo,
         variant_abs_hi,
         normal_pct_lo,
         normal_pct_hi,
         normal_abs_lo,
         normal_abs_hi) %>%
  pivot_longer(-Date, names_to = "variable", values_to = "value") 


# Plot 1 ------------------------------------------------------------------

plot_data %>%
  filter(variable %in% c("variant_abs_est", "normal_abs_est")) %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = variable), width = 5) +
 #geom_text(data = subset(plot_data, variable == "variant_abs_est"), aes(Date, value + 500  ,label = round(value, 0)), vjust=0, family = "lato", color = darken(pos_col,0.2), fontface = "bold", size = 2) +
  scale_fill_manual(name = "", labels = c("Andre varianter", "B.1.1.7"), values=c("gray85", pos_col))+
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
  filter(variable %in% c("variant_pct_est", "normal_pct_est")) %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, value, fill = variable), width = 5) +
  #geom_text(data = subset(plot_data, variable == "variant_pct_est"), aes(Date, value + 0.06 ,label = round(value, 3)), vjust=0, family = "lato", color = darken('#E69F00',0.2), fontface = "bold", size = 2.5) +
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

type <- c("Positivprocent", "Antal positivt testede")
names(type) <- c("pct", "abs")

plot_data %>%
  filter(variable %in% c("variant_pct_est", "variant_pct_lo", "variant_pct_hi", "variant_abs_est", "variant_abs_hi", "variant_abs_lo")) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  pivot_longer(-Date, names_to = c("strain", "variable_1", "variable_2"), names_sep = "_", values_to = "value") %>%
  pivot_wider(names_from = variable_2, values_from = value) %>%
  ggplot() +
  geom_ribbon(aes(Date, ymin=lo, ymax=hi, fill = variable_1)) +
  geom_line(aes(Date, est, color = variable_1), size = 1.3) +
  scale_fill_manual(name = "", values = c(alpha(pos_col, 0.4), alpha('#E69F00', 0.4))) +
  scale_color_manual(name = "", values = c(pos_col, '#E69F00')) +
  facet_wrap(~variable_1, scales = "free", labeller = labeller(variable_1 = type)) + 
  scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Positivprocent/Antal positive", x = "Startdato for uge", title = "Estimeret ugentlig udbredelse af B.1.1.7", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI", subtitle = "Antal positive med B.1.1.7 = antal positive \u00D7 antal B.1.1.7 genom / total antal genom\nPositivprocent for B.1.1.7 = antal positive med B.1.1.7 / antal testede \u00D7 100") +
  facet_theme  +
  theme(
    legend.position = "none",
    plot.caption = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    axis.title.y = element_blank(),
    strip.text = element_text(size = 9),
    axis.title.x = element_text(face = "bold", margin = margin(t = 0, r = 0, b = 8, l = 0)))

ggsave("../figures/ntl_b117_pct_pos.png", width = 18, height = 10, units = "cm", dpi = 300)


# Plot 4 ------------------------------------------------------------------


plot_data %>%
  filter(!variable %in% c("total_pos",
                         "total_pos_pct")) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  pivot_longer(-Date, names_to = c("strain", "variable_1", "variable_2"), names_sep = "_", values_to = "value") %>%
  pivot_wider(names_from = variable_2, values_from = value) %>%
  unite(variable_3, c(strain, variable_1), remove = FALSE) %>%
  ggplot() +
  #geom_ribbon(aes(Date, ymin=lo, ymax=hi, fill = variable_3)) +
  geom_line(aes(Date, est, color = variable_3), size = 1.3) +
  #scale_fill_manual(name = "", values = c(alpha("gray85", 0.4), alpha("gray85", 0.4), alpha(pos_col, 0.4),  alpha('#E69F00', 0.4))) +
  scale_color_manual(name = "", values = c(alpha(pos_col, 0.4), alpha('#E69F00', 0.4), pos_col,  '#E69F00')) +
  facet_wrap(~variable_1, scales = "free", labeller = labeller(variable_1 = type)) + 
  scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Positivprocent/Antal positive", x = "Startdato for uge", title = "Estimeret ugentlig udbredelse af hhv. B.1.1.7 og normale varianter", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI", subtitle = "Antal positive med B.1.1.7 = antal positive \u00D7 antal B.1.1.7 genom / total antal genom\nPositivprocent for B.1.1.7 = antal positive med B.1.1.7 / antal testede \u00D7 100") +
  facet_theme  +
  theme(
    legend.position = "none",
    plot.caption = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    axis.title.y = element_blank(),
    strip.text = element_text(size = 9),
    axis.title.x = element_text(face = "bold", margin = margin(t = 0, r = 0, b = 8, l = 0)))

ggsave("../figures/ntl_b117_pct_pos_2.png", width = 18, height = 10, units = "cm", dpi = 300)


# Logistisk plot af andel -------------------------------------------------


p <- table_1_df %>%  
  mutate(share_est = yes / total) %>%
  ggplot() +
  geom_point(aes(Date, share_est), size = 4, color = alpha(pos_col, 0.4)) +
  geom_smooth(aes(Date, share_est), method="glm", method.args = list(family = "binomial"), se = FALSE, color = pos_col, fullrange=TRUE) + 
  scale_x_date(labels = my_date_labels, date_breaks = "2 week", limits = c(as.Date("2020-11-29"), as.Date("2021-04-01"))) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0,1, by = .10)) +
  labs(y = "Andel", x = "Uge (startdato)", title = "Andel af B.1.1.7 af alle varianter", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme + 
  theme(axis.title.x = element_text(face = "bold", margin = margin(t = 8, r = 0, b = 3, l = 0)))

ggsave("../figures/ntl_b117_share.png", width = 18, height = 10, units = "cm", dpi = 300)

#get predicted fraction for week 9
frac <- ggplot_build(p)$data[[2]] %>% 
  mutate(Date = as.Date(round(x), origin = "1970-01-01")) %>%
  filter(Date == ymd("2021-03-01")) %>%
  pull(y)

#calculate how positive and tests increase during a week
day_mean <- tests %>%
  select(Date, NewPositive, NotPrevPos) %>%
  filter(Date > ymd(today) - months(2),
         Date < ymd("2021-03-01")) %>%
  group_by(Monday=floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 1))) %>%
  mutate(poscum = cumsum(NewPositive),
         testcum = cumsum(NotPrevPos)) %>%
  mutate(fracpos = poscum/max(poscum),
         fractest = testcum/max(testcum)) %>%
  mutate(day = wday(Date, week_start = getOption("lubridate.week.start", 1))) %>% #ggplot() + geom_point(aes(day, fracpos))
  group_by(day) %>%
  summarize(meanpos = mean(fracpos),
            meantest = mean(fractest))

prediction <- tests %>%
  select(Date, NewPositive, NotPrevPos) %>%
  filter(Date > ymd(today) - weeks(1)) %>%
  group_by(Monday = floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 1))) %>%
  mutate(poscum = cumsum(NewPositive),
         testcum = cumsum(NotPrevPos)) %>%
  ungroup() %>%
  filter(Date == max(Date)) %>%
  mutate(day = wday(Date, week_start = getOption("lubridate.week.start", 1))) %>%
  left_join(day_mean, by = "day") %>%
  mutate(positive = poscum / meanpos,
         tested = testcum / meantest) %>%
  select(Monday, positive, tested) %>%
  mutate(variant_abs_est = positive * frac,
       normal_abs_est = positive * (1 - frac),
       total_pos_pct = positive / tested * 100,
       variant_pct_est = total_pos_pct * frac,
       normal_pct_est = total_pos_pct * (1 - frac)) %>%
  rename(Date = Monday) %>%
  pivot_longer(-Date, "variable", values_to = "value")

prediction %<>%
  bind_rows(plot_data) %>%
  filter(variable %in% c("variant_pct_est", "variant_abs_est")) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  pivot_longer(-Date, names_to = c("strain", "variable_1", "variable_2"), names_sep = "_", values_to = "value") %>%
  pivot_wider(names_from = variable_2, values_from = value) %>%
  filter(Date >= max(Date) - weeks(1))
  


  

##

type <- c("Positivprocent", "Antal positivt testede")
names(type) <- c("pct", "abs")

plot_data %>%
  filter(variable %in% c("variant_pct_est", "variant_pct_lo", "variant_pct_hi", "variant_abs_est", "variant_abs_hi", "variant_abs_lo")) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  pivot_longer(-Date, names_to = c("strain", "variable_1", "variable_2"), names_sep = "_", values_to = "value") %>%
  pivot_wider(names_from = variable_2, values_from = value) %>%
  ggplot() +
  geom_ribbon(aes(Date, ymin=lo, ymax=hi, fill = variable_1)) +
  geom_line(aes(Date, est, color = variable_1), size = 1.3) +
  geom_line(data = prediction, aes(Date, est), color = "gray75", size = 1.3) +
  scale_fill_manual(name = "", values = c(alpha(pos_col, 0.4), alpha('#E69F00', 0.4))) +
  scale_color_manual(name = "", values = c(pos_col, '#E69F00')) +
  facet_wrap(~variable_1, scales = "free", labeller = labeller(variable_1 = type)) + 
  scale_x_date(labels = my_date_labels, date_breaks = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Positivprocent/Antal positive", x = "Startdato for uge", title = "Estimeret ugentlig udbredelse af B.1.1.7", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI", subtitle = "Antal positive med B.1.1.7 = antal positive \u00D7 antal B.1.1.7 genom / total antal genom\nPositivprocent for B.1.1.7 = antal positive med B.1.1.7 / antal testede \u00D7 100") +
  facet_theme  +
  theme(
    legend.position = "none",
    plot.caption = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    axis.title.y = element_blank(),
    strip.text = element_text(size = 9),
    axis.title.x = element_text(face = "bold", margin = margin(t = 0, r = 0, b = 8, l = 0)))

ggsave("../figures/ntl_b117_pct_pos_predict.png", width = 18, height = 10, units = "cm", dpi = 300)



