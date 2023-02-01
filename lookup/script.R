# Output Area to Country lookup with House of Commons Library MSOA names #

library(tidyverse)

# Local authority district to Region lookup
# Source: ONS Open Geography Portal
# URL: https://geoportal.statistics.gov.uk/datasets/ons::local-authority-district-to-region-december-2022-lookup-in-england
regions <- read_csv("data/Local_Authority_District_to_Region_(December_2022)_Lookup_in_England.csv") %>% 
  select(-c(LAD22NM,ObjectId)) %>% 
  rename_with(tolower)

# MSOA names
# Source: House of Commons Library
# URL: https://houseofcommonslibrary.github.io/msoanames
msoa_names <- read_csv("https://houseofcommonslibrary.github.io/msoanames/MSOA-Names-2.2.csv") %>% 
  select(msoa21cd, msoa21hclnm)

# MSOA lookup
# Source: ONS Open Geography Portal
# URL: https://geoportal.statistics.gov.uk/datasets/output-area-to-lower-layer-super-output-area-to-middle-layer-super-output-area-to-local-authority-district-december-2021-lookup-in-england-and-wales-v2-1
lookup <- read_csv("data/OA21_LSOA21_MSOA21_LAD22_EW_LU.csv") %>% 
  select(-lad22nmw) %>% 
  left_join(msoa_names, by = "msoa21cd") %>% 
  left_join(regions, by = "lad22cd") %>% 
  mutate(ctry21cd = case_when(is.na(rgn22cd) ~ "W92000004", TRUE ~ "E92000001"),
         ctry21nm = case_when(is.na(rgn22nm) ~ "Wales", TRUE ~ "England")) %>% 
  relocate(msoa21hclnm, .after = msoa21nm)

write_csv(lookup, "OA21_LSOA21_MSOA21_LAD22_RGN22_CTRY22_lookup.csv")

# Using the lookup ---------------------------------------------
df <- lookup %>% 
  select(-c(1:3)) %>% # drop uneccessary columns
  distinct(msoa21cd, .keep_all = TRUE) %>% # select unique MSOA codes
  filter(rgn22nm == "North West") # filter by region

glimpse(df)
