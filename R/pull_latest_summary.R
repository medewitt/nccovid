#' Retrieve State Summary Metrics
#' 
#' This pulls the most up to date summary data from the state.
#' 
#' @return a data.table with information for North Carolina
#' 
#' @export
#' 
pull_covid_summary <- function(){
	
	dat <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/nc-summary-stats.csv")
	names(dat) <- c("cases_reported", "cases_antigen", "n_antigen_tests", "n_tests","pct_pos", "deaths_by_date", "cases_pcr", "date", "n_pcr_test")
	dat_death = nccovid::get_covid_state(reporting_adj = TRUE)[,list(daily_deaths = sum(deaths_daily)), by = "date"]
	
	dat = merge(dat, dat_death, by = "date")
	
	return(dat)
	
}

