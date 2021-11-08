#' Vaccine Coverage by Age
#' 
#' Generates a graphic that shows the vaccine coverage by age band as a 
#' stacked bar chart in order to show the coverage as well as the raw number
#' of vaccinated versus unvaccinated individuals.
#' 
#' @param county_use a string vector representing the North Carolina
#'     counties to be displayed
#' @export

generate_vax_coverage_age <- function(county_use = nccovid::cone_region){

	vax <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/nc-summary-all-vaccine.csv")
	
	
	vax <- clean_names(vax)
	
	vax_rock <- vax[county%in%county_use][demographic=="Age Group"][data_source=="All Programs"]
	
	
	full_vax <- vax_rock[!age_group%in% c("Suppressed", "Missing or Undisclosed")]
	
	
	full_vax <- full_vax[!is.na(fully_vaccinated_population)& !is.na(week_of)]
	full_vax[,people_fully_vaccinated:=na_to(people_fully_vaccinated,0)]
	
	full_vax[order(week_of),cum_vax:=cumsum(people_fully_vaccinated), by = c("county","age_group")]
	
	d_latest <- full_vax %>%
		dplyr::group_by(county) %>%
		dplyr::filter(week_of == max(week_of, na.rm = TRUE))
	
	new_titles <- data.table::setDT(d_latest)[,list(Global = scales::percent(sum(cum_vax)/sum(fully_vaccinated_population))), by = "county"]
	new_titles[,Title_use:=sprintf("%s %s Overall Fully Vaccinated", county, Global)]
	vax_perc_graph <- data.table::setDT(d_latest)[,list(AgePerc = scales::percent(sum(cum_vax)/sum(fully_vaccinated_population))), by = c("county","age_group")]
	vax_perc_graph <- merge(vax_perc_graph,new_titles, by = "county" )
	
	x <- unique(d_latest$age_group)
	
	y <- stringr::str_extract(x, "\\d\\d|\\d")
	
	x <- x[order(as.numeric(y))]
	
	d_latest %>%
		dplyr::mutate(age_group = factor(age_group,x)) %>%
		dplyr::mutate(unvax = fully_vaccinated_population-cum_vax) %>%
		dplyr::left_join(new_titles, by = "county") %>%
		dplyr::select(cum_vax,unvax, age_group, Title_use) %>%
		tidyr::gather(metric, value, -age_group, -Title_use) %>%
		dplyr::mutate(metric = rev(metric)) %>%
		ggplot2::ggplot(ggplot2::aes(age_group, fill = metric, value))+
		ggplot2::geom_col()+
		ggplot2::geom_text(data = vax_perc_graph,
											 ggplot2::aes(x= age_group,y = 100, label = AgePerc), 
											 inherit.aes=FALSE, hjust=0,
							color = "grey90", font = "bold", size = 6)+
		ggplot2::coord_flip()+
		ggplot2::labs(
			title = "Full Vaccination Coverage",
			y = "Population",
			fill = NULL,
			x = NULL,
			caption = "Data: NCDHHS"
		)+
		ggplot2::scale_y_continuous(labels = scales::comma)+
		ggplot2::scale_fill_manual(values =c("grey70", "#00468B"), 
															 labels = c("Unvaccinated", "Vaccinated"))+
		ggplot2::theme_bw()+
		ggplot2::theme(panel.grid.major.x = ggplot2::element_line(),
					panel.grid.major.y = ggplot2::element_blank())+
		ggplot2::facet_wrap(~Title_use, scales = "free")+
		ggplot2::theme(legend.position = "top")
	
}

