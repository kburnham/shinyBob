

library(shiny)
library(tidyverse)

setwd("/Users/kb/Documents/MOOCs/BobDylanProject/BobDylan/")
lyrics <- readRDS("bob_dylan_lyrics.rds")
albums <- readRDS("bob_dylan_albums.rds")
concerts <- readRDS("bob_dylan_concerts.rds")
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
