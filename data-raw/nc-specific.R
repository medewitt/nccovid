## code to prepare `nc-specific` dataset goes here

library(tidycensus)
library(tidyverse)


# defaults ----------------------------------------------------------------

theme_set(theme_minimal())

# import raw --------------------------------------------------------------

raw_nc <- get_estimates(breakdown = c("SEX", "AGEGROUP"),  
												product = "characteristics",
												breakdown_labels = TRUE,
												state = "NC", geography = "county",
												geometry = FALSE, key = CENSUS_KEY)

nc_aggregated <- raw_nc %>%
	filter(SEX != "Both sexes") %>%
	filter(grepl("^Age", AGEGROUP)) %>%
	mutate(age_grp = fct_collapse(AGEGROUP,
																`0-9` = c("Age 0 to 4 years", "Age 5 to 9 years"),
																`10-19` = c("Age 10 to 14 years", "Age 15 to 19 years"),
																`20-29` = c("Age 20 to 24 years", "Age 25 to 29 years"),
																`30-39` = c("Age 30 to 34 years", "Age 35 to 39 years"),
																`40-49` = c("Age 40 to 44 years", "Age 45 to 49 years"),
																`50-59` = c("Age 50 to 54 years", "Age 55 to 59 years"),
																`60-69` = c("Age 60 to 64 years", "Age 65 to 69 years"),
																`70-79` = c("Age 70 to 74 years", "Age 75 to 79 years"),
																`80-89` = c("Age 80 to 84 years", "Age 85 to 89 years", "Age 85 years and older"),
																`90+` = c("Age 90 to 94 years", "Age 95 to 99 years")
	)) %>%
	mutate(age_grp2 = fct_collapse(AGEGROUP,
																 `0-9` = c("Age 0 to 4 years", "Age 5 to 9 years"),
																 `10-19` = c("Age 10 to 14 years", "Age 15 to 19 years"),
																 `20-29` = c("Age 20 to 24 years", "Age 25 to 29 years"),
																 `30-39` = c("Age 30 to 34 years", "Age 35 to 39 years"),
																 `40-49` = c("Age 40 to 44 years", "Age 45 to 49 years"),
																 `50-59` = c("Age 50 to 54 years", "Age 55 to 59 years"),
																 `60-69` = c("Age 60 to 64 years", "Age 65 to 69 years"),
																 `70-79` = c("Age 70 to 74 years", "Age 75 to 79 years"),
																 `80+` = c("Age 80 to 84 years", "Age 85 to 89 years", "Age 85 years and older")
	)) %>%
	mutate(age_grp3 = fct_collapse(AGEGROUP,
																 `0-5` = c("Age 0 to 4 years"),
																 `5-9` = "Age 5 to 9 years",
																 `10-19` = c("Age 10 to 14 years"),
																 `15-19` = "Age 15 to 19 years",
																 `20-24` = c("Age 20 to 24 years"),
																 `25-29` = c("Age 25 to 29 years"),
																 `30-34` = c("Age 30 to 34 years"),
																 `35-39` = c("Age 35 to 39 years"),
																 `40-44` = c("Age 40 to 44 years"),
																 `45-49` = c( "Age 45 to 49 years"),
																 `50-54` = c("Age 50 to 54 years"),
																 `55-59` = c( "Age 55 to 59 years"),
																 `60-64` = c("Age 60 to 64 years"),
																 `65-69` = c( "Age 65 to 69 years"),
																 `70-74` = c("Age 70 to 74 years"),
																 `75-79` = c("Age 75 to 79 years"),
																 `80+` = c("Age 80 to 84 years", "Age 85 to 89 years", "Age 85 years and older")
	)) %>%
	group_by(NAME, SEX, age_grp, age_grp2, age_grp3) %>%
	summarise(pop = sum(value)) %>%
	mutate(prop = pop/sum(pop)) %>%
	ungroup() %>%
	mutate(NAME = stringr::str_trim(stringr::str_remove(NAME, "County, North Carolina")))

nc_pop_age <- nc_aggregated %>% 
	group_by(NAME, age_grp3) %>% 
	summarise(pop = sum(pop)) %>% 
	group_by(NAME) %>% 
	mutate(prop = pop/sum(pop))

usethis::use_data(nc_pop_age, overwrite = T)

italy_rates <-tibble(
	age_grp = rep(c('0-9', '10-19', '20-29', '30-39', '40-49', '50-59', '60-69', '70-79', '80-89', '90+'), 2),
	sex = rep(c("Male", "Female"), each = 10),
	cfr = c(0, 0, 0, 0.6, 0.7,   1.7, 6.0, 17.8, 26.4, 32.5,
					0, 0, 0, 0.2,   0.4, 0.6, 2.8,  10.7, 19.1,   22.3) / 100,
	age_midpt = rep(c(5, 15, 25, 35, 45, 55, 65, 75, 85, 95), 2)
)

usethis::use_data(italy_rates)

overall_crit = readr::read_csv("https://gist.githubusercontent.com/medewitt/e8509153f40e960a60997276fd049c18/raw/9edd393af15d7155535e7d3931739d4622eb13eb/covid-mortality-rates.csv")

overall_crit

nc_fatality_estimates <- nc_aggregated %>%
	left_join(italy_rates, by = c("SEX" = "sex", "age_grp")) %>%
	left_join(overall_crit, by = c("age_grp2"="age_group")) %>%
	mutate(n_fatalities = cfr * pop) %>%
	mutate(n_hospitalized = pct_sympto_hospital * pop) %>%
	mutate(n_icu = n_hospitalized * pct_hosp_icu) %>%
	ungroup() %>%
	group_by(NAME) %>%
	summarise(pct_fatality = sum(n_fatalities)/sum(pop),
						n_fatality = sum(n_fatalities),
						pct_hospitalized = sum(n_hospitalized)/sum(pop),
						n_hospitalized = sum(pct_hospitalized),
						pct_icu = sum(n_icu)/sum(pop),
						n_icu = sum(n_icu),
						pop = sum(pop))

usethis::use_data(nc_fatality_estimates)

triad_counties <- c("Alamance", "Caswell", "Davidson", "Davie",
										"Forsyth", "Guilford", "Montgomery", "Randolph",
										"Rockingham", "Stokes", "Surrey", "Yadkin")

usethis::use_data(triad_counties)

cone_region <- c("Alamance", "Rockingham", "Randolph", "Guilford")

usethis::use_data(cone_region)

fatality_estimates %>%
	filter(NAME %in% c("Guilford", "Alamance", "Rockingham")) %>%
	select(starts_with("pct"), NAME) %>%
	gather(metric, value, -NAME) %>%
	ggplot(aes(reorder(metric, value), value))+
	geom_text(aes(label = round(value*100,digits = 1)), nudge_x = .1)+
	geom_point()+
	facet_wrap(~NAME)+
	coord_flip()+
	scale_y_continuous(labels = scales::percent_format(accuracy = 1))


# nc fips -----------------------------------------------------------------

dat <- data.table::fread(here::here("data-raw", "nc-fips.dat"), 
												 col.names = c("county", "fips"))
nc_county_fips=dat
usethis::use_data(nc_county_fips)
