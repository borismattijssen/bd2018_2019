library(shiny)

# Define UI ----
ui <- fluidPage(
  titlePanel("Monica & Boris — the shiny app"),
  sidebarLayout(
    sidebarPanel("Some info"),
    mainPanel(
      p("Mucho emoji! 🎉 "),
      br(),
      code("$ such code")
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
