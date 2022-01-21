# temp_summary <- read_csv("data/temp_summary.csv")
# pressure_summary <- read_csv("data/pressure_summary.csv")
# pressure_summary <- readRDS("data/pressure_summary.rds")


#   if(input$weather_summary == "Air temperature, °C (1989-2019)"){
#     DT::datatable(temp_summary,
#                   class = 'cell-border stripe',
#                   colnames = c('Year', 'Mean Air Temp.', 'Max. Air Temp.', 'Min. Air Temp.'),
#                   options = list(pageLength = 5),
#                   caption = htmltools::tags$caption(
#                     style = 'caption-side: top; text-align: left;',
#                     'Table 2: ', htmltools::em('caption here')))
#   }
#   else if(input$weather_summary == "Pressure, mbar (1989-2019)"){
#     DT::datatable(pressure_summary,
#                   # class = 'cell-border stripe',
#                   # colnames = c('Year', 'Mean Pressure (mbar)', 'Maximum Pressure (mbar)', 'Minimum Pressure (mbar)'),
#                   options = list(pageLength = 5),
#                   caption = htmltools::tags$caption(
#                     style = 'caption-side: top; text-align: left;',
#                     'Table 3: ', htmltools::em('caption here')))
#   }




# summarize temp data ------------------------------------------
temp_summary <- weather_data %>% 
  clean_names() %>% 
  mutate(year = format(date, format="%Y")) %>%
  group_by(year) %>% 
  summarize(
    mean_temp = round(mean(temperature_average_c), 1),
    max_temp  = max(temperature_high_c),
    min_temp  = min(temperature_low_c),
  ) 

# write_csv(temp_summary, "./myapp/data/temp_summary.csv")
saveRDS(temp_summary, "./myapp/data/temp_summary.rds")

# summarize pressure data ------------------------------------------
pressure_summary <- weather_data %>% 
  clean_names() %>% 
  mutate(year = format(date, format="%Y")) %>% 
  group_by(year) %>% 
  summarize(
    mean_pressure = round(mean(pressure_average_mbar), 1),
    max_pressure = max(pressure_high_mbar),
    min_pressure = min(pressure_low_mbar),
  )

# write_csv(pressure_summary, "./myapp/data/pressure_summary.csv")
saveRDS(pressure_summary, "./myapp/data/pressure_summary.rds")