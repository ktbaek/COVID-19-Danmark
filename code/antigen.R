private <- pdf_text("../data/privattest_210223.pdf") %>%
  read_lines()

tabel_1 <- max(which(str_detect(private, "Tabel 1")))


table <- private[(tabel_1 + 5):(length(private) - 1)]

table <- table[c(1:39, 44:75)]

table %<>%
  str_squish() %>%
  strsplit(split = " ")

table_df <- data.frame(matrix(unlist(table), nrow=length(table), byrow=T))

table_df %<>% select(X1, X6, X7)

colnames(table_df) <- c("Date", "Tested", "Positive")

plot_data <- table_df %>%
  as_tibble %>%
  mutate(Date = dmy(str_replace_all(Date, "\\.", "-"))) %>%
  mutate_all(str_replace_all, "\\.", "") %>%
  mutate(across(c(Tested, Positive), as.double)) %>%
  mutate(Date = as.Date(Date)) %>%
  mutate(pct = Positive / Tested * 100)

plot_data %>%
  ggplot() +
  geom_bar(stat = "identity", position = "stack", aes(Date, pct), fill = alpha(pct_col, 0.6), width = 1) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 weeks") +
  scale_y_continuous(
    limits = c(0, NA),
    labels = function(x) paste0(x, " %")
  ) +
  labs(y = "Positivprocent", x = "Dato", title = "Daglig procent positivt SARS-CoV-2 testede (antigen 'lyntest')", subtitle = "Testresultater fra private udbydere. Positivprocenten er ikke direkte sammenlignelig med PCR data fra SSI",
       caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme

ggsave("../figures/ntl_pct_antigen.png", width = 18, height = 10, units = "cm", dpi = 300)

plot_data %<>%
  select(-pct) %>%
  mutate(Positive = Positive * 100) %>%
  pivot_longer(-Date, names_to = "variable", values_to = "value") 

plot_data %>%
  ggplot() +
  geom_bar(data = subset(plot_data, variable == 'Positive'), stat = "identity", position = "identity", size = 1, aes(Date, value, fill = variable), width = 1) +
  geom_line(data = subset(plot_data, variable == 'Tested'), stat = "identity", position = "identity", size = 1.5, aes(Date, value, color = variable)) +
  scale_fill_manual(name = "", labels = c("Positive"), values = alpha(pos_col, 0.8)) +
  scale_color_manual(name = "", labels = c("Testede"), values = test_col) +
  scale_x_date(labels = my_date_labels, date_breaks = "2 weeks") +
  scale_y_continuous(
    name = "Testede",
    labels = scales::number,
    sec.axis = sec_axis(~ . / 100, name = "Positive"),
    limits = c(0, NA)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Dagligt antal SARS-CoV-2 testede og positive (antigen 'lyntest')", subtitle = "Testresultater fra private udbydere",
       caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme

ggsave("../figures/ntl_postest_antigen.png", width = 18, height = 10, units = "cm", dpi = 300)


plot_data %>%
  left_join(tests, by = "Date") %>%
  select(Date, pct, pct_confirmed) %>%
  pivot_longer(-Date, names_to = "variable", values_to = "value") %>%
  ggplot() +
  geom_line(aes(Date, value, color = variable), size = 2) + 
  scale_x_date(labels = my_date_labels, date_breaks = "2 weeks") +
  scale_y_continuous(
    limits = c(0, NA),
    labels = function(x) paste0(x, " %")
  ) +
  scale_color_manual(name = "", labels = c("Privat antigen", "Offentlig PCR"), values = c(lighten(pct_col, 0.2), darken(pct_col, 0.2))) +
  labs(y = "Positivprocent", x = "Dato", title = "Daglig procent positivt SARS-CoV-2 testede",
  caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme + 
  theme(panel.grid.minor.x = element_blank())

ggsave("../figures/ntl_pct_antigen_2.png", width = 18, height = 10, units = "cm", dpi = 300)
