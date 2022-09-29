# Special Areas of Conservation

# Source: Natural England
# URL: https://naturalengland-defra.opendata.arcgis.com/datasets/e4142658906c498fa37f0a20d3fdfcff_0
# Licence: Open Government Licence

library(tidyverse) ; library(sf) ; library(rmapshaper)

sf <- st_read("https://services.arcgis.com/JJzESW51TqeY9uat/arcgis/rest/services/Special_Areas_of_Conservation_England/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
  select(area_code = SAC_CODE, area_name = SAC_NAME) %>% 
  st_transform(4326) %>% 
  ms_simplify(keep = 0.001, keep_shapes = TRUE) %>% 
  st_write("special_areas_of_conservation.geojson")