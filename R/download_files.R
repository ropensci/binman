#' Download binaries
#'
#' Download binaries from repository
#'
#' @param dllist A named list of data.frames. The data.frame should
#'     contain the version, url and file to be processed, the directory to
#'     download the file to and whether the file already exists.
#' @param overwrite Overwrite existing binaries. Default value of FALSE
#'
#' @return A data.frame indicating whether a file was
#'     downloaded for a platform.
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
  dlfiles <- lapply(names(dllist), function(platform){
    platformDF <-dllist[[platform]]
    if(!overwrite){
      platformDF <- platformDF[!platformDF[["exists"]], ]
    }
    if(identical(nrow(platformDF), 0L)){
      return(data.frame(platform = character(), file = character(),
                        processed = logical()))
    }
    res <- Map(dl_files,
               dir = platformDF[["dir"]],
               file = platformDF[["file"]],
               url = platformDF[["url"]], USE.NAMES = FALSE)
    res <- vapply(res, class, character(1)) == "response"
    data.frame(platform = platform,
               file = file.path(platformDF[["dir"]],
                                platformDF[["file"]]),
               processed = res,
               stringsAsFactors = FALSE)
  })
  invisible(do.call(rbind.data.frame, dlfiles))
}
