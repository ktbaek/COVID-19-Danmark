# Color scale -------------------------------------------------------------
color_scale <- c(
  "#888888",
  "#E69F00",
  lighten("#3087B7", 0.1),
  desaturate("#FC4E07", 0.1),
  desaturate(lighten("#293352", 0.15), 0.1)
)

death_col <- color_scale[1]
pct_col <- color_scale[2]
admit_col <- color_scale[3]
pos_col <- color_scale[4]
test_col <- color_scale[5]

# Typeface ----------------------------------------------------------------

quartzFonts(lato = c("Lato-Regular", "Lato-Bold", "Lato-Light", "Lato-BoldItalic"))

# global variables --------------------------------------------------------

standard_caption <- "Kristoffer T. Bæk, covid19danmark.dk, data: SSI"
standard_caption_en <- "Kristoffer T. Bæk, covid19danmark.dk, data: SSI"

# Set gg themes ------------------------------------------------------------

theme_set(theme_covid())

facet_theme <-
  theme_covid() +
  theme(
    text = element_text(size = 9),
    plot.margin = margin(1, 1, 0.3, 1, "cm"),
    legend.position = "bottom",
    plot.title = element_text(size = 14, hjust = 0),
    plot.caption = element_text(size = 10),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, margin = margin(t = 0, r = 0, b = 0, l = 20))
  )

tile_theme <-
  theme_tufte() +
  theme(
    text = element_text(size = 13, family = "lato"),
    plot.background = element_blank(),
    plot.margin = margin(1, 0, 0.3, 0, "cm"),
    panel.border = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    plot.caption = element_text(color = "gray60", hjust = 0),
    axis.text.y = element_text(margin = margin(t = 0, r = -5, b = 0, l = 0)),
    legend.text = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    axis.title.x = element_text(size = 12),
    axis.ticks = element_blank(),
    axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 8, l = 0))
  )

