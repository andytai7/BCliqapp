library(shiny)
library(tidyverse)
options(shiny.autoreload = TRUE)

bcl <- read_csv("bcl-data.csv")

ui <- fluidPage(
  titlePanel("BC Liquor Alcohol Content Explorer"),
  fluidRow(
    column(
      width = 12,
      sidebarPanel(
        sliderInput("price",
                    label = "Select a price range",
                    min= 0,
                    max = 100,
                    value = c(20, 35),
                    pre = "$")
      )
      ),
      column(
        width = 8,
        sidebarPanel(
        radioButtons("beverage",
                     label = "Select beverage type.",
                     choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE")
        )
      )
      ),
    plotOutput("plot"),
    tableOutput("table")
  )
)



server <- function(input, output) {

  bcl_filtred <- reactive({
    bcl %>%
    filter(Price < input$price[2],
           Price > input$price[1],
           Type == input$beverage)
  })

  output$plot <- renderPlot({
    print(as.list(input))
    ggplot(bcl_filtred(), aes(Alcohol_Content)) +
      geom_histogram()
  })

  output$table <-  renderTable({
    bcl_filtred()
  })
}

shinyApp(ui = ui, server = server)
