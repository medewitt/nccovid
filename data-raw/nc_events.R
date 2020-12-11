# Keeping Track of Key Events in North Carolina

nc_events <- tibble::tribble(
	~"event", ~"date",
	"Phase 1", "2020-05-08",
	"Phase 2", "2020-05-22",
	"Phase 2.5", "2020-09-05",
	"Phase 3", "2020-10-02",
	"UNC-CH In Session", "2020-08-10",
	"Mask Mandate", "2020-06-26",
	"Curfew 10pm-5am", "2020-12-11",
)

nc_events$date <-as.Date(nc_events$date)

usethis::use_data(nc_events, overwrite = T)
