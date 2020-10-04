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

quartzFonts(lato = c("Lato-Regular", "Lato-Bold", "Lato-Light", "Lato-BoldItalic"))

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

# Custom base plot functions -------------------------------------------------

standard_plot <- function(title, 
                          max_y_value,
                          y_label = "Antal", 
                          y_label_dist = 4,
                          x_by = "2 months",
                          start_date = "2020-02-15") {
  
  par(family = "lato", mar = c(5, 8, 5, 2))
  
  plot(NULL,
       type = "n",
       ylab = "",
       xlab = "",
       axes = FALSE,
       cex = 1.2,
       cex.axis = cex_axis,
       ylim = c(0, max_y_value),
       xlim = c(as.Date(start_date), as.Date(today) - 1),
  )
  
  
  mtext(
    text = title,
    side = 3, # side 1 = bottom
    line = 1,
    cex = 1.5,
    font = 2
  )
  
  mtext(
    text = "Dato",
    side = 1, # side 1 = bottom
    line = 3,
    cex = cex_labels,
    font = 2
  )
  
  mtext(
    text = y_label,
    side = 2, # side 1 = bottom
    line = y_label_dist,
    cex = cex_labels,
    font = 2
  )
  
  mtext("ktbaek.github.io/COVID-19-Danmark", 
        side = 1, 
        line = 3.7, 
       # at = as.Date(today) + 20,
        cex = cex_labels/1.8,
        adj = 1,
        font = 3)
  
  box(which = "plot", lty = "solid")
  
  axis.Date(1, at = seq(as.Date("2020-03-01"), as.Date(today) - 1, x_by), format = "%b", cex.axis = cex_axis)
  

  
}

double_plot <- function(title, 
                        max_y_value,
                          y_label = "Antal", 
                        y2_label, 
                          y_label_dist = 4,
                          x_by = "2 months",
                          start_date = "2020-02-15") {
  
  y2_label_pos <- as.double(0.16 * (as.Date(today) - as.Date(start_date)))
  
  par(family = "lato", mar = c(5, 7, 5, 7))
  
  plot(NULL,
       type = "n",
       ylab = "",
       xlab = "",
       axes = FALSE,
       cex = 1.2,
       cex.axis = cex_axis,
       ylim = c(0, max_y_value),
       xlim = c(as.Date(start_date), as.Date(today) - 1),
  )
  
  
  mtext(
    text = title,
    side = 3, # side 1 = bottom
    line = 1,
    cex = 1.5,
    font = 2
  )
  
  mtext(
    text = "Dato",
    side = 1, # side 1 = bottom
    line = 3,
    cex = cex_labels,
    font = 2
  )
  
  mtext(
    text = y_label,
    side = 2, # side 1 = bottom
    line = y_label_dist,
    cex = cex_labels,
    font = 2
  )
  
  mtext("ktbaek.github.io/COVID-19-Danmark", 
        side = 1, 
        line = 3.7, 
        # at = as.Date(today) + 20,
        cex = cex_labels/1.8,
        adj = 1,
        font = 3)
  
  box(which = "plot", lty = "solid")
  
  axis.Date(1, at = seq(as.Date("2020-03-01"), as.Date(today) - 1, x_by), format = "%b", cex.axis = cex_axis)
  
  text(par("usr")[2] + y2_label_pos, mean(par("usr")[3:4]), y2_label, srt = -90, xpd = TRUE, adj = 0.5, cex = cex_labels, font = 2)
  
  
}
