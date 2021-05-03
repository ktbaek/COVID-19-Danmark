read_data <- function(path, type = 2, ...) {
  
  if(file.exists(path)){
    if(type == 1) return(readr::read_csv(path, ...))
    if(type == 2) return(readr::read_csv2(path, ...))
    }
}

ra <- function(x, n = 7, s = 2) {
  stats::filter(x, rep(1 / n, n), sides = s)
}