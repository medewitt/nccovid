#' Increase Cases
#' 
#' Increase case count in the presence of high testing positivity
#' 
#' @param observed_cases numberic, the reported cases
#' @param pos_rate numberic, the observed positivity rate
#' @param m scaling factor
#' @param k scaling factor with default of 1/2 on range [0,1]
#'
#' @source \url{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4809590/}
#'
#' @export

increase_cases <- function(observed_cases, pos_rate, m = 10.83, k = .5){
	y <- observed_cases * pos_rate ^ k * m
	return(y)
}
#' Decrease Cases
#' 
#' Decreased previous observed cases back to scale
#' 
#' @param calculated_cases numeric, the calculated cases
#' @param pos_rate numeric, the observed positivity rate
#' @param m scaling factor
#' @param k scaling factor with default of 1/2 on range [0,1]
#'
#' @source \url{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4809590/}
#'
#' @export

decrease_cases <- function(calculated_cases, pos_rate, m = 10.83, k = .5){
	y <- calculated_cases /( pos_rate ^ k * m)
	return(y)
}
