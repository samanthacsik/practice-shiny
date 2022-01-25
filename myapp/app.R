# load packages ----
library(shiny)
library(palmerpenguins)
library(tidyverse)
library(DT)
library(bslib)
library(thematic)
library(shinyWidgets)
library(reactlog)

# import data ----
temp_summary <- readRDS("data/temp_month_summary.rds")

# ui ----
ui <- fluidPage(

  # set theme ----
  theme = bslib::bs_theme(bootswatch = "minty"),

  # create navbar ----
  navbarPage(
    "Exploring Antarctic Penguins & Weather",

    # background tab ----
    tabPanel("Background",
             sidebarLayout(
               sidebarPanel(
                 # penguin image radioButton input ----
                 radioButtons(
                   inputId = "img", label = "Choose a penguin to display:",
                   choices = c("All penguins", "Sassy chinstrap", "Staring gentoo", "Adorable adelie"),
                   selected = "All penguins")
                 ),
               mainPanel(
                 imageOutput(outputId = "penguin_img")
                 )
               )
             ),

    # penguins tab ----
    tabPanel("Antarctic Penguins",
             tabsetPanel(
               tabPanel("Scatterplot",
                        # body mass slider input ----
                        sliderInput(inputId = "body_mass", label = "Select a range of body masses (g):",
                                    value = c(3000, 4000), min = 2700, max = 6300),
                         # body mass plot output ----
                        plotOutput(outputId = "bodyMass_scatterPlot")
                        ),
               tabPanel("Histogram",
                     # island input ----
                        pickerInput(inputId = "island", label = "Select an island:",
                                    choices = c("Torgersen", "Dream", "Biscoe"),
                                    options = list(`actions-box` = TRUE),
                                    selected = c("Torgersen", "Dream", "Biscoe"),
                                    multiple = T),
                        # bin number input ----
                        sliderInput(inputId = "bin_num", label = "Select number of bins:",
                                    value = 25, max = 100, min = 1),
                        # flipper length plot output ----
                        plotOutput(outputId = "flipperLength_hist")
                        )
               )
             ),

    # palmer weather tab ----
    tabPanel("Antarctic Weather",
             em("some widget to explore weather data here")),
    # explore data tab ----
    tabPanel("Explore the Data",
             tabsetPanel(
                tabPanel("Penguin Data",
                        # penguin data table output ----
                        DT::dataTableOutput(outputId = "penguin_data")
                        ),
                tabPanel("Palmer Station Weather Data",
                         sidebarLayout(
                           sidebarPanel(
                             # weather checkboxGroupInput ----
                             checkboxGroupInput(
                               inputId = "month", label = "Choose a month(s):",
                               choices = c("January", "February", "March", "April",
                                           "May", "June", "July", "August",
                                           "September", "October", "November", "December"),
                               selected = c("January", "February")
                             )
                           ),
                           mainPanel(
                             # weather table output----
                             DT::dataTableOutput(outputId = "temp_table")
                             )
                         )
                     )
               )
             )
  )
)


# server instructions ----
server <- function(input, output) {

  # render penguin images ----
  output$penguin_img <- renderImage({

    if(input$img == "All penguins"){
      list(src = "www/all_penguins.jpeg", height = 240, width = 300,
           alt = "")
    }
    else if(input$img == "Sassy chinstrap"){
      list(src = "www/chinstrap.jpeg", height = 240, width = 300,
           alt ="")
    }
    else if(input$img == "Staring gentoo"){
      list(src = "www/gentoo.jpeg", height = 240, width = 300,
           alt = "")
    }
    else if(input$img == "Adorable adelie"){
      list(src = "www/adelie.gif", height = 240, width = 300,
           alt = "An adelie penguin using it's feet to push itself along the ice on it's belly.")
    }

  }, deleteFile = FALSE)

  # filter body mass data ----
  body_mass_df <- reactive({
    penguins %>%
      filter(body_mass_g %in% input$body_mass[1]:input$body_mass[2])
  })

  # render scatter plot ----
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

  # filter island data ----
  island_df <- reactive({

    # alt: need(input$island != "", "Please..."
    validate(
      need(length(input$island) > 0, "Please select at least one island to visualize.")
    )

    penguins %>%
      filter(island == input$island)
  })

  # render the flipper length histogram ----
  output$flipperLength_hist <- renderPlot({

    ggplot(na.omit(island_df()), aes(x = flipper_length_mm, fill = species)) +
      geom_histogram(alpha = 0.6, bins = input$bin_num) +
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
  
  # filter weather data by month ----
  month_df <- reactive({
    
    temp_summary %>% 
      filter(month_name %in% input$month)
    
  })
  
  # render the temperature data table ----
  output$temp_table <- renderDataTable({
    DT::datatable(month_df(),
                  class = 'cell-border stripe',
                  colnames = c('Year', "Month", 'Mean Air Temp.', 'Max. Air Temp.', 'Min. Air Temp.'),
                  #options = list(pageLength = 5),
                  caption = htmltools::tags$caption(
                    style = 'caption-side: top; text-align: left;',
                    'Table 2: ', htmltools::em('Mean, maximum, and minimum monthly air temperatures (°C) recorded at Palmer Station, Antarctica from 1989 - 2019.'))) 

  })

  # end server ----
}

# combine UI & server into an app ----
shinyApp(ui = ui, server = server)