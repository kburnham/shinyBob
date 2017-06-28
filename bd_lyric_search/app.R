

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
         submitButton(text = "Search")
      ),

      # Show a plot of the generated distribution
      mainPanel(
         uiOutput("lyrics"),
         tableOutput("table")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    #output$lyrics <- renderText("Hello")
    output$lyrics <- renderUI({
      matches <- find_bd_lyrics(input$search_text)
      line_matches <- find_line_matches(matches$Song[1], input$search_text)
      highlight_matches(song_name = matches$Song[1], line_matches) %>% HTML()
      })

}


shinyApp(ui = ui, server = server)

