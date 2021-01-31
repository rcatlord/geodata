# Natural Earth
### URL: https://www.naturalearthdata.com/downloads

library(tidyverse) ; library(sf) ; library(rnaturalearth) ; library(rnaturalearthhires)

# country boundaries (low resolution)
plot(st_geometry(
  ne_countries(scale = 'small', returnclass = 'sf')
  ))

# individual countries (high resolution)
# dependency: rnaturalearthhires
plot(st_geometry(
  ne_countries(country = 'italy', type = 'countries', scale = 'large', returnclass = 'sf')
  ))

# boundaries within countries 
plot(st_geometry(
  ne_states(country = 'italy', returnclass = 'sf') %>% 
  filter(region == "Sicily")
))



