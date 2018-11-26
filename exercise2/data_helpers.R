library(DBI)


# pollution levels
# reference https://www.airqualitynow.eu/download/CITEAIR-Comparing_Urban_Air_Quality_across_Borders.pdf
# the most important pollutants
pollutants <- c("NO_2", "PM10", "O_3", "SO_2", "CO")
NO_2 = c(0, 50, 100, 200, 400, Inf)
PM10= c(0, 25, 50, 90, 180, Inf)
O_3 = c(0, 60, 120, 180, 240, Inf)
SO_2 = c(0, 50, 100, 350, 500, Inf)
CO = c(0, 5000, 7500, 10000, 12500, Inf)
pollutionLevels = data.frame(NO_2, PM10, O_3, SO_2, CO)

fetchPollutionData <- function(stations, chemical, daterange) {
  db <- dbConnect(RSQLite::SQLite(), "data/air_pollution.db")
  
  query <- paste("SELECT DATE(date) FROM measurements WHERE date BETWEEN '", daterange[1], "' AND '", daterange[2], "' GROUP BY DATE(date)", sep="")
  res <- dbSendQuery(db, query)
  chunks <- dbFetch(res)
  dbClearResult(res)
  
  result <- data.frame("date" = as.Date(chunks[['DATE(date)']]))
  
  for(station in stations) {
    query <- paste("SELECT AVG(", chemical, ") FROM measurements WHERE station_id = ", station, " AND date BETWEEN '", daterange[1], "' AND '", daterange[2], "' GROUP BY DATE(date)", sep="")
    res <- dbSendQuery(db, query)
    chunks <- dbFetch(res)
    result[[station]] <- chunks[[paste('AVG(', chemical, ')', sep="")]]
    dbClearResult(res)
  }
  
  dbDisconnect(db)
  return(result)
}

fetchDayPollutionData <- function(stations, chemical, day) {
  db <- dbConnect(RSQLite::SQLite(), "data/air_pollution.db")
  
  query <- paste("SELECT date FROM measurements WHERE DATE(date) = '", day, "' AND station_id = ", stations[1], sep="")
  res <- dbSendQuery(db, query)
  chunks <- dbFetch(res)
  dbClearResult(res)
  
  result <- data.frame("date" = as.POSIXlt(chunks[['date']]))
  
  for(station in stations) {
    query <- paste("SELECT ", chemical, " FROM measurements WHERE station_id = ", station, " AND DATE(date) = '", day, "'", sep="")
    res <- dbSendQuery(db, query)
    chunks <- dbFetch(res)
    result[[station]] <- chunks[[chemical]]
    dbClearResult(res)
  }
  
  print(result)
  
  dbDisconnect(db)
  return(result)
}

fetchAllData <- function(chemical, daterange) {
  db <- dbConnect(RSQLite::SQLite(), "data/air_pollution.db")
  res<-dbSendQuery(db, paste("SELECT station_id, date, ", chemical, " FROM measurements WHERE date BETWEEN '", daterange[1], "' AND '", daterange[2], "'", sep=""))
  results <- dbFetch(res)
  dbClearResult(res)
  dbDisconnect(db)
  colnames(results)<-c("station_id", "date", "pollution")
  return(results)
}

fetchAllTable <- function() {
  db <- dbConnect(RSQLite::SQLite(), "data/air_pollution.db")
  res<-dbSendQuery(db, paste("SELECT * FROM measurements", sep=""))
  results <- dbFetch(res)
  dbClearResult(res)
  dbDisconnect(db)
  return(results)
}

calculateSubIndexes<-function(){
  
  data_all <- fetchAllData()
  labels <- factor(c(1,2,3,4,5), ordered = TRUE)
  
  df2 = data_all %>%
    group_by(station_id) %>%
    mutate(NO_2.ind = cut(NO_2, breaks = c(0, 50, 100, 200, 400, Inf), labels=labels)) %>%
    mutate(PM10.ind = cut(PM10, breaks = c(0, 25, 50, 90, 180, Inf), labels=labels)) %>%
    mutate(O_3.ind = cut(O_3, breaks = c(0, 60, 120, 180, 240, Inf), labels=labels)) %>%
    mutate(CO.ind = cut(CO, breaks = c(0, 5000, 7500, 10000, 12500, Inf), labels=labels)) %>%
    mutate(SO_2.ind = cut(SO_2, breaks = c(0, 50, 100, 350, 500, Inf), labels=labels)) 
  
  # some stuff to calculate CAQI Index
  # key_pollutants <- c("NO_2.ind", "PM10.ind",  "O_3.ind")
  # df2$caqi = apply(df2[key_pollutants], 1, function(x) max(x))
  # final<-merge(data_all, df2[,c("id", "caqi")], by="id" )
  
  return(df2)
  
}

stationsGeoData <- function(){
  
  return(read.csv("data/stations.csv"))
}


