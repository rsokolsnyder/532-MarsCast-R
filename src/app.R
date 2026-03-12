library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(tidyr)

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
  ),
  div(
  layout_columns(
    plotOutput("pressure_min_temp_plot"),
    plotOutput("pressure_max_temp_plot")
  ),
  plotOutput("pressure_series"),
  plotOutput("temperature_series")
  )
)



server <- function(input, output) {
  
  filtered_data <- reactive({
    filtered <- mars |>
      mutate(datep = as.Date(terrestrial_date))
    
    if (input$month != 'All') {
      filtered <- filtered |>
        filter(month == input$month)
    }
    
    if (input$season == 'Summer'){
      filtered <- filtered |>
        filter(ls >= 270 & ls <= 360)
    } else if (input$season == 'Spring') {
      filtered <- filtered |>
        filter(ls >= 180 & ls <= 270)
    } else if (input$season == 'Winter') {
      filtered <- filtered |>
        filter(ls >= 90 & ls <= 180)
    } else if (input$season == 'Autumn') {
      filtered <- filtered |>
        filter(ls >= 0 & ls <= 90)
    }
    
    date_bounds <- sort(input$dates)
    filtered <- filtered |> filter(
      datep >= date_bounds[1],
      datep <= date_bounds[2]
    )
    
    filtered
  })
  
  output$pressure_min_temp_plot <- renderPlot(
    {
      filtered_data() |>
        ggplot(aes(x = pressure, y = min_temp)) +
        geom_point(color = '#FFAD70') +
        labs(
          title = "Pressure vs Minimum Temperature",
          x = "Pressure (Pa)",
          y = "Minimum Temperature (C)"
        ) +
        theme_minimal() +
        theme(aspect.ratio = 1)
    }
  )
  
  output$pressure_max_temp_plot <- renderPlot(
    {
      filtered_data() |>
        ggplot(aes(x = pressure, y = max_temp)) +
        geom_point(color = '#C1440E') +
        labs(
          title = "Pressure vs Maximum Temperature",
          x = "Pressure (Pa)",
          y = "Maximum Temperature (C)"
        ) +
        theme_minimal()+
        theme(aspect.ratio = 1)
    }
  )
  
  output$pressure_series <- renderPlot(
    {
      filtered_data() |>
        complete(datep = seq(min(datep), max(datep), by = "day")) |>
        ggplot(aes(x = datep, y = pressure)) +
        geom_line(color = '#FFAD70') +
        labs(
          title = "Daily Average Air Pressure",
          x = "Terrestrial Date",
          y = "Pressure (Pa)"
        ) + 
        theme_minimal()
    }
  )
  
  output$temperature_series <- renderPlot(
    {
      filtered_data() |>
        complete(datep = seq(min(datep), max(datep), by = "day")) |>
        pivot_longer(cols = c(min_temp, max_temp), names_to = "Temperature", values_to = "temp") |>
        ggplot(aes(x = datep, y = temp, color = Temperature)) +
        geom_line() +
        scale_color_manual(
          values = c(min_temp = "#FFAD70", max_temp = "#C1440E"),
          labels = c(min_temp = "Min Temp", max_temp = "Max Temp")
        ) +
        labs(
          title = "Daily Average Temperatures",
          x = "Terrestrial Date",
          y = "Temperature (C)"
        ) +
        theme_minimal()
    }
  )
  
}

shinyApp(ui = app_ui, server = server)