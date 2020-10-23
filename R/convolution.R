#' Convolution
#' 
#' Perform a convolution given a pdf
#' 
#' @param cases numeric, the observed cases
#' @param pdf numeric vector, the pdf of cases
#' @param direction string, one of forward or backwards convolution
#' @export
#' 
#' @examples {
#'   
#' true_cases <- rpois(100, 5)
#' out <- data.frame(reported = ceiling(epi_convolve(true_cases, pdf = c(.2,.2,.3,.2,.1))),
#' true_cases,
#' date = 1:100
#' )
#' 
#' library(ggplot2)
#' ggplot(out, aes(date))+
#' 	geom_line(aes(y = true_cases))+
#' 	geom_line(aes(y = reported_cases), color = "blue")
#' }

epi_convolve <- function(cases, pdf, direction = "forward"){
	
	direction <- match.arg(direction, c("forward", "backward"))
	
	pdf <- pdf/sum(pdf)
	
	convolved_cases <- vector()
	max_pdf <- length(pdf)
	if(direction == "forward"){
		for(s in seq_along(cases)){
			convolved_cases[s] <- cases[max(1, (s - max_pdf + 1)):s] %*%tail(pdf, min(max_pdf, s))
		}
	} else{
		for(s in seq_along(cases)){
			convolved_cases[s] <- cases[max(1, (s - max_pdf + 1)):s] %*%tail(rev(pdf), min(max_pdf, s))
		}
	}
	
	
	convolved_cases
}
