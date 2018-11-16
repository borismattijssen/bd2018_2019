library(DBI)

fetchPolutionData <- function(stations, chemical, daterange) {
  print("test2")
  print(stations)
  result <- list()
  db <- dbConnect(RSQLite::SQLite(), "data/air_pollution.db")
  for(station in stations) {
    query <- paste("SELECT ", chemical, " FROM measurements WHERE station_id = ", stations[1], " AND date BETWEEN '", daterange[1], "' AND '", daterange[2], "'", sep="")
    res <- dbSendQuery(db, query)
    chunks <- dbFetch(res)
    result[[station]] <- chunks[[chemical]]
    #print(chunks[[chemical]])
    dbClearResult(res)
  }

  dbDisconnect(db)
  return(result)
}

terst <- function(i,j) {
  print(i)
  print(j)
}
