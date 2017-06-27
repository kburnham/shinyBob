

library(shiny)
library(tidyverse)
library(bobdylanr)


#setwd("/Users/kb/Documents/MOOCs/BobDylanProject/BobDylan/")
lyrics <- bd_songs
albums <- bd_albums
ui <- fluidPage(titlePanel("Bob Dylan"),
                sidebarLayout(
                  sidebarPanel(
                    uiOutput("song_select"),
                    tableOutput("album")

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
  output$lyrics <- renderUI({lyrics %>% filter(Song == input$song) %>% .$Lyrics %>% unlist %>%  paste(collapse = "</br>") %>% HTML()})
  output$album <- renderTable({albums %>% filter(Song == input$song) %>% select(-Song)})
}


shinyApp(ui = ui, server = server)
