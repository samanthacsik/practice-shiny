# load packages ----
library(shiny)
library(shinydashboard)
library(palmerpenguins)
library(tidyverse)
library(DT)
library(bslib)
library(thematic)
library(shinyWidgets)
library(reactlog)

# import data ----

# ui ----
ui <- dashboardPage(
  
  # change color theme ("skin") ----
  skin = "black",
  
  # add a title ---
  dashboardHeader(
    title = "Exploring Antarctic Penguins & Weather",
    titleWidth = 400
  ),
  
  # add a sidebar and menu items; check out icons below ----
  # https://fontawesome.io/icons/
  # https://getbootstrap.com/docs/3.4/components/#glyphicons (need to include `lib` argument to use these)
  dashboardSidebar(
    width = 400,
    sidebarMenu(
      menuItem("Background", tabname = "background", icon = icon("book-open")),
      menuItem("Penguin Dashboard", tabname = "penguins", icon = icon("snowflake"),
               menuItem("Flipper x Bill lengths", tabname = "scatterplot"),
               menuItem("Flipper Lengths by Island & Species", tabname = "histogram")),
      menuItem("Antarctic Weather Dashboard", tabname = "weather", icon = icon("thermometer-half")),
      menuItem("Data", tabname = "data", icon = icon("file"),
               menuItem("{palmerpenguins} Data", tabname = "penguin_dat"),
               menuItem("Palmer Station Temperature Data"), tabname = "temp_dat")
    )
  ),
  
  # add content for each menu item ----
  dashboardBody(
    
    tabItems(
      
      # tab 1: background content ----
      tabItem(tabName = "background",
        fluidRow(
          
          # penguin image radioButton input ----
          box( 
            radioButtons(
              inputId = "img", label = "Choose a penguin to display:",
              choices = c("All penguins", "Sassy chinstrap", "Staring gentoo", "Adorable adelie"),
              selected = "All penguins")
          ),
          
          # penguin image output ----
          box(imageOutput(outputId = "penguin_img"))
        )
      )
    )
  )
)


# server ----
server <- function(input, output) {
  
  # render penguin images ----
  # output$penguin_img <- renderImage({
  #   
  #   if(input$img == "All penguins"){
  #     list(src = "www/all_penguins.jpeg", height = 240, width = 300,
  #          alt = "")
  #   }
  #   else if(input$img == "Sassy chinstrap"){
  #     list(src = "www/chinstrap.jpeg", height = 240, width = 300,
  #          alt ="")
  #   }
  #   else if(input$img == "Staring gentoo"){
  #     list(src = "www/gentoo.jpeg", height = 240, width = 300,
  #          alt = "")
  #   }
  #   else if(input$img == "Adorable adelie"){
  #     list(src = "www/adelie.gif", height = 240, width = 300,
  #          alt = "An adelie penguin using it's feet to push itself along the ice on it's belly.")
  #   }
  #   
  # }, deleteFile = FALSE)
  
}

# combine UI & server into an app ----
shinyApp(ui = ui, server = server)