#' Unzip downloaded files
#'
#' Unzip downloaded files. Keeps the original zip file
#'
#' @param dlfiles A data.frame of files by platform and indicating
#'     whether they were process
#'
#' @return indicates whether the unzips were successful
#' @export
#'
#' @examples
#' \dontrun{
#'  x<-1
#' }

unzip_dlfiles <- function(dlfiles){
  assert_that(is_data.frame(dlfiles))
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
