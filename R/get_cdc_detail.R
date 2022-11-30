#' Retrieve CDC COVID-19 Spread by County
#' 
#' Utilizes the CDC's COVID-19 Tracker to General Information About the Spread
#' of Disease.
#' 
#' @return a data.table with details regarding disease spread by county
#' @source <https://covid.cdc.gov/covid-data-tracker/#datatracker-home>
#' @export

get_cdc_detail <- function(){
	# dat <- data.table::fread("https://raw.githubusercontent.com/medewitt/covidcdc/main/output/nc-county-detail.csv")
	
	tmpf <- tempfile(fileext = '.json')
	download.file(
		"https://covid.cdc.gov/covid-data-tracker/COVIDData/getAjaxData?id=integrated_county_latest_external_data",
		tmpf,
		quiet = TRUE,
		cacheOK = FALSE
	)
	
	dat_raw <- jsonlite::read_json(tmpf)
	
	a <- dat_raw[[2]]
	b <- data.table::rbindlist(lapply(a, data.table::as.data.table), fill = TRUE)
	
	dat_out <- b[State_name=="North Carolina"]
	# str(dat_out)
	dat_out <- dat_out[,County:=stringr::str_remove(County, " County")]
	
	dat_out = dat_out[,data.table::last(.SD), by = c("County", "report_date")]
	
	return(dat_out)
	
}
