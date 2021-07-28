test_that("Stops on bad values (County)", {
  expect_error(get_covid_county_plus(county = 1))
})

test_that("Stops on bad values (Adjustment)", {
	expect_error(get_covid_county_plus(adjust = 1))
})


test_that("Stops on bad values", {
	expect_error(get_covid_county_plus(adjust = 1))
})
