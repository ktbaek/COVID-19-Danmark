
image_files <- list.files(path="../figures/")

image_files <- image_files[!image_files %in% c("twitter_card.png",
                                               "model_twitter_card.png",
                                               "Tested_explanation.png"
                                               )
                           ]


image_files <- image_files[!str_detect(image_files, "^exp")] 
image_files <- image_files[!str_detect(image_files, "^BK")] 
image_files <- image_files[!str_detect(image_files, "pdf$")] 
image_files <- image_files[!str_detect(image_files, "ai$")] 

add_image_text <- function(filename) {
  
  img <- image_read(paste0("../figures/", filename))
  
  img %<>% image_annotate("Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI", 
                 size = 34, 
                 gravity = "southwest", 
                 font = "lato", 
                 location = geometry_point(30, 30), 
                 weight = 300)
  
  image_write(img, path = paste0("../figures/", filename), format = "png")
}


lapply(image_files, function(x) add_image_text(x))
