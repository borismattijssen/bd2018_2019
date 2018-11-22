library(DBI)

stations <- NULL

listOfStations <- function(){
  if(is.null(stations)) {
    db <- dbConnect(RSQLite::SQLite(), "data/air_pollution.db")
    res <- dbSendQuery(db, "SELECT id, name FROM stations ORDER BY name")
    chunk <- dbFetch(res)
    dbClearResult(res)
    dbDisconnect(db)
    stations <- setNames(chunk$id, chunk$name)
  }
  stations
}
listOfChemicals <- function(){
  db <- dbConnect(RSQLite::SQLite(), "data/air_pollution.db")
  res <- dbListFields(db, 'measurements')
  dbDisconnect(db)
  res[-c(1,2,3)]
}
startDate <- function(){
  #as.Date('2001-01-01 01:00:00')
  as.Date('2014-12-01 01:00:00')
}
endDate <- function(){
  as.Date('2015-01-01 00:00:00')
}