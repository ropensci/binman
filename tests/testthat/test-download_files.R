context("download_files")

test_that("canDownloadFiles", {
  trdata <- system.file("testdata", "test_dlres.Rdata", package="binman")
  tldata <- system.file("testdata", "test_dllist.Rdata", package="binman")
  load(trdata)
  load(tldata)
  dllist <- assign_directory(test_dllist, "myapp")
  
  dlfiles <- download_files(dllist)
  expect_true(all(dlfiles[["processed"]]))
})

test_that("canReturnEmptyDFWhenEmptyDownloadFiles", {
  trdata <- system.file("testdata", "test_dlres.Rdata", package="binman")
  tldata <- system.file("testdata", "test_dllist.Rdata", package="binman")
  load(trdata)
  load(tldata)
  dllist <- assign_directory(test_dllist, "myapp")
  dllist <- lapply(dllist, function(x){x[["exists"]] <- TRUE; x})
  
  dlfiles <- download_files(dllist)
  exout <- data.frame(platform = character(), file = character(),
                      processed = logical(), stringsAsFactors = FALSE)
  expect_identical(dlfiles, exout)
})
