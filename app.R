library(mapproj)
library(maps)
library(ggmap)

ui = (fluidPage(
  titlePanel("Arson Maps"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create maps relating state to the number of incidents of arson."),
      
      selectInput("var", 
                  label = "Choose a year to display",
                  choices = c("2007", "2010",
                              "2013", "2015"),
                  selected = "2007")
      
    ),
    mainPanel(plotOutput("map"))
  )
))



server = (
  function(input, output) {
    output$map <- renderPlot({
      data <- switch(input$var, 
                     "2007" = state_incident_table,
                     "2010" = state_incident_table10,
                     "2013" = state_incident_table13,
                     "2015" = state_incident_table15)
      
      color <- switch(input$var, 
                      "2007" = "darkgreen",
                      "2010" = "black",
                      "2013" = "darkorange",
                      "2015" = "darkviolet")
      
      legend <- switch(input$var, 
                       "2007" = "2007",
                       "2010" = "2010",
                       "2013" = "2013",
                       "2015" = "2015")
      myMap <- get_map(location = "Montana", zoom = 3, maptype = "roadmap")
      ggmap(myMap) + geom_point(aes(x = state_ll$V1.lon, y = state_ll$V1.lat), data = data, alpha = .5, color = "darkred", size = ((data$N)/1000))
      
    })
  }
)


# Run the application 
shinyApp(ui = ui, server = server)

