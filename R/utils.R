pretty_message <- function(x, ..., width = getOption("width")){
  newx <- if(nchar(x) > width - 7){
    paste0(substr(x, 1, width - 7), "...")
  }else{
    x
  }
  message(newx, ...)
}
