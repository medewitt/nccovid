## code to prepare `nc_delay` dataset goes here
# NCDHHS Reporting Data Starting 2020-10-29
lab_results <- c(
	1.4,
	1.4,
	1.4,
	1.6,
	1.8,
	1.5,
	1.2,
	1.3,
	1.3,
	1.4,
	1.6,
	1.8,
	1.6,
	1.4,
	1.5,
	1.7,
	1.7,
	1.8,
	1.9,
	2,
	1.5,
	1.6,
	1.6,
	1.6,
	1.9,
	2.2,
	1.9,
	1.6,
	1.7,
	1.9,
	2,
	1.8,
	1.1,
	1.1,
	1.3,
	1.6,
	1.6,
	1.8
)

electronic_report <- c(
	.9,
	1,
	.8,
	.6,
	.7,
	.9,
	3.2,
	.8,
	.8,
	.8,
	.7,
	.8,
	1.3,
	1,
	.5,
	1.1,
	.8,
	.8,
	.8,
	4.6,
	3.5,
	.7,
	.8,
	.8,
	.8,
	.6,
	1,
	1,
	.6,
	1.1,
	1,
	1,
	1.6,
	1.3,
	1.1,
	1.1,
	1,
	.8
	
)

dates <- seq.Date(from = as.Date("2020-10-29"), by = 1, length.out = length(lab_results))

combined_delay <- lab_results+electronic_report

nc_delay <- EpiNow2::bootstrapped_dist_fit(combined_delay, dist = "gamma")

usethis::use_data(nc_delay, overwrite = TRUE)
