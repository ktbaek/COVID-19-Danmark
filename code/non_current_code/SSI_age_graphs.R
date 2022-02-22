age_graph <- read_csv2("../data/SSI_age_data_10_1.csv")
dst_age_groups <- read_csv2("../data/DST_age_sex_group_1_year.csv", col_names = FALSE)
dst_age_groups_10 <- read_csv2("../data/DST_age_group_data.csv")

age_lookup_1 <- tribble(~Aldersgruppe_graph, ~Aldersgruppe_cut,
                        "0-2", "(-1,2]",
                        "3-6", "(2,6]",
                        "7-12", "(6,12]",
                        "13-19", "(12,19]",
                        "20-39", "(19,39]",
                        "40-64", "(39,64]",
                        "65-79", "(64,79]",
                        "80+", "(79,125]"
)

age_lookup_2 <- tribble(~Aldersgruppe_graph, ~Aldersgruppe_new,
                        "0-2", "0-19",
                        "3-6", "0-19",
                        "7-12", "0-19",
                        "13-19", "0-19",
                        "20-39", "20-39",
                        "40-64", "40-79",
                        "65-79", "40-79",
                        "80+", "80+"
)

age_lookup_3 <- tribble(~Aldersgruppe, ~Aldersgruppe_new,
                        "0-9", "0-19",
                        "10-19", "0-19",
                        "20-29", "20-39",
                        "30-39", "20-39",
                        "40-49", "40-79",
                        "50-59", "40-79",
                        "60-69", "40-79",
                        "70-79", "40-79",
                        "80-89", "80+",
                        "90+", "80+"
)

age_lookup_4 <- tribble(~Aldersgruppe_graph, ~Aldersgruppe_new,
                        "0-2", "0-12",
                        "3-6", "0-12",
                        "7-12", "0-12",
                        "13-19", "13-19",
                        "20-39", "20-39",
                        "40-64", "40-64",
                        "65-79", "65+",
                        "80+", "65+"
)

age_lookup_5 <- tribble(~Aldersgruppe_graph, ~Aldersgruppe_new,
                        "0-2", "0-12",
                        "3-6", "0-12",
                        "7-12", "0-12",
                        "13-19", "13-19",
                        "20-39", "20-39",
                        "40-64", "40-64",
                        "65-79", "65-79",
                        "80+", "80+"
)

age_lookup_6 <- tribble(~Aldersgruppe_graph, ~Aldersgruppe_new,
                        "0-2", "0-6",
                        "3-6", "0-6",
                        "7-12", "7-12",
                        "13-19", "13-19",
                        "20-39", "20-39",
                        "40-64", "40-64",
                        "65-79", "65-79",
                        "80+", "80+"
)

age_groups <- dst_age_groups %>%
  rename(Alder = X1,
         Male = X2,
         Female = X3) %>%
  mutate_all(str_replace_all, " år", "") %>%
  mutate_all(as.double) %>%
  mutate(Population = Male + Female) %>%
  select(-Male, -Female) %>%
  group_by(Aldersgruppe_cut = cut(Alder, breaks= c(-1, 2, 6, 12, 19, 39, 64, 79, 125))) %>%
  summarize(Population = sum(Population)) %>%
  full_join(age_lookup_1, by = "Aldersgruppe_cut") %>%
  select(-Aldersgruppe_cut) 

age_graph_2 <- age_graph %>%
  mutate(year = ifelse(Week %in% seq(33,53), 2020, 2021)) %>%
  mutate(Week = sprintf("%02d", Week)) %>%
  mutate(Date = ISOweek2date(paste0(year, "-W", Week, "-1"))) %>%
  select(-Week, -year) %>%
  pivot_longer(c(-Date, -Variable), names_to = "Aldersgruppe_graph", values_to = "Incidense") %>%
  full_join(age_groups, by = "Aldersgruppe_graph") %>%
  mutate(Absolute = Incidense * Population / 100000) 

# test that values read from the graph sum to tested total
weekly_sums <- tests %>%
  filter(Date > ymd("2020-09-06")) %>%
  group_by(Date=floor_date(Date, "1 week", week_start = getOption("lubridate.week.start", 1))) %>%
  select(Date, NotPrevPos, NewPositive) %>%
  group_by(Date) %>%
  summarize(Tested = sum(NotPrevPos),
            Positive = sum(NewPositive)) %>%
  pivot_longer(-Date, "Variable") %>%
  mutate(Dataset = "Datafil")

