#' Get Reported Demographics by County
#' 
#' Retrieve Latest Demographic data from NC DHHS.
#' 
#' @param demographic a string, one of age, k_12, ethnicity, gender, or race
#' @param region a string vector, could a string or vector of the counties of 
#'     interest
#' @param add_population a boolean, TRUE to add the population estimates
#'     (may not be available for all demographics)
#' @examples 
#'library(ggplot2)
#'library(data.table)
#'out <- get_county_covid_demographics(region = "Guilford", demographic = "age")
#'
#'out[,per_capita:=cases/(population/100000)]
#' ggplot(out, aes(week_of, per_capita, colour = metric))+
#'	geom_line()+
#'	theme_bw()+
#'	theme(legend.position = "top")+
#'	labs(
#'	title = "SARS-CoV-2 Cases per 100k Residents",
#'	subtitle = "Guilford County, North Carolina",
#'	x = "Cases per 100k",
#'	y = NULL
#'	)
#' 
#' @export
get_county_covid_demographics <- function(demographic = "age_group", region = NULL, add_population = TRUE){
	
	field <- match.arg(demographic, c("age_group", "k_12", "ethnicity", "gender", "race"))
	
	url <- "https://raw.githubusercontent.com/conedatascience/covid-data/master/data/timeseries/county-demographics.csv"
	dat <- data.table::fread(url, na.strings = "")
	
	#names(dat) <- c("demographic", "race", "age_group", "deaths", "gender", "week_of", 
	#								"county", "ethnicity", "cases")
	
	dat <- clean_names(dat)
	
	data.table::setnames(dat, "hispanic", "ethnicity")
	
	dat[,demographic:=gsub(" |-","_",tolower(demographic))]
	dat[,demographic:=ifelse(demographic=="age_group_b_k_12", "k_12", demographic)]
	
	dat = dat[demographic==field & !is.na(week_of)]
	#dat$date <- as.Date(dat$date, "%m/%d/%Y")
	
	field = ifelse(field == "k_12", "age_group", field)
	dat = dat[,list(week_of, county, demographic,metric = get(field), cases, deaths)]
	
	dat[,`:=` (cases = ifelse(is.na(cases),0,cases),
						 deaths = ifelse(is.na(deaths),0,deaths))]
	
	if(!is.null(region)){
		dat = dat[county %in% region]
	}
	
	if(add_population){
		
		if(field == "race"){
			use_pop <- data.table::as.data.table(nccovid::nc_county_demos)
			
			use_pop <- use_pop[,metric:=ifelse(metric == "Black",
																				 "Black or African American",
																				 ifelse(metric %in% c("Asian","Native Hawaiian and Other Pacific Islander"),
																				 			 "Asian or Pacific Islander",
																				 			 ifelse(metric == "American Indian and Alaska Native",
																				 			 			 "American Indian Alaskan Native", metric)))]
			
			use_pop <- use_pop[,list(population = sum(population)), by = c("County", "metric", "category")]
		} else {
			use_pop <- data.table::as.data.table(nccovid::nc_county_demos)[,c("County", "metric", "category", "population")]
		}
			
			
		
		dat = merge(dat, use_pop %>% 
									setNames(c("county", "metric", "category", "population")), 
								by = c("metric", "county"),
								all.x = TRUE)
	}
	
	last_date <- max(dat$week_of)
	message(sprintf("Data valid as of: %s\nUse with caution.", as.character(last_date)))
	dat
}

