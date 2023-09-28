#' predict_model
#' makes prediction using the fitted model
#' @param mymodel the name of the object containing the model
#' @param reference reference period for standardization
#' @return a table with prediction
#' @export
#'
#' @examples
predict_model <- function(mymodel, reference = 1960:1979){
  #we build the prediction grid
  lookup <- c(site = "as.factor(site)")
  newdata <- expand.grid(mymodel$xlevels) %>%
    rename(any_of(lookup))
  
  names(mymodel$xlevels) <- ifelse(names(mymodel$xlevels) == "as.factor(site)",
                                   "site",
                                   names(mymodel$xlevels))
  
  #we only predict for reference site
  if ("site" %in% names(newdata))
    newdata <- newdata %>%
    dplyr::filter(site==mymodel$xlevels$site[1]) %>%
    mutate(year = as.numeric(as.character(year_f)))
  
  newdata$p=predict(mymodel ,newdata = newdata)
  newdata$se=predict(mymodel, newdata = newdata, se.fit=TRUE)[["se.fit"]]
  
  variables <- names(mymodel$xlevels)
  vargroup <- variables[! variables %in% c("year_f", "site")]
  if (length(vargroup) == 0){
    newdata <- newdata %>%
      mutate(customgroup = "1")
    vargroup = "customgroup"
  }
  newdata <- newdata %>%
    group_by(!!sym(vargroup))
  
  #rescale by reference period
  newdata <- newdata %>%
    group_by(!!sym(vargroup)) %>%
    mutate(mean_ref = mean(ifelse(year %in% reference, p, NA), #compute mean over the reference period
                           na.rm = TRUE)) %>%
    mutate(p_std = exp(p - mean_ref),
           p_std_min = exp(p - mean_ref - 1.96 * se),
           p_std_max = exp(p - mean_ref + 1.96 * se)) %>%
    ungroup() %>%
    dplyr::select(-any_of("customgroup"))
  newdata
  
}


#' plot_trend_model
#' makes a ggplot of time-trend of a model
#' @param predtable the table of prediction, should have a column year, a column
#' vargroup and column p_std, p_std_in and p_std_max

#' @param xlab xaxis title
#' @param ylab yaxis title
#' @param palette the colors to be used, if NULL (default) standard ggplot
#' colors will be used
#' @param logscale should a logscale y be used for y axis(default FALSE) 
#' @param ... other option send to theme
#' @return a ggplot
#' @export
#'
#' @examples

plot_trend_model <- function(predtable, 
                             xlab = "", 
                             ylab = "",
                             palette = NULL,
                             logscale = FALSE,
                             ...){
  variables <- names(predtable)
  vargroup <-  variables[!variables %in% c("year_f",
                                           "site", 
                                           "year", 
                                           "p", 
                                           "se",
                                           "mean_ref", 
                                           "p_std",
                                           "p_std_min",
                                           "p_std_max")]
  showlegend <- length(vargroup) > 0 #we do not display legend if no grouping
  if (length(vargroup) > 0){
    if (length(vargroup) > 1){
      predtable$group <- interaction(predtable[vargroup],
                                     sep = ":")
      p <- ggplot(predtable,
                  aes(x = year,
                      y = p_std)) 
      vargroup <- "group"
    } else {
      p <- ggplot(predtable,
                  aes(x = year,
                      y = p_std) )
    }
  } else {
    predtable$group <- "1"
    vargroup <- "group"
    p <- ggplot(predtable, aes(x = year, y = p_std))
  }
  p <- p + 
    geom_line(aes(col = !!sym(vargroup)), show.legend = showlegend) +
    geom_ribbon(aes(ymin = p_std_min,
                    ymax = p_std_max,
                    fill = !!sym(vargroup)),
                alpha = .3,
                show.legend = showlegend)
  if (logscale)
    p <- p + scale_y_log10()
  if (!is.null(palette))
    p <- p + 
    scale_fill_manual(values = palette) + 
    scale_color_manual(values = palette)
  p <- p + xlab(xlab) + ylab(ylab) +theme(...) + labs(fill = "", col = "")
  p + theme_bw() + theme(...)
}




#' load_database
#' In this chunk everything will be loaded. 
# The data selection is made tranparently later in the function "select_series"
# this fuction requires a db connection

