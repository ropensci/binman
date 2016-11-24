context("binman_utils")

test_that("canListBinmanApp", {
  appdir <- rappdirs::user_data_dir("superduperapp", "binman")
  on.exit(unlink(appdir, recursive = TRUE))
  platforms <- LETTERS[1:4]
  versions <- LETTERS[5:7]
  mkdirs <- file.path(appdir, outer(platforms, versions, file.path))
  chk <- vapply(mkdirs, dir.create, logical(1), recursive = TRUE)
  expect_true(all(chk))
  res <- list_versions("superduperapp")
  expect_identical(names(res), platforms)
  expect_true(all(vapply(res, identical, logical(1), versions)))
})

test_that("canListPlatformBinmanApp", {
  appdir <- rappdirs::user_data_dir("superduperapp", "binman")
  on.exit(unlink(appdir, recursive = TRUE))
  platforms <- LETTERS[1:4]
  versions <- LETTERS[5:7]
  mkdirs <- file.path(appdir, outer(platforms, versions, file.path))
  chk <- vapply(mkdirs, dir.create, logical(1), recursive = TRUE)
  expect_true(all(chk))
  res <- list_versions("superduperapp", "B")
  expect_identical(names(res), "B")
  expect_true(all(vapply(res, identical, logical(1), versions)))
})
