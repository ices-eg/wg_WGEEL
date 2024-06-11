# draw the eel precautionary diagram
# 
# Author: cedric.briand
###############################################################################



#' @title Draw background of the precautionary diagram
background<-function(Aminimum=0,Amaximum=6.5,Bminimum=1e-2,Bmaximum=1){
  # the left of the graph is filled with polygons
  Bminimum<<-Bminimum
  Bmaximum<<-Bmaximum
  Amaximum<<-Amaximum
  Aminimum<<-Aminimum
  B<-seq(Bminimum,0.4, length.out=30)
  Alim<-0.92
  Btrigger=0.4
  SumA<-Alim*(B/Btrigger) # linear decrease in proportion to B/Btrigger
  X<-c(B,rev(B))
  Ylowersquare<-c(SumA,rep(Aminimum,length(B)))
  df<-data.frame("B"=X,"SumA"=Ylowersquare,"color"="orange")
  Yuppersquare<-c(SumA,rep(Amaximum,length(B)))
  df<-rbind(df, data.frame("B"=X,"SumA"=Yuppersquare,"color"="red"))
  df<-rbind(df,data.frame("B"=c(0.4,0.4,Bmaximum,Bmaximum),"SumA"=c(Aminimum,0.94,0.94,Aminimum),"color"="green")) # drawn clockwise from low left corner
  df<-rbind(df,data.frame("B"=c(0.4,0.4,Bmaximum,Bmaximum),"SumA"=c(0.94,Amaximum,Amaximum,0.94),"color"="orange1")) # drawn clockwise from low left corner
  return(df)
}

#' @title Draw precautionary diagram itself
#' @param precodata data.frame with column being: eel_emu_nameshort	bcurrent	bbest	b0	suma, using extract_data("precodata")
#' @param adjusted_b0 should adjusted_b0 following WKEMP2021 be used?
#' @examples
#' x11()
#' trace_precodiag( extract_data("precodata"))
# TODO: offer the possibility to aggregate by country
trace_precodiag = function(precodata, 
                           precodata_choice=c("emu","country","all"), 
                           last_year=TRUE, adjusted_b0=FALSE)
{  
  ###############################
  # Data selection
  # this in done on precodata which is filtered by the app using filter_data
  #############################
  precodata$last_year[is.na(precodata$last_year)] <- precodata$eel_year[is.na(precodata$last_year)]
  if (last_year) precodata <- precodata[precodata$last_year==precodata$eel_year ,]
  
  if (length(precodata_choice) >1 ) title= "Precautionary diagram" else
    switch(precodata_choice,
           "emu"={title <- "Precautionary diagram for emu"},
           "country"={title <- "Precautionary diagram for country"},
           "all"={title <- "Precautionary diagram for all countries"},
    )
  
  precodata<-precodata[precodata$aggreg_level%in%precodata_choice,]
  ############################
  # Data for buble plot 
  ############################
  mylimits=c(0,1000)
  precodata$pSpR=exp(-precodata$suma)
  precodata$pbiom=precodata$ratio_bcurrent_b0
  if (length(precodata_choice) == 1){
    if (adjusted_b0 & precodata_choice == "emu")
    {
      precodata$pbiom=precodata$bcurrent / mapply(estimate_adjusted_b0, precodata$eel_emu_nameshort, precodata$eel_year,
                                                  MoreArgs=list(precodata = precodata))
    }
  }
  if (any(precodata$bcurrent>precodata$b0,na.rm=TRUE)){
    cat("You  have Bbest larger than B0, you should check \n")
    Bmaximum<-max(precodata$pbiom,na.rm=TRUE)
  } else Bmaximum=1
  if (any(is.na(precodata$b0))) cat("Be careful, at least some B0 are missing")
  if (max(precodata$bbest,na.rm=TRUE)>mylimits[2]) mylimits[2]<-max(precodata$bbest,na.rm=TRUE)
  if (all(is.na(precodata$pbiom))|all(is.na(precodata$pSpR))) errortext<-"Missing data" else errortext<-""
  df<-background(Aminimum=0,Amaximum=5,Bminimum=exp(-5),Bmaximum=Bmaximum)
  ######################
  # Drawing the graphs
  ############################
  # If EMU only show labels
  if (length(precodata_choice)==1){    
    choose_label_for_plot <- rep(TRUE,length(precodata))
    choose_color <- "eel_year"
    
    
  } else {
    
    choose_label_for_plot <- precodata$aggreg_level != "emu"
    choose_color <- "aggreg_level"
  }
  precodata$eel_year <- as.factor(precodata$eel_year)
  g<- ggplot(df)+
    theme_bw()+
    theme(legend.key = element_rect(colour = "white"))+
    geom_polygon(aes(x=B,y=SumA,fill=color),alpha=0.7)+
    scale_fill_identity(labels=NULL)+
    scale_x_continuous(name=expression(paste(bold("Spawner escapement")~ ~over(B,B0))),
                       limits=c(Bminimum, Bmaximum),trans="log10",
                       breaks=c(0.005,0.01,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1),
                       labels=c("","1%","5%","10%","","","40%","","","","","","100%"))+ 
    scale_y_continuous(name=expression(paste(bold("Lifetime mortality")~ ~symbol("\123"),"A")),
                       limits=c(Aminimum, Amaximum)) +
    #geom_path(data = precodata,aes(x = pbiom, y = suma, group = eel_cou_code))+
    #scale_color_discrete(#guide = 'none'
    #    ) +
    geom_point(
      data = precodata,
      aes(x = pbiom, y = suma, size = bbest, color = choose_color),
      alpha = 0.7
    ) +
    geom_text_repel(
      data = precodata,
      aes(
        x = pbiom,
        y = suma,
        label = paste(aggreg_area, substr(eel_year, 3, 4), sep = "")#,
                                        #size=bbest/8
    ),
    show.legend = FALSE      
    )+
    scale_size(name="B best (millions)",range = c(2, 25),limits=c(0,max(pretty(precodata$bbest))))+
    annotate("text",x =  1, y = 0.92, label = "0.92",  parse = F, hjust=1,vjust=-1.1, size=3)+
    annotate("text",x =  1, y = 0.92, label = "Alim",  parse = F, hjust=1,vjust=1.1, size=3)+
    annotate("text",x =  0.4, y = 0, label = "Blim",  parse = F, hjust=0,vjust=-0.7, size=3,angle=90)+
    annotate("text",x =  0.4, y = 0, label = "Btrigger",  parse = F, hjust=0,vjust=1.1, size=3,angle=90)+
    #annotate("text",x =  0.1, y = 2, label = errortext,  parse = F, hjust=1,vjust=1, size=5,col="white")+
    annotate("text",x =  Bminimum, y = 0, label = "100% -",  parse = F, hjust=1, size=3)+
    annotate("text",x =  Bminimum, y = 1.2, label = "30% -",  parse = F, hjust=1, size=3)+
    annotate("text",x =  Bminimum, y = 1.6, label = "20% -",  parse = F, hjust=1, size=3)+
    annotate("text",x =  Bminimum, y = 2.3, label = "10% -",  parse = F, hjust=1, size=3)+
    annotate("text",x =  Bminimum, y = 2.99, label = "5% -",  parse = F, hjust=1, size=3)+
    annotate("text",x =  Bminimum, y = 4.6, label = "1% -",  parse = F, hjust=1, size=3)+
    annotate("text",x =  Bminimum, y = Amaximum, label = "%SPR",  parse = F, hjust=1,vjust=-3,size=3,angle=90)+               
    ggtitle(str_c(title))
  if(pretty(max(precodata$suma,na.rm=TRUE))[2] > 4.6)   g = g +annotate("text",x =  Bminimum, y = 4.6, label = "1%",  parse = F, hjust=1, size=3) 
  if (choose_color == "eel_year")
    g + viridis::scale_colour_viridis(discrete = TRUE) else
      g + scale_colour_brewer(palette = "Set3", direction = -1)
  
  
  
  return(g)
}


