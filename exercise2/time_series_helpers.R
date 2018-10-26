renderTimeSeriesPlot <- function(data, rain, future){
    t=seq(0,10,0.1)
    y=sin(t)
    plot(t,y,type="l", xlab="time", ylab="Sine wave")
}