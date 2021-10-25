#' Pull Vaccine Information by Census Tract
#' 
#' The purpose of this function is to pull data provided by NCDHHS
#' on vaccination rates by census tract. Additionally, information
#' on SVI and other demographics is provided
#' 
#' @param county_pull a vector, the counties to select for the query
#' 
#' @return a data.table with vaccination rates at the census tract level
#' 
#' @export

pull_vaccine_census <- function(county_pull = NULL){
	svi_info <- data.table::fread(verbose = FALSE, 
																showProgress = FALSE, 
																"https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/svi-tract.csv")
	dat_vax <- data.table::fread(verbose = FALSE, 
															 showProgress = FALSE,
															 "https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/vax-census.csv")
	
	combined_vax_svi <- merge(dat_vax, svi_info, 
														by.x ="geoid", by.y = "FIPS", full.x=TRUE )
	
	combined_vax_svi[,update_dts:=as.Date(update_dts)]
	
	combined_vax_svi[county=="",county:=COUNTY]
	
	combined_vax_svi[,percent_total:=round(total_vax/total_population*100,1)]
	
	if(!is.null(county_pull)){
		combined_vax_svi <- combined_vax_svi[county %in% county_pull]
	}
	message("Last date available: ", max(combined_vax_svi$update_dts))
	combined_vax_svi
}

