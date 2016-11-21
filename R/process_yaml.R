#' Process a yaml file
#'
#' Process a yaml file. The file defines the pre-download function,
#'     the download function and the post download function.
#'
#' @param ymlfile A file in a YAML format defining the pre-download/
#'     download and post download functions together with their arguments.
#'
#' @return
#' @export
#'
#' @examples

process_yaml <- function(ymlfile){
  ymldata <- yaml::yaml.load_file(ymlfile)
  ymlfuncs <- process_ymldata(ymldata)
  message("BEGIN: PREDOWNLOAD\n")
  dllist <- do.call(ymlfuncs[["predlfunction"]][["function"]],
                    ymlfuncs[["predlfunction"]][["args"]])
  message("BEGIN: DOWNLOAD\n")
  dlfiles <- do.call(ymlfuncs[["dlfunction"]][["function"]],
                     c(list(dllist = dllist),
                       ymlfuncs[["dlfunction"]][["args"]]))
  message("BEGIN: POSTDOWNLOAD\n")
  postproc <- do.call(ymlfuncs[["postdlfunction"]][["function"]],
                      c(list(dlfiles = dlfiles),
                        ymlfuncs[["postdlfunction"]][["args"]]))
}

process_ymldata <- function(ymldata){
  ymlnames <- names(ymldata)
  assert_that(
    contains_required(ymldata, c("name", "predlfunction", "dlfunction",
                                 "postdlfunction"))
  )
  yfuncs <- c("predlfunction", "dlfunction", "postdlfunction")
  ymlfuncs <- list(name = ymldata[["name"]],
                   predlfunction = list(),
                   dlfunction = list(),
                   postdlfunction = list())
  ymlfuncs[yfuncs] <-
    lapply(yfuncs, function(func){
      funclist <- ymlfuncs[[func]]
      funclist[["function"]] <- find_func(names(ymldata[[func]]))
      funclist[["args"]] <- ymldata[[func]][[1]]
      funclist
    })
  invisible(ymlfuncs)
}

find_func <- function(x){
  funcdetail <- strsplit(x, "::")[[1]]
  getExportedValue(funcdetail[1], funcdetail[2])
}
