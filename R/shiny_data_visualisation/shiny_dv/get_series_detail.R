
#' get a list of tables detailing the content of a series 
#' @note this file is not used in the shiny_dv but used by the api
#' @param series A vector of identifiers (ser_namehsort) for the series
#' @param cred A credential for the file
#' @returns A list with station, annual, group and indiv
get_series_detail <- function(series, cred){
  #read working group credentials
  con_wgeel <- dbConnect(RPostgres::Postgres(),
    dbname = cred$dbname,
    host = cred$host,
    port = cred$port,
    user = cred$user,
    password = cred$password
  )
  # add = TRUE expr will be executed after nay previously set expression
  on.exit(
    if (DBI::dbIsValid(con_wgeel))
      DBI::dbDisconnect(con_wgeel),
    add = TRUE
  )

  # ----------- station (t_series_ser data)------------------------------------- 

station <-
    dbGetQuery(con_wgeel,
               glue::glue_sql(
                 "SELECT 
        				ser_id,  ser_nameshort, ser_namelong, ser_typ_id, 
        				ser_effort_uni_code,
        				ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, 
        				ser_locationdescription,
        				ser_emu_nameshort, ser_cou_code, ser_area_division, ser_x, 
        				ser_y,             
        				ser_sam_id, ser_qal_id, 
        				ser_qal_comment,
        				ser_ccm_wso_id,
        				area_km2,
        				cou_code, 
        				cou_country, 
        				cou_order 
        				FROM datawg.t_series_ser 
        				LEFT JOIN ref.tr_country_cou ON cou_code=ser_cou_code 
        				LEFT JOIN ref.tr_lifestage_lfs ON ser_lfs_code=lfs_code
        				LEFT JOIN ref.tr_faoareas ON ser_area_division=f_division
        				LEFT JOIN ccm21.seaoutlets ON seaoutlets.wso_id = ANY(ser_ccm_wso_id)
        				WHERE ser_nameshort IN ({.ser_nameshort*})", 
                 .ser_nameshort = series,
                 .con = con_wgeel)
    )
  
  # -------------- Annual data t_dataseries_das --------------------------------
  
  annual <- dbGetQuery(con_wgeel,
                      glue::glue_sql(
                        "SELECT 
                				das_id,
                				das_value,       
                				das_year,
                				das_comment,				
                				das_effort, 
                				ser_effort_uni_code,       
                				das_last_update,
                				das_qal_id,
                				ser_id,            
                				ser_nameshort,
                				ser_area_division,
                				f_subarea,
                				lfs_code,          
                				lfs_name
                				FROM datawg.t_dataseries_das 
                				JOIN datawg.t_series_ser ON das_ser_id=ser_id
                				LEFT JOIN ref.tr_lifestage_lfs ON ser_lfs_code=lfs_code
                				LEFT JOIN ref.tr_faoareas ON ser_area_division=f_division
                				WHERE ser_nameshort IN ({.ser_nameshort*})", 
                        .ser_nameshort = series,
                        .con = con_wgeel))
  
  # -------------- Group metrics  ----------------------------------------------
  
  group <- dbGetQuery(
    con_wgeel,
    glue::glue_sql(
      "SELECT * FROM datawg.t_series_ser
				JOIN datawg.t_groupseries_grser  ON grser_ser_id = ser_id
				JOIN datawg.t_metricgroupseries_megser ON meg_gr_id = gr_id 
				LEFT JOIN ref.tr_metrictype_mty ON mty_id=meg_mty_id
				WHERE ser_nameshort IN ({.ser_nameshort*})",
      .ser_nameshort = series,
      .con = con_wgeel)
  )
  
  # -------------- Indiv metrics  ----------------------------------------------
  
  indiv <- dbGetQuery(
    con_wgeel,
    glue::glue_sql(
      "SELECT 
      ser.ser_nameshort,
      fiser.*,
      meiser.*,
      mty_name, mty_individual_name, mty_description, mty_method, mty_uni_code, 
      mty_group, mty_min, mty_max
      FROM datawg.t_series_ser ser
				JOIN datawg.t_fishseries_fiser fiser  ON fiser_ser_id = ser_id
				JOIN datawg.t_metricindseries_meiser meiser ON mei_fi_id = fi_id 
				LEFT JOIN ref.tr_metrictype_mty ON mty_id=mei_mty_id
				WHERE ser_nameshort IN ({.ser_nameshort*})",
      .ser_nameshort = series,
      .con = con_wgeel)
  )
  return(list(station = station,
              annual = annual,
              group = group,
              indiv = indiv))
}