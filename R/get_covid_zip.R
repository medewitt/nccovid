#' Pull Covid Data by Zip Code
#' 
#' This function will pull down NC Covid Information by Zip Code
#' 
#' @export

get_covid_zip <- function(){
	
	dat <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/nc-cases-by-zip.csv")
	dat <- dat[,date:=as.Date(date)]
	
	return(dat)
}