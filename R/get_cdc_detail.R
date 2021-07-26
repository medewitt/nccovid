#' Retrieve CDC COVID-19 Spread by County
#' 
#' Utilizes the CDC's COVID-19 Tracker to General Information About the Spread
#' of Disease.
#' 
#' @return a data.table with details regarding disease spread by county
#' @source <https://covid.cdc.gov/covid-data-tracker/#datatracker-home>
#' @export

get_cdc_detail <- function(){
	dat <- data.table::fread("https://raw.githubusercontent.com/medewitt/covidcdc/main/output/nc-county-detail.csv")
	
	dat = dat[,data.table::last(.SD), by = c("County", "report_date")]
	
	return(dat)
	
}