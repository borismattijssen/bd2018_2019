library(weatherData)

# columns from the data for WindSpeedAvgMPH and PrecipitationSumCM (respectively)
cols<-c(14,16)
stations_Madrid<- c("IMADRIDV3", "IMADRIDM44")

fetchRainData <- function(date_range){
  ## OUT: daily weather (Data, WindSpeedAvgKMH, PrecipitationSumCM)
  df<-getSummarizedWeather(stations_Madrid[1], start_date = date_range[1], date_range[2], station_type="id", opt_custom_columns=TRUE, custom_columns = cols)
  colnames(df)<- c("date", "wind", "rain")

  df$date=as.Date(df$date)
  # drop last row
  df = df[-nrow(df),]
  return(df)
  }
