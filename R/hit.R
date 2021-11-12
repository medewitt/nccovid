#' Calculate Herd Immunity Threshold
#' 
#' Calculates Basic Herd Immunity Threshold Based on 
#' the Basic Reproduction Number
#' 
#' @param R0 a positive double, the basic reproduction number
#' @examples 
#' # Calculate the Herd Immunity Threshold for R0 Between 1 and 9
#' o <- vapply(seq(1,9, .1), hit, FUN.VALUE = numeric(1))
#' 
#' plot(seq(1,9, .1), o, main = "HIT", type = "l",
#'     ylab = "Prop with Immunity", xlab = expression(R[0]))
#' 
#' @export

hit <- function(R0){
	stopifnot(is.numeric(R0))
	if(R0 < 1){
		message("This virus will not reach endemicity.")
		
		return(0)
	}
	
	1 - 1 / R0
	
}
