## code to prepare `nc_population` dataset goes here
library(data.table)
nc_population <- setDT(readxl::read_excel(here::here("data-raw", "countytotals_2020_2029.xls"), skip = 2))

nc_population <- janitor::clean_names(nc_population)

nc_population <- nc_population[!is.na(july_2020)]

usethis::use_data(nc_population, overwrite = TRUE)
