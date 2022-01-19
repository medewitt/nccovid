run_regression <- function(){
	dat <- nccovid::get_county_covid_demographics(region = c(nccovid::cone_region, "Forsyth"))
	
	# dat = dat[,.(cases = sum(cases),
	#        deaths = sum(deaths)), by =c("week_of", "metric")]
	
	dat = dat[order(week_of)]
	
	dat %>%
		.[!metric %in% c("Missing", "Suppressed")] %>%
		.[,l_cases:=log(cases)] %>%
		.[,t:=.I] %>%
		dplyr::group_by(county, metric) %>%
		tidyr::nest() %>%
		dplyr::mutate(model = purrr::map(data,
																		 ~broom::tidy(glm(l_cases ~ t, data = tail(.x,6),
																		 								 family = quasipoisson())))) %>%
		tidyr::unnest(model) %>%
		dplyr::filter(term == "t")
}

out <- run_regression()

test_that("Verify calculations can be performed", {
  expect_equal(ncol(out), 8L)
})
