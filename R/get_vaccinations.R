#' Pull Vaccination Rates by County
#' 
#' Pulled from <conedatascience/covid-data>
#' 
#' @param county_list a string, the county to pull. default is all counties
#' @param add_population a boolean, default of TRUE to add a population
#' @examples {
#' 
#' get_vaccinations(county_list = "Guilford")
#' 
#' }
#' @export

get_vaccinations <- function(county_list = NULL, add_population = TRUE){
	dat <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/nc-vaccinations.csv")

	dat$date <- as.Date(dat$date)
	
	if(!is.null(county_list)){
		dat <- dat[county %in% county_list]
	}
	
	if(add_population){
		dat <- merge(dat, setNames(nccovid::nc_population[,1:2], c("county", "population")),
								 by = "county", all.x = TRUE)
	}
	
	return(dat)
}

