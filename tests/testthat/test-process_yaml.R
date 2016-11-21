context("process_yaml")

test_that("canProcessYaml", {
  ymlfile <- system.file("exdata", "sampleapp.yml", package="binman")
  trdata <- system.file("testdata", "test_dlres.Rdata", package="binman")
  load(trdata)
  with_mock(
    `httr::GET` = function(...){
      test_llres
    },
    `base::dir.create` = function(...){TRUE},
    `utils::unzip` = function(zipfile, ...){zipfile},
    procyml <- process_yaml(ymlfile)
  )
  expect_true(all(vapply(procyml, is.character, logical(1))))
})
