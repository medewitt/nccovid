#' Transmission Increase
#' 
#' Calculating the Transmission Increase from Factors
#' @param R_w a numeric, the baseline effective reproduction number
#' @param rho a numeric, the estimated transmission advantage
#' @param D a numeric, the generation time (average)
#' @param omega a numeric with default of NULL indicating proportion of the 
#'     population that has immunity against earlier variants
#' 
#' @examples 
#' c(4,6) * calculate_transmission_increase(R_w = .8, .43, D = 5.2, omega = NULL)
#' 
#' c(4,6) * calculate_transmission_increase(R_w = .8, .43, D = 5.2, omega = .25)
#' 
#' @export


calculate_transmission_increase <- function(R_w, rho, D = 4.7, omega = 0){
	if(is.null(omega)){
		rho * D / R_w 
	} else {
		rho * D * (1- omega) / (omega * R_w)
	}
	
}
