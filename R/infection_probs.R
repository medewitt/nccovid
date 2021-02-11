#' Infection Probability
#' 
#' Calculate Infection probability given D50
#' 1-10^(log10(.5)/D50)
#' 
#' @param D50 a double, #RNA for 50 percent infection probability (D50)
#' 
#' @export

infection_probability <- function(D50 = 316){
	1-10^(log10(0.5)/D50)
}

#' RNA Content in Aerosol
#' 
#' Estimate the RNA Content in an Aerosol
#' 
#' @param resp_fluid a double, respiratory fluid RNA conc [/cm^3]
#' @param wet_aerosol_diameter a double, mean wet aerosol diameter [um]
#' 
#' @export

rna_content <- function(resp_fluid = 500000000, 
												wet_aerosol_diameter = 5){
	
}

#' Aerosol Emission per Hour
#' 
#' Estimate the aerosol emission rate per hours
#' 
#' @param emission_breathing a double, emission while breathing cm^3
#' @param emission_speaking a double, emission while speaking cm^3
#' @param speaking_ratio a double, between 0 and 1 for ratio between speaking and breathing
#' @param resp_rate a double, the respiratory rate in liters per minute
#' @export

aerosol_emission <- function(emission_breathing = .06, emission_speaking = .6,
														 speaking_ratio = .1, resp_rate = 10){
	wt_avg = emission_breathing * (1-speaking_ratio) + emission_speaking * speaking_ratio
	
	wt_avg * 1000 * resp_rate * 60
}

#' Aerosol Concentration
#' 
#' Estimate the aerosol concentration given environment parameters
#' 
#' @param room_area a double, meters squared
#' @param room_height a double, meters
#' @inheritParams aerosol_emission
#' 
aerosol_concentration <- function(room_area = 60, room_height = 3,
																	emission_breathing = .06, emission_speaking = .6,
																	speaking_ratio = .1, resp_rate = 10){
	
	aerosol_emission(emission_breathing, emission_speaking,
									 speaking_ratio, resp_rate)/(room_area*room_height*1000)
	
	
}