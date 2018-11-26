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
      selectInput('stations', 'Stations', choices = listOfStations(), selected = 1, multiple=TRUE),
      selectInput('chemical', 'Chemical', choices = pollutants),
      dateRangeInput("date_range", 
                     "Date range",
                     start = startDate(),
                     end = endDate()),
      checkboxInput('rain', 'Include rainfall', value = FALSE),
      checkboxInput('wind', 'Include wind', value = FALSE)
    ),
    mainPanel(
      fluidRow(
        leafletOutput("map")
      ),
      fluidRow(
        textOutput("selected_var"),
        column(7,plotOutput("plot1", click = "plot_click")),
        column(5,plotOutput("plot2"))
      )
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  
  data   <- reactive({
    fetchPollutionData(input$stations, input$chemical, input$date_range)
  })
  
  data_all <- reactive({fetchAllData(input$chemical, input$date_range)})
  weather   <- reactive({
    if(input$rain || input$wind){ 
      return(fetchRainData(input$date_range))
    }
    return(NULL)
  })
  future <- reactive({
    predictFuture(data())
  })
  
  day_data <- reactive({
    day <- as.Date(input$plot_click$x, origin = "1970-01-01")
    fetchDayPollutionData(input$stations, input$chemical, day)
  })
  
  output$plot1 <- renderPlot({renderTimeSeriesPlot(data(), weather(), input$rain, input$wind, future(), input$chemical)})
  output$plot2 <- renderPlot({renderDayTimeSeriesPlot(day_data(), input$chemical)})
  output$map   <- renderLeaflet({renderMap(data_all(), input$stations, input$chemical)})
}


# Run the app ----
shinyApp(ui = ui, server = server)

