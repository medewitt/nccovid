#' Final Size of An Epidemic
#' 
#' Calculate the final size of an epidemic. 
#' Usethe the following logic:
#' 
#' 1 + 1/R0*W(-R0exp(-R0))
#' 
#' 
#' @param r0 a double, the reproduction number (can be basic or Reff)
#' 
#' @examples \dontrun{
#' epi_finalsize(3.5)
#' 
#' plot(seq(1,3,.01), epi_finalsize(seq(1,3,.01)),xlab = "R", 
#' ylab = "Percent Infected", type = "l")
#' }
#' 
#' @export

epi_finalsize <- function(r0) {
	1+1/r0*lambertW(-r0*exp(-r0))
}