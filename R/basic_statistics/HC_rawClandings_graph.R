# TODO create a variable for all the functions name cou_cod: load country and ordered 
set_directory("reference")

country_cod <-read.table(str_c(reference_wd,"/tr_country_cou.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
country_cod<-country_cod[order(as.factor(country_cod$cou_order)),]
cou_cod<-country_cod$cou_code

# TODO create a variable name hcol assigning color to each habitat for all the graphs, we try to find colorblind color so keep looking

library(RColorBrewer)

values=c("#F0E442","#0072B2" ,"#56B4E9", "#009E73","#D55E00")

hcol = setNames(values,levels(landings_complete$eel_hty_code))




#########################
# Load the data test the function
#########################
source("R/utilities/load_library.R")
load_library(c("ggplot2", "reshape", "rJava","reshape2", "stringr", "dplyr", "lattice", "RColorBrewer", "grid"))

source("R/utilities/set_directory.R")
set_directory("result")
set_directory("data")

CY = as.numeric(format(Sys.time(), "%Y")) # year of work

# for landings only

# download the data + transform into tonnes + create new names for the habitat  
landings_complete <-read.table(str_c(data_wd,"/landings.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
landings_complete$eel_value<-as.numeric(landings_complete$eel_value) / 1000
landings_complete$eel_hty_code = factor(landings_complete$eel_hty_code, levels = rev(c("MO", "C", "T", "F", "AL")))



# work only on commercial fisheries and yellow + silver
com_landings = landings_complete[landings_complete$typ_name == "com_landings_kg", ] 
#landings_habitat = com_landings  %>% filter(eel_year>1995 & eel_year<CY) %>% group_by(eel_year, eel_hty_code, eel_cou_code) %>% dplyr::summarize(eel_value=sum(eel_value,na.rm=TRUE))
landings = as.data.frame(com_landings %>% group_by(eel_year, eel_cou_code,eel_hty_code) %>% dplyr::summarize(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(landings)<-c("year","country","habitat","landings")

# excluding the current year and year before 1945
#landings = landings[landings$year != CY & landings$year>=1945,]
landings$country = as.factor(landings$country)
landings$habitat = as.factor(landings$habitat)

landings$year = as.numeric(as.character(landings$year))

#if (is.null(countries)){countries=as.character(unique(landings2$country))}
#complete2<-filter(landings2,year %in% seq(year_min, year_max, by=1) & country %in% countries)
#completeraw<-filter(landings,year %in% seq(year_min, year_max, by=1) & country %in% countries)
#if (is.null(country)){country=as.character(unique(landings2$country))}
#if (is.null(lfs)){lfs=as.character(unique(landings_complete$eel_lfs_code))}

#  
#if (!is.null(habitat)){
#    complete2<-filter(landings_complete,eel_year %in% seq(year_min, year_max, by=1) & eel_cou_code %in% country & eel_lfs_code %in% lfs & eel_hty_code %in% habitat)
#}
# else{
# # landings_completesum<-aggregate(eel_value~eel_cou_code+eel_year+eel_typ_id,data=landings_complete,sum,na.rm=T)  #
#complete2<-filter(landings_completesum,eel_year %in% seq(year_min, year_max, by=1) & eel_cou_code %in% country & eel_lfs_code %in% lfs)
#}    


completeraw<-landings
########
# FUnction
########
#TODO change the column name to be the same of the data base
# TODO add inputs in the function to call cou_cod and hcol
###For the graph we need a table with column names: country (2 letters code), year, landings, habitat 
### we also need cou_cod and hcol
HCrawCLandingsGraph<-function (dataset="data",title=NULL)
{ 
  
completeraw<-dataset
landings_habitat<-aggregate(landings~country+habitat,completeraw,mean)

Country<-factor(landings_habitat$country,levels=cou_cod,ordered=T)
Country<-droplevels(Country)
HCrawCLandings<-ggplot(landings_habitat) + aes(x = Country, y = landings, fill = habitat) + 
  geom_col(position = "fill") + 
  theme_bw() + 
  theme(legend.position = "right") + 
  xlab("Country") + ylab("Proportion")+scale_fill_manual(values=hcol)+
  ggtitle(title)
return(HCrawCLandings)

}
