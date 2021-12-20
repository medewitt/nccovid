#' Vaccine Effectiveness
#' 
#' Calculates Effective Vaccine Effectiveness as a function of parameters
#' and time since vaccination. Includes heavyside function to accomendate
#' the daily from injection
#' 
#' @param VE a numeric, the maximum vaccine efficacy
#' @param omega a numeric, the rate parameter of wane
#' @param t an integer, the day of interest
#' @param t_2 an integer, the inflection of the heavyside
#' @param theta a numeric, the general wane of the vaccine to be calibrated
#' @examples 
#' plot(0:30, effective_ve_wane(t = 0:30))
#' @export

effective_ve_wane <- function(VE=.8, omega=.1, t, theta=.3, t_2=14){
	
	a <- VE * exp(-omega*(t - t_2)) * theta * (t - t_2)
	
	a[a<0] <- 0
	
	a
	
}

