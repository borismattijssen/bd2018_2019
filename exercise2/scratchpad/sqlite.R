library(DBI)

con <- dbConnect(RSQLite::SQLite(), "~/Downloads/test.db")

res <- dbSendQuery(con, "SELECT * FROM stations")
chunk <- dbFetch(res)
print(chunk)

dbClearResult(res)
dbDisconnect(con)
