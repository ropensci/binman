test_that("canPreDowloadGoogleStorage", {
  gsdata <- system.file("testdata", "test_googstor.json",
    package = "binman"
  )
  platform <- c("linux64", "win32", "mac64")
  gsdllist <- predl_google_storage(
    url = gsdata, platform, history = 5L,
    appname = "binman_chromedriver"
  )
  exout <- structure(c(
    "version", "url", "file", "dir", "exists",
    "version", "url", "file", "dir", "exists",
    "version", "url", "file", "dir", "exists"
  ),
  .Dim = c(5L, 3L),
  .Dimnames = list(
    NULL,
    c("linux64", "win32", "mac64")
  )
  )
  expect_identical(vapply(gsdllist, names, character(5)), exout)
})

test_that("canPreDowloadGithubAssets", {
  gadata <- system.file("testdata", "test_gitassets.json",
    package = "binman"
  )
  platform <- c("linux64", "win64", "macos")
  gadllist <- predl_github_assets(
    url = gadata, platform, history = 3L,
    appname = "binman_chromedriver"
  )
  exout <- structure(c(
    "version", "url", "file", "dir", "exists",
    "version", "url", "file", "dir", "exists",
    "version", "url", "file", "dir", "exists"
  ),
  .Dim = c(5L, 3L),
  .Dimnames = list(
    NULL,
    c("linux64", "macos", "win64")
  )
  )
  expect_identical(vapply(gadllist, names, character(5)), exout)
})

test_that("canPreDownloadBitBucketDownloads", {
  bbdata <- system.file("testdata", "test_bitbucketdl.json",
    package = "binman"
  )
  platform <- c("linux64", "windows", "macosx")
  platformregex <- c("linux-x86_64", "windows", "macosx")
  bbdllist <-
    predl_bitbucket_downloads(
      url = bbdata, platform, history = 3L,
      appname = "binman_chromedriver",
      platformregex
    )
  exout <- structure(c(
    "version", "url", "file", "dir", "exists",
    "version", "url", "file", "dir", "exists",
    "version", "url", "file", "dir", "exists"
  ),
  .Dim = c(5L, 3L),
  .Dimnames = list(NULL, c(
    "linux64", "macosx",
    "windows"
  ))
  )
  expect_identical(vapply(bbdllist, names, character(5)), exout)
})
