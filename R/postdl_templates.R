#' Unzip downloaded files
#'
#' Unzip downloaded files. Keeps the original zip file
#'
#' @param dlfiles A data.frame of files by platform and indicating
#'     whether they were process
#'
#' @return Returns a list of character vectors indicating files
#'     processed
#' @export
#'
#' @examples
#' \dontrun{
#' ymlfile <- system.file("exdata", "sampleapp.yml", package="binman")
#' trdata <- system.file("testdata", "test_dlres.Rdata", package="binman")
#' load(trdata)
#' testthat::with_mock(
#'   `httr::GET` = function(...){
#'     test_llres
#'   },
#'   `base::dir.create` = function(...){TRUE},
#'   `utils::unzip` = function(zipfile, ...){zipfile},
#'   procyml <- process_yaml(ymlfile)
#' )
#' procyml
#' }

unzip_dlfiles <- function(dlfiles){
  assert_that(is_data.frame(dlfiles))
  if(nrow(dlfiles) == 0L){
    return()
  }
  unzip_file <- function(platform, file, processed){
    if(!processed){return()}
    exdir <- dirname(file)
    unzip(file, exdir = exdir)
  }
  Map(unzip_file,
      platform = dlfiles[["platform"]],
      file = dlfiles[["file"]],
      processed = dlfiles[["processed"]])
}
