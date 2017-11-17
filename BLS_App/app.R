
# BLS App

library(tidyverse)
library(shiny)


the_data <- read_rds("the_data.rds")


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Employment Situation"),
   
   # Show a plot of the generated distribution
   mainPanel(
      plotOutput("Unemployment_Plot")
   )
)





# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$Unemployment_Plot <- renderPlot({
      
     # Plot
     ggplot(the_data, aes(x = date, y = value)) +
       geom_hline(yintercept = mean(the_data$value, na.rm = TRUE), 
                  color = "white", size = 2) +
       geom_point(size = 3, color = "blue") +
       geom_line(color = "blue") +
       labs(x = NULL, y = NULL,
            title = "Employment Situation - Unemployment Rate",
            subtitle = "Source: Buruea of Labor Statistics") +
       scale_y_continuous(labels = scales::percent) 
     
   })
   
}






# Run the application 
shinyApp(ui = ui, server = server)

