test_that("Mu stops on character", {
  expect_error(r2R(.01, "a"))
})

test_that("Sd stops on character", {
	expect_error(r2R(.01, 4,"a"))
})

test_that("Sd stops on negative", {
	expect_error(r2R(.01, 4, -4))
})


value_check <- (round(r2R(1),2) - 14.8)< 1e-3
test_that("Returns expected results", {
	
	expect_true(value_check)
})
