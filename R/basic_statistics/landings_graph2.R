# Produce graph for landings and reconstruct landings
# 2011
# Author: cedric.briand
###############################################################################

#########################
# INITS
#########################
source("R/utilities/load_library.R")
load_library(c("ggplot2", "reshape", "rJava","reshape2", "stringr", "dplyr", "lattice", "RColorBrewer", "grid"))

source("R/utilities/set_directory.R")
set_directory("result")
set_directory("data")

CY = as.numeric(format(Sys.time(), "%Y")) # year of work

# load data
landings_complete <-read.table(str_c(data_wd,"/landings.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
landings_complete$eel_value<-as.numeric(landings_complete$eel_value) / 1000
landings_complete$eel_hty_code = factor(landings_complete$eel_hty_code, levels = rev(c("MO", "C", "T", "F", "AL")))



###create a subset
graph<-function (dataset="data.csv", countries=NULL, year_min, year_max,lfs=NULL, habitat=NULL)
{ 
 
# for landings only
  
# download the data + transform into tonnes + create new names for the habitat  
  landings_complete <-read.table(str_c(data_wd,"/landings.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
  landings_complete$eel_value<-as.numeric(landings_complete$eel_value) / 1000
  landings_complete$eel_hty_code = factor(landings_complete$eel_hty_code, levels = rev(c("MO", "C", "T", "F", "AL")))
  
  #load country and ordered 
  set_directory("reference")
  
  country_cod <-read.table(str_c(reference_wd,"/tr_country_cou.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
  country_cod<-country_cod[order(as.factor(country_cod$cou_order)),]
  cou_cod<-country_cod$cou_code
# For commercial landings
  
  # reconstruction for G and Y+S using all the data available: create the prediction data
  #########################
  
  ### For Glass eel
  
  if (lfs=="G"){
    
    # select the glass eel + sum the habitats by country and by year + rename the column
    
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
    if (is.null(countries)){countries=as.character(unique(landings2$country))}
    complete2<-filter(landings2,year %in% seq(year_min, year_max, by=1) & country %in% countries)
    completeraw<-filter(landings,year %in% seq(year_min, year_max, by=1) & country %in% countries)
    
  } 
  
  ### To order the table by country (geographical position)
  countryF<-factor(complete2$country,levels=cou_cod,ordered=T)
  countryF<-droplevels(countryF)
  
  ### Create the table by country by year
  tableLandingCountry<-round(xtabs(landings~year+countryF, data = complete2))

  #########################
  # graph
  #########################
  #cols<-c(brewer.pal(12,"Set3"),brewer.pal(length(levels(complete2$country))-12,"Set1"))
  
  #cols<-c(brewer.pal(12,"Accent"),brewer.pal(length(levels(cou_cod))-12,"Set1"))
  count<-length(cou_cod)
  
  values=colorRampPalette(brewer.pal(9, "Accent"))(count)
  
  col = setNames(values, levels(as.factor(cou_cod)))
  
  # reconstructed
  g_reconstructed_landings <- ggplot(complete2) + geom_col(aes(x=year,y=landings,fill=countryF),position='stack')+
    ggtitle("Commercial Landings (G) combined")+ #+ scale_x_continuous(breaks = seq(1950, 2030, 10))
  xlab("Year") + ylab("Landings (tons)")+
    coord_cartesian(expand = FALSE, ylim = c(0, max(complete2$landings)*1.6)) + #TODO: change 25000 for max*1.1
    scale_fill_manual(values=col)+
    theme_bw()#+ 
  #scale_fill_manual(palette="Accent")
  
  # raw
  #g_raw_landings <- ggplot(completeraw) + geom_col(aes(x=year,y=landings,fill=countryF,legend = FALSE),position='stack')+
    #ggtitle("Commercial Landings (Y+S) uncorrected") + xlab("year") + ylab("Landings (tons)")+
    #scale_fill_manual(values=cols)+
    #theme_bw() + # make the theme black-and-white rather than grey (do this before font changes, or it overrides them)
    #xlim(c(1945, CY))+ 
    #scale_fill_manual(palette="Accent")
  
  # percentage of original data
  g_percentage_reconstructed <- ggplot(complete2)+geom_col(aes(x=year,y=landings,fill=!predicted),position='stack')+
    #ggtitle("Landings (Y+S) recontructed from missing or original") +
    xlab("") + 
    ylab("")+
    scale_fill_manual(name = "Original data", values=c("black","grey"))+
    theme_bw()+    
    theme(legend.position="top")
  print(g_percentage_reconstructed)
  print(g_reconstructed_landings)
  
  g3_grob <- ggplotGrob(g_percentage_reconstructed)
  g_combined_reconstructed <- g_reconstructed_landings+annotation_custom(g3_grob, xmin=min(complete2$year), xmax=max(complete2$year), ymin=max(complete2$landings)*1.05, ymax=max(complete2$landings)*1.6)
  x11()

  print(g_combined_reconstructed)

  
  
  return(g_combined_reconstructed)
  return (tableLandingCountry)
  }

#trial<-graph (dataset="landings_complete",lfs="G", year_min=1990, year_max=2015)


  
