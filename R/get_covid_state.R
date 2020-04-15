#' Retrieve Covid19 Data
#' 
#' This functions hits the Johns Hopkins Covid Data Respository
#' and filters down to North Carolina Data. Alternatively, it can
#' retrieve any state.
#' 
#' @param state with a default of North Carolina
#' @param select_county the county, if desired
#' @examples \dontrun{
#' # To get all counties
#' get_covid_state()
#' 
#' # To get a single county
#' get_covid_state(select_county = "Guilford")
#' }
#' 
#' 
#' @export
#' 
get_covid_state <- function(state = "North Carolina", select_county = NULL){
	url_cases <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
	url_deaths <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv"
	
	# HAndle Daily Cases
	dat_cases <- data.table::fread(url_cases)
	
	dat_cases <- dat_cases[Province_State==state]
	
	dat_cases <- dat_cases[, .SD, .SDcols = patterns("20$|Admin2|Province_State")]
	
	dat_cases <- data.table::melt(dat_cases, id.vars = c("Province_State", "Admin2"),
																variable.name = c("date"), 
																value.name = "confirmed_cases")
	names(dat_cases) <- c("state", "county", "date", "cases_confirmed_cum")
	
	dat_cases <- dat_cases[,cases_daily := cases_confirmed_cum - dplyr::lag(cases_confirmed_cum,1,0), by = "county"]
	
	# Deaths
	
	dat_death <- data.table::fread(url_deaths)
	
	dat_death <- dat_death[Province_State==state]
	
	dat_death <- dat_death[, .SD, .SDcols = patterns("20$|Admin2|Province_State")]
	
	dat_death <- data.table::melt(dat_death, id.vars = c("Province_State", "Admin2"),
																variable.name = c("date"), 
																value.name = "deaths_confirmed_cum")
	names(dat_death) <- c("state", "county", "date", "deaths_confirmed_cum")
	
	dat_death <- dat_death[,deaths_daily := deaths_confirmed_cum - dplyr::lag(deaths_confirmed_cum,1,0), by = "county"]
	
	out_data <- data.table::merge.data.table(dat_cases,dat_death, by = c("state", "county", "date"))
	
	if(!is.null(select_county)){
		out_data <- out_data[county==select_county]
	}
	
	out_data
}

