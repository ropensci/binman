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

#' @name parse_version
#' @rdname parse_version
#' @importFrom semver parse_version
#' @keywords internal
#' @export
semver::parse_version

#' @name render_version
#' @rdname render_version
#' @importFrom semver render_version
#' @keywords internal
#' @export
semver::render_version

#' @name set_version
#' @rdname set_version
#' @importFrom semver set_version
#' @keywords internal
#' @export
semver::set_version

#' @name reset_version
#' @rdname reset_version
#' @importFrom semver reset_version
#' @keywords internal
#' @export
semver::reset_version

#' @name increment_version
#' @rdname increment_version
#' @importFrom semver increment_version
#' @keywords internal
#' @export
semver::increment_version

#' Create a connection to a url and read from JSON to an R object
#' 
#' A wrapper for jsonlite::fromJSON that will create a curl handle to 
#' which you can pass additional curl options
#' @rdname fromJSON_url
#' @importFrom jsonlite fromJSON
#' @importFrom curl new_handle handle_setheaders
#' @param url string for URL
#' @param .curl_options A named list of options - defaults httr config settings
#' @keywords internal
#' @export
fromJSON_url <- function(url, .curl_options = getOption("httr_config",list(options = list()))[['options']]){
  
  if(is_file(url)) {
    return(jsonlite::fromJSON(url))
  }
  
  h <- curl::new_handle(useragent = paste("jsonlite /", 
                                          R.version.string),
                        .list = .curl_options)
  curl::handle_setheaders(h, Accept = "application/json, text/*, */*")
  
  urlConnection <- curl::curl(url = url, handle = h)
  #on.exit(close.connection(urlConnection))
  jsonlite::fromJSON(urlConnection)
}



