## code to prepare `nc_population` dataset goes here
library(data.table)
nc_population <- setDT(readxl::read_excel(here::here("data-raw", "countytotals_2020_2029.xls"), skip = 2))

nc_population <- janitor::clean_names(nc_population)

nc_population <- nc_population[!is.na(july_2020)]

usethis::use_data(nc_population, overwrite = TRUE)

# population per ncdhhs ---------------------------------------------------
library(tidyverse)
conn <- DBI::dbConnect(odbc::odbc(), "DS_Team")

county_info <- DBI::dbReadTable(conn = conn,
																DBI::Id(schema = "demographics",
																				table = "acs_county"))
DBI::dbDisconnect(conn)

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
