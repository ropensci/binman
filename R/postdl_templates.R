#' Unzip downloaded files
#'
#' Unzip downloaded files. Keeps the original zip file
#'
#' @param dlfiles A named list. The names are the relevant platforms.
#'     The list contain named logical vectors
#'
#' @return
#' @export
#'
#' @examples

unzip_dlfiles <- function(dlfiles){
  if(nrow(dlfiles) == 0L){
    return()
  }
  unzip_file <- function(platform, file, processed){
    if(!processed){return()}
    exdir <- dirname(file)
    unzip(file, exdir = exdir)
  }
  do.call(unzip_file, dlfiles)
}
