#' Assign directory
#'
#' Assign directory to download list
#' @param dllist A named list of data.frames. The name indicates the
#'     platform. The data.frame should contain the version, url and file
#'     to be processed.
#' @param appname Name to give the app
#'
#' @return A named list of data.frames. The data.frame should contain the
#'     version, url and file to be processed, the directory to download
#'     the file to and whether the file already exists.
#' @export
#'
#' @examples
#' \dontrun{
#' tdata <- system.file("testdata", "test_dllist.Rdata", package="binman")
#' load(tdata)
#' assign_directory(test_dllist, "myapp")
#' }

assign_directory <- function(dllist, appname){
  assert_that(is_list_of_df(dllist))
  assert_that(is_string(appname))
  dl_dirs <- function(platform, version){
    dlversion <- normalizePath(paste(platform, version, sep = "/"),
                               mustWork = FALSE)
    dldir <- rappdirs::user_data_dir(appname, "binman", dlversion)
  }
  applist <- lapply(names(dllist), function(platform){
    platformDF <- dllist[[platform]]
    platformDF[["dir"]] <- Map(dl_dirs,
                               platform = platform,
                               version = platformDF[["version"]])
    platformDF[["exists"]] <-
      file.exists(file.path(platformDF[["dir"]], platformDF[["file"]]))
    platformDF
  })
  invisible(setNames(applist, names(dllist)))
}
