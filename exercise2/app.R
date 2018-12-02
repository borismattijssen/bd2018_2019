source('input_helpers.R')
source('data_helpers.R')
source('rain_helpers.R')
source('prediction_helpers.R')
source('time_series_helpers.R')
source('bar_chart_helpers.R')
source('map_helpers.R')

# Define UI ----
ui <- fluidPage(
  theme = "tooltip.css",
  tags$script(src = "tooltip.js"),
  
  titlePanel('Madrid Air Quality'),
  sidebarLayout(
    sidebarPanel(
      helpText('Gain insights in the air quality of Madrid.'),
      selectInput('stations', 'Stations', choices = listOfStations(), selected = c('28079016'), multiple=TRUE),
      selectInput('chemical', 'Chemical', choices = pollutants),
      dateRangeInput("date_range", 
                     "Date range",
                     start = startDate(),
                     end = endDate()),
      checkboxInput('rain', 'Include rainfall', value = FALSE),
      checkboxInput('wind', 'Include wind', value = FALSE),
      actionButton('load', 'Load')
    ),
    mainPanel(
      style = "position: inherit",
      fluidRow(
        leafletOutput("map")
      ),
      fluidRow(
        textOutput("selected_var"),
        column(7,plotOutput("plot1", click = "plot_click", hover = hoverOpts("plot_hover", delay = 0))),
        uiOutput("my_tooltip"),
        column(5,plotOutput("plot2"))
      )
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  
  data   <- eventReactive(input$load, {
    fetchPollutionData(input$stations, input$chemical, input$date_range)
  })
  data_all <- eventReactive(input$load, {
    fetchAllData(input$chemical, input$date_range)
  })
  weather   <- eventReactive(input$load, {
    if(input$rain || input$wind){ 
      return(fetchRainData(input$date_range))
    }
    return(NULL)
  })
  future <- eventReactive(input$load, {
    predictFuture(data())
  })
  day_data <- eventReactive(input$plot_click, {
    day <- as.Date(input$plot_click$x, origin = "1970-01-01")
    fetchDayPollutionData(input$stations, input$chemical, day)
  })
  
  chemical <- eventReactive(input$load, {input$chemical})
  rain <- eventReactive(input$load, {input$rain})
  wind <- eventReactive(input$load, {input$wind})
  
  output$plot1 <- renderPlot({renderTimeSeriesPlot(data(), weather(), rain(), wind(), future(), chemical())})
  output$plot2 <- renderPlot({renderDayTimeSeriesPlot(day_data(), chemical())})
  output$map   <- renderLeaflet({renderMap(data_all(), chemical())})
  
  # create tooltip value
  output$my_tooltip <- renderUI({
    hover <- input$plot_hover 
    req(!is.null(hover))
    format(as.Date(hover$x, origin = "1970-01-01"), format="%Y-%m-%d")
  })

}


# Run the app ----
shinyApp(ui = ui, server = server)

