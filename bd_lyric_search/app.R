

library(shiny)

library(tidyverse)
library(bobdylanr)
library(forcats)
library(stringr)
library(SnowballC)
lyrics <- bd_songs

ui <- fluidPage(

   # Application title
   titlePanel("Bob Dylan Lyric Search"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
      sidebarPanel(
         textInput("search_text",
                     "Enter word(s) to search:"
                   ),
         tableOutput("matches")
      ),

      # Show a plot of the generated distribution
      mainPanel(
          uiOutput("title"),
          uiOutput("lyrics")

      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    matches <- reactive({
      if (input$search_text == "") return(data.frame())
      matches <- find_bd_lyrics(input$search_text)
    })

    output$matches <- renderTable({matches()})

    output$lyrics <- renderUI({
      if (nrow(matches()) == 0) return("No matches found")
      line_matches <- find_line_matches(matches()$Song[1], input$search_text)
      highlight_matches(song_name = matches()$Song[1], line_matches) %>% HTML()
    })

    output$title <- renderUI({matches()$Song[1] %>%
        as.character() %>%
        h2()})


}


shinyApp(ui = ui, server = server)

