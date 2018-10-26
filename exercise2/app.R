source('data_helpers.R')
source('input_helpers.R')
source('time_series_helpers.R')
source('bar_chart_helpers.R')
source('map_helpers.R')

# Define UI ----
ui <- fluidPage(
  titlePanel('Madrid Air Quality'),
  sidebarLayout(
    sidebarPanel(
      helpText('Gain insights in the air quality of Madrid.'),
      selectInput('stations', 'Stations', choices = listOfStations(), selected = listOfStations(), multiple=TRUE),
      selectInput('chemical', 'Chemical', choices = listOfChemicals()),
      dateRangeInput('date_range', 'Date range', start=startDate(), end=endDate()),
      checkboxInput('rain', 'Include rainfall', value = FALSE),
      checkboxInput('future', 'Predicut future values', value = FALSE)
    ),
    mainPanel(
      fluidRow(
        column(8,plotOutput("plot1")),
        column(4,plotOutput("plot2"))
      ),
      fluidRow(
        leafletOutput("map")
      )
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  
  data   <- fetchPolutionData(input$stations, input$chemical, input$date_range)
  rain   <- fetchRainData(input$date_range)
  future <- predictFuture(data)
  
  output$plot1 <- renderPlot(renderTimeSeriesPlot(data, rain, future))
  output$plot2 <- renderPlot(renderBarChart(data))
  output$map   <- renderLeaflet(renderMap(data))
}

# Run the app ----
shinyApp(ui = ui, server = server)