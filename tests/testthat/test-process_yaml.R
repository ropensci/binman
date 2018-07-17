context("process_yaml")

test_that("canProcessYaml", {
  ymlfile <- system.file("exdata", "sampleapp.yml", package="binman")
  trdata <- system.file("testdata", "test_dlres.Rdata", package="binman")
  load(trdata)
  
  procyml <- process_yaml(ymlfile)
  expect_true(all(vapply(procyml, is.character, logical(1))))
})
