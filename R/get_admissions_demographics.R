#' #' Pulls Admissions Demographics for NC
#' #' 
#' #' Makes available information regarding admissions by age, race, and ethnicity
#' #' by COVID-19 testing status by week.
#' #' 
#' #' 
#' get_admissions_demographics <- function(){
#' 	dat = data.table::fread("https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/hospitalization-demographics.csv")
#' }