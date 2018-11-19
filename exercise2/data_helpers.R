library(DBI)

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