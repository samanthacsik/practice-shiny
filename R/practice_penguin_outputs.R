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


