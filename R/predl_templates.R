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
#'   package = "binman"
#' )
#' platform <- c("linux64", "win32", "mac64")
#' gsdllist <- predl_google_storage(
#'   url = gsdata, platform, history = 5L,
#'   appname = "binman_chromedriver"
#' )
#' }
#'
predl_google_storage <-
  function(url, platform, history, appname,
           fileregex = "\\.zip$",
           platformregex = platform,
           versionregex = c(paste0("(.*)/.*", fileregex), "\\1")) {
    assert_that(is_URL_file(url))
    assert_that(is_character(platform))
    assert_that(is_integer(history))
    assert_that(is_string(appname))
    assert_that(is_string(fileregex))
    assert_that(is_character(platformregex))
    assert_that(is_character(versionregex))
    ver_data <- jsonlite::fromJSON(url)[["items"]]
    ver_data <- ver_data[order(as.numeric(ver_data[["generation"]])), ]
    is_file <- grepl(fileregex, basename(ver_data[["name"]]))
    is_platform <- lapply(platformregex, function(x) {
      grepl(x, basename(ver_data[["name"]]))
    })
    app_links <- lapply(is_platform, function(x) {
      df <- utils::tail(ver_data[is_file & x, ], history)
      df[["version"]] <- gsub(
        versionregex[1], versionregex[2],
        df[["name"]]
      )
      df[["url"]] <- df[["mediaLink"]]
      df[["file"]] <- vapply(df[["url"]], function(x) {
        basename(xml2::url_unescape(httr::parse_url(x)[["path"]]))
      }, character(1))
      df[, c("version", "url", "file")]
    })
    assign_directory(setNames(app_links, platform), appname)
  }

#' Pre download Github assets
#'
#' Pre download Github assets template function
#'
#' @param url A url giving the github asset JSON for a project. As an
#'     example https://github.com/mozilla/geckodriver/releases the
#'     geckodriver project has an asset JSON available at
#'     https://api.github.com/repos/mozilla/geckodriver/releases
#' @param platform A character vector of platform names
#' @param history The maximum number of files to get for a platform
#' @param appname Name of the app
#' @param platformregex A filter for platforms. Defaults to the platform
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
#' gadata <- system.file("testdata", "test_gitassets.json",
#'   package = "binman"
#' )
#' platform <- c("linux64", "win64", "macos")
#' gadllist <- predl_github_assets(
#'   url = gadata, platform, history = 3L,
#'   appname = "binman_chromedriver"
#' )
#' }
#'
predl_github_assets <-
  function(url, platform, history, appname, platformregex = platform,
           versionregex = c("", "")) {
    assert_that(is_URL_file(url))
    assert_that(is_character(platform))
    assert_that(is_integer(history))
    assert_that(is_string(appname))
    assert_that(is_character(platformregex))
    ghdata <- jsonlite::fromJSON(url)
    version <- ghdata[["tag_name"]]
    version <- gsub(versionregex[1], versionregex[2], version)
    get_args <- function(version, assets) {
      file <- assets[["name"]]
      url <- assets[["browser_download_url"]]
      plat <- match_platform(file, platform, platformregex)
      res <- data.frame(
        file = file, url = url, version = version,
        platform = plat, stringsAsFactors = FALSE
      )
      stats::na.omit(res)
    }
    res <- Map(get_args, version = version, assets = ghdata[["assets"]])
    res <- do.call(rbind.data.frame, c(res, make.row.names = FALSE))
    res <- split(res[, c("version", "url", "file")], f = res[["platform"]])
    res <- lapply(res, utils::head, history)
    assign_directory(res, appname)
  }

#' Pre download bitbucket downloads
#'
#'  Pre download bitbucket downloads template function
#'
#' @param url A url giving the bitbucket download JSON for a project. As
#'     an example https://bitbucket.org/ariya/phantomjs/downloads the
#'     phantomjs project has an asset JSON available at
#'     https://api.bitbucket.org/2.0/repositories/ariya/phantomjs/downloads?pagelen=100
#' @param platform A character vector of platform names
#' @param history The maximum number of files to get for a platform
#' @param appname Name of the app
#' @param platformregex A filter for platforms. Defaults to the platform
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
#' bbdata <- system.file("testdata", "test_bitbucketdl.json",
#'   package = "binman"
#' )
#' platform <- c("linux64", "linux32", "windows", "macosx")
#' platformregex <- c("linux-x86_64", "linux-i686", "windows", "macosx")
#' bbdllist <-
#'   predl_bitbucket_downloads(
#'     url = bbdata, platform, history = 3L,
#'     appname = "binman_chromedriver",
#'     platformregex
#'   )
#' }
#'
predl_bitbucket_downloads <-
  function(url, platform, history, appname,
           platformregex = platform,
           versionregex = "\\d+(?:\\.\\d+)+") {
    assert_that(is_URL_file(url))
    assert_that(is_character(platform))
    assert_that(is_integer(history))
    assert_that(is_string(appname))
    assert_that(is_character(platformregex))
    assert_that(is_character(versionregex))
    bbdata <- jsonlite::fromJSON(url)
    file <- bbdata[["values"]][["name"]]
    url <- bbdata[["values"]][["links"]][["self"]][["href"]]
    vermatch <- regexpr(versionregex, file)
    version <- regmatches(file, vermatch)
    plat <- match_platform(file, platform, platformregex)
    res <- data.frame(
      file = file, url = url, version = version,
      platform = plat, stringsAsFactors = FALSE
    )
    res <- stats::na.omit(res)
    res <- split(res[, c("version", "url", "file")], f = res[["platform"]])
    res <- lapply(res, utils::head, history)
    assign_directory(res, appname)
  }
