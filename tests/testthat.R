library(testthat)
library(binman)

if (identical(tolower(Sys.getenv("NOT_CRAN")), "true")) {
  test_check("binman")
}
