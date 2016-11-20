#' Download binaries
#'
#' Download binaries from repository
#'
#' @param dllist A named list of data.frames. The data.frame should
#'     contain the version, url and file to be processed, the directory to
#'     download the file to and whether the file already exists.
#'
#' @return
#' @export
#'
#' @examples

download_files <- function(dllist, overwrite = FALSE){
  dl_files <- function(dir, file, url){
    if(!dir.exists(dir)){
      message("Creating directory: ", dir, "\n")
      chk <- dir.create(dir, recursive = TRUE)
      stopifnot(chk)
    }
    message("Downloading binary: ", url, "\n")
    wd <- httr::write_disk(file.path(dir, file), overwrite = TRUE)
    res <- httr::GET(url, wd)
    httr::stop_for_status(res)
    res
  }
  lapply(dllist, function(platformDF){
    if(!overwrite){
      platformDF <- platformDF[!platformDF[["exists"]], ]
    }
    if(identical(nrow(platformDF), 0L)){
      return(NULL)
    }
    res <- Map(dl_files,
               dir = platformDF[["dir"]],
               file = platformDF[["file"]],
               url = platformDF[["url"]])
  })
}
