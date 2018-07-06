# TODO create a variable for all the functions name cou_cod: load country and ordered 
set_directory("reference")

country_cod <-read.table(str_c(reference_wd,"/tr_country_cou.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
country_cod<-country_cod[order(as.factor(country_cod$cou_order)),]
cou_cod<-country_cod$cou_code

# TODO create a variable name col assigning color to each country for all the graphs


values=c(brewer.pal(12,"Set3"),brewer.pal(12, "Paired"), brewer.pal(8,"Accent"),
         
         brewer.pal(7, "Dark2"))

col = setNames(values,cou_cod)

# load data
aquaculture <-read.table(str_c(data_wd,"/aquaculture.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
aquaculture$eel_value<-as.numeric(aquaculture$eel_value)
aquaculture$eel_value = aquaculture$eel_value / 1000 
aquaculture[is.na(aquaculture$eel_value),]

a1<-as.data.frame(aquaculture%>%dplyr::group_by(eel_cou_code,eel_year)%>%filter(eel_typ_id==11)%>%
  summarize(eel_value=sum(eel_value,na.rm=TRUE)))

########
# FUnction
########

###For the graph we need a table with column names: eel_cou_code (2 letters code), eel_year, eel_value, eel_lfs_code 
### we also need cou_cod and col
aqualcultureGraph<-function (dataset="data", title=NULL)
{ 
  a1<-data
  ### To order the table by country (geographical position)
  Country<-factor(a1$eel_cou_code,levels=cou_cod,ordered=T)
  Country<-droplevels(Country)
  
aquaculture<-ggplot(a1)+geom_col(aes(x=eel_year,y=eel_value,fill=Country))+
  ggtitle(title) + xlab("year") + ylab("Production (tons)")+
  scale_fill_manual(values=col)+
  scale_y_continuous(breaks = seq(0,10000, 2000))+
  theme_bw()
return(aquaculture)
}