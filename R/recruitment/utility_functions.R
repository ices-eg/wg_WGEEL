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
					panel.margin = unit(0.25, "lines"), 
					
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
geomean=function(x){
	x<-x[!is.na(x)]
	n=length(log(x)[!is.infinite(log(x))&!is.na(log(x))])
	return(data.frame("y"=exp(sum(log(x)[!is.infinite(log(x))&!is.na(log(x))])/n)))
}

