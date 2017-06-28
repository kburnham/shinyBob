

library(shiny)
library(tidyverse)
library(bobdylanr)
library(forcats)
library(stringr)
library(SnowballC)

#setwd("/Users/kb/Documents/MOOCs/BobDylanProject/BobDylan/")
lyrics <- bd_songs
albums <- bd_albums
ui <- fluidPage(titlePanel("Bob Dylan"),
                sidebarLayout(
                  sidebarPanel(
                    uiOutput("song_select"),
                    tableOutput("album"),
                    textInput("target_text", "Or search within all lyrics:"),
                    actionButton("search_button", label = "Search", icon = NULL, width = NULL),
                    tableOutput("song_finds")

                  ),
                  mainPanel(htmlOutput("lyrics"))

                )
)

server <- function(input, output, session) {
  output$song_select <- renderUI({
    selectInput("song",
                label = "Select a song . . .",
                choices = lyrics$Song,
                selected = "Shelter From The Storm")

  })
  values <- reactiveValues()
  observe({})
  output$lyrics <- renderUI({lyrics %>%
      filter(Song == input$song) %>%
      pull(Lyrics) %>% unlist %>%
      paste(collapse = "</br>") %>% HTML()})
  output$album <- renderTable({albums %>%
      filter(Song == input$song) %>%
      select(-Song) %>%
      arrange(as.numeric(Year))})
  output$song_finds <- renderTable({
    input$search_button
    query <- get_word_stems(input$target_text)
    found <- find_bd_lyrics(query)
  })
}


shinyApp(ui = ui, server = server)
