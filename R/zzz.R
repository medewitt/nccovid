globalVariables({
	c(
		"cases_daily",
		"cases_confirmed_cum",
		"deaths_daily",
		"deaths_confirmed_cum",
		"patterns",
		"county",
		"Province_State",
		"mobility_file",
		"sub_region_1",
		"sub_region_2",
		"state_name",
		"county_code",
		"value",
		"state",
		".id",
		"state_code",
		"cases",
		"deaths",
		"metric",
		"population",
		"week_of",
		"date_pulled",
		"cases_daily_roll",
		"update_dts",
		"demographic",
		"data_source",
		"age_group",
		"fully_vaccinated_population",
		"people_fully_vaccinated",
		"cum_vax",
		"people_fully_vaccinated",
		"Title_use",
		"category",
		"total_population",
		"unvax",
		"variable",
		"total_vax",
		"AgePerc",
		"COUNTY",
		"Date",
		"Global",
		"covid_status",
		"percent_total",
		"two_doses_or_one_dose_jj_population",
		"primary_series_n",
		"people_vaccinated_with_two_doses_or_one_dose_jj",
		"vax_cum",
		"un_vax_cum",
		"vax_per",
		"TitleText",
		"VaxGroupPerc",
		"GroupVaxRate",
		"TotalVaxRate",
		"county_names"
	)
})



clean_names <- function(x){
	
	id <- names(x)
	
	id <- tolower(id)
	
	id <- gsub(pattern = " |\\.|-", replacement = "_", id)
	
	names(x) <- id
	
	return(x)
	
}

na_to <- function(x, to = 0){
	ifelse(is.na(x),to,x)
}
