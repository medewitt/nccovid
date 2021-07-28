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
	
	search_names <- c("Cases by Report Date", "Antigen Positive Cases by Specimen Date", 
										"Antigen Test", "Positive Test Percentage", "Daily Tests Total", 
										"Deaths by Date of Death", "Molecular (PCR) Positive Cases by Specimen Date", 
										"Date", "Molecular Test")
	
	replace_names <- c("cases_reported", "cases_antigen", "n_antigen_tests",
										 "positive_tests", "n_tests", "deaths_by_date",
										 "cases_pcr", "date", "n_pcr_tests")
	
	for(i in seq_along(dat)){
		colnames(dat)[i] <- replace_names[which(colnames(dat)[i]==search_names)]
	}
	
	dat_death = nccovid::get_covid_state(reporting_adj = TRUE)[,list(daily_deaths = sum(deaths_daily)), by = "date"]
	
	dat = merge(dat, dat_death, by = "date")
	
	return(dat)
	
}

