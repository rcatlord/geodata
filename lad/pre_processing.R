library(tidyverse) ; library(sf) ; library(leaflet)

# Local authority districts (2020)
# Source: ONS Open Geography Portal
# URL: https://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2020-uk-buc

sf <- st_read("Local_Authority_Districts_(December_2020)_UK_BUC.geojson", stringsAsFactors = FALSE) %>% 
  select(AREACD = LAD20CD, AREANM = LAD20NM) %>% 
  # combine polygons to create West Northamptonshire and North Northamptonshire
  mutate(AREACD = case_when(AREACD %in% c("E07000150", "E07000152", "E07000153", "E07000156") ~ "E06000061", 
                            AREACD %in% c("E07000151", "E07000154", "E07000155") ~ "E06000062", 
                            TRUE ~ AREACD),
         AREANM = case_when(AREACD == "E06000061" ~ "North Northamptonshire",
                            AREACD == "E06000062" ~ "West Northamptonshire",
                            TRUE ~ AREANM)) %>% 
  group_by(AREACD, AREANM) %>% 
  summarize(geometry = st_union(geometry))

# plot results
leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addPolygons(data = sf, color = "#444444", weight = 1, opacity = 1.0, fillOpacity = 0, label = ~AREANM)

# write results
st_write(sf, "lad.geojson")
