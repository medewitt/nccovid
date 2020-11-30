#' Get Reported Hospitalisation Data
#' 
#' Retrieve Latest Hospitalisation data from NC DHHS. This is not an automatic
#' Scrap so there could be some delay.
#' @export
get_hospitalizations <- function(){
	dat <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/hospitalisations.csv")
	
	names(dat)<- c("date", "region_or_state", "coalition", "adult_icu_empty", 
								 "adult_icu_full", "adult_intensive_care_unit_staffed_bed_capacity", 
								 "at_admission_confirmed_covid19_patients_in_24_hrs", "at_admission_suspected_covid19_patients_in_24_hrs", 
								 "full_adult_icu_covid19_positive_patients", "icu_licensed_beds", 
								 "inpatient_empty_beds_all_types", "inpatient_full_all_bed_types", 
								 "licensed_inpatient_beds", "number_of_covid_19_positive_patients_in_hospital", 
								 "total_staffed_inpatient_capacity_all_bed_types", "ventilator_available", 
								 "ventilator_used_not_specific_to_covid_19")
	
	dat$date <- as.Date(dat$date, "%m/%d/%Y")
	
	last_date <- max(dat$date)
	message(sprintf("Data valid as of: %s\nUse with caution.", as.character(last_date)))
	dat
}