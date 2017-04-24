#-----------------------------------------------------------------------------
# Author: cedric.briand
# utility functions for recruitment
#-----------------------------------------------------------------------------


#' Function to remove unwanted charaters from latex code
#' @param str A string
sanitizeLatexS <- function(str) {
	gsub('([#$%&~_\\^\\\\{}])', '\\\\\\\\\\1', str, perl = TRUE);
}


#' Function to sanitize code before sending to latex
#' @param str x A string
#' @param scientific, default FALSE, if true scientific notation
#' @param digits, number of digits expected in the sweave output
sn <- function(x,scientific=FALSE,digits=0)
{
	if (class(x)=="character") {                
		warning("sn appliqué a un character")
		return(x)
	}
	if (length(x)==0) {                
		warning("sn length 0")
		return("???")
	}
	if (x==0) return("0")
	ord <- floor(log(abs(x),10))
	if (scientific==FALSE&ord<9){
		if (digits==0) {
			digits=max(1,ord) # digits must be >0
			nsmall=0
		}else {
			nsmall=digits
		}
		x<-format(x,big.mark="~",small.mark="~",digits=digits,nsmall=nsmall)
		return(str_c("$",as.character(x),"$"))                
	} else {
		x <- x / 10^ord
		if (!missing(digits)) x <- format(x,digits=digits)
		if (ord==0) return(as.character(x))
		return(str_c("$",x,"\\\\times 10^{",ord,"}$"))
	}
}

#' function to create a back theme,  deprecated by latest ggplot releases
theme_black <- function (base_size = 12,base_family=""){
	theme_grey(base_size=base_size,base_family=base_family) %+replace%
			theme(
					axis.line = element_blank(), 
					axis.text.x = element_text(size = base_size * 0.8, colour = 'white', lineheight = 0.9, vjust = 1, margin=margin(0.5,0.5,0.5,0.5,"lines")), 
					axis.text.y = element_text(size = base_size * 0.8, colour = 'white', lineheight = 0.9, hjust = 1, margin=margin(0.5,0.5,0.5,0.5,"lines")), 
					axis.ticks = element_line(colour = "white", size = 0.2), 
					axis.title.x = element_text(size = base_size, colour = 'white', vjust = 1), 
					axis.title.y = element_text(size = base_size, colour = 'white', angle = 90, vjust = 0.5), 
					axis.ticks.length = unit(0.3, "lines"), 
					
					
					legend.background = element_rect(colour = NA, fill = 'black'), 
					legend.key = element_rect(colour = NA, fill = 'black'), 
					legend.key.size = unit(1.2, "lines"), 
					legend.key.height = NULL, 
					legend.key.width = NULL,     
					legend.text = element_text(size = base_size * 0.8, colour = 'white'), 
					legend.title = element_text(size = base_size * 0.8, face = "bold", hjust = 0, colour = 'white'), 
					#legend.position = c(0.85,0.6), 
					legend.text.align = NULL, 
					legend.title.align = NULL, 
					legend.direction = "vertical", 
					legend.box = NULL,    
					
					panel.background = element_rect(fill = "black", colour = NA), 
					panel.border = element_rect(fill = NA, colour = "white"), 
					panel.grid.major = element_blank(), 
					panel.grid.minor = element_blank(), 
					panel.spacing = unit(0.25, "lines"), 
					
					strip.background = element_rect(fill = "grey30", colour = "grey10"), 
					strip.text.x = element_text(size = base_size * 0.8, colour = 'white'), 
					strip.text.y = element_text(size = base_size * 0.8, colour = 'white', angle = -90), 
					
					plot.background = element_rect(colour = 'black', fill = 'black'), 
					plot.title = element_text(size = base_size * 1.2, colour = "white"), 
					plot.margin = unit(c(1, 1, 0.5, 0.5), "lines")
			)
}
#' Calculates the geometric means of a series
#' @param x a numeric
#' @return A data frame with one column y
geomean=function(x,na.rm=TRUE){
	if (na.rm) x<-x[!is.na(x)]
	n=length(log(x)[!is.infinite(log(x))&!is.na(log(x))])
	return(data.frame("y"=exp(sum(log(x)[!is.infinite(log(x))&!is.na(log(x))])/n)))
}

#' save a figure in jpeg, bmp, png and pdf format
#' @param width a numeric
#' @param height a numeric
#' @return nothing
save_figure<-function(figname,fig,width,height){
	setwd(imgwd)
	#savePlot()
	jpeg(filename = paste(figname,".jpeg",sep=""), width = width, height = height)
	print(fig)
	dev.off()
	
	bmp(filename = paste(figname,".bmp",sep=""), width = width, height = height)
	print(fig)
	dev.off()
	
	png(filename = paste(figname,".png",sep=""), width = width, height = height)
	print(fig)
	dev.off()
	
	pdf(file= paste(imgwd,"/",figname,".pdf",sep=""), width = width/100, height = height/100)
	print(fig)
	rien<-dev.off()
	setwd(wd)
	return(invisible(NULL))
}

#' split data in a format suitable for printing with decades as rows and years as columns
#' @param data A dataframe with one column and rownames year
#' @return A data frame formatted
split_per_decade<-function(data){
	dates<-as.numeric(rownames(data))
	start=min(dates)
	cgroupdecade<-vector()
	df=data.frame()
	firsttimeever<-TRUE
	while (start<10*floor(CY/10)){		
		end=start+9	
		cgroupdecade<-c(cgroupdecade,str_c(" ",start,""))
		if (firsttimeever) df<-data[as.character(start:end),,drop=FALSE] else
		df<-cbind(df,data[as.character(start:end),,drop=FALSE])
		rownames(df)<-0:9	
		start=end+1
		firsttimeever<-FALSE
	}
	df<-as.matrix(df)
	cgroupdecade<-c(cgroupdecade,str_c(" ",start,""))
	dat<-data[as.character(start:CY),]
	dat[(length(dat)+1):10]<-NA
	df<-as.data.frame(cbind(df,as.data.frame(dat)))
	colnames(df)<-cgroupdecade
	return(df)
}
#' split data in a format suitable for printing with decades as rows and years as columns
#' script adapted to glass eel
#' @param data A dataframe with two columns and rownames year
#' @return A data frame formatted
split_per_decade_ge<-function(data){
	dates<-as.numeric(rownames(data))
	start=min(dates)
	df=NULL
	cgroupdecade<-vector()
	while (start<10*floor(CY/10)){
		end=start+9	
		cgroupdecade<-c(cgroupdecade,str_c(" ",start,""))
		if(is.null(df)) {
			df<-data[as.character(start:end),]
			rownames(df)<-0:9
		}else {
			df<-cbind(df,data[as.character(start:end),])
		}
		start=end+1
	}
	cgroupdecade<-c(cgroupdecade,str_c(" ",start,""))
	dffin<-data[as.character(start:CY),]
	dffin[(nrow(dffin)+1):10,]<-NA
	df<-cbind(df,dffin)
	cgroupdecade<<-cgroupdecade
	return(df)
}