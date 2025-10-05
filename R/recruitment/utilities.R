library(dplyr)
library(stringr)
library(scales)

#' predict_model
#' makes prediction using the fitted model
#' @param mymodel the name of the object containing the model
#' @param reference reference period for standardization
#' @param vargroup grouping variable (default area), null if no gouping
#' @return a table with prediction
#' @export
#'
#' @examples
predict_model <- function(mymodel, reference = 1960:1979){
  #we build the prediction grid
  lookup <- c(site = "as.factor(site)")
  newdata <- expand.grid(mymodel$xlevels) %>%
      dplyr::rename(any_of(lookup))
  
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
#' @param predtable the table of prediction, should have a column year
#' and column p_std, p_std_in and p_std_max
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
      cou_code,
      cou_order,
      ser_nameshort,
      ser_area_division,
      ser_hty_code,
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
      where ser_typ_id=1 and das_qal_id in (0,1,2,3,4)'
  
  wger_init <- dbGetQuery(con, query) # (wge)el (r)ecruitment data
  wger_init <- chnames(wger_init,
      c("das_id","das_value","das_year","ser_nameshort","ser_area_division","lfs_name"),
      c("id","value","year","site","area_division","lifestage"))
  
# selection of the last years with problem for graph --------------------------------------------
  
  query <- paste0("SELECT * FROM datawg.t_series_ser join  datawg.t_dataseries_das ON das_ser_id = ser_id
          WHERE das_year in(", paste(year,year-1,sep=",",collapse=","),") AND das_qal_id IN (0,3,4) and ser_typ_id=1;")
  last_years_with_problem <- dbGetQuery(con, query)

# Issue an error if any series in recruitment has das_qal_id NULL, the db currently still has missing quality for
# Silver eel series, here we are creating a specific query
# 
  query <- "SELECT ser_nameshort, t_dataseries_das.* FROM datawg.t_dataseries_das  
  JOIN datawg.t_series_ser ON ser_id = das_ser_id
  WHERE das_qal_id IS NULL 
  AND ser_qal_id = 1
  AND ser_typ_id = 1; "
  
  problems_of_missing_quality <- dbGetQuery(con, query)
  ser_qal_missing <- unique(problems_of_missing_quality$ser_nameshort)
  w <- sprintf("Series %s has missing quality, data with das_qal_id NULL will not be queried from the database, check this series and remove NULL das_qal_id", paste(ser_qal_missing, collapse = ','))
  if (nrow(problems_of_missing_quality)>0) warning(w)
  
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
    cat("sites with qal_id 1 or 4")
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
  statseries <- dbGetQuery(con, 'select site,namelong,min,max,duration,missing,life_stage,sampling_type,unit,habitat_type,"order",series_kept,
  qal_comment
          from datawg.series_summary where ser_typ_id=1')
  t_series_ser <- dbGetQuery(con, 'select ser_id,ser_nameshort,ser_namelong,ser_typ_id,ser_effort_uni_code,
          ser_comment,ser_uni_code,ser_lfs_code,ser_hty_code,ser_locationdescription,ser_emu_nameshort,ser_cou_code,
          ser_area_division,ser_tblcodeid,ser_x,ser_y,ser_sam_id,ser_qal_id,ser_qal_comment,ser_ccm_wso_id,ser_dts_datasource,
          ser_distanceseakm,ser_method,ser_sam_gear,ser_restocking from datawg.t_series_ser where ser_typ_id =1 ')
# fix integer64 rounded to zero :-o
  statseries$missing <- as.integer(statseries$missing)
  for (i in 1:length(path)){
    save(wger_init,file=str_c(path[i],"wger_init.Rdata"))
    cat("writing", str_c(path[i],"wger_init.Rdata"),"\n")
    save(statseries,file=str_c(path[i],"statseries.Rdata"))
    cat("writing", str_c(path[i],"statseries.Rdata"),"\n")
    save(R_stations,file=str_c(path[i],"R_stations.Rdata"))
    cat("writing", str_c(path[i],"R_stations.Rdata"),"\n")
    save(last_years_with_problem,file=str_c(path[i],"last_years_with_problem.Rdata"))
    cat("writing", str_c(path[i],"last_years_with_problem.Rdata"),"\n")
    save(t_series_ser, file=str_c(path[i],"t_series_ser.Rdata"))
    cat("writing", str_c(path[i],"t_series_ser.Rdata"),"\n")
    write.table(R_stations, sep=";",file=str_c(path[i],"R_stations.csv"))
    cat("writing", str_c(path[i],"R_stations.csv"),"\n")
    openxlsx::write.xlsx(x=list("R_stations"=R_stations,
            "t_series_ser"=t_series_ser, "statseries"=statseries),file=str_c(outputdatawd,"series_description", CY, ".xlsx"))
    
    
  }
}

#' select_series
#' the function does the series selection, removing and displaying series that
#' are discarded or kept because of identified quality issues (ser_qal_id,
#' das_qal_id) 
#' @param wger_init the dataseries table
#' @param R_stations table with information on series
#' @return a list with data frames for further analysis, as well as selection_summary, a list
#' that includes key statistics of the selection process
#' @export
#'
#' @examples
select_series <- function(wger_init, R_stations){
  selection_summary <- list() ## selection_summary is a list to store interesting statistics
  selection_summary$sites_summary <- list()
  selection_summary$sites_summary$qal_0 <- ""
  selection_summary$sites_summary$qal_0 <- 
  wger_init %>% filter(ser_qal_id==0) %>%
      dplyr::select(site,cou_code) %>%
      mutate(site_cou = str_c(site,"(",cou_code,")"))  %>%
      dplyr::select(site_cou) %>%
      arrange(site_cou) %>% distinct() %>% pull(site_cou) %>% paste(collapse=", ")
  selection_summary$sites_summary$qal_3 <- 
  wger_init %>% filter(ser_qal_id==3) %>%
  dplyr::select(site,cou_code) %>%
  mutate(site_cou = str_c(site,"(",cou_code,")"))  %>%
  dplyr::select(site_cou) %>%
  arrange(site_cou) %>% distinct() %>% pull(site_cou) %>% paste(collapse=", ")
  # this one should not contain any data
  selection_summary$sites_summary$qal_4 <- 
      wger_init %>% filter(ser_qal_id==4) %>%
      dplyr::select(site,cou_code) %>%
      mutate(site_cou = str_c(site,"(",cou_code,")"))  %>%
      dplyr::select(site_cou) %>%
      arrange(site_cou) %>% distinct() %>% pull(site_cou) %>% paste(collapse=", ")
  if ( selection_summary$sites_summary$qal_4[1] !="") warning("There should not be any series with qal_id 4, please check")
# wger_init is used to keep the "whole" dataset, just in case we mess with it afterwards
  wger <- wger_init
  
  selection_summary$nb_series_init <- length(unique(wger$site)) # this is the true number at the beginning
  
  selection_summary$stat_discarded_series <- list()
  
  selection_summary$stat_discarded_series$span_sup_10 <- list()
  selection_summary$stat_discarded_series$span_sup_10$text <- "Series with qal_id = 0 and spanning more than ten years, along with their true length"
  selection_summary$stat_discarded_series$span_sup_10$table <-
      left_join(left_join(
          wger_init %>% dplyr::group_by(ser_id, site, ser_qal_id) %>%
              dplyr::summarize(span=max(year)-min(year)+1) %>% 
              mutate(sup10=span>=10) %>%
              filter(ser_qal_id %in% c(0,3) & sup10)%>%
              dplyr::select(site,ser_qal_id,span ),
          wger_init %>% group_by(ser_id, site, ser_qal_id) %>%
              filter(!is.na(value)) %>% 
              dplyr::summarize(len=n()) %>% 
              dplyr::select(site, len)
      ),
      wger_init %>% group_by(ser_id, site, ser_qal_id) %>%
        filter(!is.na(value) & das_qal_id == 1) %>% 
        dplyr::summarize(len_qal_id1=n()) %>% 
        dplyr::select(site, len_qal_id1))
  selection_summary$stat_discarded_series$span_less_10 <- list()
  selection_summary$stat_discarded_series$span_less_10$text <-
      "Series with ser_qal_id 1 or 4 and spanning less than ten years, number consecutive years ?. SHOULD BE NO SERIES"
  selection_summary$stat_discarded_series$span_less_10$table <-  
      left_join(
          wger_init %>% group_by(ser_id, site, ser_qal_id) %>%
              dplyr::summarize(span=max(year)-min(year)+1) %>% 
              mutate(sup10=span<10) %>%
              filter(ser_qal_id %in% c(1,4) & sup10)%>%
              dplyr::select(site,span, ser_qal_id),
          wger_init %>% group_by(ser_id, site, ser_qal_id) %>%
              filter(!is.na(value)) %>% 
              dplyr::summarize(len=n()) %>% 
              dplyr::select(site, len)
      )
    
  selection_summary$ser_qal_id_count <- wger_init %>% group_by(ser_qal_id) %>% distinct(ser_id) %>%dplyr::summarize(len=n())
  wger <- wger[wger$ser_qal_id==1,] # fix 2023 we don't want any ser_qal_id 4
  
  
  selection_summary$nb_series_init_qual1 <- length(unique(wger$site)) #number of series thare are kept 
  
# check on series discarded -----------------------------------------------
  
# There is no automatic rule to include series that
# are more than 10 year long. So each year we have to check. Some of the series have been
# discared for other reasons and this is stated in column eel_qal_comment of the t_series_ser table
  
  wgerdiscarded <- wger_init[wger_init$ser_qal_id!=1,]
  
# series marked as "0" might have a very low value but not included in the analysis, here replaced by NA
  wgerdiscarded$value[wgerdiscarded$das_qal_id==0] <- NA #das_qal_id=0 means data are not good
  selection_summary$wgerdiscarded <- list()
  selection_summary$wgerdiscarded$text <- "  
      Treating individual eel_qal_comment on the series
      In some series and for some years, there might be a value, and a good reason not to
      consider that value, e.g. hydropower station on which the pass is built only operated after
      the recruitment season, or local conditions making it impossible to evaluate recruitment.
      Series with no data have das_qal_id = 0
      Series with data to be removed have eel_qal_id = 3
      Series about which we have serious doubts but that we choose to keep have eel_qal_id = 4"
  selection_summary$wgerdiscarded$table <- wgerdiscarded
# storing this information in a list for eventual later display and check
  selection_summary$wgerdiscarded$length_discarded <- tapply(wgerdiscarded$value,wgerdiscarded$site,function(X) sum(!is.na(X)))

  
  
  
  #This is a way to check that data with identified issues are indeed excluded from the analysis
# All values labelled 0 must have no data 
selection_summary$wgerdiscarded$should_be_na <- list()
selection_summary$wgerdiscarded$should_be_na$table <-should_be_na <- wger[!is.na(wger$das_qal_id) & wger$das_qal_id==0 & is.na(wger$das_value),c("value")]
selection_summary$wgerdiscarded$should_be_na$ids <-should_be_na_id <-  wger[!is.na(wger$das_qal_id)&wger$das_qal_id==0 & is.na(wger$das_value),c("id")]
  
  if (! all(is.na(
          should_be_na
      )))
    stop("Rows with id", paste(should_be_na_id[which(!is.na(should_be_na))],collapse=","), 
        " with qal_id 0 should be NA")
  
# Checking series with eel_qal_id 3 (wrong data to be ignored) -------------------------------------
  wger$site_cou <- paste0(wger$site, "(", wger$cou_code,")")
  removed_id <-  wger[!is.na(wger$das_qal_id)&wger$das_qal_id==3,c("id")] 
  removed_year <-  wger[!is.na(wger$das_qal_id)&wger$das_qal_id==3,c("year")]
  removed_site <-  unique(wger[!is.na(wger$das_qal_id)&wger$das_qal_id==3,c("site")])
  removed_country <-  unique(wger[!is.na(wger$das_qal_id)&wger$das_qal_id==3,c("cou_code")])
  removed_site_cou <- unique(wger[!is.na(wger$das_qal_id)&wger$das_qal_id==3,c("site_cou")])
  warnings("Rows with ids: ", paste(removed_id,collapse=","),     
      " years: ", paste(removed_year,collapse=","),
      " sites: ", paste(removed_site,collapse=","),     
      " with qal_id = 3 removed from analysis")
  selection_summary$wgerdiscarded$das_qal_id_3_removed <- list()
  selection_summary$das_qal_id_3_removed$length <- length(removed_id)
  selection_summary$das_qal_id_3_removed$year <- removed_year
  selection_summary$das_qal_id_3_removed$site <- removed_site_cou
  
  
# For those series, values are replaced with NA -----------------------------------------------------
  
  wger[!is.na(wger$das_qal_id) & wger$das_qal_id==3,c("value")] <- NA
  
  #########################################################################
# standardizing with 2000-2009
# this was a question asked by ACFM ? 2014 ?
# so it's still done, we produce a graph but don't show it
# as it might confuse the reader
  ##########################################################################
  
  mdata <- wger[wger$year>=2000 & wger$year<2010,]
  std_site <- unique(mdata$site[order(mdata$site)])
# length(std_site) 
  site <- unique(wger$site[order(wger$site)])
# length(site)  #52
  unused_series_2000_2009  <-  site[!site%in%std_site] # series not having data between 2000 and 2009 # "Vida" "YFS1" 
  selection_summary$sc_2000_2009_unused_series <- unused_series_2000_2009
  selection_summary$sc_2000_2009_nb <- selection_summary$nb_series_init_qual1-length(selection_summary$sc_2000_2009_unused_series)
#add a column to R_station for flagging unused series
  R_stations$unused_2000_2009  <-  FALSE
  R_stations[R_stations$rec_nameshort %in% unused_series_2000_2009, "unused_2000_2009"]  <-  TRUE
#ex(std_site) 
  mean_site <- data.frame(mean_2000_2009=tapply(mdata$value,mdata$site,mean,na.rm=TRUE))
  mean_site$site <- rownames(mean_site)
  wger <- merge(wger,mean_site,by="site",all.x=TRUE,all.y=FALSE) # here we loose the two stations Inag and Maig and also Fr\E9mur
  wger$value_std_2000_2009 <- wger$value/wger$mean_2000_2009
  
  #########################################################################
#standardizing with mean from 1979-1994
  ##########################################################################
  
  mdata <- wger[wger$year>=1979 & wger$year<1994,]
  std_site <- unique(mdata$site[order(mdata$site)])
# length(std_site) # 45
  site <- unique(wger$site[order(wger$site)])
# length(site) #49
  unused_series_1979_1994 <- site[!site%in%std_site] # "Bres" "Fre"  "Inag" "Klit" "Maig" "Nors" "Sle"  "Vac"
  selection_summary$sc_1979_1994_unused_series <- unused_series_1979_1994
  selection_summary$sc_1979_1994_nb <- selection_summary$nb_series_init_qual1-length(selection_summary$sc_1979_1994_unused_series)
#add a column to R_station for flagging unused series
  R_stations$unused_1979_1994  <-  FALSE
  R_stations[R_stations$rec_nameshort %in% unused_series_1979_1994, "unused_1979_1994"]  <-  TRUE
  mean_site <- data.frame(mean_1979_1994=tapply(mdata$value,mdata$site,mean,na.rm=TRUE))
  mean_site$site <- rownames(mean_site)
  wger <- merge(wger,mean_site,by="site",all.x=TRUE,all.y=FALSE) 
  wger$value_std_1979_1994 <- wger$value/wger$mean_1979_1994
  
  #########################################################################
#standardizing with mean (all data)
  ##########################################################################
  
  mean_site <- data.frame(mean = tapply(wger$value,wger$site,mean,na.rm=TRUE))
  mean_site$site <- rownames(mean_site)
  wger <- merge(wger,mean_site,by="site",all.x=TRUE,all.y=FALSE) 
  wger$value_std <- wger$value/wger$mean
  
  
  #########################################################################
#separating glass eel and yellow eels
  ##########################################################################
  
  
  glass_eel_yoy <- wger[wger$lifestage!="yellow eel" & wger$year>1959,] #glass eel and yoy
  older <- wger[wger$lifestage=="yellow eel" & wger$year>1949,] # Advice Drafting 2017 asks to 
# give from 1949 to be consistent with previous years
  
  ##########################################################################
# Some statistics for later use, nb of year per series
  #########################################################################
  
  nb_year <- colSums(ftable(xtabs(formula = value_std_1979_1994~year+site,data=wger))>0)
  names(nb_year) <- colnames(xtabs(formula = value_std_1979_1994~year+site,data=wger))
  
  ###############################################################
# some other statistics used there
  ###############################################################
  
  nb_series_glass_eel <- length(unique(glass_eel_yoy$site)) # this will be reported in the pdf later
  selection_summary$nb_series_glass_eel <- nb_series_glass_eel  
  selection_summary$nb_series_glass_eel_per_area <-glass_eel_yoy %>% distinct(site, area) %>% group_by(area)%>%dplyr::summarize(n())
  selection_summary$nb_series_glass_eel_G <-glass_eel_yoy %>% filter(lfs_code=='G') %>%distinct(site) %>%dplyr::summarize(n()) %>% pull()
  selection_summary$nb_series_glass_eel_GY <-glass_eel_yoy %>% filter(lfs_code=='GY') %>%distinct(site) %>%dplyr::summarize(n()) %>% pull()
  nb_series_older <- length(unique(older$site)) # this will be reported in the pdf later
  selection_summary$nb_series_older <- nb_series_older
  nb_series_final <- nb_series_glass_eel+nb_series_older
  selection_summary$nb_series_final <- nb_series_final
  selection_summary$nb_series_older_baltic <- older%>% filter(area2=="Baltic") %>%distinct(site) %>%dplyr::summarize(n()) %>% pull()
  selection_summary$nb_series_older_northsea <- older%>% filter(area2=="North Sea") %>%distinct(site) %>%dplyr::summarize(n()) %>% pull()
  selection_summary$nb_series_older_mediterranean <- older%>% filter(area2=="Mediterranean Sea") %>%distinct(site) %>%dplyr::summarize(n()) %>% pull()
  selection_summary$nb_series_older_atlantic <- older%>% filter(area2=="Atlantic") %>%distinct(site) %>%dplyr::summarize(n()) %>% pull()
  
  ###############################################################
# Finally saving the data
  ###############################################################
  
  
  
  write.table(glass_eel_yoy,file=str_c(datawd,"glass_eel_yoy.csv"), sep=";")
  write.table(older,file=str_c(datawd,"older.csv"), sep=";")
  return(list(selection_summary=selection_summary,
          glass_eel_yoy = glass_eel_yoy,
          older = older,
          wger = wger,
          R_stations = R_stations))
}

#' Function to create diagram of series used
#' @param selection_summary A list that summarizes the selection process of series used in the model
diagram_series_used <- function(selection_summary){
  library(DiagrammeR)
  library(magrittr)
  library(DiagrammeRsvg)
  library(rsvg)
  node_list <- create_node_df(n=16,		
      type=rep(c("box",
              "value"), 16
      ),
      label=c(
          str_c("Series available in ", CY),
          selection_summary$nb_series_init,
          "used",
          selection_summary$nb_series_final,
          "G + GY",
          selection_summary$nb_series_glass_eel,
          "Y",
          selection_summary$nb_series_older,
          "NS",
          as.numeric(selection_summary$nb_series_glass_eel_per_area[selection_summary$nb_series_glass_eel_per_area$area=="Elsewhere Europe",2]),
          "EE",
          as.numeric(selection_summary$nb_series_glass_eel_per_area[selection_summary$nb_series_glass_eel_per_area$area=="North Sea",2]),
          "< 10 Y",
          as.numeric(selection_summary$ser_qal_id_count[selection_summary$ser_qal_id_count$ser_qal_id==0,"len"]),
          "discarded",
          as.numeric(selection_summary$ser_qal_id_count[selection_summary$ser_qal_id_count$ser_qal_id==3,"len"])
      ),
      color=c(rep("green",12),"orange","orange","red","red"),
      style="filled",
      shape=rep(c("plaintext","circle"),8),
      value=1:16,
      fixedsize =FALSE
  )
  
  edge_list<-create_edge_df(
      from=c(1,2,3,4,5,4,7,2 ,2 ,13,15,6,6,11,9),
      to=  c(2,3,4,5,6,7,8,13,15,14,16,9,11,12,10),
      rel="a",
      label=rep(" ",15),
      color=rep("grey",15),
      length=100)
  
  
  
  igraph1 <- create_graph( attr_theme = NULL)
  
  igraph2 <- igraph1%>%
      add_nodes_from_table(table = node_list, 
          type_col=type,
          label_col=label) 
#igraph2 %>% get_node_df()
# Add the edges to the graph
  igraph3 <-igraph2 %>%
      add_edges_from_table(
          table = edge_list,
          from_col = from,
          to_col = to,
          from_to_map = id_external
      )
  
  # we save data into the image directory
  dir.create(path="images", showWarnings = FALSE)
  render_graph(igraph3, layout="tree") %>% 
      export_svg %>%  charToRaw %>% rsvg_png("images/series_selection.png")
  
  
}


#' make_table_series
#' this function builds some tables that summarize the data that are kept
#' or discarded
#' @param selection_summary key statistics of the selection process
#' @param R_stations info about station 
#' @param wger the data that are kept for analysis
#'
#' @return a list with updated selection_summary and R_stations as well as several tables
#' that summarizes the data selection
#' @export
#'
#' @examples
make_table_series <- function(selection_summary, R_stations, wger){
  last_year <- tapply(wger$year,wger$site, function(X) max(X))
  #stations updated to",CY
  R_stations$areashort <- "EE"
  R_stations$areashort[R_stations$area=="North Sea"] <- "NS"
  R_stations$ser_namelong <- iconv(R_stations$ser_namelong,to= "UTF8")
  R_stations$ser_nameshort  <- iconv(R_stations$ser_nameshort, to ="UTF-8")
  series_CY <- R_stations[R_stations$ser_nameshort%in%names(last_year[last_year==CY]),
      c("ser_nameshort","ser_namelong","cou_code","ser_lfs_code","areashort","ser_area_division","ser_qal_id","cou_order","ser_y", "ser_qal_comment")]
  #series_CY <- merge(series_CY,last_years_with_problem[,c("das_qal_id", "ser_nameshort")], by="ser_nameshort", all.x=T)
  #series_CY$das_qal_id[is.na(series_CY$das_qal_id)] <- 1
  
  series_CY <- series_CY[order(series_CY$ser_lfs_code,series_CY$cou_order),-c(ncol(series_CY)-1,ncol(series_CY))]
  #series_CY <- series_CY[order(series_CY$ser_lfs_code,series_CY$cou_order),	c("ser_nameshort","ser_namelong","cou_code","ser_lfs_code","areashort","ser_area_division")]
  colnames(series_CY) <-c("Site","Name","Coun.","Stage","Area","Division", "Kept", "Qal Comment")

  
  selection_summary$nCY <- nrow(series_CY) # number of series updated to the current year (for later use)
  selection_summary$nCYG <- nrow(series_CY[series_CY$Stage=="G",]) # number of series with glass eel updated to the current year
  selection_summary$nCYGY <- nrow(series_CY[series_CY$Stage=="GY",]) # number of series with glass eel updated to the current year
  selection_summary$nCYY <- nrow(series_CY[series_CY$Stage=="Y",]) # number of series with yellow eel (only) updated to the current year
  
  #"stations updated to",CY-1
  series_CYm1 <- R_stations[R_stations$ser_nameshort%in%names(last_year[last_year==CY-1]),
      c("ser_nameshort","ser_namelong","cou_code","ser_lfs_code","areashort","ser_area_division","cou_order","ser_y")]
  series_CYm1 <- series_CYm1[order(series_CYm1$ser_lfs_code,series_CYm1$cou_order),c("ser_nameshort","ser_namelong","cou_code","ser_lfs_code","areashort","ser_area_division")]
   colnames(series_CYm1) <- c("Site","Name","Coun.","Stage","Area","Division")
  selection_summary$nCYm1 <- nrow(series_CYm1) # number series updated last year only (and not this year)
  selection_summary$nCYm1G <- nrow(series_CYm1[series_CYm1$Stage=="G",]) # same for glass eel 
  selection_summary$nCYm1GY <- nrow(series_CYm1[series_CYm1$Stage=="GY",]) # same for glass eel 
  selection_summary$nCYm1Y <- nrow(series_CYm1[series_CYm1$Stage=="Y",]) # same for yellow eel only
  
  # Series that have not been updated for two years
  lost_ones <- last_year[last_year<CY-1]
  d_lost_ones <- data.frame("site"=names(lost_ones),"year"=lost_ones) # data frame
  series_lost <- merge(
      R_stations[R_stations$ser_nameshort%in%names(lost_ones),c("ser_nameshort","ser_namelong","cou_code","ser_lfs_code","areashort","ser_area_division")],
      d_lost_ones,
      by.y="site",by.x="ser_nameshort")
  series_lost <- series_lost[order(series_lost$year),]
  selection_summary$nseries_lost <- nrow(series_lost) # number of series not updated for the two last years
  selection_summary$nseries_lostG <- nrow(series_lost[series_lost$ser_lfs_code=="G",])
  selection_summary$nseries_lostY <- nrow(series_lost[series_lost$ser_lfs_code=="Y",])
  selection_summary$nseries_lostGY <- nrow(series_lost[series_lost$ser_lfs_code=="GY",])
  #xtable of current year series
  
  
  

  
  #------------------------------------------------------
  # xtable of series that have not been updated
  #------------------------------------------------------
  colnames(series_lost) <- str_c("\\scshape{",c("Site","Name","Coun.","Stage","Area","Division","Last Year"),"}")
  
  
  # number of series per area per year
  area_year=table(glass_eel_yoy$year,glass_eel_yoy$area)
  # number of series per stage per year
  n_y_lfs <- reshape2::dcast(wger,year~lifestage,length,value.var="year")
  n_y_lfs$sum <- rowSums(n_y_lfs[,c(2:4)])
  colnames(n_y_lfs) <- c("year","glass","glass+yellow","yellow","sum")
  rownames(n_y_lfs) <- n_y_lfs$"year"
  
  printstatseries <- statseries[,c(1,3,4,5,6,7,8,9,10,11,12, 13)]
  printstatseries$sampling_type[printstatseries$sampling_type=="scientific estimate"] <- "sci. surv."
  printstatseries$sampling_type[grep("trap",printstatseries$sampling_type)] <- "trap"
  printstatseries$sampling_type[printstatseries$sampling_type=="commercial catch"] <- "com. catch"
  printstatseries$sampling_type[printstatseries$sampling_type=="commercial CPUE"] <- "com. cpue"
  column_to_import <- R_stations[,c("ser_nameshort","areashort")]
  printstatseries <- merge(printstatseries,column_to_import,by.x="site",by.y="ser_nameshort")
  printstatseriesGNS <- printstatseries%>% 
      filter(life_stage=="G", areashort=="NS")%>%
      arrange(site)%>%
      dplyr::select(1,13,2:9,11:12)%>%
      dplyr::rename("code"="site",
          "area"="areashort",
          "n+"="duration",
          "n-"="missing", 
          "life stage"="life_stage", 
          "sampling type"="sampling_type",
          "habitat"="habitat_type",
          "kept"="series_kept",
          "comment"="qal_comment")
  
  
  printstatseriesGEE <- printstatseries%>% 
      filter(life_stage=="G", areashort=="EE")%>%
      arrange(site)%>%
    dplyr::select(1,13,2:9,11:12)%>%
      dplyr::rename("code"="site",
          "area"="areashort",
          "n+"="duration",
          "n-"="missing", 
          "life stage"="life_stage", 
          "sampling type"="sampling_type",
          "habitat"="habitat_type",
          "kept"="series_kept",
          "comment"="qal_comment")
  
  
  
  
  printstatseriesGY <- printstatseries %>% 
      filter(life_stage=="GY") %>%
      arrange(site) %>%
    dplyr::select(1,13,2:9,11:12) %>%
      dplyr::rename("code"="site",
          "area"="areashort",
          "n+"="duration",
          "n-"="missing", 
          "life stage"="life_stage", 
          "sampling type"="sampling_type",
          "habitat"="habitat_type",
          "kept"="series_kept",
          "comment"="qal_comment")
  
  
  printstatseriesY <- printstatseries%>% 
      filter(life_stage=="Y")%>%
      arrange(site)%>%
    dplyr::select(1,13,2:9,11:12)%>%
      dplyr::rename("code"="site",
          "area"="areashort",
          "n+"="duration",
          "n-"="missing", 
          "life stage"="life_stage", 
          "sampling type"="sampling_type",
          "habitat"="habitat_type",
          "kept"="series_kept",
          "comment"="qal_comment")
  
  
  ################################################################
  # Table of the problem in series for this year
  ################################################################
  
  series_prob <- last_years_with_problem[last_years_with_problem$ser_typ_id %in% 1,c("ser_nameshort","ser_lfs_code","ser_cou_code","ser_area_division","das_year","das_qal_id","das_comment" )]
  series_prob <- series_prob[order(series_prob$ser_lfs_code,series_prob$das_year, series_prob$ser_nameshort),]
  colnames(series_prob) <- c("Name","Stage", "Country","Division","Year", "Kept", "Comment")

  
  ################################################################
  # some additional stats for the report
  #################################################################
  
  # in which year has there been the largest number of glass eel (or apparented) series ?
  yearmaxglasseel <- n_y_lfs$year[which(max(n_y_lfs$"glass"+n_y_lfs$"glass+yellow")==n_y_lfs$"glass"+n_y_lfs$"glass+yellow")]
  # and for how long ?
  nbmaxglasseel <- max(n_y_lfs$"glass"+n_y_lfs$"glass+yellow")
  # storing this in our nice list
  selection_summary$yearmaxglasseel <- yearmaxglasseel
  selection_summary$nbmaxglasseel <- nbmaxglasseel
  selection_summary$nbcurrentglasseel <- n_y_lfs$"glass"[n_y_lfs$year==CY]+n_y_lfs$"glass+yellow"[n_y_lfs$year==CY]
  # same for yellow eel
  yearmaxyellow <- n_y_lfs$year[which(max(n_y_lfs$"yellow")==n_y_lfs$"yellow")]
  nbmaxyellow <- max(n_y_lfs$"yellow")
  selection_summary$yearmaxyellow <- yearmaxyellow
  selection_summary$nbmaxyellow <- nbmaxyellow
  selection_summary$nbcurrentyellow <- n_y_lfs$"yellow"[n_y_lfs$year==CY]
  
  return(list(selection_summary = selection_summary,
          R_stations = R_stations, 
          series_CY = series_CY, 
          series_CYm1 = series_CYm1, 
          series_lost = series_lost, 
          printstatseriesY = printstatseriesY,
          printstatseriesGNS = printstatseriesGNS,
          printstatseriesGEE = printstatseriesGEE,
          printstatseriesGY = printstatseriesGY,
          series_prob = series_prob))
}
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
#' @param pdf whether should be saved as pdf
#' @return nothing
save_figure<-function(figname,fig,width,height, pdf = TRUE){
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
  
  if (pdf){
    pdf(file= paste(figname,".pdf",sep=""), width = width/100, height = height/100)
    print(fig)
    rien<-dev.off()
  }
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


#' createReportTableFromPred
#'
#' @param predtable 
#'
#' @return
#' @export
#'
#' @examples
createReportTableFromPred <- function(predtable){
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
  if (length(vargroup) == 0){
    predtable$R <- "R"
    vargroup <- "R" 
  }
  predtable <- predtable %>%
      dplyr::select(all_of(c(c("year", "p_std"), vargroup))) %>%
      mutate(p_std = round(100*p_std, digits = 1)) %>%
      tidyr::pivot_wider(names_from = all_of(vargroup), 
          values_from = p_std) %>%
      dplyr::arrange(year) %>%
      mutate(yearindecade = year - as.integer(year/10) * 10) %>%
      mutate(decade = year - yearindecade) %>%
      tibble::column_to_rownames("year") %>% 
      tidyr::pivot_wider(id_cols = yearindecade, 
          names_from = decade,
          values_from = !all_of(c("decade", "yearindecade")),
          names_vary = "slowest")
  predtable
  
}



#' compute_retro_year
#' This function is used to carry out retrospective analysis, i.e. compute the 
#' glm models as if we were in year y, with the time series used at that time,
#' either including data revisions or not
#' @param y the consider year of assessment
#' @param model either "glm_yoy" (default) or "older
#' @param exclude_run_id potential run_id to exclude
#' @param update_data should we include revision of data that have occured since
#' y or not
#'
#' @return a dataframe with previous results
compute_retro_year <- function(y, model = "glm_yoy", exclude_run_id = NULL, update_data = FALSE){
  data=dbGetQuery(con,paste0("select * from datawg.t_modelrun_run left join datawg.t_modeldata_dat on dat_run_id=run_id where extract(year from run_date)=",y, " and run_mod_nameshort='",model,"'"))
  runids=unique(data$run_id)
  do.call(bind_rows,lapply(runids,function(rid){
    subdata=data %>%
      filter(run_id == rid) %>%
      dplyr::rename(ser_id = "dat_ser_id",
                    das_value = "dat_das_value")
    dbWriteTable(con,"temp_table",subdata[,c("ser_id","dat_ser_year")],temporary=TRUE)
    newvalues=dbGetQuery(con,"select das_ser_id ser_id, dat_ser_year, das_value new_val, das_year from temp_table  full join datawg.t_dataseries_das on  ser_id=das_ser_id and dat_ser_year=das_year where (das_qal_id is null or das_qal_id in (1,2,4)) and das_ser_id in (select ser_id from temp_table) and das_ser_id is not null")
    dbGetQuery(con,"drop table temp_table")
    
    updatedvalues = newvalues %>% #this is a data that might have been updated after the assessment
      filter(das_year <= y)
    # lattervalues = newvalues %>% #this is a data in year after the assessment
    #   filter(das_year > y)
    
    if (update_data){
      subdata <- subdata %>%
        merge(updatedvalues, all.x = TRUE) %>%
        mutate(das_value = new_val)
    } 
    
    #In the GLM data are standardised by their mean across the period (till y)
    meanseries = subdata %>%
      dplyr::group_by(ser_id) %>%
      dplyr::summarize(mean=mean(das_value, na.rm=TRUE))%>%
      ungroup()
    
    # subdata <- subdata %>%
    #   bind_rows(lattervalues %>%
    #               dplyr::select(ser_id,das_year,new_val) %>%
    #               dplyr::rename(dat_ser_year="das_year",
    #                             das_value="new_val"))
    # 
    # 
    
    
    
    subdata <- subdata %>%
      left_join(R_stations)

    
    subdata <- subdata %>%
      inner_join(meanseries) %>%
      mutate(value_std=das_value/mean,
             year_f=as.factor(dat_ser_year)) %>%
      dplyr::rename(site="ser_nameshort") %>%
      mutate(area=as.factor(area),
             site=as.factor(site))
    
    if(model=="glm_yoy"){
      mymodel <- update(model_ge_area,data=subdata %>%
                          filter(value_std>0 & dat_ser_year>1959))
    } else {
      mymodel <- update(model_older,data=subdata %>%
                          filter(value_std>0 & dat_ser_year>1949))
    }
    res <- predict_model(mymodel,reference=1960:1979)
    res$run_id=y
    res <- bind_rows(res %>% 
                       filter(year<=y) %>%
                       mutate(proj=FALSE),
                     res %>% 
                       filter(year>y) %>%
                       mutate(proj=TRUE))
    res
    
  }))
}

theme_ICES_plots <-
  function(
    type = c("Catches", "Recruitment", "F", "SSB", "quality_SSB", "quality_F", "quality_R"), df = NULL) {
    font <- "Gothic A1, sans-serif"#"Calibri, sans-serif" # assign font family up front
    tmp <- theme_minimal() %+replace% # replace elements we want to change
      
      theme(
        axis.title = element_text( # axis titles
          family = font, # font family
          size = 18,
          colour = "darkgrey",
          vjust = -2
        ),
        axis.text = element_text( # axis titles
          family = font, # font family
          size = 13,
          colour = "black"
        ),
        axis.title.x = element_blank(),
        
        panel.grid.major.y = element_line(
          colour = "grey",
          size = 1,
          linetype = "solid",
        ),
        plot.title = element_text( # title
          family = font, # set font family
          size = 21, # set font size
          face = "bold", # bold typeface
          hjust = 0, # left align
          vjust = 1,
          margin = ggplot2::margin(t = 0, r = 0, b = 0, l = 0),
          if (type == "Catches") {
            color <- "#002b5f"
          } else if (type == "Recruitment" | type == "quality_R") {
            color <- "#28b3e8"
          } else if (type == "F" | type == "quality_F") {
            color <- "#ed5f26"
          } else if (type == "SSB" | type == "quality_SSB") {
            color <- "#047c6c"
          }
        ),
        axis.line = element_line(size = 1, colour = "black"),
        axis.ticks = element_line(size = 1, color="black"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.border = element_rect(
          colour = "black",
          fill = NA,
          size = 0.5
        ),
        legend.text = element_text(
          family = "sans-serif",
          size = 15,
          color = "black"
        ),
        legend.title = element_blank(),
        legend.position = "bottom"
        
      )
    
    if (type == "Catches") {
      
      if (is.null(title)) {
        title <- "Catches"
      }
      if (is.null(ylegend)) {
        ylegend <- sprintf("Catches in 1000 %s", dplyr::last(df$Units))
      }
      
      if (is.null(ymax)) {
        limits <- expand_limits(y = 0)
      } else {
        limits <- expand_limits(y = c(0, ymax))
      }
      
      theme_ICES_plots <- list(
        tmp,
        labs(
          title = title,
          y = ylegend
        ),
        scale_fill_manual(values = c(
          "Landings" = "#002b5f",
          "Discards" = "#fda500",
          "Catches" = "#002b5f",
          "Industrial Bycatch" = "#00b29d",
          "Unallocated_Removals" = "#6eb200",
          "Down-weighted Catches" = "#6eb5d2"
        )),
        limits,
        scale_y_continuous(
          expand = expansion(mult = c(0, 0.1)),
          labels = function(l) {
            trans <- l / 1000
          }
        ),
        scale_x_continuous(breaks = breaks_pretty())
      )
    } else if (type == "Recruitment") {
      
      
      theme_ICES_plots <- list(
        tmp,
        scale_fill_manual(values = c("#28b3e8")),
        scale_color_manual(values = "#28b3e8"),
        scale_x_continuous(breaks = breaks_pretty())
      )
    } else if (type == "F") {
      if (is.null(title)) {
        title <- "Fishing pressure"
      }
      if (is.null(ylegend)) {
        ylegend <- sprintf("%s <sub>(ages %s)</sub>", dplyr::last(df$FishingPressureDescription), dplyr::last(df$FAge))
      }
      
      theme_ICES_plots <- list(
        tmp,
        labs(
          title = title, #"Fishing pressure", # sprintf("Recruitment <sub>(age %s)</sub>", dplyr::last(df$RecruitmentAge)),
          y = ylegend, #sprintf("%s <sub>(ages %s)</sub>", dplyr::last(df$FishingPressureDescription), dplyr::last(df$FAge)), # sprintf("Catches in 1000 %s", dplyr::last(df$Units))
          x = "Year"
        ),
        scale_color_manual(values = c(
          "F" = "#ed5f26",
          "F<sub>MSY</sub>" = "#00AC67",
          "F<sub>Lim</sub>" = "#000000",
          "F<sub>pa</sub>" = "#000000",
          "HR MSY<sub>proxy</sub>" = "#00AC67",
          "FMSY<sub>proxy</sub>" = "#00AC67"
        )),
        scale_linetype_manual(values = c(
          "F" = "solid",
          "F<sub>Lim</sub>" = "dashed",
          "F<sub>pa</sub>" = "dotted",
          "F<sub>MSY</sub>" = "solid",
          "HR MSY<sub>proxy</sub>" = "dotdash",
          "FMSY<sub>proxy</sub>" = "dotdash"
        )),
        scale_size_manual(values = c(
          "F" = 1.5,
          "F<sub>Lim</sub>" = .8,
          "F<sub>pa</sub>" = 1,
          "F<sub>MSY</sub>" = .5,
          "HR MSY<sub>proxy</sub>" = .8,
          "FMSY<sub>proxy</sub>" = .8
        )),
        scale_fill_manual(values = c("#f2a497")),
        expand_limits(y = 0),
        scale_y_continuous(
          expand = expansion(mult = c(0, 0.1)) # ,
        ),
        scale_x_continuous(breaks = breaks_pretty())
      )
    } else if (type == "SSB") {
      if (is.null(title)) {
        title <- "Spawning Stock Biomass"
      }
      if (is.null(ylegend)) {
        ylegend <- sprintf("%s in 1000 %s", dplyr::last(df$StockSizeDescription), dplyr::last(df$StockSizeUnits))
        ylabels_func <- function(l) {
          trans <- l / 1000 #1000000
        }
      } else {
        if (is.na(ylegend)) ylegend <- ""
        ylabels_func <- function(l) {
          trans <- l
        }
      }
      
      if (is.null(ymax)) {
        limits <- expand_limits(y = 0)
      } else {
        limits <- expand_limits(y = c(0, ymax))
      }
      
      theme_ICES_plots <- list(
        tmp,
        labs(
          title = title, 
          y = ylegend,
          x = "Year"
        ),
        scale_color_manual(values = c(
          "SSB" = "#047c6c",
          "MSY B<sub>trigger</sub>" = "#689dff",
          "B<sub>Lim</sub>" = "#000000",
          "B<sub>pa</sub>" = "#000000",
          "Average" = "#ed5f26",
          "I<sub>trigger</sub>" = "#689dff",
          "BMGT<sub>lower</sub>" = "#000000",
          "BMGT<sub>upper</sub>" = "#689dff"
        )),
        scale_linetype_manual(values = c(
          "SSB" = "solid",
          "B<sub>Lim</sub>" = "dashed",
          "B<sub>pa</sub>" = "dotted",
          "MSY B<sub>trigger</sub>" = "solid",
          "Average" = "solid",
          "I<sub>trigger</sub>" = "dotdash",
          "BMGT<sub>lower</sub>" = "dotted",
          "BMGT<sub>upper</sub>" = "dotdash"
        )),
        scale_size_manual(values = c(
          "SSB" = 1.5,
          "B<sub>Lim</sub>" = .8,
          "B<sub>pa</sub>" = 1,
          "MSY B<sub>trigger</sub>" = .5,
          "Average" = .8,
          "I<sub>trigger</sub>" = .8,
          "BMGT<sub>lower</sub>" = .8,
          "BMGT<sub>upper</sub>" = .8                
        )),
        scale_fill_manual(values = c("#94b0a9")),
        limits,
        scale_y_continuous(
          expand = expansion(mult = c(0, 0.1)),
          labels = ylabels_func
        ),
        scale_x_continuous(breaks = breaks_pretty())
      )
    } else if (type == "quality_SSB") {
      
      if (is.null(title)) {
        title <- sprintf("%s in 1000 %s", dplyr::last(df$StockSizeDescription), dplyr::last(df$StockSizeUnits))
      }
      
      rfpt <- c( "B<sub>Lim</sub>", "B<sub>pa</sub>","MSY B<sub>trigger</sub>")
      
      line_color <- c("#969696","#737373","#525252","#252525","#047c6c") %>% tail(length(unique(df$AssessmentYear)))
      names(line_color) <- as.character(sort(unique(df$AssessmentYear)))
      line_color_rfpt <- c( "#000000","#000000", "#689dff")
      names(line_color_rfpt) <- rfpt
      line_color <- append(line_color, line_color_rfpt)
      
      line_type <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) "solid")
      line_type_rfpt <- c("dashed", "dotted","solid")
      names(line_type_rfpt) <- rfpt
      line_type <- append(line_type, line_type_rfpt)
      
      line_size <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) 1)
      line_size_rfpt <- c( .8, 1, .5)
      names(line_size_rfpt) <- rfpt
      line_size <- append(line_size, line_size_rfpt)
      
      
      theme_ICES_plots <- list(
        tmp,
        labs(
          title = title,
          y = "",
          x = ""
        ),
        scale_color_manual(values = line_color
        ),
        scale_linetype_manual(values = line_type
        ),
        scale_size_manual(values = line_size
        ),
        expand_limits(y = 0),
        scale_y_continuous(
          expand = expansion(mult = c(0, 0.1)),
          labels = function(l) {
            trans <- l / 1000
          }
        ),
        scale_x_continuous(breaks= pretty_breaks())
        
      )
    } else if (type == "quality_F") {
      rfpt <- c( "F<sub>Lim</sub>","F<sub>pa</sub>", "F<sub>MSY</sub>")
      
      line_color <- c("#969696","#737373","#525252","#252525","#ed5f26") %>% tail(length(unique(df$AssessmentYear)))
      names(line_color) <- as.character(sort(unique(df$AssessmentYear)))
      line_color_rfpt <- c( "#000000","#000000", "#00AC67")
      names(line_color_rfpt) <- rfpt
      line_color <- append(line_color, line_color_rfpt)
      
      line_type <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) "solid")
      line_type_rfpt <- c("dashed", "dotted","solid")
      names(line_type_rfpt) <- rfpt
      line_type <- append(line_type, line_type_rfpt)
      
      line_size <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) 1)
      line_size_rfpt <- c( .8, 1, .5)
      names(line_size_rfpt) <- rfpt
      line_size <- append(line_size, line_size_rfpt)
      
      if (is.null(title)) {
        title <- sprintf("%s <sub>(ages %s)</sub>", dplyr::last(df$FishingPressureDescription), dplyr::last(df$FAge))
      }
      
      theme_ICES_plots <- list(
        tmp,
        labs(
          title = title,
          y = "",
          x = "Year"
        ),
        scale_color_manual(values = line_color
        ),
        scale_linetype_manual(values = line_type
        ),
        scale_size_manual(values = line_size
        ),
        expand_limits(y = 0),
        scale_y_continuous(
          expand = expansion(mult = c(0, 0.1))
          
        ),
        scale_x_continuous(breaks= pretty_breaks())
      )
    } else if (type == "quality_R") {
      line_type <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) "solid")
      line_size <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) 1)
      line_color <- c("#969696","#737373","#525252","#252525","#28b3e8") %>% tail(length(unique(df$AssessmentYear)))
      names(line_color) <- as.character(sort(unique(df$AssessmentYear)))
      

      theme_ICES_plots <- list(
        tmp,
        scale_color_manual(values = line_color
        ),
        scale_linetype_manual(values = line_type
        ),
        scale_size_manual(values = line_size
        ),
        scale_x_continuous(breaks= pretty_breaks())
      )
    }
    
    return(theme_ICES_plots)
    
  }



