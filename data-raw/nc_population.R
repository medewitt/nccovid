## code to prepare `nc_population` dataset goes here
library(data.table)
nc_population <- setDT(readxl::read_excel(here::here("data-raw", "countytotals_2020_2029.xls"), skip = 2))

nc_population <- janitor::clean_names(nc_population)

nc_population <- nc_population[!is.na(july_2020)]

usethis::use_data(nc_population, overwrite = TRUE)

# population per ncdhhs (latest acs) ---------------------------------------------------
library(tidyverse)
conn <- DBI::dbConnect(odbc::odbc(), "CBIEADS1")

county_info <- DBI::dbReadTable(conn = conn,
																DBI::Id(schema = "demographics",
																				table = "acs_county"))
DBI::dbDisconnect(conn)

county_info <- county_info %>% filter(State == 'North Carolina')

nc_pop_group <- county_info %>%
	select(contains("NBR")) %>%
	gather(age,pop) %>%
	mutate(dhhs_grouper = case_when(
		age %in% c("AgeUnder5NBR", "Age5to9NBR", "Age10to17NBR")~"0-17",
		age %in% c("Age18to24NBR")~"18-24",
		age %in% c("Age25to29NBR", "Age30to39NBR", "Age40to49NBR")~"25-49",
		age %in% c("Age50to59NBR", "Age60to64NBR")~"50-64",
		age %in% c("Age65to69NBR", "Age70to74NBR")~"65-74",
		age %in% c("Age75to79NBR", "AgeOver79NBR")~"75+",
	)) %>%
	group_by(dhhs_grouper) %>%
	summarise(pop = sum(pop))
nc_pop_dhhs <- nc_pop_group

usethis::use_data(nc_pop_dhhs, overwrite = TRUE)


# nc sex and demographics -------------------------------------------------

# County

nc_age <- county_info %>%
	select(contains("NBR"), County) %>%
	gather(age,pop, -County) %>%
	mutate(dhhs_grouper = case_when(
		age %in% c("AgeUnder5NBR", "Age5to9NBR", "Age10to17NBR")~"0-17",
		age %in% c("Age18to24NBR")~"18-24",
		age %in% c("Age25to29NBR", "Age30to39NBR", "Age40to49NBR")~"25-49",
		age %in% c("Age50to59NBR", "Age60to64NBR")~"50-64",
		age %in% c("Age65to69NBR", "Age70to74NBR")~"65-74",
		age %in% c("Age75to79NBR", "AgeOver79NBR")~"75+",
	)) %>%
	group_by(County, dhhs_grouper) %>%
	summarise(pop = sum(pop)) %>% 
	setNames(c("County", "metric", "population")) %>% 
	mutate(category = "age")

nc_sex_group <- county_info %>%
	select(contains(c("Male", "County")),Population) %>% 
	mutate(Male = round(MalePCT*Population),
				 Female = round((1-MalePCT)*Population))
# Sex 
nc_sex <- nc_sex_group %>% 
	select(County, Male, Female) %>% 
	gather(metric, population, -County) %>% 
	mutate(category = "sex")

# Ethnicity
nc_ethnicity <- county_info %>%
	select(starts_with(c("Hispanic")),Population, County) %>% 
	mutate(`Non-Hispanic` = Population - Hispanic) %>% 
	select(County, Hispanic, `Non-Hispanic`) %>% 
	gather(metric, population, -County) %>% 
	mutate(category = "ethnicity")

# Race

nc_race <- tidycensus::get_estimates(geography = "county",
														 product = "characteristics",
														 breakdown = c("RACE"),
														 breakdown_labels = TRUE,
														 state = "NC", key = CENSUS_KEY)

nc_race <- nc_race %>% 
	mutate(County = stringr::str_remove(NAME, " County, North Carolina")) %>% 
	filter(RACE != "All Races") %>% 
	filter(grepl(pattern = "alone$", RACE)) %>% 
	select(County, RACE, value) %>% 
	mutate(RACE = stringr::str_remove(RACE, " alone")) %>% 
	setNames(c("County", "metric", "population")) %>% 
	mutate(category = "race")

nc_county_demos <- nc_race %>% 
	bind_rows(nc_ethnicity) %>% 
	bind_rows(nc_sex) %>% 
	bind_rows(nc_age)

usethis::use_data(nc_county_demos, overwrite = TRUE)
