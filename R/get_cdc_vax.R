#' Retrieve CDC Vaccination Rates by County
#' 
#' Utilizes the CDC's COVID-19 Tracker to Retrieve Vaccination Rates
#' 
#' @return a data.table with vaccination information by county by day
#' @source <https://covid.cdc.gov/covid-data-tracker/#datatracker-home>
#' @export

get_cdc_vax <- function(){
	dat <- data.table::fread("https://raw.githubusercontent.com/medewitt/covidcdc/main/output/nc-county-vax.csv")
	
	dat = dat[,data.table::last(.SD), by = c("County", "Date")]
	
	return(dat)
	
}