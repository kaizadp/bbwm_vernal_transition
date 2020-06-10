## BEAR BROOK - VERNAL TRANSITION
## Soil chemistry

## Kaizad F. Patel
## June 2020

#################################### #


source("code/0-vt_packages.R")


# load file and clean -----------------------------------------------------
soil = read.csv("data/soil.csv", stringsAsFactors = F)

soil_data = soil %>% 
  dplyr::select(Date_Sampled, Year, Season, Sample, Watershed, Forest, Horizon,
                NO3_mg_kg, NH4_mg_kg) %>% 
  filter(Horizon %in% "O") %>%
  # The Sample column is of the format EBHW 1. Extract only the numbers
  dplyr::mutate(Sample = readr::parse_number(Sample))
  


# output ------------------------------------------------------------------

write.csv(soil_data, "data/processed/soil_n.csv", row.names = F)


#




