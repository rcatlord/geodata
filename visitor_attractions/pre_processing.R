# Popular visitor attractions in the UK
# Source: Association of Leading Visitor Attractions
# URL: https://www.alva.org.uk

library(tidyverse) ; library(rvest) ; library(opencage) ; library(leaflet) ; library(sf)

# Scrape list of visitor attractions from the website
attractions <- read_html("https://www.alva.org.uk/details.cfm?p=615") %>% 
  html_table(fill = TRUE) %>%
  .[[1]] %>% 
  select(Site, Area) %>% 
  mutate(Area = case_when(Area == "Eng excl Lon" ~ "England", TRUE ~ Area),
         location = paste0(Site, ", ", Area)) %>% 
  pull(location)

# Forward geocode using the opencage package  
coordinates <- oc_forward_df(placename = attractions)

# Check results
leaflet(data = coordinates) %>% 
  addTiles() %>% 
  addMarkers(~oc_lng, ~oc_lat, label = ~as.character(placename))

# Write results
st_write(coordinates, "visitor_attractions.geojson")
