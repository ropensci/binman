context("predl_templates.R")

test_that("canPreDowloadGoogleStorage", {
  gsdata <- system.file("testdata", "test_googstor.json",
                        package="binman")
  platform <- c("linux64", "win32", "mac64")
  gsdllist <- predl_google_storage(url = gsdata, platform, history = 5L,
                                   appname = "binman_chromedriver")
  exout <- structure(c("version", "url", "file", "dir", "exists",
                       "version", "url", "file", "dir", "exists",
                       "version", "url", "file", "dir", "exists"),
                     .Dim = c(5L, 3L),
                     .Dimnames = list(NULL,
                                      c("linux64", "win32", "mac64")))
  expect_identical(vapply(dllist, names, character(5)), exout)
})
