#' Pull Testing Information at County Level
#' 
#' Pulling information on tests and percent positive at the 
#' county level
#' 
#' @param county a string, the county of counties of interest
#' @export

get_county_tests <- function(county_select = NULL){
	
	url <- "https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/testing-by-county.csv"
	
	dat <- data.table::fread(url)
	
	dat$date <- as.Date(dat$date)
	
	if(!is.null(county_select)){
		dat <- dat[county %in% county_select]
	}
	
	dat
	
}
