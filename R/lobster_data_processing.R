##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                    setup                                 ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#..........................load packages.........................
library(tidyverse)
library(vcdExtra)

#..........................import data...........................
size_abund <- read_csv(here::here("raw_data", "Lobster_Abundance_All_Years_20210412.csv")) %>% 
  select(-NUM_AO, -AREA) %>% 
  rename(SBC_LTER_TRANSECT = TRANSECT, LOBSTER_TRANSECT = TRANSECT)

traps <- read_csv(here::here("raw_data", "Lobster_Trap_Counts_All_Years_20210519.csv")) %>% 
  select(-OBSERVER) %>% 
  rename(SWATH_START = SEGMENT_START, SWATH_END = SEGMENT_END) %>% 
  mutate(TRAPS = na_if(TRAPS, -99999))

#.......................expand freq tables.......................
abund_freq <- as.data.frame(size_abund) %>% 
  expand.dft(freq = "COUNT") # expands freq. table to df representing individual obs. in the table

traps_freq <- as.data.frame(traps) %>% 
  expand.dft(freq = "TRAPS")

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                    wrangling/plotting abundance vs traps                 ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#.........calculate mean abundance by year for each site.........
abund_by_years_site <- abund_freq %>%
  group_by(YEAR, SITE) %>% # group by year, then site
  summarize(
    count = length(SIZE_MM) # sample size by site
  ) %>%
  mutate(site_full = case_when( # expand to full length names
    SITE == "AQUE" ~ "Arroyo Quemado",
    SITE == "CARP" ~ "Carpinteria",
    SITE == "IVEE" ~ "Isla Vista",
    SITE == "MOHK" ~ "Mohawk Reef",
    SITE == "NAPL" ~ "Naples Reef"
  )
  ) %>%
  select(YEAR, SITE, site_full, count) %>% # select and reorder columns
  mutate(site_full = fct_relevel(site_full, c("Naples Reef", "Isla Vista","Arroyo Quemado", "Mohawk Reef", "Carpinteria")))

# write.csv(abund_by_years_site, here::here("app", "data", "abund_freq.csv"))

#......calculate mean fishing pressure by year for each site.....
traps_by_years_site <- traps_freq %>%
  select(YEAR, SITE, SWATH_START, SWATH_END) %>%
  filter(SITE %in% c("AQUE", "CARP", "MOHK")) %>%
  group_by(YEAR, SITE) %>% # group by year, then site
  summarize(
    count = length(SWATH_START) # number of traps by site
  ) %>%
  mutate(site_full = case_when( # expand to full length names
    SITE == "AQUE" ~ "Arroyo Quemado",
    SITE == "CARP" ~ "Carpinteria",
    SITE == "MOHK" ~ "Mohawk Reef"
    )
  ) %>%
  select(YEAR, SITE, site_full, count) %>% # select and reorder columns
  filter(YEAR != 2021) %>% 
  mutate(site_full = fct_relevel(site_full, c("Arroyo Quemado", "Mohawk Reef", "Carpinteria")))

# write.csv(traps_by_years_site, here::here("app", "data", "traps_freq.data"))

#..............................plot..............................
abund_traps_plot <- ggplot(abund_by_years_site, aes(x = YEAR, y = count, color = site_full)) +
  geom_point() +
  geom_line() +
  geom_point(data = traps_by_years_site, shape = 15) +
  geom_line(data = traps_by_years_site, linetype = "dashed") +
  theme_classic() +
  # theme(axis.text = element_text(color = "black"),
  #       panel.border = element_rect(colour = "black", fill=NA, size=0.7),
  #       strip.background = element_rect(fill = "grey"),
  #       plot.caption = element_text(size = 10, hjust = 0)) +
  labs(x = "Year", y = "Lobster Abundance & Trap Counts",
       color = "Site")  # caption = caption1 (to include caption)
  #scale_x_continuous(breaks=c(2013, 2015, 2017, 2019, 2021))
abund_traps_plot
