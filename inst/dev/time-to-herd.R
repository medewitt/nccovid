a <- nccovid::get_vaccinations(county_list = nccovid::triad_counties)
a[,rate:=daily_dose_1/days_available]
a[,days_to_herd:=population*.5/rate]
a <- a[order(days_to_herd)]
dotchart(x = a$days_to_herd, 
				 labels = a$county, 
				 main = "Days to Herd Immunity\n(50% Vax Given 20% Infected)", xlab = "Days")
