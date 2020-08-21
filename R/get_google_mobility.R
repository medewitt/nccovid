#' Get Google Mobility Data
#' 
#' This is a helper function to automatically access Google's 
#' Mobility data for North Carolina Counties
#' @source <https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv>
#' 
#' @param counties a string vector of the desired counties deafult of \code{NULL}
#'     returns all counties.
#' @examples \dontrun{
#' # Return All NC Counties
#' get_google_mobility()
#' 
#' # Return a Specific County
#' get_google_mobility("Alamance County")
#' 
#' }
#' @export
#' 

get_google_mobility <- function(counties = NULL){
	
	if(is.null(counties)){
		counties <- sprintf("%s County",nccovid::nc_population$county[1:100])
	}
	
	# mobility_file <- "https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv"
	# 
	# mobility_data <- data.table::fread(mobility_file))
	
	#mobility_data <- data.table::fread(cmd = paste("curl", mobility_file, "| grep 'North Carolina'"))
	
	mobility_data <- data.table::fread(cmd = paste("curl", mobility_file, "| sed -n '1p;/North Carolina/p'"))
	
	us_mobility_data <- mobility_data %>%
		#dplyr::filter(sub_region_1 %in% state.name, grepl('County',sub_region_2)) %>%
		dplyr::mutate(state = sub_region_1, county = sub_region_2) %>%
		# filter(updated_at == max(date)) %>%
		dplyr::select(-sub_region_1, -sub_region_2) %>%
		dplyr::left_join(tigris::fips_codes %>% 
										 	dplyr::transmute(state = state_name, county,
										 									 FIPS = as.numeric(paste0(state_code,county_code))),
										 by = c("state", "county"))
	
	names(us_mobility_data) <- gsub('_percent_change_from_baseline', '', names(us_mobility_data))
	
	us_mobility_data_long <- us_mobility_data %>%
		tidyr::pivot_longer(cols = c('retail_and_recreation',
																 'grocery_and_pharmacy','parks',
																 'transit_stations','workplaces','residential'),
												names_to = 'variable',values_to = 'value') %>%
		dplyr::filter(!is.na(value)) %>%
		dplyr::mutate(value = round(value),
									variable = dplyr::case_when(variable=='retail_and_recreation'~"Retail & Recreation",
																							variable == 'grocery_and_pharmacy'~"Grocery & Pharmacy",
																							variable == 'parks'~'Parks',
																							variable == 'transit_stations'~"Transit Stations",
																							variable == 'workplaces'~"Work Places",
																							variable == 'residential'~'Residential'))
	
	
	mobility_cone_longitudinal <- us_mobility_data_long %>%
		dplyr::filter(county %in% counties)
	
	mobility_cone_longitudinal <- mobility_cone_longitudinal %>%
		dplyr::mutate(county = trimws(stringr::str_remove(string = county, "County"), "both"))
	
	return(mobility_cone_longitudinal)
	
}
