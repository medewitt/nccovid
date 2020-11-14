# nccovid 0.0.2

* Added logic to account for data dumps from North Carolina with an optional argument in  `get_covid_state` called `report_adj` with a default of `FALSE` to account for two points
  * 2020-09-25 when all antigen tests were added 
  * 2020-11-13/2020-11-14 when data collection times changed and only 10 hours of data were collect.

The current method just imputes the previous days value for September for the death and case incidence on 25 September. 
For the November reporting change the 13/14 days are averaged across the two days. 
This should smooth out any reporting irregularity. 
This is important for calculating R or any other metrics that rely on daily data.
