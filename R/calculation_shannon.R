#' Calculate Shannon Index for a Series
#' @param incidence numeric, the case incidence
#' @return double, the intensity of epidemic calculated via Shannon index
#' @export

calculate_shannon <- function(incidence){
	
	requireNamespace("entropy")
	
	#calculate fraction of total cases for each period
	p.i <- incidence/sum(incidence, na.rm = TRUE) 
	
	#calculate inverse Shannon entropy
	epidemic_intensity <- entropy::entropy(p.i)^-1 
	
	min_int.i <- entropy::entropy(rep(1/length(p.i), length(p.i)))^-1
	
	epidemic_intensity_norm.i <- epidemic_intensity - min_int.i
	
	epidemic_intensity_norm.i
}

#' @examples {
#' dat <- nccovid::get_covid_state(c("Guilford", "Forsyth", "Mecklenburg", "Wake"))
#' 
#' library(tidyverse)
#' dat %>% 
#' 	group_by(county) %>% 
#' 	nest() %>% 
#' 	mutate(intensity = map_dbl(data, ~calculate_shannon(incidence = .x$cases_daily) )) %>% 
#' 	ungroup() %>% 
#' 	filter(county %in% nccovid::triad_counties) %>% 
#' 	ggplot(aes(reorder(county,intensity), intensity))+
#' 	geom_point()+
#' 	coord_flip()+
#' 	labs(
#' 		title = "Epidemic Intensity"
#' 	)
#' 	}
