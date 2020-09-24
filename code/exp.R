
rt_x <- rt_cases %>% rename(Date = date_sample)

ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 1) #function to calculate 7-day average based on past values
}
tests_x <- tests %>% mutate(
  running_avg_pct = ra(pct_confirmed),
  running_avg_pos = ra(NewPositive),
  running_avg_total = ra(Tested)
)

plot_data <- tests_x %>%
  filter(Date > as.Date("2020-03-30")) %>%
  arrange(Date) %>%
  pivot_longer(cols = c(NewPositive, running_avg_pos), names_to = "variable", values_to = "value")


ggplot(plot_data, aes(Date, value)) +
  geom_point(data = plot_data[plot_data$variable == "NewPositive",], stat = "identity", position = "identity", aes(shape = variable), color = pos_col) +
  geom_line(stat = "identity", position = "identity", size = 0.8, aes(linetype = variable), color = pos_col) +
  scale_linetype_manual(name = "", values = c("blank", "solid")) +
  labs(y = "", x = "Dato", title = "Nye positive og løbende gns bagud 7 dage") +
  scale_y_continuous(limits = c(0, NA)) + 
  theme_minimal() +
  theme(
    text = element_text(size = 12, family = "lato"),
    legend.position = "none",
    plot.title = element_text(size = 12, face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )



plot_data <- tests_x %>%
  full_join(rt_x, by = "Date") %>%
  filter(Date > as.Date("2020-03-30")) %>%
  arrange(Date) %>%
  mutate(Diff_day = as.integer(Date - lag(Date)),  # Difference in time (just in case there are gaps)
         Diff_pct = running_avg_pct - lag(running_avg_pct), #Difference compared to day before
         Diff_pos = running_avg_pos - lag(running_avg_pos), #Difference compared to day before
         rate_pct = (Diff_pct / Diff_day)/lag(running_avg_pct), #Daily growth rate
         rate_pos = (Diff_pos / Diff_day)/lag(running_avg_pos), #Daily growth rate
         ra_rate_pos = as.numeric(ra(rate_pos))) %>%
  select(Date, rate_pos, ra_rate_pos) %>%
  pivot_longer(cols = c(rate_pos, ra_rate_pos), names_to = "variable", values_to = "value")
# growth rate in percent


ggplot(plot_data, aes(Date, value)) +
  geom_line(stat = "identity", position = "identity", aes(color = variable, size = variable)) +
  #scale_color_manual(name = "", labels = c("Baseret på positivandel", "Baseret på antal positive")) +
  scale_size_manual(values=c(1.5,0.5)) +
  labs(y = "", x = "Dato", title = "Hældning af løbende gns og løbende bagud gns af ditto") +
  theme_minimal() +
  theme(
    text = element_text(size = 12, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(size = 12, face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )


plot_data <- tests_x %>%
  full_join(rt_x, by = "Date") %>%
  filter(Date > as.Date("2020-03-30")) %>%
  arrange(Date) %>%
  mutate(Diff_day = as.integer(Date - lag(Date)),  # Difference in time (just in case there are gaps)
         Diff_pct = running_avg_pct - lag(running_avg_pct), #Difference compared to day before
         Diff_pos = running_avg_pos - lag(running_avg_pos), #Difference compared to day before
         rate_pct = (Diff_pct / Diff_day)/lag(running_avg_pct), #Daily growth rate
         rate_pos = (Diff_pos / Diff_day)/lag(running_avg_pos), #Daily growth rate
         exp_rate_pct = 2^as.numeric(ra(rate_pct) * 5.5),
         exp_rate_pos = 2^as.numeric(ra(rate_pos) * 5.5)) %>%
  select(Date, exp_rate_pct, exp_rate_pos, estimate) %>%
  pivot_longer(cols = c(exp_rate_pos, exp_rate_pct, estimate), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 0.8, aes(color = variable)) +
  scale_color_manual(name = "", labels = c("Kontakttal", "Baseret på positivandel", "Baseret på antal positive"), values = c("darkgray", pct_col,  pos_col)) +
  labs(y = "", x = "Dato", title = "Kontakttal vs beregning") +
  scale_y_continuous(limits = c(0, NA)) + 
  theme_minimal() +
  theme(
    text = element_text(size = 10, family = "lato"),
    legend.text = element_text(size = 10, family = "lato"),
    plot.title = element_text(size = 12, face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/rt_vs_calculated_rt.png", width = 25, height = 12, units = "cm", dpi = 300)



plot_data <- tests_x %>%
  full_join(rt_x, by = "Date") %>%
  filter(Date > as.Date("2020-03-30")) %>%
  arrange(Date) %>%
  mutate(Diff_day = as.integer(Date - lag(Date)),  # Difference in time (just in case there are gaps)
         Diff_pos = running_avg_pos - lag(running_avg_pos), #Difference compared to day before
         rate_pos = (Diff_pos / Diff_day)/lag(running_avg_pos), #Daily growth rate
         exp_rate_pos = 2^as.numeric(ra(rate_pos) * 5.6),
         exp_rate_pos = floor(exp_rate_pos * 10) / 10) %>%
  select(Date, exp_rate_pos, estimate) %>%
  pivot_longer(cols = c(exp_rate_pos, estimate), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 0.8, aes(color = variable)) +
  scale_color_manual(name = "", labels = c("SSIs kontakttal", "Min beregning"), values = c("darkgray",  pos_col)) +
  labs(y = "", x = "Dato", title = "Kontakttal vs beregning") +
  scale_y_continuous(limits = c(0, NA)) + 
  theme_minimal() +
  theme(
    text = element_text(size = 14, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 14, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 14, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 14, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

ggsave("../figures/rt_vs_calculated_rt_2.png", width = 25, height = 12, units = "cm", dpi = 300)
###############

plot_data <- tests_x %>%
  full_join(rt_x, by = "Date") %>%
  filter(Date > as.Date("2020-03-30")) %>%
  arrange(Date) %>%
  mutate(Diff_day = as.integer(Date - lag(Date, 7)),  #Difference in time (just in case there are gaps)
         Diff_pos = NewPositive - lag(NewPositive, 7), #Difference compared to day before
         rate_pos = (Diff_pos / Diff_day)/lag(NewPositive, 7), #Daily growth rate
         exp_rate_pos = 10^as.numeric(ra(rate_pos))) %>%
  select(Date, exp_rate_pos, estimate) %>%
  pivot_longer(cols = c(exp_rate_pos, estimate), names_to = "variable", values_to = "value")
# growth rate in percent

ggplot(plot_data, aes(Date, value)) +
  geom_line(stat = "identity", position = "identity", size = 0.8, aes(color = variable)) +
  scale_color_manual(name = "", labels = c("Kontakttal", "Baseret på positivandel", "Baseret på antal positive"), values = c("darkgray", pct_col,  pos_col)) +
  labs(y = "", x = "Dato", title = "Kontakttal vs beregning") +
  scale_y_continuous(limits = c(0, NA)) + 
  theme_minimal() +
  theme(
    text = element_text(size = 12, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(size = 12, face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )


# Experiments --------

ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 1)
}
tests_x <- tests %>% mutate(
  running_avg_pct = ra(pct_confirmed),
  running_avg_pos = ra(NewPositive),
  running_avg_total = ra(Tested)
)

admitted_x <- admitted %>%
  mutate(running_avg = ra(Total))

norm_pos <- tests_x %>% full_join(admitted_x, by = "Date") %>% filter(Date == as.Date("2020-07-01")) %>% mutate(Ratio = running_avg/running_avg_pos) %>% pull(Ratio)
norm_pct <- tests_x %>% full_join(admitted_x, by = "Date") %>% filter(Date == as.Date("2020-07-01")) %>% mutate(Ratio = running_avg/running_avg_pct) %>% pull(Ratio)

plot_data <- tests_x %>%
  full_join(admitted_x, by = "Date") %>%
  filter(Date > as.Date("2020-05-01")) %>%
  select(Date, Total, running_avg, running_avg_pct, running_avg_pos) %>%
  mutate(Ratio_0 = lead(Total,0)/running_avg_pct/norm_pct,
         Ratio_1 = lead(Total,1)/running_avg_pct/norm_pct,
         Ratio_2 = lead(Total,2)/running_avg_pct/norm_pct,
         Ratio_3 = lead(Total,3)/running_avg_pct/norm_pct,
         Ratio_4 = lead(Total,4)/running_avg_pct/norm_pct,
         Ratio_5 = lead(Total,5)/running_avg_pct/norm_pct) %>%
  # mutate(Ratio_pos = running_avg/running_avg_pos/norm_pos,
  #        Ratio_pct = running_avg/running_avg_pct/norm_pct) %>%
  pivot_longer(cols = c(Ratio_0:Ratio_5), names_to = "variable", values_to = "values")

plot_data %>% 
  group_by(variable) %>%
  summarize(max = max(values, na.rm = TRUE),
            min = min(values, na.rm = TRUE)) %>%
  mutate(range = max - min)


ggplot(plot_data, aes(Date, values)) +
  geom_line(stat = "identity", position = "identity" , aes(color = variable)) +
  labs(y = "Procent positive", x = "Uge", title = "Ugentlig procent positivt testede for udvalgte kommuner") +
  scale_y_continuous(
    limits = c(0, NA)
  ) +
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    legend.text = element_text(size = 12, family = "lato"),
    plot.title = element_text(face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, family = "lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, family = "lato", margin = margin(t = 20, r = 0, b = 0, l = 0))
  )


########

