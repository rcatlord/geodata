# Special Protection Areas

# Source: Natural England
# URL: https://naturalengland-defra.opendata.arcgis.com/maps/special-protection-areas-england
# Licence: Open Government Licence

library(tidyverse) ; library(sf) ; library(rmapshaper)

st_read("https://services.arcgis.com/JJzESW51TqeY9uat/arcgis/rest/services/Special_Protection_Areas_England/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>% 
  select(area_code = SPA_CODE, area_name = SPA_NAME, area = AREA) %>% 
  st_transform(4326) %>% 
  group_by(area_code, area_name) %>% 
  summarise(area = sum(area)) %>% 
  ms_simplify(keep = 0.001, keep_shapes = TRUE) %>% 
  st_write("special_protection_areas.geojson")
