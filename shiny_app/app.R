library(tidyverse)
library(tidyquant)
library(ggplot2)

ex_stocks <- tq_get(c("PG"), get  = "stock.prices",
                    from = "2010-01-01", to = "2023-10-01")

ui <- fluidPage(
  titlePanel("Interactive Insight P&G Price Over Time"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("line_color", "Select Line Color:", value = "#0072B2"),
      
      tags$head(tags$script("$(document).on('shiny:connected', function(event) {
                      $('#line_color').attr('type', 'color');
                  });")),
      
      sliderInput("line_size", "Select Line Size:", min = 0.5, max = 3, value = 0.8, step = 0.1),
      dateRangeInput("date_range", "Select Date Range:", start=min(ex_stocks$date), end=max(ex_stocks$date))
    ),
    mainPanel(
      plotOutput("stockPlot")
    )
  )
)



# Server Function
server <- function(input, output) {
  output$stockPlot <- renderPlot({
    filtered_data <- subset(ex_stocks, date >= input$date_range[1] & date <= input$date_range[2])
    
    ggplot(filtered_data, aes(x = date, y = adjusted)) + 
      geom_line(color = input$line_color, size = input$line_size) +
      labs(title = "Insight P&G Price Over Time",
           caption = "Data source: Yahoo Finance",
           x = "Date",
           y = "Adjusted Stock Price($)") +
      theme_minimal() +
      theme(
        plot.title = element_text(face="bold", size=16, hjust=0.5),
        plot.caption = element_text(size=10, hjust=1), 
        axis.title.x = element_text(size=13, face="bold"),
        axis.title.y = element_text(size=13, face="bold"),
        axis.text.x = element_text(angle=45, vjust=0.5)
      )
  })
}

# Run the Shiny app
shinyApp(ui, server)