#' Title
#'
#' @param dataset the data frame
#' @param value_name the name of the column of interest
#' @param year_name the name of the year columns
#' @param assessment_year_name the name of the assessment year columns
#' @param terminalyear the last year of assessement 
#' @param firstyear the first year to include in the computation
#'
#' @return
#' @export
#'
#' @examples
computeMohnsRho <- function(dataset, value_name, year_name, assessment_year_name,terminalyear, firstyear ){
  lag <- 0
  if (max(dataset[,assessment_year_name])> max(dataset[,year_name]))
    lag <- 1
   lastassessment = dataset %>%
     filter(!!as.symbol(assessment_year_name) == terminalyear &
              !!as.symbol(year_name) >= firstyear - lag) %>%
     dplyr::select(all_of(c(assessment_year_name, year_name,value_name)))
   oldassessment = dataset %>%
     filter(!!as.symbol(assessment_year_name) %in% (firstyear:(terminalyear-1)) &
              (!!as.symbol(assessment_year_name)- lag) == (!!as.symbol(year_name) )) %>%
     dplyr::select(all_of(c(assessment_year_name, year_name,value_name)))
   
   mergedata <- merge(lastassessment, oldassessment, by ="year", suffixes=c(".last",".old"))
   1/nrow(mergedata) * sum((mergedata[,paste0(value_name, ".old")] - mergedata[,paste0(value_name,".last")])/
                             mergedata[,paste0(value_name,".last")]) * 100
  
}
