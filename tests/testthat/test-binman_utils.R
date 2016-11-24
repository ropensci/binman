context("binman_utils")

test_that("canListBinmanApp", {
  appdir <- app_dir("superduperapp", FALSE)
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
  appdir <- app_dir("superduperapp", FALSE)
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

test_that("canCheckBinmanAppDir", {
  expect_error(appdir <- app_dir("superduperapp"),
               "superduperapp app directory not found")
})

test_that("canRemoveBinmanAppVersion", {
  appname <- "superduperapp"
  appdir <- app_dir(appname, FALSE)
  on.exit(unlink(appdir, recursive = TRUE))
  platforms <- LETTERS[1:4]
  versions <- LETTERS[5:7]
  mkdirs <- file.path(appdir, outer(platforms, versions, file.path))
  chk <- vapply(mkdirs, dir.create, logical(1), recursive = TRUE)
  expect_true(all(chk))
  appver <- list_versions(appname)
  chk <- rm_version(appname, platforms[2], versions[1:2])
  expect_true(all(chk))
  appver <- list_versions(appname)
  expect_identical(appver[[platforms[2]]], versions[3])
})