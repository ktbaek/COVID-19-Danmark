library(zoo)
# Calculate positives -----------------------------------------------------

x <- tests %>% 
  select(Date, NotPrevPos, NewPositive) %>% 
  mutate(A = ra(NotPrevPos * 0.001),
         B = ra(NotPrevPos * 0.002),
         C = ra(NotPrevPos * 0.003),
         Obs = ra(NewPositive)) %>% 
  select(-NotPrevPos, -NewPositive) %>% 
  pivot_longer(-Date, values_to = "Positive") %>% 
  filter(Date >= ymd("2021-01-01")) 

y <- tests %>% 
  select(Date, NotPrevPos) %>% 
  mutate(A = NotPrevPos * 0.001,
         B = NotPrevPos * 0.002,
         C = NotPrevPos * 0.003) %>% 
  mutate(A = rollsum(A, 14, na.pad = TRUE),
         B = rollsum(B, 14, na.pad = TRUE),
         C = rollsum(C, 14, na.pad = TRUE)) %>% 
  mutate(A = A * 3500 / 5800000,
         B = B * 3500 / 5800000,
         C = C * 3500 / 5800000) %>% 
  mutate(A = A + 3500 * 0.001,
         B = B + 3500 * 0.002,
         C = C + 3500 * 0.003) %>% 
  full_join(admitted, by = "Date") %>%
  select(Date, A, B, C, Total) %>% 
  mutate(Obs = ra(Total)) %>% 
  select(-Total) %>% 
  pivot_longer(-Date, values_to = "Nyindlagte") %>% 
  filter(Date >= ymd("2021-01-01")) 

z <- tests %>% 
  select(Date, NotPrevPos) %>% 
  mutate(A = NotPrevPos * 0.001,
         B = NotPrevPos * 0.002,
         C = NotPrevPos * 0.003) %>% 
  mutate(A = rollsum(A, 30, na.pad = TRUE, align = "right"),
         B = rollsum(B, 30, na.pad = TRUE, align = "right"),
         C = rollsum(C, 30, na.pad = TRUE, align = "right")) %>% 
  mutate(A = A * 150 / 5800000,
         B = B * 150 / 5800000,
         C = C * 150 / 5800000) %>% 
  full_join(deaths, by = "Date") %>%
  select(Date, A, B, C, Antal_døde) %>% 
  mutate(Obs = ra(Antal_døde)) %>% 
  select(-Antal_døde) %>% 
  pivot_longer(-Date, values_to = "Døde") %>% 
  filter(Date >= ymd("2021-01-01")) 
  
x %>% 
  full_join(y, by = c("Date", "name")) %>% 
  full_join(z, by = c("Date", "name")) %>% 
  pivot_longer(c(-Date, -name), "Parameter", values_to = "value") %>% 
  ggplot() +
  geom_line(aes(Date, value, color = name), size = 0.7) +
  scale_x_date(labels = my_date_labels, breaks = "1 months", minor_breaks = "1 month") +
  facet_wrap(~ Parameter, scales = "free") +
  scale_color_discrete(name = "") +
  scale_color_discrete(name = "", labels = c("0.1%", "0.2%", "0.3%", "Observeret")) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Antal", title = "Konsekvens af forskellige falsk-positivrater ved 0 smittede", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme

ggsave("../figures/ntl_fp_scenarios.png", width = 18, height = 10, units = "cm", dpi = 300)

# Calculate admitted ------------------------------------------------------

