library(reshape2)
library(scales)

renderTimeSeriesPlot <- function(data, rain, future){
  #    ggplot(data=rain, aes(x=Date, y=Rain)) +geom_line()
  data_long <- melt(data, id="date")
  ggplot(data=data_long, aes(x=date, y=value, colour=variable, group=variable)) + 
    geom_line() +
    scale_x_date(date_minor_breaks = "1 day")
}

renderDayTimeSeriesPlot <- function(data) {
  data_long <- melt(data, id="date")
  ggplot(data=data_long, aes(x=date, y=value, colour=variable, group=1)) + 
    geom_line() + 
    scale_x_datetime(labels = time_format("%H:%M"))
}