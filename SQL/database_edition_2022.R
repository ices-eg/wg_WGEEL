library(RPostgres)
library(dplyr)
con=dbConnect(Postgres(),host="localhost",user="wgeel",dbname="wgeel",password="wgeel", port=5432)

####collect all biometry data associated with time series
biometry_ser=dbGetQuery(con,"select * from datawg.t_biometry_series_bis")


# bio_length,bio_weight,bio_age,bio_perc_female,
# bio_length_f,bio_weight_f,bio_age_f,
# bio_length_m, bio_weight_m,bio_age_m,
# bis_g_in_gy,bio_number

#remove lines in which we don't have any biometry data
biometry_ser <- biometry_ser %>%
  select(bio_id,bio_length,bio_weight,bio_age,bio_perc_female,
         bio_length_f,bio_weight_f,bio_age_f,
         bio_length_m, bio_weight_m,bio_age_m,
         bis_g_in_gy,bio_number) %>%
  filter(rowSums(is.na(.)) != ncol(.)-1) %>%
  left_join(biometry_ser)


# for each of this line, we have to create a group
groups <- biometry_ser %>%
  select(bio_lfs_code,bio_year,bio_number,bis_ser_id,
         bio_comment,
         bio_dts_datasource) %>%
  rename(gr_lfs_code=bio_lfs_code,
         gr_year=bio_year,
         gr_number=bio_number,
         gr_comment=bio_comment,
         gr_dts_datasource=bio_dts_datasource,
         grser_ser_id=bis_ser_id)


