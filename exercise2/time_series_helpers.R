library(reshape2)
library(scales)

renderTimeSeriesPlot <- function(data, rain, future, chemical){
  # set plot title
  title <- paste(chemical, " levels",sep="")
  
  # find station names
  n <- names(data)
  l <- length(n)
  n[2:l] = stationIdsToNames(n[2:l])
  print(n)
  data <- setNames(data, n)
  
  # Convert data to rate-of-change data if combined with rain data
  if(!is.null(rain)) {
    data$rain = rain$Rain
    l <- length(data)
    delta <- diff(as.matrix(data[2:l]))
    data <- data[-nrow(data),]
    data[2:l] <- delta / data[2:l]
    
    title <- paste("Rate-of-change for ", chemical, " and rainfall", sep="")
  }
  
  # convert to ggplot consumable data
  data_long <- melt(data, id="date")
  data_long <- setNames(data_long, c('date', 'station', 'value'))
  
  plot <- ggplot(data=data_long, aes(x=date, y=value, colour=station, group=station)) + 
    geom_line() +
    xlab('Date') + 
    ylab(chemical) + 
    theme(legend.justification = c(0, 1), legend.position = c(0, 1)) +
    scale_x_date(date_minor_breaks = "1 day") +
    ggtitle(title)
  
  # If rain, plot rate-of-change, so plot percentages
  if(!is.null(rain)) {
    plot <- plot + scale_y_continuous(labels = percent)
  }
  
  return(plot)
}

stationIdsToNames <- function(ids) {
  s <- listOfStations()
  n <- names(s)
  l <- length(ids)
  for(i in 1:l) {
    ids[[i]] <- n[s == ids[i]]
  }
  return(ids)
}

renderDayTimeSeriesPlot <- function(data) {
  data_long <- melt(data, id="date")
  ggplot(data=data_long, aes(x=date, y=value, colour=variable, group=1)) + 
    geom_line() + 
    scale_x_datetime(labels = time_format("%H:%M"))
}