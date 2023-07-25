test_that("canNotPostProcess", {
  dlfiles <- data.frame(
    platform = LETTERS[1:3],
    file = file.path(
      LETTERS[1:3],
      LETTERS[4:6]
    ),
    processed = rep(TRUE, 3),
    stringsAsFactors = FALSE
  )
  procdlfiles <- noproc_dlfiles(dlfiles)
  expect_identical(procdlfiles[["processed"]], c("A/D", "B/E", "C/F"))
})

test_that("canUnzipFile", {
  zipf <- system.file("exdata", "samplefiles.zip", package = "binman")
  ziptemp <- tempfile(fileext = ".zip")
  on.exit(unlink(ziptemp))
  file.copy(zipf, ziptemp)
  dlfiles <- data.frame(
    platform = LETTERS[1],
    file = ziptemp,
    processed = TRUE,
    stringsAsFactors = FALSE
  )
  procdlfiles <- unziptar_dlfiles(dlfiles, chmod = TRUE)
  zfiles <- utils::unzip(ziptemp, list = TRUE)
  zout <- file.path(dirname(ziptemp), basename(zfiles[["Name"]]))
  fmode <- file.mode(zout)
  expect_true(all(file.exists(zout)))
  if (binman:::get_os() != "win") {
    expect_identical(fmode, structure(c(493L, 493L), class = "octmode"))
  }
  unlink(zout)
})

test_that("canUntarFile", {
  gzipf <- system.file("exdata", "samplefiles.tar.gz", package = "binman")
  gziptemp <- tempfile(fileext = ".tar.gz")
  on.exit(unlink(gziptemp))
  file.copy(gzipf, gziptemp)
  dlfiles <- data.frame(
    platform = LETTERS[1],
    file = gziptemp,
    processed = TRUE,
    stringsAsFactors = FALSE
  )
  procdlfiles <- unziptar_dlfiles(dlfiles, chmod = TRUE)
  gzfiles <- utils::untar(gziptemp, list = TRUE)
  gzout <- file.path(dirname(gziptemp), basename(gzfiles))
  fmode <- file.mode(gzout)
  expect_true(all(file.exists(gzout)))
  if (binman:::get_os() != "win") {
    expect_identical(fmode, structure(c(493L, 493L), class = "octmode"))
  }
  unlink(gzout)
})
