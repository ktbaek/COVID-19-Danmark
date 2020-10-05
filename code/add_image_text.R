library(magick)

image_files <- list.files(path="../figures/")

image_files <- image_files[!image_files %in% c("twitter_card.png",
                                               "Covid-19-Danmark.pdf",
                                               "Tested_explanation.png",
                                               "begreber.ai",
                                               "exp_masks.png"
                                               )
                           ]
  

add_image_text <- function(filename) {
  
  img <- image_read(paste0("../figures/", filename))
  
  img %<>% image_annotate("ktbaek.github.io/COVID-19-Danmark", 
                 size = 32, 
                 gravity = "southeast", 
                 font = "lato", 
                 location = geometry_point(30, 30), 
                 weight = 300)
  
  image_write(img, path = paste0("../figures/", filename), format = "png")
}


lapply(image_files, function(x) add_image_text(x))
