library(testthat)
library(farsData)

setwd(system.file("extdata", package = "farsData"))

test_that("Correct object type is created by fars_read_years", {
  expect_type(fars_read_years(c(2014, 2015)), "list")
})

test_that("An error is given by fars_read_years for incorrect years", {
  expect_error(fars_read_years(c(202)))
})

test_that("An error is given by fars_summarize_years for incorrect  years", {
  expect_type(fars_summarize_years(2015),"list")
})


test_that("Correct filename is created from year by make_filename", {
  expect_match(sub(".*?/extdata/","",make_filename(2015)), "accident_2015.csv.bz2")
  expect_match(sub(".*?/extdata/","",make_filename(2015)), "accident_2015.csv.bz2")
})
