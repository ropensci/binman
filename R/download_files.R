#' Download binaries
#'
#' Download binaries from repository
#'
#' @param dllist A named list of data.frames. The data.frame should
#'     contain the version, url and file to be processed, the directory to
#'     download the file to and whether the file already exists.
#'
#' @return A list of download responses for each of the proposed files.
#'     If no download was carried out the response is NULL.
#' @export
#'
#' @examples
#' \dontrun{
#' trdata <- system.file("testdata", "test_dlres.Rdata", package="binman")
#' tldata <- system.file("testdata", "test_dllist.Rdata", package="binman")
#' load(trdata)
#' load(tldata)
#' dllist <- assign_directory(test_dllist, "myapp")
#' testthat::with_mock(
#'   `httr::GET` = function(...){
#'     test_llres
#'   },
#'   `base::dir.create` = function(...){TRUE},
#'   dlfiles <- download_files(dllist)
#' )
#' }

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
               url = platformDF[["url"]], USE.NAMES = FALSE)
    res
  })
}