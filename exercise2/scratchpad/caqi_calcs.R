table <- fetchAllTable()
df < -calculateSubIndexes(table)


# Write table in db

db <- dbConnect(RSQLite::SQLite(), "data/air_pollution.db")
dbWriteTable(db, "measurements2",
             final)

# change the name to 'measurements 

res<-dbSendQuery(db, paste("DROP TABLE measurements", sep=""))

res<-dbSendQuery(db, paste("ALTER TABLE measurements2 RENAME TO measurements
", sep=""))

dbDisconnect(db)

mad2017<-read.csv("data/subset/madrid_2017.csv")
summary(mad2017)
