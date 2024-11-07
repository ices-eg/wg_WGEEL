library(RPostgres)
library(sf)
library(getPass)
library(ggforce)
library(ggplot2)
library(flextable)
library(tidyverse)
library(yaml)
cred=read_yaml("../../credentials.yml")
con = dbConnect(Postgres(), dbname=cred$dbname,host=cred$host,port=cred$port,user=cred$user, password=getPass())


indicator <- dbGetQuery(con,"select eel_year, eel_cou_code,eel_emu_nameshort, b0,bbest,bcurrent, suma,sumf, sumh from datawg.precodata_emu ")%>%
		pivot_wider(names_from=c("eel_year"),values_from=c("bbest","bcurrent", "suma","sumf", "sumh"),names_sort=TRUE)
landings_releases <- dbGetQuery(con, "select typ_name,eel_year,eel_emu_nameshort,sum(case when eel_missvaluequal = 'NP' then 0 else eel_value end) eel_value,eel_lfs_code from datawg.t_eelstock_eel join ref.tr_typeseries_typ on typ_id=eel_typ_id
                                where eel_typ_id in (4,6,9) and eel_qal_id in (1,4) and eel_year >=2000
                                group by typ_name,eel_year,eel_emu_nameshort,eel_lfs_code ") %>%
  pivot_wider(names_from=c("typ_name","eel_lfs_code","eel_year"),values_from="eel_value",names_sort=TRUE)



# B0 adjusted


load( file=file.path(getwd(),"data_dependencies","annex13.Rdata")) # annexes13_method,annexes13_traceability,annexes13_management,
load("../../R/shiny_data_visualisation/shiny_dv/data/maps_for_shiny.Rdata")
load("../../R/shiny_data_visualisation/shiny_dv/data/ref_and_eel_data.Rdata")
eu_cou_codes=c("AT",	"BE",	"BG",	"HR",	"CY",	"CZ",	"DK",	"EE",	"FI",	"FR",	"DE",	"GR",	"HU",	"IE",	"IT",	"LV",	"LT",	"LU",	"MT",	"NL",	"PL",	"PT",	"RO",	"SK",	"SI",	"ES",	"SE")

emu_sea= emu_p %>%
		filter(emu_cou_code %in% eu_cou_codes) %>%
		mutate(rec_zone = ifelse(emu_cou_code %in% c("NL","DK","NO","BE","LU", "CZ","SK") |
								emu_nameshort %in% c("FR_Rhin","FR_Meus","GB_Tham","GB_Angl","GB_Humb","GB_Nort","GB_Solw",
										"DE_Ems","DE_Wese","DE_Elbe","DE_Rhei","DE_Eide","DE_Maas") ,
						"NS", 
						ifelse(emu_cou_code %in% c("EE","FI","SE","LV","LT","AX", "PL","DE"),
								"BA",
								"EE")))


mor_wise = annexes13_method %>% select(emu_nameshort,mortality_wise)
mor_wise = merge(emu_sea %>% st_drop_geometry(),mor_wise)
mor_wise <- mor_wise %>% mutate(cohort_wise=grepl("ohort",mortality_wise)) %>%
		mutate(emu_nameshort = ifelse(emu_nameshort == "NL_Neth","NL_total",emu_nameshort))
load("../../R/shiny_data_visualisation/shiny_dv/data/recruitment/dat_ge.Rdata")
load("../../R/shiny_data_visualisation/shiny_dv/data/recruitment/dat_ye.Rdata")


estimate_b0 = function(emu, year, mor_wise,precodata){
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
	precodata$bbest[precodata$eel_emu_nameshort==emu & precodata$eel_year==year] / Rcurrent
}

indicator_sub <- dbGetQuery(con,"select eel_year, eel_emu_nameshort, bbest from datawg.precodata_emu ") %>%
		filter(eel_emu_nameshort %in% unique(mor_wise$emu_nameshort))
indicator_sub$b0_adj = mapply(estimate_b0,indicator_sub$eel_emu_nameshort, indicator_sub$eel_year,
		MoreArgs=list(mor_wise=mor_wise,precodata=indicator_sub))

res <- indicator %>%
		left_join(indicator_sub %>% 
				select(eel_year, eel_emu_nameshort, b0_adj) %>%
				group_by(eel_emu_nameshort)%>%
				summarize(b0_adj_mean=mean(b0_adj)),	
		by = c("eel_emu_nameshort")) %>%
		left_join(landings_releases, by="eel_emu_nameshort")
#colnames(res)
res <-res[,c(1:3,179,4:178,180:ncol(res))]

write.table(res,"/temp/indicators_landings_releases.csv",col.names=TRUE,row.names=FALSE,sep=";")

#indicator <- dbGetQuery(con,"select eel_year, eel_cou_code,eel_emu_nameshort, b0,bbest,bcurrent, suma,sumf, sumh from datawg.precodata_emu ")
#landings_releases <- dbGetQuery(con, "select typ_name,eel_year,eel_emu_nameshort,sum(case when eel_missvaluequal = 'NP' then 0 else eel_value end) eel_value,eel_lfs_code from datawg.t_eelstock_eel join ref.tr_typeseries_typ on typ_id=eel_typ_id
#                                where eel_typ_id in (4,6,9) and eel_qal_id in (1,4) and eel_year >=2000
#                                group by typ_name,eel_year,eel_emu_nameshort,eel_lfs_code ") %>%
#  pivot_wider(names_from=c("typ_name","eel_lfs_code"),values_from="eel_value",names_sort=TRUE)
#
#write.table(merge(indicator,landings_releases),"/tmp/indicators_landings_releases.csv",col.names=TRUE,row.names=FALSE,sep=";")

