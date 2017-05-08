#
library(shiny)
library(plotly)

data(table_for_shiny, package = "ggplot2")
nms <- names(table_for_shiny)

ui <- fluidPage(
  
  headerPanel("Arson Data"),
  p("Make sure that the x and y values are from the same year for the resulting graph to make sense."),
  sidebarPanel(
    sliderInput('sampleSize', 'Sample Size', min = 1, max = nrow(diamonds),
                value = 1000, step = 500, round = 0),
    selectInput('x', 'X', choices = nms, selected = "NUM_CASUALTIES_2007"),
    selectInput('y', 'Y', choices = nms, selected = "NUM_CASUALTIES_2010"),
    sliderInput('plotHeight', 'Height of plot (in pixels)', 
                min = 100, max = 2000, value = 1000)
  ),
  mainPanel(
    plotlyOutput('trendPlot', height = "900px")
  )
)

server <- function(input, output) {
  
  #add reactive data information. Dataset = built in diamonds data
  dataset <- reactive({
    table_for_shiny[sample(nrow(table_for_shiny), input$sampleSize),]
  })
  
  output$trendPlot <- renderPlotly({
    
    # build graph with ggplot syntax
    p <- ggplot(dataset(), aes_string(x = input$x, y = input$y, color = input$color)) + 
      geom_point()
    
    ggplotly(p) %>% 
      layout(height = input$plotHeight, autosize=TRUE)
    
  })
  
}

shinyApp(ui, server)
