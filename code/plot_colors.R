color_scale <- c(
  "#888888",
  "#E69F00",
  lighten("#3087B7", 0.1),
  desaturate("#FC4E07", 0.1),
  desaturate(lighten("#293352", 0.15), 0.1),
  desaturate(lighten("#FC4E07", 0.4), 0),
  desaturate(darken("#FC4E07", 0.1), 0))

#specplot(color_scale)

pos_col <- color_scale[4]
test_col <- color_scale[5]
pct_col <- color_scale[2]
admit_col <- color_scale[3]
death_col <- color_scale[1]
binary_col <- c(color_scale[6], color_scale[7])
#89D9CF