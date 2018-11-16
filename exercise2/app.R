source('input_helpers.R')
source('data_helpers.R')
source('rain_helpers.R')
source('prediction_helpers.R')
source('time_series_helpers.R')
source('bar_chart_helpers.R')
source('map_helpers.R')

# Define UI ----
ui <- fluidPage(
  titlePanel('Madrid Air Quality'),
  sidebarLayout(
    sidebarPanel(
      helpText('Gain insights in the air quality of Madrid.'),
      selectInput('stations', 'Stations', choices = listOfStations(), selected = c(), multiple=TRUE),
      selectInput('chemical', 'Chemical', choices = listOfChemicals()),
      dateRangeInput("date_range", 
                     "Date range",
                     start = "2018-07-01", 
                     end = as.character(Sys.Date())),
      checkboxInput('rain', 'Include rainfall', value = TRUE),
      checkboxInput('future', 'Predicut future values', value = FALSE)
    ),
    mainPanel(
      fluidRow(
        textOutput("selected_var"),
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
  
  data   <- reactive({
    fetchPolutionData(input$stations, input$chemical, input$date_range)
  })
  rain   <- reactive({
    fetchRainData(input$date_range)
  })
  future <- reactive({
    predictFuture(data())
  })
  
  output$plot1 <- renderPlot({renderTimeSeriesPlot(data(), rain(), future())})
  output$plot2 <- renderPlot({renderBarChart(data())})
  output$map   <- renderLeaflet({renderMap(data())})
}


# Run the app ----
shinyApp(ui = ui, server = server)

