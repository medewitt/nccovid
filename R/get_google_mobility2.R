#' Get Google Mobility (Version 2)
#' This is a helper function to automatically access Google's 
#' Mobility data for North Carolina Counties. It's a bit faster than
#' `get_google_mobility` which downloads the entire csv for the world
#' 
#' @param counties a string vector of the desired counties deafult of \code{NULL}
#'     returns all counties.
#' @param state_in a string vector representing state or states of interest
#' @export
#' 

get_google_mobility2 <- function(counties= NULL, state_in = "North Carolina"){
	
	if(is.null(counties)){
		counties <- sprintf("%s County",nccovid::nc_population$county[1:100])
	}
	tmp <- tempfile()
	
	
	url <- "https://www.gstatic.com/covid19/mobility/Region_Mobility_Report_CSVs.zip"
	
	download.file(url = url, destfile = tmp)
	
	zipped_csv_names <- grep('_US_Region_Mobility_Report.csv$', unzip(tmp, list=TRUE)$Name, 
													 ignore.case=TRUE, value=TRUE)
	unzip(tmp, files=zipped_csv_names)
	require(data.table)
	comb_tbl <- rbindlist(lapply(zipped_csv_names,  
															 function(x) cbind(fread(x, sep=',', header=TRUE,
															 												stringsAsFactors=FALSE),
															 									file_nm=x)), fill=TRUE ) 
	
	us_mobility_data <- comb_tbl %>%
		#dplyr::filter(sub_region_1 %in% state.name, grepl('County',sub_region_2)) %>%
		dplyr::mutate(state = sub_region_1, county = sub_region_2) %>%
		# filter(updated_at == max(date)) %>%
		dplyr::select(-sub_region_1, -sub_region_2) %>%
		dplyr::left_join(tigris::fips_codes %>% 
										 	dplyr::transmute(state = state_name, county,
										 									 FIPS = as.numeric(paste0(state_code,county_code))),
										 by = c("state", "county"))
	
	names(us_mobility_data) <- gsub('_percent_change_from_baseline', '', names(us_mobility_data))
	
	if(!is.null(state_in)){
		us_mobility_data <- us_mobility_data %>%
			dplyr::filter(state %in% state_in)
	} else {
		us_mobility_data <- us_mobility_data 
	}
	
	
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
																							variable == 'residential'~'Residential')) %>% 
		group_by(state,county, variable) %>% 
		arrange(date) %>% 
		mutate(rolling = frollmean(value, 7)) %>% 
		ungroup()
	
	
	
	
	mobility_cone_longitudinal <- us_mobility_data_long %>%
		filter(county %in% counties) %>% 
		dplyr::mutate(county = trimws(stringr::str_remove(string = county, "County"), "both"))
	
	return(mobility_cone_longitudinal)
	
}
