# load packages ----
library(shiny)
library(palmerpenguins)

# user interface ----
ui <- fluidPage(
  
  # app title ----
  tags$h1("My App Title"),
  
  # app subtitle ----
  p(strong("Exploring Antarctic Penguins and Temperatures")),
  
  # body mass slider ----
  sliderInput(inputId = "body_mass", label = "Select a range of body masses (g):",
              value = c(3000, 4000), min = 2700, max = 6300),
  
  # body size plot ouput ----
  plotOutput(outputId = "bodySize_scatterPlot")
  
  # island radio buttons ----
  # radioButtons(inputId = "island", label = h3("Choose an island:"),
  #              choices = list("All" = , "Torgersen" = Torgersen, "Biscoe" = Biscoe, "Dream" = Dream),
  #              selected = )
  

  # date range input ----
  # sliderInput(inputId = "year", label = "Select a year range:", 
  #                start = 2007, end = 2009, format = "yyyy")
  
)

# server instructions ----
server <- function(input, output) {
  
  # render the scatter plot ----
  output$bodySize_scatterPlot <- renderPlot({

    # filter body mass data ----
    body_mass_dat <- penguins %>%
      filter(body_mass_g %in% input$body_mass[1]:input$body_mass[2])

    # plot
    ggplot(na.omit(body_mass_dat),
           aes(x = flipper_length_mm, y = bill_length_mm, color = species, shape = species)) +
      geom_point() +
      scale_color_manual(values = c("#FEA346", "#B251F1", "#4BA4A4")) +
      scale_shape_manual(values = c(19, 17, 15)) +
      labs(x = "Flipper length (mm)", y = "Bill lenght (mm)",
           color = "Penguin species", shape = "Penguin species") +
      theme_minimal() +
      theme(legend.position = c(0.85, 0.2),
            legend.background = element_rect(color = "white"))

  })
  
}

# run the application ----
shinyApp(ui = ui, server = server)