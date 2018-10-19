source("helpers.R")
counties <- readRDS("data/counties.rds")
library(maps)
library(mapproj)
library(shiny)

# Define UI ----
ui <- fluidPage(
  titlePanel("censusVis"),
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with information from the 2010 US Census."),
      selectInput("var", "Select a variable to display", 
                  choices = list("Percent White", "Percent Black", "Percent Hispanic", "Percent Asian")),
      sliderInput('interest', 'Range of interest', min=0, max=100, value=c(0,100))
    ),
    mainPanel(
      textOutput("selected_var"),
      br(),
      textOutput("selected_range"),
      plotOutput("map")
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  output$selected_var <- renderText({ 
    paste("You have selected", input$var)
  })
  output$selected_range <- renderText({
    paste("You have chosen a range that goes form", input$interest[1], " to ", input$interest[2])
  })
  output$map <- renderPlot({
    
    percent_map(switch(input$var, 
                       "Percent White" = counties$white,
                       "Percent Black" = counties$black,
                       "Percent Hispanic" = counties$hispanic,
                       "Percent Asian" = counties$asian),
                switch(input$var, 
                       "Percent White" = "darkgreen",
                       "Percent Black" = "black",
                       "Percent Hispanic" = "orange",
                       "Percent Asian" = "navy"),
                switch(input$var, 
                       "Percent White" = "% White",
                       "Percent Black" = "% Black",
                       "Percent Hispanic" = "% Hispanic",
                       "Percent Asian" = "% Asian"), input$interest[1], input$interest[2])
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)
