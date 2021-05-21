Estimat af nedre grænse for COVID-19 indlæggelser
================
Kristoffer T. Bæk

2021-05-21


### Estimat af hvor mange COVID-19 relaterede indlæggelser der vil registreres med SSI’s definition hvis ingen indlægges pga. COVID-19.

Der registreres dagligt ca. 2500 akutindlæggelser i Danmark. Den
gennemsnitlige daglige risiko for at en person bliver akutindlagt kan
derfor sættes til *risiko* = 2500 / 5800000.

Hver dag kan beregnes hvor stor puljen af personer med en positiv test
der er mindre end 14 dage gammel er. Chancen for at en person med en
positiv test indlægges er derfor:
*positivpulje* * *risiko*. Derudover
antages det at alle akutindlagte rutinetestes, og at man derigennem også
vil finde positive (selvom de ikke er indlagt pga. COVID-19). Antallet
af positive man vil finde på denne måde sættes til:
2500 * positivprocenten. Da den
generelle positivprocent blandt testede i hele befolkningen måske ikke
er retvisende for gruppen af indlagte personer, beregnes et lavt
scenarie til 2500 * 0,7 * positivprocenten, og et højt scenarie til
2500 * 1,5 * positivprocenten.

Det samlede antal personer der opfylder SSI’s definition beregnes som:
Positivt testede der indlægges + indlagte der testes positive.

### Plot

``` r
ra <- function(x, n = 7, s = 2) {
  stats::filter(x, rep(1 / n, n), sides = s)
}
```

``` r
plot_data <- read_csv2("../data/SSI_plot_data.csv")

plot_data %>%
  filter(name %in% c("Positive", "Admitted", "Tested")) %>%
  pivot_wider(names_from = name, values_from = c(daily, ra), names_sep = "_") %>%
  rename(
    obs_admit_y = ra_Admitted
  ) %>%
  mutate(
    pool_14 = rollsum(daily_Positive, 14, align = "right", na.pad = TRUE),
    pred_admit_lo = (pool_14 * 2500 / 5800000) + (2500 * ra(daily_Positive / daily_Tested) * 0.7),
    pred_admit_hi = (pool_14 * 2500 / 5800000) + (3000 * ra(daily_Positive / daily_Tested) * 1.5)
  ) %>%
  select(Date, obs_admit_y, pred_admit_lo, pred_admit_hi) %>%
  pivot_longer(-Date, names_to = c("type", "variable", "limit"), names_sep = "_") %>%
  pivot_wider(names_from = limit, values_from = value) %>%
  filter(Date >= ymd("2021-02-01")) %>%
  ggplot() +
  geom_ribbon(aes(Date, ymin = lo, ymax = hi, fill = type), alpha = 0.8) +
  geom_line(aes(Date, y, color = type), size = 1)+#, alpha = type, size = type)) +
  scale_x_date(labels = my_date_labels, breaks = "1 months", minor_break = "1 month") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(
    x = "Dato",
    y = "Antal",
    title = "<b><span style = 'font-size:13pt'>Nedre grænse for antal COVID-19 nyindlæggelser</span></b><br><br>Fordi antallet af COVID-19 indlæggelser kun er baseret på en positiv SARS-CoV-2 test, kan der registreres nyindlagte selv i et scenarie hvor ingen indlægges pga. COVID-19.<br><br>Den <b style='color:#FC8D62;'>nedre grænse</b> er beregnet udfra antal PCR positive, den gennemsnitlige statistiske risiko for indlæggelse, og metoden hvormed COVID-19 indlæggelser opgøres.<br><br>Estimeret nedre grænse for indlagte viser et interval mellem et muligt lavt og højt scenarie<br>",
    caption = "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI") +
  scale_colour_brewer(palette = "Set2", name = "", guide = FALSE) +
  scale_fill_brewer(palette = "Set2", name = "",
                    labels = c("Observeret 7-dages gennemsnit", "Estimeret nedre grænse")) +
  standard_theme +
  theme(
    plot.title.position = "plot",
    plot.title = element_textbox_simple(
      size = 10, face = "plain", lineheight = 1.05, padding = margin(0, 5, 5, 0)
    )
  )
```
