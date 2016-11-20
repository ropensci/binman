context("test-assign_directory")

test_that("canAssignDirectory", {
  tdata <- system.file("testdata", "test_dllist.Rdata", package="binman")
  load(tdata)
  expect_silent(assign_directory(test_dllist, "myapp"))
})
