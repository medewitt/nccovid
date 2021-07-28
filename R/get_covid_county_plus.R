#' Append Additional Information to COVID-19 Count Information
#' 
#' Combined NCDHHS Case and Death Counts with CDC Details
#' 
#' @param county a string vector, representing the counties of interest. If left
#'     NULL then all counties in North Carolina will be returned
#'     
#' @param adjusted a logical, should the adjusted cases be used (to account for
#'     reporting gaps on weekends and holidays from NCDHHS). Defaults to \code{TRUE}
#' @return a data.table with combined values for all counties or specified counties
#' @export

get_covid_county_plus <- function(county = NULL, adjusted = TRUE){
	
	stopifnot(is.null(county) | is.character(county))
	stopifnot(is.logical(adjusted))
	
	if(is.null(county)){
		dat_cases <- nccovid::get_covid_state(reporting_adj = adjusted)
		dat_details <- nccovid::get_cdc_detail()
		
		dat_combined <- merge(dat_cases, dat_details, by.x = c("county", "date"),
													by.y = c("County", "report_date"),
													all.x = TRUE)
		
	} else {
		dat_cases <- nccovid::get_covid_state(select_county = county, reporting_adj = TRUE)
		dat_details <- nccovid::get_cdc_detail()
		
		dat_combined <- merge(dat_cases, dat_details, by.x = c("county", "date"),
													by.y = c("County", "report_date"),
													all.x = TRUE)
	}
	
	return(dat_combined)
}
