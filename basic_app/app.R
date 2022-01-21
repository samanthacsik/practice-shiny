# load packages ----
library(shiny) 
library(palmerpenguins)
library(tidyverse)

# user interface ----
ui <- fluidPage(
  
  # app title ----
  tags$h1("My App Title"), 
  
  p(strong("Exploring Antarctic Penguins and Temperatures")), 
  
  # body mass slider ----
  sliderInput(inputId = "body_mass", label = "Select a range of body masses (g):", 
              value = c(3000, 4000), min = 2700, max = 6300),
  
  # body mass plot output ----
  plotOutput(outputId = "bodyMass_scatterPlot"),
  
  # penguin data table output ----
  DT::dataTableOutput(outputId = "penguin_data")
  
)

# server instructions ----
server <- function(input, output) { 
  
  # filter body masses ----  
  body_mass_df <- reactive({ 
    penguins %>% 
      filter(body_mass_g %in% input$body_mass[1]:input$body_mass[2])
    
  })
  
  # render the scatter plot ----
  output$bodyMass_scatterPlot <- renderPlot({
    
    ggplot(na.omit(body_mass_df()),
           aes(x = flipper_length_mm, y = bill_length_mm, color = species, shape = species)) +
      geom_point() +
      scale_color_manual(values = c("Adelie" = "#FEA346", "Chinstrap" = "#B251F1", "Gentoo" = "#4BA4A4")) +
      scale_shape_manual(values = c("Adelie" = 19, "Chinstrap" = 17, "Gentoo" = 15)) +
      labs(x = "Flipper length (mm)", y = "Bill length (mm)",
           color = "Penguin species", shape = "Penguin species") +
      theme_minimal() +
      theme(legend.position = c(0.85, 0.2),
            legend.background = element_rect(color = "white"))
    
  })
  
  # render the penguins data table ----
  output$penguin_data <- DT::renderDataTable({
    DT::datatable(penguins,
                  options = list(pageLength = 5),
                  caption = htmltools::tags$caption(
                    style = 'caption-side: top; text-align: left;',
                    'Table 1: ', htmltools::em('Size measurements for adult foraging penguins near Palmer Station, Antarctica')))
  })

}
  
 


# combine UI & server into an app ----
shinyApp(ui = ui, server = server)