# nccovid 0.0.21

* ncdhhs removed data and changed column names in dataset used in get_hospitalizations() function, some columns are now unavailable and others have been renamed to their previous names for back compatibility.

# nccovid 0.0.20

* bug fix: get_covid_county_demographics() was not reporting deaths anymore after NCDHHS changed to a monthly instead of weekly report on deaths

# nccovid 0.0.19

* get_cdc_detail() downloads data directly from cdc on call instead of pulling from repo

# nccovid 0.0.18

* Fix get_county_covid_demographics() where updated state data added ' County' to the names of the counties

# nccovid 0.0.17

* Updating population estimates from 2018 ACS to 2020 ACS.
* Pointing reproduction number pulls (`pull_estimates`) to new Cori et al estimates in [r-estimates-cori github repository](https://github.com/conedatascience/r-estimates-cori)

# nccovid 0.0.16

* **BUGFIX**: Update pull_covid_summary() for new
"Reinfection Cases by Speciman Date" column in the raw data.

# nccovid 0.0.15

* Ensure that smoothing of the daily rates continues for several years (into 2025)

# nccovid 0.0.14

* Fixed holidays through July 4th of 2022
* Fixed a column ordering issue with `get_covid_county_demographics`
* Fixed error introduced in `get_google_mobility2`

# nccovid 0.0.13

* Speed up google mobility function calls

# nccovid 0.0.8

* Fix Veteran's Day reporting lag
* Added a basic herd immunity calculation function in the form of `hit`

# nccovid 0.0.7

* Updated `get_covid_state` to reflect the reporting irregularity around September 4th.
* Updated functions to ensure correct field names were used (hospitalization details)
* Updated functions around converting growth rates to reproduction numbers

# nccovid 0.0.6

* Added `calculate_community_immunity` in order to estimate the level of community immunity

# nccovid 0.0.4

* Added `get_cdc_vax` and `get_cdc_detail` to more easily retrieve information from the CDC on the spread of SARS-CoV-2 by county


# nccovid 0.0.3
* Added a smoother for reporting delays for Alamance and Guilford counties between 1 May and 21 May for the adjusted case metrics.
* `pull_vaccine_census` now available to pull vaccination rates at the Census Tract


# nccovid 0.0.2

* Added logic to account for data dumps from North Carolina with an optional argument in  `get_covid_state` called `report_adj` with a default of `FALSE` to account for two points
  * 2020-09-25 when all antigen tests were added 
  * 2020-11-13/2020-11-14 when data collection times changed and only 10 hours of data were collect.
* Added `get_hospitalizations` to retrieve hospitalisation data 
* Added North Carolina Healthcare Preparation Coalitions as a data set 
The current method just imputes the previous days value for September for the death and case incidence on 25 September. 
For the November reporting change the 13/14 days are averaged across the two days. 
This should smooth out any reporting irregularity. 
This is important for calculating R or any other metrics that rely on daily data.
