#' Retrieve State Summary Metrics
#' 
#' This pulls the most up to date summary data from the state.
#' 
#' @export
#' 
pull_covid_summary <- function(){
	
	dat <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/nc-summary-stats.csv")
	
	return(dat)
	
}