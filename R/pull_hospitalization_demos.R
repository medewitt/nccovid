#' Pull Hospitalization Demographics
#' 
#' A Helper Function That Pull Hospitalizations by Demographics
#' as Posted by NCDHHS
#' 
#' @examples 
#'o <- pull_hospitalization_demos()
#'
#'age_only <-o[demographic=="Age"&covid_status=="Confirmed"]
#'
#'age_only <- age_only[date<Sys.Date()-90]
#'
#'plot(NULL, 
#'		 xlim=range(age_only$date), 
#'		 ylim=range(age_only$value), ylab="Admissions", 
#'		 xlab="Date", main = "Admissions by Age")
#'
#'buckets <- unique(age_only$category)
#'
#'my_cols <- c("#00A2B2", "#F1BD51", "#00205C", "#c9c9c9", "#7750A9", "#B7D866", 
#'						 "#5C5859", "#DB2B27", "#63CCFF", "#000000", "#123453")
#'names(my_cols) <- buckets
#'
#'for(i in buckets){
#'	lines(age_only[category==i]$date,
#'				age_only[category==i]$value,
#'				col = my_cols[[i]])
#'}
#' 
#' @export
#' @returns a data.table
#' 

pull_hospitalization_demos <- function(){
	url <- "https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/hospitalization-demographics.csv"
	
	dat_raw <- data.table::fread(url)
	
	if("Date Filter" %in% names(dat_raw)){
		dat_raw[,"Date Filter" :=NULL]
	}
	
	dat_long <- data.table::melt(dat_raw, id.vars = c("Date", "today", "Max Date"))
	
	dat_long[,covid_status:=stringr::str_extract(variable, "Confirmed|Suspected")]
	dat_long[,demographic:=stringr::str_extract(variable, "Age|Gender")]
	dat_long[,demographic:=ifelse(stringr::str_detect(variable, "ispanic"), "Ethnicity", demographic)]
	dat_long[,demographic:=ifelse(stringr::str_detect(variable, "\\d"), "Age", demographic)]
	dat_long[,demographic:=ifelse(is.na(demographic), "Race", demographic)]
	dat_long[,category:=stringr::word(string = variable,-1)]
	dat_long[,category:=ifelse(grepl("Indian",category), "Alaskan Native American Indian",category)]
	dat_long[,category:=ifelse(grepl("American",category), "Black African American",category)]
	dat_long[,category:=ifelse(grepl("Islander",category), "Native Hawaiian Pacific Islander",category)]
	dat_long[,category:=ifelse(grepl("Disclosed",category), "Not Disclosed",category)]
	dat_long <- dat_long[order(Date)]
	
	names(dat_long) <- c("date", "report_date", "max_date",
											 "variable", "value", "covid_status",
											 "demographic", "category")
	
	return(dat_long)
}


