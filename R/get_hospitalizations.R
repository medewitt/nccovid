#' Get Reported Hospitalisation Data
#' 
#' Retrieve Latest Hospitalisation data from NC DHHS. This is not an automatic
#' Scrap so there could be some delay.
#' @export
get_hospitalizations <- function(){
	dat <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/hospitalisations.csv")
	
	dat<- clean_names(dat)

	
	# names changes 2023/03/29
	name_cross <- data.frame(new = c('date', 'adult_icu_covid_19_patients', 'coalition', 
																	 'inpatient_empty_staffed_beds', 'icu_empty_staffed_beds', 
																	 'inpatient_beds_in_use', 'icu_beds_in_use', 
																	 'covid_19_hospitalizations', 
																	 'covid_19_confirmed_patients_admitted___last_24_hours',
																	 'hospitalized_and_ventilated_covid_19_inpatient_count',
																	 'influenza_confirmed_patients_admitted___last_24_hours'),
													 
													 old = c('date', 'full_adult_icu_covid19_positive_patients', 'coalition',
													 				'inpatient_empty_(beds_all_types)', 'adult_icu_empty', 
													 				'inpatient_full_(all_bed_types)', 'adult_icu_ful',
													 				'number_of_covid_19_positive_patients_in_hospital',
													 				'at_admission_confirmed_covid19_patients_in_24_hrs', 
													 				'hospitalized_and_ventilated_covid_inpatient_count', 
													 				'previous_day_confirmed_influenza'))
	
	if(all(name_cross$old %in% names(dat))){
		# old names, do nothing
	} else if(all(name_cross$new %in% names(dat))){

		
# --calculated--														--NOW GONE--
# icu_beds_in_use + icu_empty_staffed_beds	adult_intensive_care_unit_staffed_bed_capacity
# 																					confirmed_covid_pediatric_patient_count
# 																					ed_covid_visits_previous_day
# 																					ed_total_visits_previous_day
# 																					icu_licensed_beds
# 																					parent_name
# inpatient_empty_staffed_beds + 
								#	inpatient_beds_in_use			total_staffed_inpatient_capacity_all_bed_types
# 																					licensed_inpatient_beds
# 																					ventilator_available
# 																					ventilator_used_not_specific_to_covid_19
# 																					at_admission_suspected_covid19_patients_in_24_hrs
	
		
		
		# calculate capacity
	dat$`total_staffed_inpatient_capacity_(all_bed_types)` <- dat$inpatient_empty_staffed_beds + dat$inpatient_beds_in_use
	dat$adult_intensive_care_unit_staffed_bed_capacity <- dat$icu_beds_in_use + dat$icu_empty_staffed_beds
	
	#replace new names with old names
	names(dat)[match(c(name_cross$new), names(dat))] <- c(name_cross$old)
	
	
	} else{
		warning('Detected column names are not as expected.')
	}
	
	#dat$date <- as.Date(dat$date, "%m/%d/%Y")
	
	last_date <- max(dat$date)
	message(sprintf("Data valid as of: %s\nUse with caution.", as.character(last_date)))
	dat
}
