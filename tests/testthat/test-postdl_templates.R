context("postdl_templates")

test_that("canNotPostProcess", {
  dlfiles <- data.frame(platform = LETTERS[1:3],
                        file = file.path(LETTERS[1:3],
                                         LETTERS[4:6]),
                        processed = rep(TRUE, 3),
                        stringsAsFactors = FALSE)
  procdlfiles <- noproc_dlfiles(dlfiles)
  expect_identical(procdlfiles[["processed"]], c("A/D", "B/E", "C/F"))
})
