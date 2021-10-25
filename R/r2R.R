#' Convert Growth Rate to Reproduction Number
#' 
#' Convenience function to convert a growth rate (little r)
#' to a reproduction number (R) given a particular
#' generation time.
#' 
#' @param r a double representing the growth rate
#' @param mu_gamma a double representing mean of the 
#'     gamma function characterizing the generation time.
#' @param sd_gamma a double representing standard deviation of the 
#'     gamma function characterizing the generation time.
#' @source \url{https://royalsocietypublishing.org/doi/10.1098/rsif.2020.0144}
#' @examples 
#' 
#' cases <- rpois(10,2.5)
#' t <- 1:10
#' fit <- glm(cases ~ t, family = "poisson")
#' 
#' r2R(coef(fit)[2])
#' 
#' 
#' 
#' @export

r2R <- function(r, mu_gamma = 4.7, sd_gamma = 2.9){
	stopifnot(is.numeric(r))
	stopifnot(is.numeric(mu_gamma))
	stopifnot(is.numeric(sd_gamma) && sd_gamma > 0)
	
	k <- (sd_gamma / mu_gamma) ^ 2
	
	R <- (1 + k * r *  mu_gamma) ^ (1 / k)
	
	return(R)
	
}
