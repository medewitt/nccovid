replace_names <- c("cases_reported", "cases_antigen", "n_antigen_tests",
									 "positive_tests", "n_tests", "deaths_by_date",
									 "cases_pcr", "date", "n_pcr_tests")

test_pull_latest_summary <- function(){
	dat <- pull_covid_summary()
	
	all(replace_names%in%names(dat))
}

test_date <- function(){
	dat <- pull_covid_summary()
	
	"Date" %in% class(dat$date)
}

test_that("all columns available", {
  expect_true(test_pull_latest_summary())
})

test_that("date column appropriately assigned", {
	
	expect_true(test_date())
})