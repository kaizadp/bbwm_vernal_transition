## BEAR BROOK - VERNAL TRANSITION
## Environmental variables -- temperature and snowpack

## Kaizad F. Patel
## June 2020

#################################### #
source("code/0-vt_packages.R")

# 1. temperature ---------------------------------------------------------------
temp = read.csv("data/temperature.csv")

# calculate moving averages

temp_mav = 
  temp %>%
  mutate(air = round(zoo::rollmean(AirTemp,7,align='right',fill=NA),2),
         org = round(zoo::rollmean(OrganicTemp,7,align='right',fill=NA),2),
         min10cm = round(zoo::rollmean(`Mineral10cm.Temp`,7,align='right',fill=NA),2)) %>% 
  dplyr::select(Date, Year, Season, JulianDay, air, org, min10cm) %>% 
  na.omit()

#
# 2. snowpack ---------------------------------------------------------------
snowpack = read.csv("data/snowpack.csv")

snowpack2 = 
  snowpack %>% 
  dplyr::rename(Survey_cm = `Snow.Depth..cm`,
         EB_cm = `EB..cm`,
         WB_cm = `WB..cm`) %>%
  dplyr::select(Date, Year, Survey_cm, EB_cm, WB_cm) %>% 
  reshape2::melt(id = c("Date", "Year"), value.name = "depth_cm") %>% 
  na.omit() %>% 
  dplyr::mutate(Date = as.Date(Date),
                depth_cm = round(depth_cm,2),
                variable = str_replace(variable, "_cm","")) %>% 
  arrange(Date)


#
# 3. output ---------------------------------------------------------------
write.csv(temp_mav, "data/processed/temp_movingavg.csv", row.names = F)
write.csv(snowpack2, "data/processed/snowpack_depth.csv", row.names = F)

