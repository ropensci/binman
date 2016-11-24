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
#' appdir <- app_dir("superduperapp", FALSE)
#' platforms <- LETTERS[1:4]
#' versions <- LETTERS[5:7]
#' mkdirs <- file.path(appdir, outer(platforms, versions, file.path))
#' chk <- vapply(mkdirs, dir.create, logical(1), recursive = TRUE)
#' expect_true(all(chk))
#' res <- list_versions("superduperapp")
#' unlink(appdir, recursive = TRUE)
#' }

list_versions <- function(appname, platform = c("ALL")){
  assert_that(is_string(appname))
  assert_that(is_character(platform))
  appdir <- app_dir(appname)
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

rm_version <- function(appname, platform, version = c("ALL")){
  assert_that(is_string(appname))
  assert_that(is_character(platform))
  appdir <- rappdirs::user_data_dir(appname, "binman")
}

#' Get application directory
#'
#' Get application directory
#'
#' @param appname A character string giving the name of the application
#' @param check check whether the app given by appname exists or not.
#'
#' @return A character string giving the path of the directory
#' @export
#'
#' @examples
#' \dontrun{
#' appdir <- app_dir("superduperapp", FALSE)
#' }

app_dir <- function(appname, check = TRUE){
  assert_that(is_string(appname))
  assert_that(is_logical(check))
  appdir <- rappdirs::user_data_dir(appname, "binman")
  if(check){assert_that(app_dir_exists(appdir))}
  invisible(appdir)
}
