#' Calculating Community Immunity
#' 
#' Considering Proportion of the Vaccinated and Those Who Were Naturall
#' Infected
#' 
#' @param prop_infected a numeric representing the proportion of the population
#'     with natural infection
#' @param prop_vaccinated a numeric representing the proportion of the
#'     population that is vaccinated.
#' @examples {
#' 
#' calculate_community_immunity(.3,.5)
#' 
#' }
#' @source Lopman, B. A. et al. A framework for monitoring population immunity 
#'     to SARS-CoV-2. Annals of Epidemiology S1047279721002635 (2021) 
#'     \url{doi:10.1016/j.annepidem.2021.08.013}.
#'     
#' @export

calculate_community_immunity <- function(prop_infected, prop_vaccinated){
	prop_infected + (1 - prop_infected) * prop_vaccinated
}


