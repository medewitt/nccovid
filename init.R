usethis::use_package("data.table")
usethis::use_package("dplyr")
usethis::use_data_raw("covid_mortality_data")
usethis::use_readme_rmd()
usethis::use_mit_license()
usethis::use_package_doc()
usethis::git_vaccinate
usethis::use_lifecycle_badge("experimental")
usethis::use_travis()

devtools::document()
usethis::use_data_raw(name = "nc-specific")
