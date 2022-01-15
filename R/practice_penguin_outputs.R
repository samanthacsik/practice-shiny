library(tidyverse)
library(palmerpenguins)

# scatterplot
body_mass_dat <- penguins %>% 
  filter(body_mass_g %in% 3000:4000)  

ggplot(na.omit(penguins), aes(x = flipper_length_mm, y = bill_length_mm, 
                                   color = species, shape = species)) +
  geom_point() +
  scale_color_manual(values = c("#FEA346", "#B251F1", "#4BA4A4")) +
  scale_shape_manual(values = c(19, 17, 15)) +
  labs(x = "Flipper length (mm)", y = "Bill lenght (mm)", 
       color = "Penguin species", shape = "Penguin species") +
       #title = "Flipper and bill length", subtitle = "Dimensions for Adelie, Chinstrap and Gentoo Penguins at Palmer Station LTER") +
  theme_minimal() +
  theme(legend.position = c(0.85, 0.2),
        legend.background = element_rect(color = "white"))

#ggsave("penguin_scatterplot.png", x, width = 5, height = 4, bg = "#FFFFFF")

# histogram
filtered_island <- penguins %>% 
  filter(island == "Dream")

ggplot(na.omit(filtered_island), aes(x = flipper_length_mm, fill = species)) +
  geom_histogram(alpha = 0.6, bins = 25) +
  scale_fill_manual(values = c("Adelie" = "#FEA346", "Chinstrap" = "#B251F1", "Gentoo" = "#4BA4A4")) +
  labs(x = "Flipper length (mm)", y = "Frequency", 
       fill = "Penguin species") +
  theme_minimal() +
  theme(legend.position = "bottom",
        legend.background = element_rect(color = "white"))




