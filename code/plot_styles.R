# Color scale -------------------------------------------------------------
color_scale <- c(
  "#888888",
  "#E69F00",
  lighten("#3087B7", 0.1),
  desaturate("#FC4E07", 0.1),
  desaturate(lighten("#293352", 0.15), 0.1),
  desaturate(lighten("#FC4E07", 0.4), 0),
  desaturate(darken("#FC4E07", 0.1), 0)
)

pos_col <- color_scale[4]
test_col <- color_scale[5]
pct_col <- color_scale[2]
admit_col <- color_scale[3]
death_col <- color_scale[1]
binary_col <- c(color_scale[6], color_scale[7])



# Date labels -------------------------------------------------------------

my_date_labels <- function(breaks) {
  
  labels <- sapply(breaks, function(x) {
    
    if(!is.na(x) && month(x) == 1) {
      str_to_lower(strftime(x, "%e. %b %y"))
    }else{
      str_to_lower(strftime(x, "%e. %b"))
    }
  })
  
  return(labels)
}


# Typeface ----------------------------------------------------------------

quartzFonts(lato = c("Lato-Regular", "Lato-Bold", "Lato-Light", "Lato-BoldItalic"))

# Custom gg themes ------------------------------------------------------------
  
standard_theme <-
  theme_minimal() +
  theme(
    text = element_text(size = 11, family = "lato"),
    panel.grid.minor.x = element_line(size = 0.2),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_line(size = 0.2),
    panel.grid.major.y = element_line(size = 0.3),
    legend.position = "top",
    plot.margin = margin(1, 1, 0.3, 1, "cm"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.caption = element_text(color = "gray70", hjust = 0, size = 7),
    plot.subtitle = element_text(color = "gray30", hjust = 0.5, size = 9),
    axis.title.y = element_text(face = "bold", margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(face = "bold", margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_blank(),
    axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 8, l = 0)),
    legend.text = element_text(size = 11),
    legend.key.size = unit(0.4, 'cm')
  )

facet_theme <-
  theme_minimal() +
  theme(
    panel.grid.minor.x = element_line(size = 0.2),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_line(size = 0.2),
    panel.grid.major.y = element_line(size = 0.3),
    text = element_text(size = 9, family = "lato"),
    plot.margin = margin(1, 1, 0.3, 1, "cm"),
    legend.text = element_text(size = 12),
    legend.position = "bottom",
    plot.title = element_text(size = 14, face = "bold"),
    plot.caption = element_text(color = "gray60", hjust = 0),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(size = 12, margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.y.right = element_text(size = 12, margin = margin(t = 0, r = 0, b = 0, l = 20)),
    axis.title.x = element_blank(),
    axis.text.x = element_text(margin = margin(t = 0, r = 0, b = 8, l = 0))
  )

tile_theme <-
  theme_tufte() +
  theme(
    text = element_text(size = 13, family = "lato"),
    plot.background = element_blank(),
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

# Custom base plot functions -------------------------------------------------

standard_plot <- function(title,
                          max_y_value,
                          y_label = "Antal",
                          x_label = "Dato",
                          y_label_dist = 4,
                          x_by = "2 months",
                          start_date = "2020-02-15",
                          end_date = today) {
  
  par(family = "lato", mar = c(5, 8, 5, 2))

  plot(NULL,
    type = "n",
    ylab = "",
    xlab = "",
    axes = FALSE,
    cex = 1.2,
    cex.axis = cex_axis,
    ylim = c(0, max_y_value),
    xlim = c(as.Date(start_date), as.Date(end_date) - 1),
  )


  mtext(
    text = title,
    side = 3, # side 1 = bottom
    line = 1,
    cex = 1.5,
    font = 2
  )

  mtext(
    text = x_label,
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

  box(which = "plot", lty = "solid")

  axis.Date(1, at = seq(as.Date("2020-03-01"), as.Date(end_date) - 1, x_by), format = "%b", cex.axis = cex_axis)
  axis.Date(1, at = seq(as.Date("2020-03-01"), as.Date(end_date) - 1, "1 month"), labels = FALSE, cex.axis = cex_axis)
  

}

double_plot <- function(title,
                        max_y_value,
                        y_label = "Antal",
                        x_label = "Dato",
                        y2_label,
                        y_label_dist = 4,
                        x_by = "2 months",
                        start_date = "2020-02-15",
                        end_date = today) {
  
  y2_label_pos <- as.double(0.21 * (as.Date(end_date) - as.Date(start_date)))

  par(family = "lato", mar = c(5, 8, 5, 6))

  plot(NULL,
    type = "n",
    ylab = "",
    xlab = "",
    axes = FALSE,
    cex = 1.2,
    cex.axis = cex_axis,
    ylim = c(0, max_y_value),
    xlim = c(as.Date(start_date), as.Date(end_date) - 1),
  )


  mtext(
    text = title,
    side = 3, # side 1 = bottom
    line = 1,
    cex = 1.5,
    font = 2
  )

  mtext(
    text = x_label,
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


  box(which = "plot", lty = "solid")

  axis.Date(1, at = seq(as.Date("2020-03-01"), as.Date(end_date) - 1, x_by), format = "%b", cex.axis = cex_axis)
  axis.Date(1, at = seq(as.Date("2020-03-01"), as.Date(end_date) - 1, "1 month"), labels = FALSE, cex.axis = cex_axis)

  text(par("usr")[2] + y2_label_pos, mean(par("usr")[3:4]), y2_label, srt = -90, xpd = TRUE, adj = 0.5, cex = cex_labels, font = 2)
}
