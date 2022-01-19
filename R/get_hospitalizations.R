#' Get Reported Hospitalisation Data
#' 
#' Retrieve Latest Hospitalisation data from NC DHHS. This is not an automatic
#' Scrap so there could be some delay.
#' @export
get_hospitalizations <- function(){
	dat <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/hospitalisations.csv")
	
	dat<- clean_names(dat)
	
	#dat$date <- as.Date(dat$date, "%m/%d/%Y")
	
	last_date <- max(dat$date)
	message(sprintf("Data valid as of: %s\nUse with caution.", as.character(last_date)))
	dat
}
