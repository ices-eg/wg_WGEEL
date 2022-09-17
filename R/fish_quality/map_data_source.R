source("../utilities/load_library.R")
load_library("sf")
load_library("rnaturalearth")
load_library("yaml")
load_library("getPass")
load_library("dplyr")


cred=read_yaml("../../credentials.yml")
# TODO 2022 use this to connect, not sqldf !!!!!!!!!!!!!!
# currently still using sqldf and RpostgreSQL() change for compatibility with linux
pwd = passwordwgeel = password=getPass(msg="password for db")
con = dbConnect(RPostgres::Postgres(), dbname=cred$dbname,host=cred$host,port=cred$port,user=cred$user, password=passwordwgeel)

worldmap <- ne_countries(scale = 'medium', type = 'map_units',
                         returnclass = 'sf')
europe_cropped <- st_crop(worldmap, xmin = -35, xmax = 55,
                          ymin = 10, ymax = 78)
countries=st_read(con,query="select * from ref.tr_country_cou")



data=read.table("map_country_list.csv",header=TRUE,sep=";") %>%
  mutate(data_code=as.character(data_code))
colours=read.table("map_color_code.csv",header=TRUE,sep=";") %>%
  mutate(data_code=as.character(data_code))

pal=colours$color
names(pal)=colours$data_code

countries <- countries %>%
  filter(cou_code %in% data$cou_code) %>%
  left_join(data)

lim=st_bbox(countries)
ggplot(europe_cropped)+geom_sf(data=europe_cropped,
                               fill="white",
                               col="grey",cex=.2)+
  geom_sf(data=countries,aes(fill=as.character(data_code)),col="grey",alpha=1,cex=.2)+
  scale_fill_manual("",values=pal,labels=colours$comment)+
  xlim(-18, lim[3])+ylim(18,lim[4]) +
  theme_bw()
ggsave("maps_countries.png",height=16/2.54,width=16/2.54,dpi=300)

dbDisconnect(con)