# test graph numbers are generally a bit lower but positive numbers are perfect:
age_graph_2 %>%
  group_by(Date, Variable) %>%
  summarize(value = sum(Absolute)) %>%
  mutate(Dataset = "Aflæst") %>%
  bind_rows(weekly_sums) %>% 
  filter(Date < ymd("2021-03-09")) %>%
  ggplot() +
  geom_line(aes(Date, value, color = Dataset), size = 1) +
  facet_wrap(~Variable, scales = "free") +
  scale_x_date(labels = my_date_labels, breaks = "1 month") +
  scale_color_discrete(name = "") +
  labs(y = "Antal", x = "Dato", title = "Test af aflæsning") +
  scale_y_continuous(
    limits = c(0, NA)
  ) +
  facet_theme +
  theme(legend.text = element_text(size = 11),
        legend.key.size = unit(0.4, 'cm'))

ggsave("../figures/SSI_read_graph_test.png", width = 18, height = 10, units = "cm", dpi = 300)


age_graph_3 <- age_graph_2 %>%
  full_join(age_lookup_4, by = "Aldersgruppe_graph") %>%
  group_by(Date, Aldersgruppe_new, Variable) %>%
  summarize(Population = sum(Population),
            Absolute = sum(Absolute)) %>%
  mutate(Incidense = Absolute / Population * 100000) %>%
  rename(Aldersgruppe_graph = Aldersgruppe_new)

age_graph_4 <- age_graph_2 %>%
  full_join(age_lookup_5, by = "Aldersgruppe_graph") %>%
  group_by(Date, Aldersgruppe_new, Variable) %>%
  summarize(Population = sum(Population),
            Absolute = sum(Absolute)) %>%
  mutate(Incidense = Absolute / Population * 100000) %>%
  rename(Aldersgruppe_graph = Aldersgruppe_new)

age_graph_5 <- age_graph_2 %>%
  full_join(age_lookup_6, by = "Aldersgruppe_graph") %>%
  group_by(Date, Aldersgruppe_new, Variable) %>%
  summarize(Population = sum(Population),
            Absolute = sum(Absolute)) %>%
  mutate(Incidense = Absolute / Population * 100000) %>%
  rename(Aldersgruppe_graph = Aldersgruppe_new)

plot_data <- age_graph_4 %>%
  select(Date, Aldersgruppe_graph, Variable, Incidense) %>%
  filter(Variable == "Positive")

#plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-12','13-19', '20-39','40-64', '65+'))
plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-12','13-19', '20-39','40-64', '65-79', '80+'))

