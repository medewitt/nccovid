#' Pull Vaccination Rates by County and Demographic
#' 
#' Pulled from <conedatascience/covid-data>. The columns vax_prop and vax_n return
#' the vaccination proportion and vaccination counts.
#' 
#' @param county_list a string, the county to pull. default is all counties AND 
#'      a North Carolina roll up. "North Carolina" can be supplied as a county.
#' @param measure a string, the measure requested. one of "distribution" or
#'      "per capita" for pulling the distribution of vaccine (adds to 1 within the 
#'      demographic) or the vaccinate rate per capita within the demographic, 
#'      respectively. default is all measures.
#' @param demographic a string, the demographic requested. one or more of "race", 
#'      "age", "ethnicity", "sex". default is all demographics
#' @param dose integer, the dose to pull (1 or 2). default is all doses.
#' @param latest logical, whether to pull only the latest vaccination record or
#'     a full time series. default F pulls full time series
#' @examples {
#' 
#' get_vaccinations_demo(county_list = "Guilford", measure = 'distribution',
#'                       demographic = 'race', dose = 1, latest = TRUE)
#' 
#' }
#' @export

get_vaccinations_demo <- function(county_list = NULL,
																	measure = NULL,
																	demographic = NULL,
																	dose = NULL, latest = FALSE){
	dat <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/vax-demos.csv")
	
	dat$date <- as.Date(dat$date)
	
	if(!is.null(county_list)){
		dat <- dat[county %in% county_list]
	}
	
	m <- match.arg(measure, c('distribution', 'per capita'),several.ok = T)
	m <- gsub('\\s','',stringr::str_to_title(m))
	if(!is.null(m)){
		dat <- dat[measure %in% m]
	}
	
	demo <- match.arg(demographic, c("race", "age", "ethnicity", "sex"),
										several.ok = T)
	demo <- gsub('Age', 'Age Group', stringr::str_to_title(demo))
	if(!is.null(m)){
		dat <- dat[demographic %in% demo]
	}
	
	d <- dose
	if(!is.null(d)){
		if(!d %in% 1:2)stop("dose most be 1, 2, or NULL")
		dat <- dat[dose %in% d]
	}
	
	if(!is.logical(latest))stop('latest must be a logical T/F')
	if(latest){
		dat <- dat[date==max(date)]
	}

	return(dat)
}

