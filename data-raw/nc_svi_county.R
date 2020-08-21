## code to prepare `nc_svi_county` dataset goes here
nc_svi_county <- sv_nc <- readr::read_csv(here::here("data-raw", "NorthCarolina_SVI.csv"))

usethis::use_data(nc_svi_county, overwrite = TRUE)
