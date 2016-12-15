context("sem_ver")

testPV <- test_sem_ver()

test_that("canParseSemanticVersions", {
  res <- sem_ver(testPV)
  expect_s3_class(res, "svlist")
  expect_s3_class(res[[1]], "semver")
})

test_that("canUseOpsSemver", {
  res <- sem_ver(testPV)
  expect_true(res[[1]] < res[[2]])
  expect_true(res[[1]] <= res[[2]])
  expect_false(res[[1]] > res[[2]])
  expect_false(res[[1]] >= res[[2]])
  expect_false(res[[1]] == res[[2]])
  expect_true(res[[1]] != res[[2]])
})

test_that("canUseOpsSvlist", {
  res <- sem_ver(testPV)
  expect_true(res[1] < res[2])
  expect_true(res[1] <= res[2])
  expect_false(res[1] > res[2])
  expect_false(res[1] >= res[2])
  expect_false(res[1] == res[2])
  expect_true(res[1] != res[2])
  expect_error(res[1] > res[1:2],
               "> not defined for \"svlist\" objects of unequal length")
})

test_that("canSortSvlist", {
  res <- sem_ver(testPV)
  sorted <- sort(res)
  sorted2 <- res[order(res)]
  expect_true(all(sorted == sorted2))
})


test_that("canGetSvlistSummary", {
  res <- sem_ver(testPV)
  expect_identical(as.character(max(res)), "10.20.30")
  expect_identical(as.character(min(res)), "0.0.4")
  expect_identical(as.character(range(res)), c("0.0.4", "10.20.30"))
})

test_that("canPrintSV", {
  res <- sem_ver(testPV)
  expect_output(print(res))
  expect_output(print(res[[1]]))
})

test_that("canCompareChracter", {
  expect_true(res[[2]] == "1.0.0")
  expect_true("1.0.0" == res[[2]])
})

test_that("canThrowSvError", {
  expect_error(!res[[1]], "unary ! not defined for \"semver\" objects")
  expect_error(!res[1], "unary ! not defined for \"svlist\" objects")
  expect_error(sem_ver("1.1"), "does not parse under semantic")
})
