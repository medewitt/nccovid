## code to prepare `covid_mortality_data` dataset goes here

covid_mortality_data <- data.table::fread("https://gist.githubusercontent.com/medewitt/e8509153f40e960a60997276fd049c18/raw/9edd393af15d7155535e7d3931739d4622eb13eb/covid-mortality-rates.csv")

usethis::use_data(covid_mortality_data)