%>% 
  ggplot() +
  geom_line(aes(Date, value, color = name), size = 0.7) +
  scale_x_date(labels = my_date_labels, breaks = "3 months", minor_breaks = "1 month") +
  scale_color_discrete(name = "") +
  scale_color_discrete(name = "", labels = c("0.1%", "0.2%", "0.3%", "Observeret")) +
  scale_y_continuous(limits = c(0, NA)) +
  labs(y = "Antal nyindlagte", title = "Konsekvens af forskellige falsk-positivrater ved 0 smittede", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme

# Calculate deaths --------------------------------------------------------

tests %>% 
  select(Date, NotPrevPos) %>% 
  mutate(A = NotPrevPos * 0.001,
         B = NotPrevPos * 0.002,
         C = NotPrevPos * 0.003) %>% 
  mutate(A = rollsum(A, 30, na.pad = TRUE, align = "right"),
         B = rollsum(B, 30, na.pad = TRUE, align = "right"),
         C = rollsum(C, 30, na.pad = TRUE, align = "right")) %>% 
  mutate(A = A * 150 / 5800000,
         B = B * 150 / 5800000,
         C = C * 150 / 5800000) %>% 
  full_join(deaths, by = "Date") %>%
  select(Date, A, B, C, Antal_døde) %>% 
  mutate(z_Antal_døde = ra(Antal_døde)) %>% 
  select(-Antal_døde) %>% 
  pivot_longer(-Date) %>% 
  filter(Date >= ymd("2021-01-01")) %>% 
  ggplot() +
  geom_line(aes(Date, value, color = name), size = 0.7) +
  scale_x_date(labels = my_date_labels, breaks = "3 months", minor_breaks = "1 month") +
  scale_color_discrete(name = "") +
  scale_y_continuous(limits = c(0, NA)) +
  scale_color_discrete(name = "", labels = c("0.1%", "0.2%", "0.3%", "Observeret")) +
  labs(y = "Antal døde", title = "Konsekvens af forskellige falsk-positivrater ved 0 smittede", caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  standard_theme


y <- tests %>% 
  select(Date, NotPrevPos) %>% 
  mutate(A = NotPrevPos * 0.001,
         B = NotPrevPos * 0.002,
         C = NotPrevPos * 0.003) %>% 
  mutate(A = rollsum(A, 14, na.pad = TRUE),
         B = rollsum(B, 14, na.pad = TRUE),
         C = rollsum(C, 14, na.pad = TRUE)) %>% 
  mutate(A = A * 3500 / 5800000,
         B = B * 3500 / 5800000,
         C = C * 3500 / 5800000) %>% 
  mutate(A = A + 3500 * 0.001,
         B = B + 3500 * 0.002,
         C = C + 3500 * 0.003) %>% 
  full_join(admitted, by = "Date") %>%
  select(Date, A, B, C, Total) %>% 
  mutate(Obs = ra(Total)) %>% 
  select(-Total) %>% 
  pivot_longer(-Date, values_to = "Nyindlagte") %>% 
  filter(Date >= ymd("2021-01-01")) 

ra <- function(x, n = 7) {
  stats::filter(x, rep(1 / n, n), sides = 2)
}

p1 <- plot_data %>% 
  rename(
    obs_death = Antal_døde,
    obs_admit = Total) %>% 
  mutate(
    obs_death = ra(obs_death),
    obs_admit = ra(obs_admit),
    pool_30 = rollsum(NewPositive, 30, align = "right", na.pad = TRUE),
    pool_14 = rollsum(NewPositive, 14, align = "right", na.pad = TRUE),
    pred_death =  pool_30 * 150 / 5800000,
    pred_admit = (pool_14 * 3000 / 5800000) + (3000 * NewPositive / NotPrevPos),
    pred_death = ra(pred_death),
    pred_admit = ra(pred_admit)) %>% 
  select(Date, obs_death, obs_admit, pred_death, pred_admit) %>% 
  pivot_longer(-Date, names_to = c("type", "variable"), names_sep = "_") %>% 
  filter(Date >= ymd("2021-02-01")) %>% 
  ggplot() +
  geom_line(aes(Date, value, color = type), size = 1)+#, alpha = type, size = type)) +
  facet_wrap(~ variable, scales = "free", labeller = as_labeller(c("death" = "Døde",  "admit" = "Nyindlæggelser"))) +
  scale_alpha_manual(
    name = "", 
    labels = c("Observeret", "Forventet"), 
    values = c(0.7, 1) 
  ) +
  scale_size_manual(
    name = "", 
    labels = c("Observeret", "Forventet"), 
    values = c(0.4, 1)
  ) +
  scale_x_date(labels = my_date_labels, breaks = "1 months", minor_break = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    x = "Dato", 
    y = "Antal", 
    title = "<b><span style = 'font-size:14pt'>Nedre grænse for antal COVID-19 nyindlæggelser og døde</span></b><br><br>Fordi antallet af COVID-19 indlæggelser og døde kun er baseret på en positiv SARS-CoV-2 test kan der registreres nyindlagte og døde selv i et scenarie hvor ingen indlægges eller dør pga. COVID-19.<br><br>De <b style='color:#FC8D62;'>nedre grænser</b> er beregnet udfra antal PCR positive, den gennemsnitlige risiko for hhv. indlæggelse og død, og metoden hvormed COVID-19 indlæggelser og døde opgøres.<br> ", 
    caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  scale_colour_brewer(palette = "Set2", name = "", 
                      labels = c("Observeret 7-dages gennemsnit", "Estimeret nedre grænse")) +
  facet_theme +
  theme(
    plot.title.position = "plot",
    plot.title = element_textbox_simple(
      size = 10, face = "plain", lineheight = 1, padding = margin(0, 0, 5, 0)
    ),
  strip.text = element_text(size = 10, face = "bold")
  )
  
ggsave("../figures/ntl_admit_death_expected.png", width = 20, height = 11, units = "cm", dpi = 300)

p2 <- plot_data %>% 
  rename(
    obs_death = Antal_døde,
    obs_admit = Total,
    obs_pos = NewPositive) %>% 
  mutate(
    obs_death = ra(obs_death),
    obs_admit = ra(obs_admit),
    obs_pos = ra(obs_pos),
    pred_pos = NotPrevPos * 0.001,
    pool_30 = rollsum(pred_pos, 30, align = "right", na.pad = TRUE),
    pool_14 = rollsum(pred_pos, 14, align = "right", na.pad = TRUE),
    pred_death =  pool_30 * 150 / 5800000,
    pred_admit = (pool_14 * 3000 / 5800000) + (3000 * 0.001),
    pred_death = ra(pred_death),
    pred_admit = ra(pred_admit),
    pred_pos = ra(pred_pos)) %>% 
  select(Date, obs_death, obs_admit, obs_pos, pred_pos, pred_death, pred_admit) %>% 
  pivot_longer(-Date, names_to = c("type", "variable"), names_sep = "_") %>% 
  mutate(
    variable = case_when(
      variable == "admit" ~ "y_admit",
      variable == "death" ~ "z_death",
      variable == "pos" ~ "pos"
    )
  ) %>% 
  filter(Date >= ymd("2021-02-01")) %>% 
  ggplot() +
  geom_line(aes(Date, value, color = type), size = 1)+#, alpha = type, size = type)) +
  facet_wrap(~ variable, scales = "free", labeller = as_labeller(c("z_death" = "Døde",  
                                                                   "y_admit" = "Nyindlæggelser",
                                                                   "pos" = "Positive"))) +
  scale_alpha_manual(
    name = "", 
    labels = c("Observeret", "Forventet"), 
    values = c(0.7, 1) 
  ) +
  scale_size_manual(
    name = "", 
    labels = c("Observeret", "Forventet"), 
    values = c(0.4, 1)
  ) +
  scale_x_date(labels = my_date_labels, breaks = "1 months", minor_break = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    x = "Dato", 
    y = "Antal", 
    title = "Nedre grænse ved falsk-positivrate = 0.1%", 
    caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI",
    subtitle = "Fordi antallet af COVID-19 indlæggelser og døde kun er baseret på en positiv SARS-CoV-2 test\nvil falske positive tests også slå igennem i antal nyindlæggelser og døde.\n\n De nedre grænser er beregnet udfra antal PCR testede, den gennemsnitlige risiko for hhv. indlæggelse og død,\nog metoden hvormed COVID-19 indlæggelser og døde opgøres.") +
  scale_colour_brewer(palette = "Set2", name = "", 
                      labels = c("Observeret 7-dages gennemsnit", "Estimeret nedre grænse")) +
  facet_theme +
  theme(
    strip.text = element_text(size = 10, face = "bold")
  )


