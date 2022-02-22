add_image_text <- function(path,filename, language) {
  
  img <- image_read(paste0(path, filename))
  
  if(language == "en") text <- "Kristoffer T. Bæk, covid19danmark.dk, data source: SSI"
  if(language == "dk") text <- "Kristoffer T. Bæk, covid19danmark.dk, datakilde: SSI"
  if(language == "dk_dst") text <- "Kristoffer T. Bæk, covid19danmark.dk, datakilder: Danmarks Statistik og SSI"
  
  img %<>% image_annotate(text, 
                          size = 34, 
                          gravity = "southwest", 
                          font = "lato", 
                          location = geometry_point(30, 30), 
                          weight = 300)
  
  image_write(img, path = paste0(path, filename), format = "png")
}


add_text_to_images <- function(path, startswith, language = "dk"){

   image_files <- list.files(path=path)

   image_files <- image_files[str_starts(image_files, startswith)] 

   lapply(image_files, function(x) add_image_text(path, x, language))

}
