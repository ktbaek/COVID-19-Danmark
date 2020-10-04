# Color scale -------------------------------------------------------------
color_scale <- c(
  "#888888",
  "#E69F00",
  lighten("#3087B7", 0.1),
  desaturate("#FC4E07", 0.1),
  desaturate(lighten("#293352", 0.15), 0.1),
  desaturate(lighten("#FC4E07", 0.4), 0),
  desaturate(darken("#FC4E07", 0.1), 0))

pos_col <- color_scale[4]
test_col <- color_scale[5]
pct_col <- color_scale[2]
admit_col <- color_scale[3]
death_col <- color_scale[1]
binary_col <- c(color_scale[6], color_scale[7])


# Typeface ----------------------------------------------------------------

quartzFonts(lato = c("Lato-Regular", "Lato-Bold", "Lato-Italic", "Lato-BoldItalic"))

# Custom gg themes ------------------------------------------------------------

standard_theme <- 
  theme_minimal() +
  theme(
    text = element_text(size = 11, family = "lato"),
    panel.grid.minor.x = element_blank(),
    plot.margin = margin(1, 1, 1, 1, "cm"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

facet_theme <- 
  theme_minimal() +
  theme(
    text = element_text(size = 9, family = "lato"),
    plot.margin = margin(1, 1, 1, 1, "cm"),
    legend.text = element_text(size = 12),
    plot.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_text(size = 12, margin = margin(t = 20, r = 0, b = 0, l = 0))
  )

tile_theme <- 
  theme_tufte() +
  theme(
    text = element_text(size = 13, family = "lato"),
    plot.background = element_blank(),
    panel.border = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    axis.text.y = element_text(margin = margin(t = 0, r = -5, b = 0, l = 0)),
    legend.text = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    axis.title.x = element_text(size = 12),
    axis.ticks = element_blank()
  )
