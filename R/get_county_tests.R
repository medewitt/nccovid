#' Pull Testing Information at County Level
#' 
#' Pulling information on tests and percent positive at the 
#' county level. Notes that these data are updated manually.
#' 
#' @param county_select a string, the county of counties of interest
#' @export

get_county_tests <- function(county_select = NULL){
	
	url <- "https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/testing-by-county.csv"
	
	dat <- data.table::fread(url)
	
	dat$date <- as.Date(dat$date)
	
	if(!is.null(county_select)){
		dat <- dat[county %in% county_select]
	}
	
	message("Data updated as of: ", max(dat$date))
	dat
	
}
