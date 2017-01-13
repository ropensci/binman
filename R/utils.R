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

#' Parse semantic version
#'
#' See \code{\link[semver]{parse_version}} for more details.
#'
#' @name parse_version
#' @rdname parse_version
#' @importFrom semver parse_version
#' @keywords internal
#' @export
semver::parse_version

#' Render semantic version
#'
#' See \code{\link[semver]{render_version}} for more details.
#'
#' @name render_version
#' @rdname render_version
#' @importFrom semver render_version
#' @keywords internal
#' @export
semver::render_version

#' Set semantic version
#'
#' See \code{\link[semver]{set_version}} for more details.
#'
#' @name set_version
#' @rdname set_version
#' @importFrom semver set_version
#' @keywords internal
#' @export
semver::set_version

#' Reset semantic version
#'
#' See \code{\link[semver]{reset_version}} for more details.
#'
#' @name reset_version
#' @rdname reset_version
#' @importFrom semver reset_version
#' @keywords internal
#' @export
semver::reset_version

#' Increment semantic version
#'
#' See \code{\link[semver]{increment_version}} for more details.
#'
#' @name increment_version
#' @rdname increment_version
#' @importFrom semver increment_version
#' @keywords internal
#' @export
semver::increment_version
