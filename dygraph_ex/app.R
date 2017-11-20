

library(tidyverse)
library(shiny)
library(dygraphs)
library(datasets)
library(timetk)

KINIRY <- read_rds("the_data.rds")

KINIRY <- KINIRY %>% arrange(date)

KINIRY <- ts(data = KINIRY$value, start = c(2010, 01), frequency = 12)




ui <- fluidPage(
                
      # Application title
      titlePanel("Predicted Deaths from Lung Disease (UK)"),
      
      # Sidebar for inputs
      sidebarLayout(
          sidebarPanel(
            numericInput("months", label = "Months to Predict", 
                         value = 72, min = 12, max = 144, step = 12),
            selectInput("interval", label = "Prediction Interval",
                        choices = c(0.80, 0.90, 0.95, 0.99),
                        selected = 0.95),
                        # choices = c("0.80", "0.90", "0.95", "0.99"),
                        # selected = "0.95"),
            checkboxInput("showgrid", label = "Show Grid", value = TRUE) ),
          
          # Area for graphs
          mainPanel(
            dygraphOutput("dygraph") )
        )
      ) 



# Define server logic required
server <- function(input, output) {
          
          
          output$dygraph <- renderDygraph({
                            dygraph(KINIRY, main = "Predicted Deaths/Month") %>%
                              dyOptions(drawGrid = input$showgrid)
                          })
  
          }



# Run the application 
shinyApp(ui = ui, server = server)

