context("download_files")

test_that("canDownloadFiles", {
  trdata <- system.file("testdata", "test_dlres.Rdata", package="binman")
  tldata <- system.file("testdata", "test_dllist.Rdata", package="binman")
  load(trdata)
  load(tldata)
  dllist <- assign_directory(test_dllist, "myapp")
  with_mock(
    `httr::GET` = function(...){
      test_llres
    },
    `base::dir.create` = function(...){TRUE},
    dlfiles <- download_files(dllist)
  )
  test_res <- function(x)any(vapply(x, class, character(1)) != "response")
  expect_false(any(vapply(dlfiles, test_res, logical(1))))
})
