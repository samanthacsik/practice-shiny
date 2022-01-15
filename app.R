# load libraries ----
library(shiny)
# ui ----
ui <- fluidPage(
  titlePanel("Exploring Antarctic Penguins & Weather"),
  sidebarLayout("This is my first sidebar",
    sidebarPanel("scatterplot sliderInput here"),
    mainPanel("reactive scatterplot output here")
  ),
  sidebarLayout("This is my second sidebar",
                sidebarPanel("histogram selectInput here"),
                mainPanel("reactive histogram output here")
  )
)
# server instructions ----
server <- function(input, output) {}
# run app ----
shinyApp(ui = ui, server = server)











# load packages ----
# library(shiny)
# library(palmerpenguins)
# library(tidyverse)
# library(DT)
# library(bslib)
# library(thematic)
# library(shinyWidgets)

# enable thematic for plotOutputs ----
# thematic_shiny()

# # ui ----
# ui <- fluidPage(
#   
#   # app title ----
#   tags$h1("My App Title"),
#   # app subtitle ----
#   p(strong("Exploring Antarctic Penguins and Temperatures")),
#   
#   # body mass slider input ----
#   sliderInput(inputId = "body_mass", label = "Select a range of body masses (g):",
#               value = c(3000, 4000), min = 2700, max = 6300),
#   
#   # body mass plot output ----
#   plotOutput(outputId = "bodyMass_scatterPlot")
# )
# 
# # server ----
# server <- function(input, output){
#   
#   # render the scatter plot ----
#   output$bodyMass_scatterPlot <- renderPlot({
#     
#     # filter body mass data ----
#     body_mass_dat <- penguins %>%
#       filter(body_mass_g %in% input$body_mass[1]:input$body_mass[2])
#     
#     # plot scatterplot ----
#     ggplot(na.omit(body_mass_dat),
#            aes(x = flipper_length_mm, y = bill_length_mm, color = species, shape = species)) +
#       geom_point() +
#       scale_color_manual(values = c("#FEA346", "#B251F1", "#4BA4A4")) +
#       scale_shape_manual(values = c(19, 17, 15)) +
#       labs(x = "Flipper length (mm)", y = "Bill length (mm)",
#            color = "Penguin species", shape = "Penguin species") +
#       theme_minimal() +
#       theme(legend.position = c(0.85, 0.2),
#             legend.background = element_rect(color = "white"))
#   })
#   
# }
# 
# shinyApp(ui = ui, server = server)
#   