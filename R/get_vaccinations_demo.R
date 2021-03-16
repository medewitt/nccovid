#' Pull Vaccinations by County and Demographic
#' 
#' Pulled from <conedatascience/covid-data>. The column vax_n returns
#' vaccination counts. Population references are available for the user to 
#' calculate distribution and/or per capita rates.
#' 
#' @param county_list a string, the county to pull. default is all counties.
#' @param demographic a string, the demographic requested. one or more of "race", 
#'      "age", "ethnicity", "sex". default is all demographics
#' @param status string, either 'partial' or 'full' for number of people with
#'      partially or fully vaccinated. Default of NULL returns both.
#' @param latest logical, whether to pull only the latest vaccination record or
#'     a full time series. default F pulls full time series
#' @examples {
#' 
#' get_vaccinations_demo(county_list = "Guilford",
#'                       demographic = 'race', status = 'partial', latest = TRUE)
#' 
#' }
#' @export

get_vaccinations_demo <- function(county_list = NULL,
																	demographic = NULL,
																	status = NULL, latest = FALSE){
	dat <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/vax-demos.csv")
	dat <- dat[date_pulled==max(date_pulled)]
	
	if(!is.null(county_list)){
		dat <- dat[county %in% county_list]
	}
	

	if(!is.null(demographic)){
		demo <- match.arg(demographic, c("race", "age", "ethnicity", "sex"),
											several.ok = TRUE)
		demo <- gsub('Age', 'Age Group', stringr::str_to_title(demo))
		dat <- dat[demographic %in% demo]
	}
	
	if(!is.null(status)){
		stat <- match.arg(status, c('partial', 'full'), several.ok = TRUE)
		dat <- dat[status %in% stat]
	}
	
	if(!is.logical(latest))stop('latest must be a logical T/F')
	if(latest){
		dat <- dat[week_of==max(week_of)]
	}

	return(dat)
}

