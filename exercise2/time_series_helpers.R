renderTimeSeriesPlot <- function(data, rain, future ){
    ggplot(data=rain, aes(x=Date, y=Rain)) +geom_line()
}