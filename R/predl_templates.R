#' Pre-Download Google Storage
#'
#' Pre-Download Google Storage template function
#'
#' @param url A url giving the JSON bucket listings for a project. For
#'     example: http://chromedriver.storage.googleapis.com/index.html
#'     lists the chromedriver files but
#'     https://www.googleapis.com/storage/v1/b/chromedriver/o/ is the
#'     JSON listings for the project.
#' @param platform A character vector of platform names
#' @param history The maximum number of files to get for a platform
#' @param appname Name of the app
#' @param fileregex A filter for files
#' @param platformregex A filter for platforms. Defaults to the platform
#'     names.
#' @param versionregex A regex for retrieving the version.
#'
#' @return A named list of data.frames. The name indicates the
#'     platform. The data.frame should contain the version, url and file
#'     to be processed. Used as input for \code{\link{download_files}} or
#'     an equivalent.
#' @export
#'
#' @examples
#' \dontrun{
#' gsdata <- system.file("testdata", "test_googstor.json",
#'                       package="binman")
#' platform <- c("linux64", "win32", "mac64")
#' gsdllist <- predl_google_storage(url = gsdata, platform, history = 5L,
#'                                  appname = "binman_chromedriver")
#' }

predl_google_storage <-
  function(url, platform, history, appname,
           fileregex = "\\.zip$",
           platformregex = platform,
           versionregex = paste0("(.*)/.*", fileregex)){
    ver_data <- jsonlite::fromJSON(url)[["items"]]
    ver_data <- ver_data[ order(as.numeric(ver_data[["generation"]])), ]
    is_file <- grepl(fileregex, basename(ver_data[["name"]]))
    is_platform <- lapply(platformregex, function(x){
      grepl(x, basename(ver_data[["name"]]))
    })
    app_links <- lapply(is_platform, function(x){
      df <- tail(ver_data[is_file & x, ], history)
      df[["version"]] <- gsub("(.*)/chromedriver.*", "\\1", df[["name"]])
      df[["url"]] <- df[["mediaLink"]]
      df[["file"]] <- vapply(df[["url"]], function(x){
        basename(xml2::url_unescape(httr::parse_url(x)[["path"]]))
      }, character(1))
      df[, c("version", "url", "file")]
    })
    assign_directory(setNames(app_links, platform), appname)
  }
