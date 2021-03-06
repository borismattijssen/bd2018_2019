library(reshape2)
library(scales)

renderTimeSeriesPlot <- function(data, weather, isRain, isWind, future, chemical, isTrendline, ranges){
  # set plot title
  title <- paste(chemical, " levels",sep="")
  
  # find station names
  n <- names(data)
  l <- length(n)
  n[2:l] = stationIdsToNames(n[2:l])
  data <- setNames(data, n)
  
  
  # Convert data to rate-of-change data if combined with rain data
  # if(isTRUE(isRain) && isTRUE(isWind)) {
  #   data <- left_join(data, weather, c("date", "date"))
  # }
  # else if(isTRUE(isRain)){
  #   data <- left_join(data, weather[,c("date", "rain")], c("date", "date"))
  # }
  # else if(isTRUE(isWind)){
  #   data <- left_join(data, weather[,c("date", "wind")], c("date", "date"))
  #   #data$rain = rain$Rain
  # }
  l <- length(data)
  # delta <- diff(as.matrix(data[2:l]))
  # data <- data[-nrow(data),]
  # data[2:l] <- delta / data[2:l]
  # 
  
  # convert to ggplot consumable data
  data_long <- melt(data, id="date")
  data_long <- setNames(data_long, c('date', 'station', 'value'))
  
  title <- paste("Pollution level of ", chemical, sep="")
  
  plot <- ggplot(data=data_long, aes(x=date, y=value, colour=station, group=station)) + 
    geom_line()+
    xlab('Date') + 
    ylab(chemical) + 
    theme_minimal() +
    theme(legend.justification = c(0, 1), legend.position = c(0, 1)) +
    scale_x_date(date_minor_breaks = "1 day") +
    coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE) + 
    ggtitle(title)
  
  if(isTRUE(isTrendline)) {
    plot <- plot + geom_smooth(method = "lm")
  }
  
  # If rain, plot rate-of-change, so plot percentages
  print(isWind)
  if(isTRUE(isWind)) {
    
    scale_factor = min(data_long$value, na.rm = TRUE)/max(weather$wind, na.rm = TRUE)
    weather$wind = weather$wind*scale_factor
    print(scale_factor)
    data <- left_join(data_long, weather[,c("date", "wind")], c("date", "date"))
    x.end <- data$date + 1
    y.start <- mean(data$wind)
    plot<-plot+geom_segment(data = data,
                            colour=alpha("grey",0.8),
                 size = 1,
                 aes(x = date,
                     xend = x.end,
                     y = y.start,
                     yend = wind),
                 arrow = arrow(length = unit(0.2, "cm")),
                 labels = "wind") 
    #plot <- plot + geom_area(data, inherit.aes = FALSE, mapping = aes(x=date, y=wind, group=station), fill = "yellow", alpha = 0.5) 
    
  }
  
   if(isTRUE(isRain)) {
     
     scale_factor = min(data_long$value, na.rm = TRUE)/max(weather$rain, na.rm = TRUE)*0.5
     weather$rain = weather$rain*scale_factor
     data <- left_join(data_long, weather[,c("date", "rain")], c("date", "date"))
     
    plot <- plot + geom_area(data, inherit.aes = FALSE, 
                             position = position_dodge(0.8), 
                             mapping = aes(x=date, y=rain, group=station), 
                             fill = "blue") 
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

renderDayTimeSeriesPlot <- function(data, chemical) {
  if(is.null(data)) return(NULL)
  
  # find station names
  n <- names(data)
  l <- length(n)
  n[2:l] = stationIdsToNames(n[2:l])
  data <- setNames(data, n)
  
  # convert to ggplot consumable data
  data_long <- melt(data, id="date")
  
  # plot
  ggplot(data=data_long, aes(x=date, y=value, colour=variable, group=variable)) + 
    geom_line() + 
    # geom_rect(inherit.aes = FALSE, data=data, aes(NULL, NULL, 
    #               xmin=date-1, xmax=date+1, 
    #               ymin=min(data_long$value), ymax=max(data_long$value), 
    #               fill=caqi))+
    xlab('Time') + 
    ylab(chemical) + 
    theme_minimal() +
    theme(legend.justification = c(0, 1), legend.position = c(0, 1)) +
    scale_x_datetime(labels = time_format("%H:%M"))+
    ggtitle(paste("Pollution level of ", chemical, " on ", as.Date(data$date, format("%d:%m:%Y")), sep=""))
}