plot_data %>% 
  ggplot() +
  geom_line(aes(Date, Incidense, color = Aldersgruppe_graph), size = 1) +
  scale_x_date(labels = my_date_labels, breaks = "1 month") +
  scale_colour_brewer(palette = "Set2", name = "") +
  labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
  scale_y_continuous(
    labels = scales::number,
    limits = c(0, NA)
  ) +
  labs(y = "Positive pr. 100.000", x = "Dato", title = "Positive per 100.000 per uge for hver aldersgruppe", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme

ggsave("../figures/SSI_read_graph_incidense_together.png", width = 20, height = 11.1, units = "cm", dpi = 300)

plot_data <- age_graph_4 %>%
  select(Date, Aldersgruppe_graph, Variable, Incidense) %>%
  filter(Variable == "Tested")

#plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-12','13-19', '20-39','40-64', '65+'))
plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-12','13-19', '20-39','40-64', '65-79', '80+'))

plot_data %>% 
  ggplot() +
  geom_line(aes(Date, Incidense, color = Aldersgruppe_graph), size = 1) +
  scale_x_date(labels = my_date_labels, breaks = "1 month") +
  scale_colour_brewer(palette = "Set2", name = "") +
  labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
  scale_y_continuous(
    labels = scales::number,
    limits = c(0, NA)
  ) +
  labs(y = "Testede pr. 100.000", x = "Dato", title = "Testede per 100.000 per uge for hver aldersgruppe", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme

ggsave("../figures/SSI_read_graph_test_incidense_together.png", width = 20, height = 11.1, units = "cm", dpi = 300)





plot_data <- age_graph_4 %>%
  select(Date, Aldersgruppe_graph, Variable, Absolute) %>%
  pivot_wider(names_from = Variable, values_from = Absolute) %>%
  mutate(Percent = Positive / Tested * 100) 

#plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-12','13-19', '20-39','40-64', '65+'))
plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-12','13-19', '20-39','40-64', '65-79', '80+'))

plot_data %>% 
  ggplot() +
  geom_line(aes(Date, Percent, color = Aldersgruppe_graph), size = 1) +
  scale_x_date(labels = my_date_labels, breaks = "1 month") +
  scale_colour_brewer(palette = "Set2", name = "") +
  labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
  scale_y_continuous(
    labels = scales::number,
    limits = c(0, NA)
  ) +
  labs(y = "Positivprocent", x = "Dato", title = "Positivprocent per uge for hver aldersgruppe", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme

ggsave("../figures/SSI_read_graph_pct_together.png", width = 20, height = 11.1, units = "cm", dpi = 300)










# 
# 
# plot_data <- age_graph_2 %>%
#   select(Date, Aldersgruppe_graph, Variable, Incidense) %>%
#   filter(Variable == "Positive")
# 
# plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-2', '3-6', '7-12','13-19', '20-39','40-64', '65-79', '80+'))
# 
# plot_data %>% 
#   ggplot() +
#   geom_line(aes(Date, Incidense, color = Aldersgruppe_graph), size = 1) +
#   scale_x_date(labels = my_date_labels, breaks = "1 month") +
#   scale_colour_brewer(palette = "Set2", name = "") +
#   labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
#   scale_y_continuous(
#     labels = scales::number,
#     limits = c(0, NA)
#   ) +
#   labs(y = "Positive pr. 100.000", x = "Startdato for uge", title = "Positive per 100.000 per uge for hver aldersgruppe", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
#   standard_theme +
#   theme(axis.title.x = element_text(face = "bold", margin = margin(t = 10, r = 0, b = 0, l = 0)),
#         axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 8, l = 0)))
# 
# ggsave("../figures/SSI_read_graph_incidense_together.png", width = 20, height = 11.1, units = "cm", dpi = 300)
# 
# 
# 
# plot_data <- age_graph_2 %>%
#   select(Date, Aldersgruppe_graph, Variable, Absolute) %>%
#   pivot_wider(names_from = Variable, values_from = Absolute) %>%
#   mutate(Percent = Positive / Tested * 100) 
# 
# 
# plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-2', '3-6', '7-12','13-19', '20-39','40-64', '65-79', '80+'))
# 
# plot_data %>% 
#   ggplot() +
#   geom_line(aes(Date, Percent, color = Aldersgruppe_graph), size = 1) +
#   scale_x_date(labels = my_date_labels, breaks = "1 month") +
#   scale_colour_brewer(palette = "Set2", name = "") +
#   labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
#   scale_y_continuous(
#     labels = scales::number,
#     limits = c(0, NA)
#   ) +
#   labs(y = "Positivprocent", x = "startdato for uge", title = "Positivprocent per uge for hver aldersgruppe", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
#   standard_theme +
#   theme(axis.title.x = element_text(face = "bold", margin = margin(t = 10, r = 0, b = 0, l = 0)),
#         axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 8, l = 0)))
# 
# ggsave("../figures/SSI_read_graph_pct_together.png", width = 20, height = 11.1, units = "cm", dpi = 300)
# 
# plot_data <- age_graph_2 %>%
#   select(Date, Aldersgruppe_graph, Variable, Incidense) %>%
#   filter(Variable == "Tested")
# 
# plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-2', '3-6', '7-12','13-19', '20-39','40-64', '65-79', '80+'))
# 
# plot_data %>% 
#   ggplot() +
#   geom_line(aes(Date, Incidense, color = Aldersgruppe_graph), size = 1) +
#   scale_x_date(labels = my_date_labels, breaks = "1 month") +
#   scale_colour_brewer(palette = "Set2", name = "") +
#   labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
#   scale_y_continuous(
#     labels = scales::number,
#     limits = c(0, NA)
#   ) +
#   labs(y = "Testede pr. 100.000", x = "Startdato for uge", title = "Testede per 100.000 per uge for hver aldersgruppe", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
#   standard_theme +
#   theme(axis.title.x = element_text(face = "bold", margin = margin(t = 10, r = 0, b = 0, l = 0)),
#         axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 8, l = 0)))
# 
# ggsave("../figures/SSI_read_graph_test_incidense_together.png", width = 20, height = 11.1, units = "cm", dpi = 300)
# 
# 
# 
# 
# 
# 
# plot_data <- age_graph_2 %>%
#   select(Date, Aldersgruppe_graph, Variable, Incidense) %>%
#   filter(Variable == "Positive") %>%
#   filter(Aldersgruppe_graph %in% c("0-2", "3-6", "7-12", "13-19"))
# 
# plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-2', '3-6', '7-12','13-19'))
# 
# plot_data %>% 
#   ggplot() +
#   geom_line(aes(Date, Incidense, color = Aldersgruppe_graph), size = 1) +
#   scale_x_date(labels = my_date_labels, breaks = "1 month") +
#   scale_colour_brewer(palette = "Set2", name = "") +
#   labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
#   scale_y_continuous(
#     labels = scales::number,
#     limits = c(0, NA)
#   ) +
#   labs(y = "Positive pr. 100.000", x = "Startdato for uge", title = "Positive per 100.000 per uge for hver aldersgruppe", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
#   standard_theme +
#   theme(axis.title.x = element_text(face = "bold", margin = margin(t = 10, r = 0, b = 0, l = 0)),
#         axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 8, l = 0)))
# 
# ggsave("../figures/SSI_read_graph_incidense_together.png", width = 20, height = 11.1, units = "cm", dpi = 300)
# 
# 
# 
# plot_data <- age_graph_2 %>%
#   select(Date, Aldersgruppe_graph, Variable, Absolute) %>%
#   pivot_wider(names_from = Variable, values_from = Absolute) %>%
#   mutate(Percent = Positive / Tested * 100) %>%
#   filter(Aldersgruppe_graph %in% c("0-2", "3-6", "7-12", "13-19"))
# 
# plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-2', '3-6', '7-12','13-19'))
# 
# plot_data %>% 
#   ggplot() +
#   geom_line(aes(Date, Percent, color = Aldersgruppe_graph), size = 1) +
#   scale_x_date(labels = my_date_labels, breaks = "1 month") +
#   scale_colour_brewer(palette = "Set2", name = "") +
#   labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
#   scale_y_continuous(
#     labels = scales::number,
#     limits = c(0, NA)
#   ) +
#   labs(y = "Positivprocent", x = "startdato for uge", title = "Positivprocent per uge for hver aldersgruppe", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
#   standard_theme +
#   theme(axis.title.x = element_text(face = "bold", margin = margin(t = 10, r = 0, b = 0, l = 0)),
#         axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 8, l = 0)))
# 
# ggsave("../figures/SSI_read_graph_pct_together.png", width = 20, height = 11.1, units = "cm", dpi = 300)
# 
# plot_data <- age_graph_2 %>%
#   select(Date, Aldersgruppe_graph, Variable, Incidense) %>%
#   filter(Variable == "Tested") %>%
#   filter(Aldersgruppe_graph %in% c("0-2", "3-6", "7-12", "13-19"))
# 
# plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-2', '3-6', '7-12','13-19'))
# 
# plot_data %>% 
#   ggplot() +
#   geom_line(aes(Date, Incidense, color = Aldersgruppe_graph), size = 1) +
#   scale_x_date(labels = my_date_labels, breaks = "1 month") +
#   scale_colour_brewer(palette = "Set2", name = "") +
#   labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
#   scale_y_continuous(
#     labels = scales::number,
#     limits = c(0, NA)
#   ) +
#   labs(y = "Testede pr. 100.000", x = "Startdato for uge", title = "Testede per 100.000 per uge for hver aldersgruppe", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
#   standard_theme +
#   theme(axis.title.x = element_text(face = "bold", margin = margin(t = 10, r = 0, b = 0, l = 0)),
#         axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 8, l = 0)))
# 
# ggsave("../figures/SSI_read_graph_test_incidense_together.png", width = 20, height = 11.1, units = "cm", dpi = 300)
# 
# plot_data <- age_graph_2 %>%
#   select(Date, Aldersgruppe_graph, Variable, Absolute) %>%
#   pivot_wider(names_from = Variable, values_from = Absolute) %>%
#   mutate(Percent = Positive / Tested**0.7) %>%
#   filter(Aldersgruppe_graph %in% c("0-2", "3-6", "7-12", "13-19"))
# 
# plot_data$Aldersgruppe_graph = factor(plot_data$Aldersgruppe_graph, levels=c('0-2', '3-6', '7-12','13-19'))
# 
# plot_data %>% 
#   ggplot() +
#   geom_line(aes(Date, Percent, color = Aldersgruppe_graph), size = 1) +
#   scale_x_date(labels = my_date_labels, breaks = "1 month") +
#   scale_colour_brewer(palette = "Set2", name = "") +
#   labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
#   scale_y_continuous(
#     labels = scales::number,
#     limits = c(0, NA)
#   ) +
#   labs(y = "Index", x = "startdato for uge", title = "Smitteindex per uge for hver aldersgruppe", subtitle = "Index = positive / testede ^0.7", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
#   standard_theme +
#   theme(axis.title.x = element_text(face = "bold", margin = margin(t = 10, r = 0, b = 0, l = 0)),
#         axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 8, l = 0)))
# 
# ggsave("../figures/SSI_read_graph_index_together.png", width = 20, height = 11.1, units = "cm", dpi = 300)
# 
# 
# 
