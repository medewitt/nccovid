#' Pull Covid-19 Demographics
#' 
#' These data originate from the North Carolina DHHS Covid-19 Dashboard
#' 
#' @export
#' 
get_covid_demographics <- function(){
	dat_demos <- data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/nc-demographics.csv")
	
	dat_demos <- dat_demos[,date :=as.Date(.id)]
	
	dat_demos
	
}