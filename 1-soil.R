source("0-vt_packages.R")

soil_data = read.csv("data/soil.csv")

(NH4 = 
    soil_data %>% 
    group_by(Date_Sampled, Watershed, Horizon) %>% 
    dplyr::mutate(NH4 = mean(NH4_mg_kg, na.rm = T),
                  Horizon = factor(Horizon, levels = c("O", "B"))) %>% 
    ggplot(aes(x = as.Date(Date_Sampled), y = NH4))+
    geom_point()+
    geom_path()+
    facet_grid(Horizon ~ Watershed)+
    NULL
)

(NO3 = 
    soil_data %>% 
    group_by(Date_Sampled, Watershed, Horizon) %>% 
    dplyr::mutate(NO3 = mean(NO3_mg_kg, na.rm = T),
                  Horizon = factor(Horizon, levels = c("O", "B"))) %>% 
    ggplot(aes(x = as.Date(Date_Sampled), y = NO3))+
    geom_point()+
    geom_path()+
    facet_grid(Horizon ~ Watershed)+
    NULL
)



# soil_temp ---------------------------------------------------------------
temp = read.csv("data/temperature.csv")

# calculate moving averages

temp_mav = 
  temp %>%
  mutate(air = round(zoo::rollmean(AirTemp,7,align='right',fill=NA),2),
         org = round(zoo::rollmean(OrganicTemp,7,align='right',fill=NA),2),
         min10cm = round(zoo::rollmean(`Mineral10cm.Temp`,7,align='right',fill=NA),2)) %>% 
  dplyr::select(Date, Year, Season, JulianDay, air, org, min10cm) %>% 
  na.omit()
  

(soil_temp = 
    temp_mav %>% 
    ggplot()+
    geom_path(aes(x = as.Date(Date), y = `air`), color = "black", size=1)+
    geom_path(aes(x = as.Date(Date), y = `org`), color = "red", size=1)+
 #   geom_path(aes(x = as.Date(Date), y = `min10cm`), color = "blue")+
    theme_kp()+
    labs(title = "temperatures",
         subtitle = "7-day running mean",
         x = "Date",
         y = "Temperature, C")+

    geom_hline(yintercept = 0)+    
  
    # seasons
    geom_vline(xintercept = as.numeric(as.Date("2015-04-12")),linetype="dashed")+
    geom_vline(xintercept = as.numeric(as.Date("2015-05-04")),linetype="dashed")+
    geom_vline(xintercept = as.numeric(as.Date("2015-09-20")),linetype="dashed")+
    geom_vline(xintercept = as.numeric(as.Date("2015-12-15")),linetype="dashed")+
    geom_vline(xintercept = as.numeric(as.Date("2016-04-10")),linetype="dashed")+
    geom_vline(xintercept = as.numeric(as.Date("2016-05-12")),linetype="dashed")+

    annotate("text", label = "W", x = as.Date("2015-03-20"), y = -18,size=4,fontface="bold")+ 
    annotate("text", label = "VT", x = as.Date("2015-04-25"), y = -18,size=4,fontface="bold")+ 
    annotate("text", label = "GS", x = as.Date("2015-06-20"), y = -18,size=4,fontface="bold")+ 
    annotate("text", label = "F", x = as.Date("2015-10-30"), y = -18,size=4,fontface="bold")+ 
    
    annotate("text", label = "W", x = as.Date("2016-02-01"), y = -18,size=4,fontface="bold")+ 
    annotate("text", label = "VT", x = as.Date("2016-04-25"), y = -18,size=4,fontface="bold")+ 
    annotate("text", label = "GS", x = as.Date("2016-06-20"), y = -18,size=4,fontface="bold")+ 
    
    # years
    geom_rect(aes(xmin = (as.Date("2015-01-01")), xmax = (as.Date("2015-12-30")),
                  ymin = -19, ymax = -21), fill = "grey90", alpha = 0.5)+
    geom_rect(aes(xmin = (as.Date("2016-01-02")), xmax = (as.Date("2016-08-01")),
                  ymin = -19, ymax = -21), fill = "grey90", alpha = 0.5)+
    annotate("text", label = "2015", x = as.Date("2015-06-01"), y = -20)+
    annotate("text", label = "2016", x = as.Date("2016-04-01"), y = -20)+
    
    scale_x_date(date_breaks = "2 month",labels=date_format("%b-%d"),
                 limits = (c(as.Date("2015-01-01"),as.Date("2016-08-01"))))+
    
    NULL
)
  



#
