




#########################
# Load the data test the function
#########################
source("R/utilities/load_library.R")
load_library(c("ggplot2", "reshape", "rJava","reshape2", "stringr", "dplyr", "lattice", "RColorBrewer", "grid"))

source("R/utilities/set_directory.R")
set_directory("result")
set_directory("data")

CY = as.numeric(format(Sys.time(), "%Y")) # year of work

# TODO create a variable for all the functions name cou_cod: load country and ordered 
set_directory("reference")

country_cod <-read.table(str_c(reference_wd,"/tr_country_cou.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
country_cod<-country_cod[order(as.factor(country_cod$cou_order)),]
cou_cod<-country_cod$cou_code

# TODO create a variable name col assigning color to each country for all the graphs

library(RColorBrewer)
values=c(brewer.pal(12,"Set3"),brewer.pal(12, "Paired"), brewer.pal(8,"Accent"),
         
         brewer.pal(7, "Dark2"))

col = setNames(values,cou_cod)

# for landings only

# download the data + transform into tonnes + create new names for the habitat  
landings_complete <-read.table(str_c(data_wd,"/landings.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
landings_complete$eel_value<-as.numeric(landings_complete$eel_value) / 1000
landings_complete$eel_hty_code = factor(landings_complete$eel_hty_code, levels = rev(c("MO", "C", "T", "F", "AL")))



# work only on commercial fisheries and yellow + silver
com_landings = landings_complete[landings_complete$typ_name == "com_landings_kg" & landings_complete$eel_lfs_code == "G", ] 
#landings_habitat = com_landings  %>% filter(eel_year>1995 & eel_year<CY) %>% group_by(eel_year, eel_hty_code, eel_cou_code) %>% dplyr::summarize(eel_value=sum(eel_value,na.rm=TRUE))
landings = as.data.frame(com_landings %>% group_by(eel_year, eel_cou_code) %>% dplyr::summarize(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(landings)<-c("year","country","landings")

# excluding the current year and year before 1945
#landings = landings[landings$year != CY & landings$year>=1945,]
landings$country = as.factor(landings$country)

#########################
# reconstruction
#########################
landings$llandings<-log(landings$landings+0.001) #introduce +0.001 to use 0 data
landings$year<-as.factor(landings$year)
glm_la<-glm(llandings~year+country,data=landings)
summary(glm_la) # check fit
landings2<-expand.grid("year"=levels(landings$year),"country"=levels(landings$country))
landings2$pred=predict(glm_la,newdat=landings2,type="response")


# BELOW WE REPLACE MISSING VALUES BY THE PREDICTED MODELLED
for (y in unique(landings$year)){
  for (c in levels(landings$country)){
    if (length(landings[landings$year==y&landings$country==c,"landings"])==0){ # no data ==> replace by predicted
      landings2[landings2$year==y&landings2$country==c,"landings"]<-round(exp(landings2[landings2$year==y&landings2$country==c,"pred"]))
      landings2[landings2$year==y&landings2$country==c,"predicted"]<-TRUE
    } else {
      # use actual value
      landings2[landings2$year==y&landings2$country==c,"landings"]<-round(landings[landings$year==y&landings$country==c,"landings"])
      landings2[landings2$year==y&landings2$country==c,"predicted"]<-FALSE
    }
  }
}
landings2$year<-as.numeric(as.character(landings2$year))

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
  
 complete2<-landings2
 completeraw<-landings

########
# FUnction
########

 #TODO change the name of the column to be adapt to the data base
 # TODO add inputs in the function to call cou_cod and col
 
###For the graph we need a table with column names: eel_cou_code (2 letters code), eel_year, eel_value, pred and predicted 
 ### we also need cou_cod and col
CombinedCLandingsGraph<-function (dataset="data", title=NULL)
{ 
  complete2<-dataset

    ### To order the table by country (geographical position)
    Country<-factor(complete2$country,levels=cou_cod,ordered=T)
    Country<-droplevels(Country)
    
    landings_year<-aggregate(landings~year, complete2, sum)
    #########################
    # graph
    #########################

    # reconstructed
    g_reconstructed_landings <- ggplot(complete2) + geom_col(aes(x=year,y=landings,fill=Country),position='stack')+
      ggtitle(title)+ 
      xlab("Year") + ylab("Landings (tons)")+
      coord_cartesian(expand = FALSE, ylim = c(0, max(landings_year$landings)*1.6)) +
      scale_fill_manual(values=col)+
      theme_bw()
    
    # percentage of original data
    g_percentage_reconstructed <- ggplot(complete2)+geom_col(aes(x=year,y=landings,fill=!predicted),position='stack')+
      xlab("") + 
      ylab("")+
      scale_fill_manual(name = "Data", values=c("black","grey"),labels=c("Predicted","Raw"))+
      theme_bw()+    
      theme(legend.position="top")

    
    g3_grob <- ggplotGrob(g_percentage_reconstructed)
    g_combined_landings <- g_reconstructed_landings+annotation_custom(g3_grob, xmin=min(complete2$year), xmax=max(complete2$year), ymin=max(landings_year$landings)*1.05, ymax=max(landings_year$landings)*1.6)
    x11()

    
    print(g_combined_landings)
    

  
  return(g_combined_landings)

}
 

 