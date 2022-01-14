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

	na_to <- function(x, to =0){
		ifelse(is.na(x),0, x)
	}
	
	vax <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/nc-summary-all-vaccine.csv")
	
	vax <- clean_names(vax)
	
	vax_use <- vax[county%in%county_use][demographic=="Age Group"][data_source=="All Programs"][!age_group%in% c("Suppressed", "Missing or Undisclosed")]
	
	
	data.table::setorderv(vax_use, cols = c("county", "age_group", "week_of"))
	
	vax_use <- vax_use[!is.na(week_of)]
	
	vax_use[,population:=two_doses_or_one_dose_jj_population]
	
	vax_use[,population:=ifelse(is.na(population), max(population, na.rm=TRUE), population), by = c("county", "age_group")]
	
	vax_use[,primary_series_n:=na_to(people_vaccinated_with_two_doses_or_one_dose_jj)]
	
	vax_use[,vax_cum:=cumsum(primary_series_n), by = c("county","age_group")]
	
	vax_use[,un_vax_cum:=population - vax_cum , by = c("county","age_group")]
	
	vax_use[,vax_per := vax_cum/population]
	
	vax_title_bar <- vax_use[week_of==max(week_of)][
		,.(TotalVaxRate = sum(vax_cum)/sum(population)), by = "county"
	][,TitleText:=sprintf("%s %s%% Overall Vaccinated",
												county, round(TotalVaxRate*100))]
	
	vax_perc_graph<- vax_use[week_of==max(week_of)][
		,.(GroupVaxRate = round(sum(vax_cum)/sum(population)*100)), 
		by = c("county", "age_group")][,VaxGroupPerc:=sprintf("%s%%", GroupVaxRate)]
	
	vax_perc_graph <- merge(vax_perc_graph,vax_title_bar, by = "county", all.x= TRUE)
	
	vax_long_version <- vax_use%>%
		.[week_of==max(week_of)] %>% 
		dplyr::select(county,age_group, `Unvaccinated` = un_vax_cum, `Vaccinated`= vax_cum) %>% 
		tidyr::gather(metric, value, -county, -age_group) %>% 
		dplyr::left_join(vax_title_bar, by = "county") %>% 
		dplyr::mutate(age_group = factor(age_group, c("0-4", "5-11", "12-17", 
																					 "18-24", "25-49", "50-64",
																					 "65-74", "75+")))
	
	vax_long_version  %>% 
		ggplot2::ggplot(ggplot2::aes(age_group, fill = metric, value))+
		ggplot2::geom_col()+
		ggplot2::coord_flip()+
		ggplot2::facet_wrap(~TitleText, scales = "free")+
		ggplot2::geom_text(data = vax_perc_graph,
											 ggplot2::aes(x= age_group,y = 100, label = VaxGroupPerc), 
							inherit.aes=FALSE, hjust=0,
							color = "grey90", font = "bold", size = 6)+
		ggplot2::labs(
			title = "Primary Series Vaccination Coverage",
			y = "Population",
			fill = NULL,
			x = NULL,
			caption = "Data: NCDHHS\nPrimary Series is either 2 Doses of mRNA or 1 Dose of J&J"
		)+
		ggplot2::scale_y_continuous(labels = scales::comma)+
		ggplot2::scale_fill_manual(values =c("grey70", "#00468B"), 
															 labels = c("Unvaccinated", "Vaccinated"))+
		ggplot2::theme_bw()+
		ggplot2::theme(panel.grid.major.x = ggplot2::element_line(),
					panel.grid.major.y = ggplot2::element_blank())+
		ggplot2::theme(legend.position = "top")
	
}

