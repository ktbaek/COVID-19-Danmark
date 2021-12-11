library(tidyverse)
library(magrittr)
library(lubridate)
library(scales)

ssi_18 <- read_csv2("../data/18_fnkt_alder_uge_testede_positive_nyindlagte.csv")

rsquared <-
  function(x, y) {
    m <- lm(y ~ x)
    return(summary(m)$r.squared)
  }

slope <-
  function(x, y) {
    m <- lm(y ~ x)
    return(summary(m)$coefficients[2])
  }

ssi_18_tidy <- ssi_18 %>%
  separate(Uge, into = c("year", "week"), sep = "-") %>%
  mutate(week = str_remove(week, "W")) %>%
  mutate(
    week = as.integer(week),
    year = as.integer(year)
  ) %>%
  mutate(date = as.Date(paste0(year, sprintf("%02d", week), "1"), "%Y%U%u")) %>%
  mutate(date = case_when(
    year(date) == 2020 ~ date - days(7),
    year(date) == 2021 ~ date,
    week == 53 ~ ymd("2020-12-28")
  ), ) %>%
  rename(
    admitted = `Nyindlagte pr. 100.000 borgere`,
    tested = `Testede pr. 100.000 borgere`,
    positive = `Positive pr. 100.000 borgere`
  ) %>%
  select(date, week, Aldersgruppe, admitted, tested, positive) %>%
  mutate(
    admitted = ifelse(is.na(admitted), 0, admitted),
    positive = ifelse(is.na(positive), 0, positive),
    tested = ifelse(is.na(tested), 0, tested)
  ) %>%
  mutate(
    year = year(date),
    quarter = quarter(date),
    year_quarter = paste(year, quarter, sep = "_")
  )

ssi_18_tidy$Aldersgruppe <- factor(ssi_18_tidy$Aldersgruppe, levels = c("0-2", "3-5", "6-11", "12-15", "16-19", "20-39", "40-64", "65-79", "80+"))

plot_data <- ssi_18_tidy %>%
  filter(!year_quarter %in% c("2020_1", "2020_2")) %>%
  mutate(year_quarter = str_replace(year_quarter, "_", " Q")) %>%
  group_by(Aldersgruppe, year_quarter) %>%
  mutate(admitted = 0.33 * (lead(admitted, n = 0) + lead(admitted, n = 1) + lead(admitted, n = 2))) %>%
  mutate(
    R = sqrt(rsquared(positive, admitted)),
    slope = slope(positive, admitted)
  )

plot_data %>%
  filter(slope >= 0) %>%
  select(Aldersgruppe, R, slope, year_quarter) %>%
  distinct() %>%
  mutate(R = ifelse(is.na(R), " ", paste0(sprintf("%.2f", round(R, 2))))) %>%
  ggplot() +
  geom_bar(aes(year_quarter, slope * 100, fill = Aldersgruppe), stat = "identity") +
  geom_text(
    aes(
      x = year_quarter,
      y = -4,
      group = year_quarter,
      label = R
    ),
    color = "gray70",
    size = rel(1.8),
    family = "lato",
    check_overlap = TRUE
  ) +
  facet_wrap(~ Aldersgruppe) +
  scale_y_continuous(limits = c(-5, NA), labels = function(x) paste0(x, " %")) +
  scale_fill_manual(name = "", values = c(hue_pal()(7)[1], hue_pal()(7)[1:2], hue_pal()(7)[3], hue_pal()(7)[3:7])) +
  facet_theme +
  theme(
    plot.margin = margin(0.5, 1, 0.2, 0.5, "cm"),
    legend.position = "none",
    axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1),
    plot.title = element_text(margin = margin(b = 3)),
    plot.subtitle = element_textbox_simple(size = rel(0.8), width = unit(1, "npc"), margin = margin(b = 4)),
    panel.grid.major.x = element_blank()
  ) +
  labs(
    y = "Andel",
    x = "Quarter",
    title = "Ugentlige indlæggelser som andel af antal PCR positive",
    subtitle = "Én uges positive er sammenlignet med gennemsnittet af indlæggelser i samme uge og de to følgende uger ('risikotiden'). Indlæggelser er defineret på baggrund af positiv SARS-CoV-2 PCR test. Tal under søjlerne angiver korrelationskoefficienten (interval 0-1).",
    caption = standard_caption
  )

ggsave("../figures/ntl_pos_admit_bars_quarter.png", width = 18, height = 10, units = "cm", dpi = 300)