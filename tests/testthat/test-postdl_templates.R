context("postdl_templates")

test_that("canNotPostProcess", {
  ymlfile <- system.file("exdata", "sampleapp4.yml", package="binman")
  trdata <- system.file("testdata", "test_dlres.Rdata", package="binman")
  load(trdata)
  testthat::with_mock(
    `httr::GET` = function(...){
      test_llres
    },
    `base::dir.create` = function(...){TRUE},
    procyml <- process_yaml(ymlfile)
  )
  expect_identical(procyml[["processed"]], character(0))
})
