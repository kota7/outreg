library(outreg)
library(testthat)
library(magrittr)

context('name conflict')
test_that('duplicate model names', {
  y <- c(0,1,2,3)
  x <- c(3,2,5,6)
  z <- c(5,2,3,1)
  fitlist <- list(model = lm(y ~ x), model = lm(y ~ x + z))
  o <- outreg(fitlist)
  expect_equal(names(o)[-c(1,2)], names(fitlist))
})


test_that('bad model names', {
  y <- c(0,1,2,3)
  x <- c(3,2,5,6)
  z <- c(5,2,3,1)
  fitlist <- list(statname = lm(y ~ 1),
                  model = lm(y ~ x),
                  variable = lm(y ~ x + z))
  o <- outreg(fitlist)
  expect_equal(names(o)[-c(1,2)], names(fitlist))
})


context('validity of fitlist input')

test_that('invalid cases', {
  expect_error(outreg(1))

  expect_error(outreg(list(1, 2, 3)))

  # single fit is okay
  y <- c(0,1,2,3)
  x <- c(3,2,5,6)
  fit <- lm(y ~ x)
  expect_true(is.data.frame(outreg(fit)))

  # each element of fitlist must be supported
  expect_error(outreg(list(fit, 'a', 'b')))
})


test_that('supported objects', {

  # lm
  y <- c(0,1,2,3)
  x <- c(3,2,5,6)
  fit <- lm(y ~ x)
  expect_true(is.data.frame(outreg(fit)))

  # glm
  y <- c(1, 1, 0, 0)
  x <- c(3, 2, 2, 1)
  fit <- glm(y ~ x, family = binomial())
  expect_true(is.data.frame(outreg(fit)))

  # survreg
  library(survival)
  y <- c(1, 4, 5, 2)
  s <- c(0, 0, 1, 1)
  x <- c(2, 3, 1, 3)
  fit <- survreg(Surv(y, s) ~ x)
  expect_true(is.data.frame(outreg(fit)))

  # ivreg
  library(AER)
  y <- c(1, 4, 5, 2)
  x <- c(2, 2, 1, 5)
  z <- c(3, 1, 4, 5)
  fit <- ivreg(y ~ x | z)
  expect_true(is.data.frame(outreg(fit)))

})




context('displayed stats')

test_that('include pv and tv, remove se', {
  y <- c(0,1,2,3)
  x <- c(3,2,5,6)
  fit <- lm(y ~ x)
  o <- outreg(fit, pv = TRUE, tv = TRUE, se = FALSE)

  included <- get_display_names(c('pv', 'tv'))
  removed  <- get_display_names(c('se'))
  expect_true(all(included %in% o[['.stat']]))
  expect_true(all(!(removed %in% o[['.stat']])))
})


test_that('two way to specify stats', {
  y <- c(0,1,2,3)
  x <- c(3,2,5,6)
  fit <- lm(y ~ x)
  expect_identical(
    outreg(fit, pv = TRUE, se = FALSE),
    outreg(fit, displayed = list(pv = TRUE, se = FALSE))
  )
})


test_that('suppress model stats', {
  y <- c(0,1,2,3)
  x <- c(3,2,5,6)
  fit <- lm(y ~ x)
  o <- outreg(fit, nobs = FALSE)
  disp_name <- get_display_names('nobs')
  expect_true(!(disp_name %in% o$.stat))
})


test_that('priority in display specification', {
  y <- c(0,1,2,3)
  x <- c(3,2,5,6)
  fit <- lm(y ~ x)
  expect_identical(
    outreg(fit, pv = TRUE),
    outreg(fit, pv = TRUE, displayed = list(pv = FALSE))
  )
})



context('const at bottom')

test_that('const bottom or not', {
  y <- c(0,1,2,3)
  x <- c(3,2,5,6)
  fit <- lm(y ~ x)
  o1 <- outreg(fit, constbot = TRUE)
  o2 <- outreg(fit, constbot = FALSE)
  expect_true(setequal(o1$.variable, o2$.variable))
  expect_equal(unique(o1$.variable)[1], 'x')
  expect_equal(unique(o2$.variable)[1], '(Intercept)')
  expect_equal(setdiff(unique(o1$.variable), '')[2], '(Intercept)')
  expect_equal(setdiff(unique(o2$.variable), '')[2], 'x')
})



