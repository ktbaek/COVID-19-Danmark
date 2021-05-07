library(zoo)
# hosp døde forventet -----------------------------------------------------

plot_data <- read_csv2("../data/SSI_plot_data.csv")

p1 <- plot_data %>% 
  filter(name %in% c("Positive", "Deaths", "Admitted", "Tested")) %>% 
  pivot_wider(names_from = name, values_from = c(daily, ra), names_sep = "_") %>% 
  rename(
    obs_death_y = ra_Deaths,
    obs_admit_y= ra_Admitted
  ) %>% 
  mutate(
    pool_30 = rollsum(daily_Positive, 30, align = "right", na.pad = TRUE),
    pool_14 = rollsum(daily_Positive, 14, align = "right", na.pad = TRUE),
    pred_death_y =  pool_30 * 150 / 5800000,
    pred_admit_lo = (pool_14 * 2500 / 5800000) + (2500 * ra(daily_Positive / daily_Tested) * 0.75),
    pred_admit_hi = (pool_14 * 3500 / 5800000) + (3000 * ra(daily_Positive / daily_Tested) * 1.25)
    ) %>% 
  select(Date, obs_death_y, obs_admit_y, pred_death_y, pred_admit_lo, pred_admit_hi) %>% 
  pivot_longer(-Date, names_to = c("type", "variable", "limit"), names_sep = "_") %>% 
  pivot_wider(names_from = limit, values_from = value) %>% 
  filter(Date >= ymd("2021-02-01")) %>% 
  ggplot() +
  geom_line(aes(Date, y, color = type), size = 1)+#, alpha = type, size = type)) +
  geom_ribbon(aes(Date, ymin = lo, ymax = hi, fill = type), alpha = 0.8) +
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
    title = "<b><span style = 'font-size:13pt'>Nedre grænse for antal COVID-19 nyindlæggelser og døde</span></b><br><br>Fordi antallet af COVID-19 indlæggelser og døde kun er baseret på en positiv SARS-CoV-2 test, kan der registreres nyindlagte og døde selv i et scenarie hvor ingen indlægges eller dør pga. COVID-19.<br><br>De <b style='color:#FC8D62;'>nedre grænser</b> er beregnet udfra antal PCR positive, den gennemsnitlige statistiske risiko for hhv. indlæggelse og død, og metoden hvormed COVID-19 indlæggelser og døde opgøres.<br><br>Estimeret nedre grænse for indlagte viser et interval mellem et muligt lavt og højt scenarie<br>", 
    caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  scale_colour_brewer(palette = "Set2", name = "", 
                      labels = c("Observeret 7-dages gennemsnit", "Estimeret nedre grænse")) +
  scale_fill_brewer(palette = "Set2", name = "", 
                      labels = c("Observeret 7-dages gennemsnit", "Estimeret nedre grænse")) +
  facet_theme +
  theme(
    plot.margin = margin(.6, .6, .3, .6, "cm"),
    plot.title.position = "plot",
    plot.title = element_textbox_simple(
      size = 9, face = "plain", lineheight = 1.1, padding = margin(0, 5, 5, 0)
    ),
  strip.text = element_text(size = 10, face = "bold")
  )
  
ggsave("../figures/ntl_admit_death_expected.png", width = 20, height = 11, units = "cm", dpi = 300)


