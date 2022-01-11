# load packages ----
library(shiny)
library(palmerpenguins)
library(tidyverse)
library(DT)
library(bslib)
library(thematic)
library(shinyWidgets)

# enable thematic for plotOutputs ----
# thematic_shiny()

# ui ----
ui <- fluidPage(
  
  # set theme ----
  theme = bslib::bs_theme(bootswatch = "minty"),
  
  # create navbar ----
  navbarPage(
    "Exploring Antarctic Penguins & Weather",
    
    # background tab ----
    tabPanel("Background",
             em("some background information here")),
    
    # penguins tab ----
    tabPanel("Antarctic Penguins",
             tabsetPanel(
               
               tabPanel("Scatterplot",
                        
                        # body mass slider input ----
                        sliderInput(inputId = "body_mass", label = "Select a range of body masses (g):",
                                    value = c(3000, 4000), min = 2700, max = 6300),
                       
                         # body mass plot output ----
                        plotOutput(outputId = "bodyMass_scatterPlot")),
               
               tabPanel("Histogram",
                        
                        # island input ----
                        pickerInput(inputId = "island", label = "Select an island:",
                                    choices = c("Torgersen", "Dream", "Biscoe"),
                                    options = list(`actions-box` = TRUE),
                                    selected = c("Torgersen", "Dream", "Biscoe"),
                                    multiple = T),
                        
                        # bin width input ----
                        sliderInput(inputId = "bin_width", label = "Select bin width:",
                                    value = 3, max = 10, min = 1),
                       
                        # flipper length plot output ----
                        plotOutput(outputId = "flipperLength_hist")))),
    
    # palmer weather tab ----
    tabPanel("Antarctic Weather",
             em("some widget to explore weather data here")),
    
    # explore data tab ----
    tabPanel("Explore the Data",
             tabsetPanel(
              
                tabPanel("Penguin Data",
                        
                        # penguin data table output ----
                        DT::dataTableOutput(outputId = "penguin_data")),
               tabPanel("Palmer Station Weather Data",
                        em("weather DT here"))))
  )
)


# server instructions ----
server <- function(input, output) {
  
  # render the scatter plot ----
  output$bodyMass_scatterPlot <- renderPlot({

    # filter body mass data ----
    body_mass_dat <- penguins %>%
      filter(body_mass_g %in% input$body_mass[1]:input$body_mass[2])

    # plot scatterplot ----
    ggplot(na.omit(body_mass_dat),
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
  
  # render the flipper length histogram
  output$flipperLength_hist <- renderPlot({
    
    # validate ----
    # alt: need(input$island != "", "Please..."
    validate(
      need(length(input$island) > 0, "Please select at least one island to visualize.")
    )
    
    # filter island data ----
    filtered_island <- penguins %>% 
      filter(island == input$island)
    
    # plot histogram ----
    ggplot(na.omit(filtered_island), aes(x = flipper_length_mm, fill = species)) +
      geom_histogram(alpha = 0.6, binwidth = input$bin_width) +
      scale_fill_manual(values = c("Adelie" = "#FEA346", "Chinstrap" = "#B251F1", "Gentoo" = "#4BA4A4")) +
      labs(x = "Flipper length (mm)", y = "Frequency", 
           fill = "Penguin species") +
      theme_minimal() +
      theme(legend.position = "bottom",
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
  

  # end server ----
}

# run the application ----
shinyApp(ui = ui, server = server)