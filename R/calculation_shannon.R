#' Calculate Shannon Index for a Series
#' @param incidence numeric, the case incidence
#' @return double, the intensity of epidemic calculated via Shannon index
#' @examples
#' dat <- nccovid::get_covid_state(c("Guilford", "Forsyth", "Mecklenburg", "Wake"))
#' 
#' library(dplyr)
#' library(ggplot2)
#' 
#' counties <- unique(dat$county)
#' entropy_values = dat %>% 
#' 	group_by(county) %>% 
#' 	dplyr::group_split() %>% 
#' 	lapply( function(x) calculate_shannon(incidence = x$cases_daily) ) %>%
#' 	unlist()
#' 	
#' entropy_values = data.frame(county = counties, intensity = entropy_values)
#' 	entropy_values %>% 
#' 	filter(county %in% nccovid::triad_counties) %>% 
#' 	ggplot(aes(reorder(county,intensity), intensity))+
#' 	geom_point()+
#' 	coord_flip()+
#' 	labs(
#' 		title = "Epidemic Intensity"
#' 	)
#' 
#' @export

calculate_shannon <- function(incidence){
	
	message("In order to use this function, the entropy package must be available")
	
	requireNamespace("entropy")
	
	#calculate fraction of total cases for each period
	p.i <- incidence/sum(incidence, na.rm = TRUE) 
	
	#calculate inverse Shannon entropy
	epidemic_intensity <- entropy::entropy(p.i)^-1 
	
	min_int.i <- entropy::entropy(rep(1/length(p.i), length(p.i)))^-1
	
	epidemic_intensity_norm.i <- epidemic_intensity - min_int.i
	
	epidemic_intensity_norm.i
}