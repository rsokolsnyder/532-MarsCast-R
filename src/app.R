library(shiny)
library(bslib)
library(dplyr)

# load data
mars <- read.csv("../data/mars-weather.csv")

app_ui <- page_sidebar(
  title = "MarsCast",
  sidebar = sidebar(
    selectInput(
      "month",
      "Martian Month",
      choices = list("All", "Month 1", "Month 2", "Month 3", "Month 4",
                       "Month 5", "Month 6", "Month 7", "Month 8", "Month 9",
                       "Month 10", "Month 11", "Month 12"),
      selected = "All"
    ),
    selectInput(
      "season",
      "Season on Mars",
      choices = list("All", "Winter", "Spring", "Summer", "Autumn"),
      selected = "All"
    ),
    dateRangeInput(
      "dates", 
      "Select dates",
      start = min(mars$terrestrial_date),
      end = max(mars$terrestrial_date)
    )
  )
)

server <- function(input, output) {
  
  filtered_data <- reactive({
    mars |>
      filter(
        ifelse(input$month!="All", month = input$month)
      )
  })
  
  
}

shinyApp(ui = app_ui, server = server)