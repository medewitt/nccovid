
calculate_hit <- function(r, expected, eps = 1e-6){
	hit(r) -expected <= eps
}


test_that("value works", {
  expect_true(calculate_hit(r = 0,0))
})

test_that("value works", {
	expect_true(calculate_hit(r = 1,.5))
})
