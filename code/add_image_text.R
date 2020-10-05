
image_files <- list.files(path="../figures/")

image_files <- image_files[!image_files %in% c("twitter_card.png",
                                               "Covid-19-Danmark.pdf",
                                               "Tested_explanation.png",
                                               "begreber.ai"
                                               )
                           ]


image_files <- image_files[!str_detect(image_files, "^exp")] 

add_image_text <- function(filename) {
  
  img <- image_read(paste0("../figures/", filename))
  
  img %<>% image_annotate("Kristoffer T. Bæk, ktbaek.github.io/COVID-19-Danmark", 
                 size = 34, 
                 gravity = "southwest", 
                 font = "lato", 
                 location = geometry_point(30, 30), 
                 weight = 300)
  
  image_write(img, path = paste0("../figures/", filename), format = "png")
}


lapply(image_files, function(x) add_image_text(x))
