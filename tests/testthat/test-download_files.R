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
  test_res <- function(x)vapply(x, all, logical(1))
  expect_true(all(test_res(dlfiles)))
})