#' @param con A DBI connection
#' @param path A vector of path to the place where the data will be saved
#' @param year The current year
#' @return nothing
#' @export
#'
#' @examples
load_database <- function(con, path, year=strftime(Sys.Date(), format="%Y")){
  
  # Description of the series -------------------------------
  # this will load series used in recruitment ser_typ_id = 1
  
  query ='select 
    ser_id, ser_nameshort, ser_namelong, ser_typ_id, ser_effort_uni_code,
    ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, ser_locationdescription,
    ser_emu_nameshort, ser_cou_code, ser_area_division, ser_x, ser_y,             
    ser_sam_id, ser_qal_id, ser_qal_comment,     
    "tblCodeID", "Station_Code", "Country", "Organisation", "Station_Name",       
    cou_code, cou_country, cou_order, cou_iso3code,
    lfs_code, lfs_name, lfs_definition,              
    ocean,  subocean, f_area, f_subarea,  f_division
    from datawg.t_series_ser 
    left join ref.tr_station on ser_tblcodeid=tr_station."tblCodeID"
    left join ref.tr_country_cou on cou_code=ser_cou_code 
    left join ref.tr_lifestage_lfs on ser_lfs_code=lfs_code
    left join ref.tr_faoareas on ser_area_division=f_division
    where ser_typ_id=1'
  
  R_stations= dbGetQuery(con, query)
  
  # Main data  --------------------------------------------------------------
  
  query <- 'SELECT 
    das_id,
    das_value,       
    das_year,
    das_comment,
    /* 
    -- below those are data on effort, not used yet
    
    das_effort, 
    ser_effort_uni_code,       
    das_last_update,
    */
    /* 
    -- this is the id on quality, used from 2018
    -- to remove the data with problems on quality from the series
    -- see WKEEKDATA (2018)
    das_qal_id,
    */ 
    ser_id,            
    cou_order,
    ser_nameshort,
    ser_area_division,
    ser_qal_id,
    ser_y,
    /* 
    -- this is the id on quality at the level of individual lines of data
    -- checks are done later to ensure provide a summary of the number of 0 (missing data),
    -- 3 data discarded, 4 will nor be used either and there should be no series with that code....
    */ 
    das_qal_id,
    das_last_update,
    f_subarea,
    lfs_code,          
    lfs_name
    from datawg.t_dataseries_das 
    join datawg.t_series_ser on das_ser_id=ser_id
    left join ref.tr_lifestage_lfs on ser_lfs_code=lfs_code
    left join ref.tr_faoareas on ser_area_division=f_division
    left join ref.tr_country_cou on  cou_code=ser_cou_code
    where ser_typ_id=1'
  
  wger_init <- dbGetQuery(con, query) # (wge)el (r)ecruitment data
  wger_init <- chnames(wger_init,
                       c("das_id","das_value","das_year","ser_nameshort","ser_area_division","lfs_name"),
                       c("id","value","year","site","area_division","lifestage"))
  
  # selection of the last years with problem for graph --------------------------------------------
  
  query <- paste0("SELECT * FROM datawg.t_series_ser join  datawg.t_dataseries_das ON das_ser_id = ser_id
        WHERE das_year in(", paste(year,year-1,sep=",",collapse=","),") AND das_qal_id IN (0,3,4) and ser_typ_id=1;")
  last_years_with_problem <- dbGetQuery(con, query)
  
  
  # When were the series included ? -------------------------------
  
  query='SELECT * FROM datawg.t_seriesglm_sgl'
  inclusion <- dbGetQuery(con, query)
  ############################################################################
  # Rebuilding areas used by wgeel (North Sea, Elswhere Europe) from area_divisions
  # See Ices (2008) for the reason why we need to do that
  # We cannot use just one series, as the series from the North Sea have dropped more
  # rapidly than the others, and are now at a much lower level.
  # Some of that drop might be explained by decreasing catch in some of the semi-commercial
  # catch and trap and transport series (Ems, Vidaa) but it also concerns fully scientific
  # Estimates....
  ###############################################################################
  wger_init[,"area"] <- NA
  # below these are area used in some of the scripts see wgeel 2008 and Willem's Analysis 
  # but currently wgeel only uses two areas so the following script is kept for memory
  # but mostly useless
  wger_init$area2[wger_init$f_subarea%in%'27.4'] <- "North Sea"
  wger_init$area2[wger_init$f_subarea%in%'27.3'] <- "Baltic"
  wger_init$area2[wger_init$f_subarea%in%c('27.6','27.7','27.8','27.9')] <- "Atlantic"
  wger_init$area2[wger_init$f_subarea%in%c('37.1','37.2','37.3')] <- "Mediterranean Sea"
  wger_init[wger_init$area2%in%c("Atlantic","Mediterranean Sea"),"area"] <- "Elsewhere Europe"
  # We consider that the series of glass eel recruitment in the Baltic are influenced
  # similarly in the Baltic and North Sea. This has no effect on Baltic data
  wger_init[wger_init$area2%in%c("Baltic","North Sea"),"area"] <- "North Sea"
  
  #check if all series have been assign to an area
  if (sum(is.na(wger_init$area))>0) {
    
    cat("sites with qal_id 1 or 4 and no ref")
    wger_init %>% dplyr::filter(is.na(area)&(ser_qal_id==1|ser_qal_id==4)) %>% dplyr::select(site) %>% distinct()
    cat("sites with qal_id 0 and no ref")
    wger_init %>% dplyr::filter(is.na(area)&ser_qal_id!=1) %>% dplyr::select(site) %>% distinct()
    stop("At least one series has not been affected to an area, stop this script NOW and check !!!")
  }
  wger_init$area <- as.factor(wger_init$area)
  # We will also need this for summary tables per recruitment site, here we go straight to 
  # the result
  R_stations[,"area"] <- NA
  R_stations$area[R_stations$f_subarea%in%c('27.4','27.3')] <- "North Sea"
  R_stations$area[R_stations$f_subarea%in%c('27.6','27.7','27.8','27.9','37.1','37.2','37.3')] <- "Elsewhere Europe"
  #REMOVE THIS !!!!!!!!!!!
  #R_stations$area[is.na(R_stations$area)]<-"Elsewhere Europe"
  #wger_init$area[is.na(wger_init$area)]<-"Elsewhere Europe"
  
  
  stopifnot(all(!is.na(R_stations$f_subarea)))
  
  # Check that there was no error in the query (while joining foreign table)
  stopifnot(all(!duplicated(wger_init$id)))
  # creates some variables
  wger_init$decade=factor(trunc(wger_init$year/10)*10)
  wger_init$year_f=factor(wger_init$year)
  wger_init$decade=factor(wger_init$decade,level=sort(unique(as.numeric(as.character(wger_init$decade)))))
  wger_init$ldata=log(wger_init$value)
  wger_init$lifestage=as.factor(wger_init$lifestage)
  
  # This is a view (like the result of a query) showing a summary of each series, including first year, last year,
  # and duration
  statseries <- dbGetQuery(con, 'select site,namelong,min,max,duration,missing,life_stage,sampling_type,unit,habitat_type,"order",series_kept
        from datawg.series_summary where ser_typ_id=1')
  t_series_ser <- dbGetQuery(con, 'select ser_id,ser_nameshort,ser_namelong,ser_typ_id,ser_effort_uni_code,
        ser_comment,ser_uni_code,ser_lfs_code,ser_hty_code,ser_locationdescription,ser_emu_nameshort,ser_cou_code,
        ser_area_division,ser_tblcodeid,ser_x,ser_y,ser_sam_id,ser_qal_id,ser_qal_comment,ser_ccm_wso_id,ser_dts_datasource,
        ser_distanceseakm,ser_method,ser_sam_gear,ser_restocking from datawg.t_series_ser where ser_typ_id =1 ')
  # fix integer64 rounded to zero :-o
  statseries$missing <- as.integer(statseries$missing)
  # these data will 
  for (i in 1:length(path)){
    save(wger_init,file=str_c(path[i],"wger_init.Rdata"))
    save(statseries,file=str_c(path[i],"statseries.Rdata"))
    save(R_stations,file=str_c(path[i],"R_stations.Rdata"))
    save(last_years_with_problem,file=str_c(path[i],"last_years_with_problem.Rdata"))
    save(t_series_ser, file=str_c(path[i],"t_series_ser.Rdata"))
    write.table(R_stations, sep=";",file=str_c(path[i],"R_stations.csv"))
  }
  
  
}

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
    warning("sn applique a un character")
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
  if (CY-10*floor(CY/10)!=9)	dat[(length(dat)+1):10]<-NA	
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
  if (CY-10*floor(CY/10)!=9)	dffin[(nrow(dffin)+1):10,]<-NA
  df<-cbind(df,dffin)
  cgroupdecade<<-cgroupdecade
  return(df)
}



#' quote_string
#'
#' @param string 
#'
#' @return the string between quotes
#' @export
#'
#' @examples
quote_string <- function(string){
  paste0("'", string, "'")
}
