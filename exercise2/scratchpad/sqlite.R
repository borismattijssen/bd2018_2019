library(DBI)

db <- dbConnect(RSQLite::SQLite(), "data/air_pollution.db")

query <- "SELECT DATE(date) FROM measurements WHERE date BETWEEN '2014-12-01' AND '2015-01-01' GROUP BY DATE(date)"
res <- dbSendQuery(db, query)
chunks <- dbFetch(res)
chunks[['DATE(date)']]
dbClearResult(res)
