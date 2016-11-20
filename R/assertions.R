is_string <- function(x) {
  is.character(x) && length(x) == 1 && !is.na(x)
}

assertthat::on_failure(is_string) <-  function(call, env) {
  paste0(deparse(call$x), " is not a string")
}

is_list <- function(x){
  is.list(x)
}

assertthat::on_failure(is_list) <- function(call, env){
  paste0(deparse(call$x), " is not a list")
}

is_list_of_df <- function(x){
  is.list(x) && all(vapply(test_dllist, is.data.frame, logical(1)))
}

assertthat::on_failure(is_list_of_df) <- function(call, env){
  paste0(deparse(call$x), " is not a list of data.frames")
}
