#' Pull Latest Estimates
#' 
#' All estimates for North Carolina and some select regions have been
#' precalculated and available for download. These estimates are utilising
#' the EpiNow2 package
#' 
#' @importFrom data.table `%chin%`
#' 
#' @param region a string or string vector, the region or county of interest
#' @param variable a string or string vector, the measure of interest
#' @export

pull_estimates <- function(region= NULL, variable ="R"){
	
	# old_url <- "https://raw.githubusercontent.com/medewitt/refresh-restimates/master/output/latest_r_coviddata.csv"
	
	# new r estimates via cori et al
	url <- "https://github.com/conedatascience/r-estimates-cori/blob/main/output/latest_r_coviddata.csv?raw=true"
	

	raw_dat <- data.table::fread(url,
															 colClasses = c(
															 	"character",
															 	"Date",
															 	"Date",
															 	"character",
															 	"character",
															 	"character",
															 	"numeric",
															 	"numeric",
															 	"numeric",
															 	"numeric",
															 	"numeric",
															 	"numeric",
															 	"numeric",
															 	"numeric",
															 	"numeric"
															 ))
	
	# Define Targets for return to client
	# If no region specified, return all.
	# If no variable define, return all
	if(!is.null(variable)){
		variables_available <- match.arg(variable, unique(raw_dat$variable), several.ok = TRUE)
	}
	
	if(is.null(region) && is.null(variable)){
		return(raw_dat)
	} else if (is.null(region)){
		clean_dat <- raw_dat[variable==variables_available]
		return(clean_dat)
	} else {
		clean_dat <- raw_dat[variable %chin% variables_available & county %chin% region]
		
		return(clean_dat)
	}
	
	
}
#' @examples {
#' # Pull Just reproduction number
#' dat <- pull_estimates(region = "Guilford")
#' plot(median~date, data = dat, type ="b")
#' abline(h = 1, col = "orange", lty = 2)
#' 
#' 
#' }