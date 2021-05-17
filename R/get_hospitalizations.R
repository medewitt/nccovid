#' Get Reported Hospitalisation Data
#' 
#' Retrieve Latest Hospitalisation data from NC DHHS. This is not an automatic
#' Scrap so there could be some delay.
#' @export
get_hospitalizations <- function(){
	dat <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/hospitalisations.csv")
	
	names(dat)<- c("at_admission_suspected_covid19_patients_in_24_hrs", "ventilator_used_not_specific_to_covid_19", 
								 "inpatient_full_all_bed_types", "ed_covid_visits_previous_day", 
								 "parent_name", "at_admission_confirmed_covid19_patients_in_24_hrs", 
								 "icu_licensed_beds", "inpatient_empty_beds_all_types", "adult_icu_empty", 
								 "ventilator_available", "date", "full_adult_icu_covid19_positive_patients", 
								 "licensed_inpatient_beds", "coalition", "adult_icu_ful", "adult_intensive_care_unit_staffed_bed_capacity", 
								 "number_of_covid_19_positive_patients_in_hospital", "hospitalized_and_ventilated_covid_inpatient_count", 
								 "ed_total_visits_previous_day", "total_staffed_inpatient_capacity_all_bed_types"
	)
	
	#dat$date <- as.Date(dat$date, "%m/%d/%Y")
	
	last_date <- max(dat$date)
	message(sprintf("Data valid as of: %s\nUse with caution.", as.character(last_date)))
	dat
}
