pretty_message <- function(x, ..., width = getOption("width")){
  newx <- if(nchar(x) > width - 7){
    paste0(substr(x, 1, width - 7), "...")
  }else{
    x
  }
  message(newx, ...)
}

match_platform <- function(file, platform, platformregex){
  platind <- vapply(platformregex, grepl, logical(length(file)),
                    x= file, perl = TRUE)
  plat <- if(is.null(dim(platind))){
    if(sum(platind) > 1){
      stop("File matches more than one platform. Check regex.")
    }
    ifelse(length(platform[platind]) > 0, platform[platind], NA)
  }else{
    if(any(rowSums(platind) > 1)){
      stop("File matches more than one platform. Check regex.")
    }
    apply(platind, 1, function(x){
      ifelse(length(platform[x]) > 0, platform[x], NA)
    })
  }
  invisible(plat)
}

get_os <- function (){
  if (.Platform$OS.type == "windows") {
    "win"
  }
  else if (Sys.info()["sysname"] == "Darwin") {
    "mac"
  }
  else if (.Platform$OS.type == "unix") {
    "unix"
  }
  else {
    stop("Unknown OS")
  }
}
