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
#' @param precodata data.frame with column being: eel_emu_nameshort	bcurrent	bbest	b0	suma, using extract_precodata()
#' @examples
#' x11()
#' trace_precodiag(extract_precodata())
# TODO: offer the possibility to aggregate by country
trace_precodiag = function(precodata, title = "Precautionary diagram per EMU",precodata_choice=c("emu","country","all"), last_year=true)
{  
    ###############################
    # Data selection
    # this in done on precodata which is filtered by the app using filter_data
    #############################
    
	############################
	# Data for buble plot 
	############################
	mylimits=c(0,1000)
	precodata$pSpR=exp(-precodata$suma)
	precodata$pbiom=precodata$bcurrent/precodata$b0
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

	g<-     ggplot(df)+
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
			scale_color_discrete(guide = 'none') +
			geom_point(data=precodata,aes(x=pbiom,y=suma,size=bbest), colour = "pink",alpha=0.7)+ 
			
			annotate("text",x=precodata$pbiom,y=precodata$suma,
					label=paste(precodata$aggreg_area, "-\'", substr(precodata$eel_year, 3, 4), sep = ""),size=3,hjust=0)+
			scale_size(name="B best (millions)",range = c(1, 25),limits=c(0,max(pretty(precodata$bbest))))+
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
	return(g)
}
