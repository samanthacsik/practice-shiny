# packages
library(tidyverse)
library(janitor)

# load in data
weather_data <- read_csv(here::here("raw_data", "table_28.csv"))

# summarize data
annual_temp_summary <- weather_data %>% 
  clean_names() %>% 
  mutate(year = format(date, format="%Y")) %>% 
  group_by(year) %>% 
  summarize(
    mean_temp = round(mean(temperature_average_c), 1),
    max_temp = max(temperature_high_c),
    min_temp = min(temperature_low_c),
  )
