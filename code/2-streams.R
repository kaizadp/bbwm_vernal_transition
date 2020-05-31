source("0-vt_packages.R")

vt = read.csv("data/data.csv")
streamflow = read.csv("data/streamflow.csv")

stream = 
  streamflow %>% 
  dplyr::mutate(Date = mdy(Date)) %>% 
  group_by(Date) %>% 
  dplyr::summarize(discharge_m3_s = round(mean(Discharge_cfs*0.02832),2),
                   gageht_cm = round(mean(Gage_ht_ft*30),2)) %>% 
  dplyr::mutate(yday = yday(Date),
                year = year(Date))

ggplot()+
  geom_path(data = stream, aes(x = Date, y = gageht_cm), size=0.5)+
  geom_point(data = stream_n, aes(x = as.Date(dates), y = NO3_N*30 + 145, color = Watershed), size = 3)+
  scale_y_continuous(sec.axis = sec_axis(~(.-145)/30))+

#  xlim(("2015-01-01"),("2016-07-01"))+
  theme_bw()+
  geom_vline(xintercept = as.numeric(as.Date("2015-04-12")),linetype="dashed")+
  geom_vline(xintercept = as.numeric(as.Date("2015-05-04")),linetype="dashed")+
  geom_vline(xintercept = as.numeric(as.Date("2015-09-20")),linetype="dashed")+
  geom_vline(xintercept = as.numeric(as.Date("2015-12-15")),linetype="dashed")+
  geom_vline(xintercept = as.numeric(as.Date("2016-04-10")),linetype="dashed")+
  geom_vline(xintercept = as.numeric(as.Date("2016-05-12")),linetype="dashed")

## stream nitrate ----
stream_n = read.csv("data/stream_nitrate.csv")
ggplot(stream_n, aes(x = as.Date(dates), y = NO3_N, color = Watershed))+
  geom_point(size=2)+
  geom_path(size=0.8)+
  theme(legend.position = "top")+
  ylim(0,1.0)+
  geom_vline(xintercept = as.numeric(as.Date("2015-04-12")),linetype="dashed")+
  geom_vline(xintercept = as.numeric(as.Date("2015-05-04")),linetype="dashed")+
  geom_vline(xintercept = as.numeric(as.Date("2015-09-20")),linetype="dashed")+
  geom_vline(xintercept = as.numeric(as.Date("2015-12-15")),linetype="dashed")+
  geom_vline(xintercept = as.numeric(as.Date("2016-04-10")),linetype="dashed")+
  geom_vline(xintercept = as.numeric(as.Date("2016-05-12")),linetype="dashed")
  facet_grid(Watershed~., scales = "free_y")
