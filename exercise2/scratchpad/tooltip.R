library(shiny)
library(ggplot2)

ui <- fluidPage(
  
  tags$head(tags$style('
                       #my_tooltip {
                       position: absolute;
                       width: 300px;
                       z-index: 100;
                       }
                       ')),
  tags$script('
              $(document).ready(function(){
              // id of the plot
              $("#plot1").mousemove(function(e){ 
              
              // ID of uiOutput
              $("#my_tooltip").show();         
              $("#my_tooltip").css({             
              top: (e.pageY + 5) + "px",             
              left: (e.pageX + 5) + "px"         
              });     
              });     
              });
              '),
  
  selectInput("var_y", "Y-Axis", choices = names(mtcars), selected = "disp"),
  plotOutput("plot1", hover = hoverOpts(id = "plot_hover", delay = 0)),
  uiOutput("my_tooltip")
  )

server <- function(input, output) {
  
  data <- reactive({
    mtcars
  })
  
  output$plot1 <- renderPlot({
    req(input$var_y)
    ggplot(data(), aes_string("mpg", input$var_y)) + 
      geom_point(aes(color = factor(cyl)))
  })
  
  output$my_tooltip <- renderUI({
    hover <- input$plot_hover 
    y <- nearPoints(data(), input$plot_hover)[ ,c("mpg", input$var_y)]
    req(nrow(y) != 0)
    verbatimTextOutput("vals")
  })
  
  output$vals <- renderPrint({
    hover <- input$plot_hover 
    y <- nearPoints(data(), input$plot_hover)[ , c("mpg", input$var_y)]
    # y <- nearPoints(data(), input$plot_hover)["wt"]
    req(nrow(y) != 0)
    # y is a data frame and you can freely edit content of the tooltip 
    # with "paste" function 
    y
  })
}
shinyApp(ui = ui, server = server)