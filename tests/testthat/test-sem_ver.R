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
