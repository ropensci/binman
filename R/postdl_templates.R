#' Unzip/Untar downloaded files
#'
#' Unzip/Untar downloaded files. Keeps the original zip file
#'
#' @param dlfiles A data.frame of files by platform and indicating
#'     whether they were processed
#' @param chmod change the mode of the unarchived file/files to "700" so
#'     they are executable on unix like systems.
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

unziptar_dlfiles <- function(dlfiles, chmod = FALSE){
  assert_that(is_data.frame(dlfiles))
  assert_that(is_logical(chmod))
  if(nrow(dlfiles) == 0L){
    return()
  }
  unzip_file <- function(platform, file, processed, chmod){
    if(!processed){return()}
    exdir <- dirname(file)
    utils::unzip(file, exdir = exdir)
    if(chmod){
      if(get_os() == "win"){return}
      zfiles <- utils::unzip(file, exdir = exdir, list = TRUE)
      Sys.chmod(file.path(exdir, basename(zfiles[["Name"]])), "700")
    }
  }
  untar_file <- function(platform, file, processed, chmod){
    if(!processed){return()}
    exdir <- dirname(file)
    utils::untar(file, exdir = exdir)
    if(chmod){
      if(get_os() == "win"){return}
      gzfiles <- utils::untar(file, exdir = exdir, list = TRUE)
      Sys.chmod(file.path(exdir, basename(gzfiles)), "700")
    }
  }
  unarchive <- function(platform, file, processed, chmod){
    is_zip <- grepl("\\.zip$", file, ignore.case = TRUE)
    is_tar <- grepl(".*\\.(tgz$)|(tar\\.gz$)", file, ignore.case = TRUE)
    if(!any(c(is_zip, is_tar))){
      stop(file, " does not appear to be a zip or tar file.\n")
    }
    func <- switch(c("zip", "tar")[c(is_zip, is_tar)],
                   zip = unzip_file,
                   tar = untar_file)
    func(platform, file, processed, chmod)
  }
  Map(unarchive,
      platform = dlfiles[["platform"]],
      file = dlfiles[["file"]],
      processed = dlfiles[["processed"]],
      chmod = chmod)
  list(processed = dlfiles[dlfiles[["processed"]], "file"])
}

#' Dont post process
#'
#' Dont post process dlfiles
#'
#' @param dlfiles A data.frame of files by platform and indicating
#'     whether they were processed
#'
#' @return Returns a list of character vectors indicating files
#'     processed
#' @export
#'
#' @examples
#' \dontrun{
#' ymlfile <- system.file("exdata", "sampleapp4.yml", package="binman")
#' trdata <- system.file("testdata", "test_dlres.Rdata", package="binman")
#' load(trdata)
#' testthat::with_mock(
#'   `httr::GET` = function(...){
#'     test_llres
#'   },
#'   `base::dir.create` = function(...){TRUE},
#'   procyml <- process_yaml(ymlfile)
#' )
#' procyml
#' }

noproc_dlfiles <- function(dlfiles){
  assert_that(is_data.frame(dlfiles))
  list(processed = dlfiles[dlfiles[["processed"]], "file"])
}