#' estimate_adjusted_b0
#' this function estimates adjusted b0 based on recruitment model and bbest
#' following WKEMP 2020. The function uses data stored in annex13.Rdata to
#' know whether mortality are estimated computed year wise or cohort wise
#' and therefore to know if shifting recruitment is required
#' @param emu The considered EMU
#' @param year the year of interest
#' @param precodata the precodata
#'
#' @return
#' @export
#'
#' @examples
estimate_adjusted_b0 = function(emu, year, precodata){
  mor_wise = annexes13_method %>%
    filter(!is.na(emu_nameshort)) %>%
    mutate(rec_zone = ifelse(cou_code %in% c("NL","DK","NO","BE","LU", "CZ","SK") |
                               emu_nameshort %in% c("FR_Rhin","FR_Meus","GB_Tham","GB_Angl","GB_Humb","GB_Nort","GB_Solw",
                                                    "DE_Ems","DE_Wese","DE_Elbe","DE_Rhei","DE_Eide","DE_Maas") ,
                             "NS", 
                             ifelse(cou_code %in% c("EE","FI","SE","LV","LT","AX", "PL","DE"),
                                    "BA",
                                    "EE"))) %>%
    select(emu_nameshort,mortality_wise,rec_zone) %>%
    mutate(cohort_wise=grepl("ohort",mortality_wise)) %>%
    mutate(emu_nameshort=ifelse(emu_nameshort=="NL_Neth", "NL_total",emu_nameshort))
  
  if (!emu %in% unique(mor_wise$emu_nameshort))
    return(NA)
  
  mod = switch(unique(mor_wise$rec_zone[mor_wise$emu_nameshort == emu]),
               "EE" = dat_ge %>% filter (area == "Elsewhere Europe"),
               "NS" = dat_ge %>% filter (area == "North Sea"),
               "BA" = dat_ye)
  if ("value_std_1960_1979" %in% names(mod)){
    Rcurrent <- mean(mod$value_std_1960_1979[mod$year %in% ((year-4):year)])
  } else {
    Rcurrent <- mean(mod$p_std_1960_1979[mod$year %in% ((year-4):year)])
  }
  
  
  if (unique(mor_wise$cohort_wise[mor_wise$emu_nameshort==emu]))
    Rcurrent <- switch(mor_wise$rec_zone[mor_wise$emu_nameshort == emu],
                       "EE" = mean(mod$p_std_1960_1979[mod$year %in% ((year-12):(year-7))]),
                       "NS" = mean(mod$p_std_1960_1979[mod$year %in% ((year-17):(year-12))]),
                       "BA" = mean(mod$value_std_1960_1979[mod$year %in% ((year-22):(year-17))]))
  unique(precodata$bbest[precodata$eel_emu_nameshort==emu & precodata$eel_year==year] / Rcurrent)
}
