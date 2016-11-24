#' List app versions
#'
#' List app versions by platform
#'
#' @param appname A character string giving the name of the application
#' @param platform A character vector of platforms to list. Defaults to
#'     "ALL"
#'
#' @return A list of platforms with version directories
#' @export
#'
#' @examples
#' \dontrun{
#' x <- 1
#' }

list_versions <- function(appname, platform = c("ALL")){
  assert_that(is_string(appname))
  assert_that(is_character(platform))
  appdir <- rappdirs::user_data_dir(appname, "binman")
  if(!dir.exists(appdir)){
    stop("App: ", appname, " not found.")
  }
  platforms <- list.dirs(appdir, full.names = FALSE, recursive = FALSE)
  platforms <- if(!identical(platform, "ALL")){
    platind <- platforms %in%platform
    if(!any(platind)){
      stop("No platforms found for ", appname, " in ", platform)
    }
    platforms[platind]
  }else{
    platforms
  }
  res <- lapply(platforms, function(platform){
    list.dirs(file.path(appdir, platform), full.names = FALSE,
              recursive = FALSE)
  })
  setNames(res, platforms)
}
