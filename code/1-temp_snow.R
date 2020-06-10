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


#
#  ---------------------------------------------------------------






#



(soil_temp =
    temp_mav %>% 
    gg_vt(aes(x = as.Date(Date), y = `air`))+
    geom_path( color = "black", size=1)+
    geom_path(aes(x = as.Date(Date), y = `org`), color = "red", size=1)+
    #   geom_path(aes(x = as.Date(Date), y = `min10cm`), color = "blue")+
    theme_kp()+
    labs(title = "temperatures",
         subtitle = "7-day running mean",
         x = "",
         y = "Temperature, C")+
    
    geom_hline(yintercept = 0)+    
    theme_kp()+
    #    ylim(-20,30)+
    geom_rect(aes(xmin = (as.Date("2015-01-01")), xmax = (as.Date("2015-12-30")),
                  ymin = 25, ymax = 27), fill = "grey90", alpha = 0.5)+
    geom_rect(aes(xmin = (as.Date("2016-01-02")), xmax = (as.Date("2016-08-01")),
                  ymin = 25, ymax = 27), fill = "grey90", alpha = 0.5)+
    annotate("text", label = "2015", x = as.Date("2015-06-01"), y = 26)+
    annotate("text", label = "2016", x = as.Date("2016-04-01"), y = 26)+
    
    annotate("text", label = "air", x = as.Date("2015-01-7"), y = -6,size=4)+
    annotate("text", label = "O horizon", x = as.Date("2015-02-10"), y = 2,size=4)+
    
    geom_curve(aes(x = as.Date("2015-04-22"), xend = as.Date("2015-05-20"), y = 0.8, yend = 3))+
    annotate("text", label = "* April-22", x = as.Date("2015-05-22"), y = 3, hjust="left")+
    
    geom_curve(x = as.Date("2016-03-27"), xend = as.Date("2016-03-23"), y = 1.4, yend = 7, curvature = -0.2)+
    annotate("text", label = "* March 28", x = as.Date("2016-03-20"), y = 8, hjust="center")+
    
    NULL
)





# soil_moisture -----------------------------------------------------------
ggplot(soil_data,
       aes(x = as.Date(Date_Sampled), y = Initial.Moisture_perc))+
  geom_point()+
  facet_grid(Horizon~Watershed)
