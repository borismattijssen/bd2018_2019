library(DBI)

listOfStations <- function(){
  db <- dbConnect(RSQLite::SQLite(), "data/air_pollution.db")
  res <- dbSendQuery(db, "SELECT id, name FROM stations ORDER BY name")
  chunk <- dbFetch(res)
  dbClearResult(res)
  dbDisconnect(db)
  setNames(chunk$id, chunk$name)
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