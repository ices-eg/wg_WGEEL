# TODO create a variable for all the functions name cou_cod: load country and ordered 
set_directory("reference")

country_cod <-read.table(str_c(reference_wd,"/tr_country_cou.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
country_cod<-country_cod[order(as.factor(country_cod$cou_order)),]
cou_cod<-country_cod$cou_code

# TODO create a variable name col assigning color to each country for all the graphs


values=c(brewer.pal(12,"Set3"),brewer.pal(12, "Paired"), brewer.pal(8,"Accent"),
         
         brewer.pal(7, "Dark2"))

col = setNames(values,cou_cod)




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

rec_landings = landings_complete[landings_complete$typ_name == "rec_landings_kg"  & landings_complete$eel_lfs_code != "G", ] 
landings = as.data.frame(rec_landings %>% group_by(eel_year, eel_cou_code) %>% summarise(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(landings)<-c("year","country","landings")



# excluding the current year and year before 1945
#landings = landings[landings$year != CY & landings$year>=1945,]
landings$country = as.factor(landings$country)
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

# TODO change the name of the column to be adapt to the database name (eel_cou_code, eel_year, ...)
###For the graph we need a table with column names: country (2 letters code), year, landings, lfs 
### we also need cou_cod and col
rawRLandingsGraph<-function (dataset="data", title=NULL)
{ 
  completeraw<-dataset
  completeraw<-aggregate(landings~year+country,completeraw, sum)
  
  ### To order the table by country (geographical position)
  Country<-factor(completeraw$country,levels=cou_cod,ordered=T)
  Country<-droplevels(Country)
  
  landings_year<-aggregate(landings~year, complete2, sum)
  #########################
  # graph
  #########################
  
  # raw
  g_raw_Rlandings <- ggplot(completeraw) + geom_col(aes(x=year,y=landings,fill=Country,legend = FALSE),position='stack')+
    ggtitle(title) + xlab("year") + ylab("Landings (tons)")+
    scale_fill_manual(values=col)+
    theme_bw() #+ # make the theme black-and-white rather than grey (do this before font changes, or it overrides them)
  
  x11()
  
  
  print(g_raw_Rlandings)
  
  
  
  return(g_raw_Rlandings)
  
}


