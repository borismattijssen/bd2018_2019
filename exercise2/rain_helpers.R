library(weatherData)

# columns from the data for WindSpeedAvgKMH and PrecipitationSumCM (respectively)
cols<-c(16)
stations_Madrid<- c("IMADRIDV3", "IMADRIDM44")

# TODO:
# add more Madrid stations
# fetched data = NULL -> check other stations
fetchRainData <- function(date_range){
  ## OUT: daily weather (Data, WindSpeedAvgKMH, PrecipitationSumCM)
  df<-getSummarizedWeather(stations_Madrid[1], start_date = date_range[1], date_range[2], station_type="id", opt_custom_columns=TRUE, custom_columns = cols)

  }

