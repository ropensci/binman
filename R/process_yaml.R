#' Process a yaml file
#'
#' Process a yaml file. The file defines the pre-download function,
#'     the download function and the post download function.
#'
#' @param ymlfile A file in a YAML format defining the pre-download/
#'     download and post download functions together with their arguments.
#' @param verbose If TRUE, include status messages (if any)
#'
#' @return A list of files processed (downloaded and post processed)
#' @export
#'
#' @examples
#' \dontrun{
#' ymlfile <- system.file("exdata", "sampleapp.yml", package = "binman")
#' trdata <- system.file("testdata", "test_dlres.Rdata", package = "binman")
#' load(trdata)
#' testthat::with_mock(
#'   `httr::GET` = function(...) {
#'     test_llres
#'   },
#'   `base::dir.create` = function(...) {
#'     TRUE
#'   },
#'   `utils::unzip` = function(zipfile, ...) {
#'     zipfile
#'   },
#'   procyml <- process_yaml(ymlfile)
#' )
#' procyml
#' }
#'
process_yaml <- function(ymlfile, verbose = TRUE) {
  assert_that(is_logical(verbose))
  ymldata <- yaml::yaml.load_file(ymlfile)
  ymlfuncs <- process_ymldata(ymldata)
  fn <- c(suppressMessages, `(`)[[verbose + 1L]]
  fn({
    message("BEGIN: PREDOWNLOAD")
    dllist <- do.call(
      ymlfuncs[[c("predlfunction", "function")]],
      ymlfuncs[[c("predlfunction", "args")]]
    )
    message("BEGIN: DOWNLOAD")
    dlfiles <- do.call(
      ymlfuncs[[c("dlfunction", "function")]],
      c(
        list(dllist = dllist),
        ymlfuncs[[c("dlfunction", "args")]]
      )
    )
    message("BEGIN: POSTDOWNLOAD")
    postproc <- do.call(
      ymlfuncs[[c("postdlfunction", "function")]],
      c(
        list(dlfiles = dlfiles),
        ymlfuncs[[c("postdlfunction", "args")]]
      )
    )
  })
}

process_ymldata <- function(ymldata) {
  ymlnames <- names(ymldata)
  assert_that(
    contains_required(ymldata, c(
      "name", "predlfunction", "dlfunction",
      "postdlfunction"
    ))
  )
  yfuncs <- c("predlfunction", "dlfunction", "postdlfunction")
  ymlfuncs <- list(
    name = ymldata[["name"]],
    predlfunction = list(),
    dlfunction = list(),
    postdlfunction = list()
  )
  ymlfuncs[yfuncs] <-
    lapply(yfuncs, function(func) {
      funclist <- ymlfuncs[[func]]
      funclist[["function"]] <- find_func(names(ymldata[[func]]))
      funclist[["args"]] <- ymldata[[func]][[1]]
      funclist
    })
  invisible(ymlfuncs)
}

find_func <- function(x) {
  funcdetail <- strsplit(x, "::")[[1]]
  getExportedValue(funcdetail[1], funcdetail[2])
}