dbWriteTable(con,"group_tmp",groups,temporary=TRUE)
res=dbGetQuery(con,"insert into datawg.t_groupseries_grser(gr_year,grser_ser_id,gr_lfs_code,gr_number,gr_comment,gr_dts_datasource)
           (select g.gr_year,g.grser_ser_id,g.gr_lfs_code,g.gr_number,g.gr_comment,g.gr_dts_datasource from group_tmp g) returning gr_id")
biometry_ser$gid=res[,1] #gids of the newly created groups
dbSendQuery(con,"drop table if exists group_tmp")

#now we have to enter the group biometry data
corresp_metric=data.frame(
mty=c("lengthmm", "weightg", "ageyear", "female_proportion",  "m_mean_lengthmm",  "m_mean_weightg", "m_mean_ageyear", "f_mean_lengthmm", "f_mean_weightg", "f_mean_age", "g_in_gy_proportion"),
oldmeas=c("bio_length","bio_weight","bio_age","bio_perc_female","bio_length_m","bio_weight_m","bio_age_m","bio_length_f","bio_weight_f","bio_age_f", "bis_g_in_gy")
)
library(tidyr)
#put it into long format after selecting important columns

biometry_ser_long <- biometry_ser %>%
  mutate(bio_perc_female=bio_perc_female / 100) %>%
  select(gid,bio_length,bio_weight,bio_age,bio_perc_female,
         bio_length_f,bio_weight_f,bio_age_f,
         bio_length_m, bio_weight_m,bio_age_m,
         bis_g_in_gy,bio_qal_id,bio_dts_datasource) %>%
  pivot_longer(-c(gid,bio_qal_id,bio_dts_datasource),gid,values_to="metric_val",names_to="oldmeas") %>%
  left_join(corresp_metric) %>%
  filter(!is.na(metric_val))


dbWriteTable(con,"bioval_tmp",biometry_ser_long,temporary=TRUE)
dbSendQuery(con, "insert into datawg.t_metricgroupseries_megser (meg_gr_id,meg_mty_id,meg_value,meg_qal_id,meg_dts_datasource)
           select gid::integer,mty_id,metric_val,bio_qal_id,bio_dts_datasource from bioval_tmp left join ref.tr_metrictype_mty on mty=mty_name")
dbSendQuery(con,"drop table if exists bioval_tmp")


###### Now we do the same for historical data
biometry_sa=dbGetQuery(con,"select * from datawg.t_biometry_other_bit")


# bio_length,bio_weight,bio_age,bio_perc_female,
# bio_length_f,bio_weight_f,bio_age_f,
# bio_length_m, bio_weight_m,bio_age_m,
# bis_g_in_gy,bio_number

#remove lines in which we don't have any biometry data
biometry_sa <- biometry_sa %>%
  select(bio_id,bio_length,bio_weight,bio_age,bio_perc_female,
         bio_length_f,bio_weight_f,bio_age_f,
         bio_length_m, bio_weight_m,bio_age_m,
         bio_number) %>%
  filter(rowSums(is.na(.)) != ncol(.)-1) %>%
  left_join(biometry_sa)

library(sf)
emu=st_read(con,query="select * from ref.tr_emu_emu")
emu=emu %>%
  filter(!emu_nameshort %in% c("SE_Ea_o","SE_So_o"))
biometry_sa_sf= st_as_sf(biometry_sa, coords = c("bit_longitude", "bit_latitude"), crs = 4326)
sf::sf_use_s2(FALSE)
biometry_sa_sf=st_join(biometry_sa_sf,emu) %>%
  filter(bit_loc_name != "Borgholm" | emu_nameshort=="SE_East") %>%
  merge(biometry_sa)

#for each sampling site, we fill an sai
sampling_sites <- biometry_sa_sf %>%
  st_drop_geometry() %>%
  select(bit_latitude,bit_longitude,bit_loc_name) %>%
  bind_cols(biometry_sa_sf%>%
              st_drop_geometry()%>%
              select(emu_nameshort,emu_cou_code)) %>%
  unique() %>%
  mutate(sai_name=paste(emu_nameshort,bit_loc_name,"HIST",sep="_"))

dbWriteTable(con,"sampling_tmp",sampling_sites,temporary=TRUE)
sai_id=dbGetQuery(con,"insert into datawg.t_samplinginfo_sai (sai_cou_code,sai_emu_nameshort,sai_metadata) 
            (select emu_cou_code,emu_nameshort, 'historical data ' || coalesce(bit_loc_name,'') from sampling_tmp) returning sai_id")
dbSendQuery(con,"drop table if exists sampling_tmp")
sampling_sites$sai_id = sai_id[,1]


###we have two samples in Lithuania for the same year so we do the merge by ourselves
double_man= biometry_sa_sf %>%
  st_drop_geometry() %>%
  left_join(sampling_sites) %>%
  filter(bit_loc_name=="Mangalsala" & bio_year==2008)

groups = biometry_sa_sf %>%
  st_drop_geometry() %>%
  left_join(sampling_sites) 

groups = groups %>%
  filter(bio_id!=double_man$bio_id[1]) %>%
  mutate(bio_number=ifelse(bio_id==double_man$bio_id[2],
                           sum(double_man$bio_number),
                           bio_number),
         bio_length_f=ifelse(bio_id==double_man$bio_id[2],
                             weighted.mean(double_man$bio_length_f, double_man$bio_number),
                             bio_length_f))
# these are the final groups that need to be created
groups <- groups %>%
  select(bio_lfs_code,bio_year,bio_number,
         bio_comment,
         bio_dts_datasource, sai_id) 
# 
# groups_renames <- groups %>%
#   rename(gr_lfs_code=bio_lfs_code,
#          gr_year=bio_year,
#          gr_number=bio_number,
#          gr_comment=bio_comment,
#          gr_dts_datasource=bio_dts_datasource,
#          grsa_sai_id=sai_id) %>%
#   bind_cols(groups)
# 
# 

dbWriteTable(con,"group_tmp",groups,temporary=TRUE)
res=dbGetQuery(con,"insert into datawg.t_groupsamp_grsa(gr_year,gr_lfs_code,gr_number,gr_comment,gr_dts_datasource,grsa_sai_id)
           (select g.gr_year,g.gr_lfs_code,g.gr_number,g.gr_comment,g.gr_dts_datasource,g.grsa_sai_id from group_tmp g) returning gr_id")
groups$gid=res[,1] #gids of the newly created groups
dbSendQuery(con,"drop table if exists group_tmp")

#now we have to enter the group biometry data
corresp_metric=data.frame(
  mty=c("lengthmm", "weightg", "ageyear", "female_proportion",  "m_mean_lengthmm",  "m_mean_weightg", "m_mean_ageyear", "f_mean_lengthmm", "f_mean_weightg", "f_mean_age", "g_in_gy_proportion"),
  oldmeas=c("bio_length","bio_weight","bio_age","bio_perc_female","bio_length_m","bio_weight_m","bio_age_m","bio_length_f","bio_weight_f","bio_age_f", "bis_g_in_gy")
)
library(tidyr)
#put it into long format after selecting important columns

biometry_sa_long <- biometry_sa_sf %>%
  st_drop_geometry() %>%
  left_join(merge(groups_renames,groups)) %>%
  mutate(bio_perc_female=bio_perc_female / 100) %>%
  dplyr::select(gid,bio_length,bio_weight,bio_age,bio_perc_female,
         bio_length_f,bio_weight_f,bio_age_f,
         bio_length_m, bio_weight_m,bio_age_m,
         bio_qal_id,bio_dts_datasource,sai_id) %>%
  pivot_longer(-c(sai_id,bio_qal_id,bio_dts_datasource,gid),values_to="metric_val",names_to="oldmeas") %>%
  left_join(corresp_metric) %>%
  filter(!is.na(metric_val))



dbWriteTable(con,"bioval_tmp",biometry_sa_long,temporary=TRUE)
dbSendQuery(con, "insert into datawg.t_metricgroupsamp_megsa (meg_gr_id,meg_mty_id,meg_value,meg_qal_id,meg_dts_datasource)
           select gid::integer,mty_id,metric_val,bio_qal_id,bio_dts_datasource from bioval_tmp left join ref.tr_metrictype_mty on mty=mty_name")
dbSendQuery(con,"drop table if exists bioval_tmp")

metric=readxl::read_excel("/tmp/tr_metrictype_mty.xlsx")
dbSendQuery(con,"drop table if exists ref.tr_metrictype_mty")
dbWriteTable(con,Id(schema="ref",table="tr_metrictype_mty"),metric)


unit=readxl::read_excel("/tmp/tr_units_uni.xlsx")
dbSendQuery(con,"drop table if exists ref.tr_units_uni.xlsx")
dbWriteTable(con,Id(schema="ref",table="tr_units_uni"),metric)


