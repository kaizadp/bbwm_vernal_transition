## BEAR BROOK - VERNAL TRANSITION
## Streams

## Kaizad F. Patel
## June 2020

#################################### #


source("code/0-vt_packages.R")

# 1. streamflow --------------------------------------------------------------
streamflow = read.csv("data/streamflow.csv")

stream_daily = 
  streamflow %>% 
  dplyr::mutate(Date = mdy(Date),
                # convert cfs to m3/s
                Discharge_m3_s = Discharge_cfs*0.02832,
                # calculate volume discharged in 5 seconds       
                vol_5s_m3_s = Discharge_m3_s*5) %>% 
  group_by(Date) %>% 
# calculate total volume discharged daily
# add all the volumes per day
  dplyr::summarize(mean_discharge_m3_s = round(mean(vol_5s_m3_s),2),
                   total_discharge_m3_s = round(sum(vol_5s_m3_s, na.rm = T),2),
                   gageht_cm = round(mean(Gage_ht_ft*30),2),
                   n = n()) %>% 
  dplyr::mutate(yday = yday(Date),
                year = year(Date)) %>% 
  ungroup %>% 
# cum-volume for Jan-01 to Jul-31 (HBD, JKR)
  mutate(group = case_when(Date<as.Date("2015-08-01")~"grp1",
                           (Date>as.Date("2015-12-31")&Date<as.Date("2016-08-01"))~"grp2")) %>% 
  arrange(Date) %>% 
  group_by(year) %>% 
  dplyr::mutate(cum_m3_s = cumsum((replace_na(total_discharge_m3_s, 0))))

(gg_cov = 
    stream_daily %>% 
    # filter(!is.na(group)) %>% 
    ggplot(aes(x = as.Date(Date), y = cum_m3_s, color = as.character(group)))+
    geom_path()
)


# select cov
cov = 
  stream_daily %>% 
  group_by(group) %>% 
  dplyr::mutate(cov = max(cum_m3_s)/2,
                max = max(cum_m3_s)) %>% 
  dplyr::select(group, cov, max) %>% 
  distinct() %>% 
  na.omit()

# manually, COV 2015-04-19 (0.22 m3/s), 2016-04-08 (0.11 m3/s)

# 2. stream nitrate ----------------------------------------------------------
stream_nitrate = read.csv("data/stream_n.csv")

# convert N units

stream_n = 
  stream_nitrate %>% 
  # convert from NO3 ueq/L to NO3-N mg/L 
  dplyr::mutate(NO3_N_mg_L = NO3_ueq_L*14/1000,
                Date = ymd(paste0(Year,"-",Month,"-",Day))) 



# 3. output ------------------------------------------------------------------

write.csv(stream_daily, "data/processed/streamflow.csv", row.names = F)
write.csv(stream_n, "data/processed/stream_n.csv", row.names = F)
