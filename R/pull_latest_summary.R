#' Retrieve State Summary Metrics
#' 
#' This pulls the most up to date summary data from the state.
#' 
#' @export
#' 
pull_covid_summary <- function(){
	
	dat <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/nc-summary-stats.csv")
	
	dat_death = get_covid_state(reporting_adj = TRUE)[,list(daily_deaths = sum(deaths_daily)), by = "date"]
	
	data.table::setnames(dat, old = "daily_deaths", "daily_deaths_reported")
	
	dat = merge(dat, dat_death, by = "date")
	
	return(dat)
	
}

