library(testthat)
library(outreg)

context("siginificance stars")

test_that("stars", {
  pv <- c(0.11, 0.06, 0.03, 0.009)
  alpha <- c(0.1, 0.05, 0.01)
  expect_equal(get_star(pv, alpha), c('', '*', '**', '***'))
})



