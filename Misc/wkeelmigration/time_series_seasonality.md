---
title: "WKEELMIGRATION TIME SERIES SEASONALITY DATA TREATMENT"
author: "Cédric Briand, Jan Dag Pohlmann, Estibaliz diaz and Hilaire Drouineau, "
date: "january 2020"
output: 
  html_document:
    keep_md: true
---


Some of the path below are adapted to Cédric's computer....



## Map data

In the following chunk we load data from the database to prepare the map.


```r
#map of country
# remove mediterranean (no recruitment) and Island.
query <- "SELECT cou_code,cou_country, geom  
		FROM REF.tr_country_cou where cou_code not in ('IL','CY','DZ','EG','LY','MT','MA','IS','TR','LB','SY','TN')"
cou <- st_read(dsn= dsn,  layer="country",query=query)
#plot(st_geometry(cou), xlim=c(-7,11.5),ylim=c(36,53))

# map of emus
query <- "SELECT * FROM REF.tr_emu_emu WHERE emu_cou_code  IN ('FR','ES','PT') AND emu_wholecountry=FALSE"
emu <- st_read(dsn= dsn, layer="i don't want no warning" , query=query)

# gets the centerpoints coordinates for the emus

query <- "SELECT emu_nameshort, st_centroid(geom) as geom FROM REF.tr_emu_emu WHERE emu_cou_code  IN ('FR','ES','PT') AND emu_wholecountry=FALSE"
emu_c <- st_read(dsn= dsn,  layer="emu",query=query)
# plot(st_geometry(emu))
# plot(emu_c, add=TRUE)

save(cou, file=str_c(datawd,"cou.Rdata"))
```

The following chunk will load additional data from the database. The idea is to
gather some referential that we already have in the database. File are saved in
an Rdata



```r
# connection settings -------------------------------------------------------------------
host <- "localhost"
port <- 5436
options(sqldf.RPostgreSQL.user = userlocal,  # userwgeel
  	sqldf.RPostgreSQL.password = passwordlocal, # passwordwgeel
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = host, #getInformation("PostgreSQL host: if local ==> localhost"), 
		sqldf.RPostgreSQL.port = port)

# Define pool handler by pool on global level
pool <- pool::dbPool(drv = dbDriver("PostgreSQL"),
		dbname="wgeel",
		host=host,
		port=port,
		user= userlocal, # userwgeel
		password= passwordlocal # passwordwgeel
		)



query <- "SELECT column_name
		FROM   information_schema.columns
		WHERE  table_name = 't_eelstock_eel'
		ORDER  BY ordinal_position"
t_eelstock_eel_fields <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))     
t_eelstock_eel_fields <- t_eelstock_eel_fields$column_name

query <- "SELECT cou_code,cou_country from ref.tr_country_cou order by cou_country"
list_countryt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
list_country <- list_countryt$cou_code
names(list_country) <- list_countryt$cou_country
list_country<-list_country

query <- "SELECT * from ref.tr_typeseries_typ order by typ_name"
tr_typeseries_typt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
typ_id <- tr_typeseries_typt$typ_id
tr_typeseries_typt$typ_name <- tolower(tr_typeseries_typt$typ_name)
names(typ_id) <- tr_typeseries_typt$typ_name
# tr_type_typ<-extract_ref('Type of series') this works also !
tr_typeseries_typt<-tr_typeseries_typt

query <- "SELECT min(eel_year) as min_year, max(eel_year) as max_year from datawg.t_eelstock_eel eel_cou "
the_years <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   

query <- "SELECT name from datawg.participants"
participants<<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))  
# save(participants,list_country,typ_id,the_years,t_eelstock_eel_fields, file=str_c(getwd(),"/common/data/init_data.Rdata"))
ices_division <- extract_ref("FAO area")$f_code
```

```
## Warning in postgresqlExecStatement(conn, statement, ...): RS-DBI driver
## warning: (unrecognized PostgreSQL field type geometry (id:68299) in column
## 13)
```

```r
emus <- extract_ref("EMU")
```

```
## Warning in postgresqlExecStatement(conn, statement, ...): RS-DBI driver
## warning: (unrecognized PostgreSQL field type geometry (id:68299) in column
## 3)
```

```r
# check nameshort---------------------------------------------------------------
t_series_ser <- sqldf("SELECT
				ser_nameshort, 
				ser_namelong, 
				ser_typ_id,
				ser_effort_uni_code, 
				ser_comment,
				ser_uni_code, 
				ser_lfs_code, 
				ser_hty_code, 
				ser_locationdescription, 
				ser_emu_nameshort,
				ser_cou_code,
				ser_area_division, 
				ser_tblcodeid, 
				ser_x, 
				ser_y from datawg.t_series_ser")
ser_nameshort <- sqldf("select ser_nameshort from datawg.t_series_ser")
ser_nameshort <- as.character(ser_nameshort$ser_nameshort)
sort(ser_nameshort)
```

```
##   [1] "AdCPG"  "AdTCG"  "AlbuG"  "AlCPG"  "BaBS"   "BadY"   "BannGY"
##   [8] "BeeG"   "BelY"   "BFeY"   "BFuY"   "BI1S"   "BI4S"   "BLFY"  
##  [15] "BoEY"   "BreS"   "BresGY" "BreY"   "BroE"   "BroG"   "BrokGY"
##  [22] "BroY"   "BRWS"   "BuBY"   "BurrG"  "BurS"   "ChBY"   "ClwY"  
##  [29] "CoqY"   "DalaY"  "DeBY"   "DeeY"   "DerY"   "DoElY"  "DoFpY" 
##  [36] "DoSY"   "EbroG"  "EdeY"   "EllY"   "EmsBGY" "EmsG"   "EmsHG" 
##  [43] "ErneGY" "ExeY"   "FarpGY" "FealGY" "FlaE"   "FlaG"   "FowY"  
##  [50] "FremY"  "FreS"   "FreY"   "FroY"   "GarY"   "GiBS"   "GiCPG" 
##  [57] "GirnY"  "GirY"   "GiScG"  "GiTCG"  "GotaY"  "GreyGY" "GrOY"  
##  [64] "GuadG"  "GudeY"  "HaAY"   "HartY"  "HellGY" "HHKGY"  "HoSGY" 
##  [71] "HumY"   "HVWS"   "IjsS"   "IjsY"   "ImsaGY" "ImsaS"  "InagGY"
##  [78] "ItcY"   "KatwG"  "KavlY"  "KilS"   "KilY"   "KlitG"  "LagaY" 
##  [85] "LagY"   "LangGY" "LauwG"  "LeeY"   "LiffGY" "LoEY"   "LoiG"  
##  [92] "LoiS"   "MaigG"  "MarY"   "MedY"   "MerY"   "MeusY"  "MinS"  
##  [99] "MinY"   "MiPoG"  "MiScG"  "MiSpG"  "MondG"  "MonS"   "MonY"  
## [106] "MorrY"  "MotaY"  "NaloG"  "NenY"   "NiWS"   "NkaS"   "NorsG" 
## [113] "NSIS"   "NZKS"   "OriaG"  "OriY"   "OttY"   "OusY"   "PanS"  
## [120] "ParY"   "PlyY"   "RhDOG"  "RhIjG"  "RibS"   "RibY"   "RingG" 
## [127] "RonnY"  "SeEAG"  "SeHMG"  "SeiY"   "SeNS"   "SeNY"   "SevNG" 
## [134] "SevY"   "ShaAGY" "ShaPY"  "ShiFG"  "ShiMG"  "ShiS"   "ShiY"  
## [141] "SkaY"   "SleG"   "SosS"   "SouS"   "SouY"   "StelG"  "StraGY"
## [148] "StrS"   "SuSY"   "TamY"   "TawY"   "TefY"   "TegY"   "TesY"  
## [155] "ThaY"   "TibeG"  "TweY"   "TyTY"   "UskY"   "VacG"   "VeAmGY"
## [162] "VerlGY" "VidaG"  "VilG"   "VilS"   "VilY"   "ViskGY" "VisY"  
## [169] "VVeY"   "WarS"   "WaSEY"  "WaSG"   "WelY"   "WenY"   "WerY"  
## [176] "WevY"   "WiFG"   "WisWGY" "WitY"   "WniY"   "WyeY"   "YFS1G" 
## [183] "YFS2G"  "YserG"  "ZMaS"
```

```r
save(ices_division, emus, the_years, tr_typeseries_typt, list_country, ser_nameshort, t_series_ser, file=str_c(datawd,"saved_data.Rdata"))

poolClose(pool)
```



# load data


The files are read in the folder datawd, a vector of names is extracted and
used in the load_seasonality function (see functions.R). This functions opens
the different sheets, and append them to a list of tables. One of the trick to
make it work is to force the format (numeric or character) while reading the
files otherwise the rbind later crashes for conflicting formats.
** TODO ** Update coordinates from Josefin.....




```r
load( file=str_c(datawd,"saved_data.Rdata"))
load(file=str_c(datawd,"cou.Rdata"))
load(file=str_c(datawd1,"list_seasonality_timeseries.Rdata"))

# list_seasonality is a list with all data sets (readme, data, series) as elements of the list
# below we extract the list of data and bind them all in a single data.frame
# to do so, I had to constrain the column type during file reading (see functions.R)
res <- map(list_seasonality,function(X){			X[["data"]]		}) %>% 
		bind_rows()
Hmisc::describe(res)
```

```
## res 
## 
##  9  Variables      8033  Observations
## ---------------------------------------------------------------------------
## ser_nameshort 
##        n  missing distinct 
##     8029        4      152 
## 
## lowest : ALA  AllE AlsT AshE AtrT, highest: zm5T zm6T zm7T zm8T zm9T
## ---------------------------------------------------------------------------
## das_value 
##        n  missing distinct     Info     Mean      Gmd      .05      .10 
##     7644      389     3074    0.984     2566     4978        0        0 
##      .25      .50      .75      .90      .95 
##        0        2       53     1146     4631 
## 
## lowest : 0.000000e+00 4.764110e-05 8.378203e-04 1.000000e-03 2.028486e-03
## highest: 2.801161e+05 3.288163e+05 3.320454e+05 3.440181e+05 3.803356e+05
## ---------------------------------------------------------------------------
## das_year 
##        n  missing distinct     Info     Mean      Gmd      .05      .10 
##     8028        5      113    0.996     2009    10.56     1985     1997 
##      .25      .50      .75      .90      .95 
##     2007     2013     2016     2018     2019 
## 
## lowest : 1907 1908 1909 1910 1911, highest: 2015 2016 2017 2018 2019
## ---------------------------------------------------------------------------
## das_month 
##        n  missing distinct 
##     8028        5       25 
## 
## lowest : Apr APR Aug AUG Dec, highest: Oct OCT OKT Sep SEP
## ---------------------------------------------------------------------------
## das_comment 
##        n  missing distinct 
##     1771     6262      107 
## 
## lowest : 2012-2013                                                                        2012-2013, attention problems with the monitoring partial percentage for January 2013-2014                                                                        2014-2015                                                                        2015-2016                                                                       
## highest: Trap removed August 18th due to H&S                                              trap working only the icefree period April-November                              Trapping began in July                                                           Trapping began in May                                                            trapping stopped in September                                                   
## ---------------------------------------------------------------------------
## das_effort 
##        n  missing distinct     Info     Mean      Gmd      .05      .10 
##      251     7782       31    0.925    25.62    8.047      5.0     12.0 
##      .25      .50      .75      .90      .95 
##     23.5     30.0     31.0     31.0     31.0 
## 
## lowest :  1  2  3  4  5, highest: 29 30 31 32 35
## ---------------------------------------------------------------------------
## source 
##        n  missing distinct 
##     8033        0       27 
## 
## lowest : DE_seasonality_of_migration      DE_seasonality_of_migration_WarS DK_seasonality_of_migration      ES_seasonality_of_migration      FL_seasonality_of_migration     
## highest: LV_seasonality_of_migration      NL_seasonality_of_migration      NO_seasonality_of_migration      PL_seasonality_of_migration      SE_seasonality_of_migration     
## ---------------------------------------------------------------------------
## country 
##        n  missing distinct 
##     8033        0       13 
##                                                                       
## Value         DE    DK    ES    FL    FR    GB    IE    LT    LV    NL
## Frequency    323    29    40   320  1801  2253   977    86    90  1537
## Proportion 0.040 0.004 0.005 0.040 0.224 0.280 0.122 0.011 0.011 0.191
##                             
## Value         NO    PL    SE
## Frequency    480    19    78
## Proportion 0.060 0.002 0.010
## ---------------------------------------------------------------------------
## datasource 
##              n        missing       distinct          value 
##           8033              0              1 wkeelmigration 
##                          
## Value      wkeelmigration
## Frequency            8033
## Proportion              1
## ---------------------------------------------------------------------------
```

```r
# correcting pb with column
#res$ser_nameshort[!is.na(as.numeric(res$das_month))]
#listviewer::jsonedit(list_seasonality)

# Correct month
unique(res$das_month)
```

```
##  [1] "MAR" "APR" "MAY" "JUN" "JUL" "AUG" "SEP" "OKT" "NOV" NA    "JAN"
## [12] "FEB" "OCT" "DEC" "Jan" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep"
## [23] "Oct" "Nov" "Dec" "Feb"
```

```r
res$das_month <- tolower(res$das_month)
res$das_month <- recode(res$das_month, okt = "oct")
res <-res[!is.na(res$das_month),]
res$das_month <- recode(res$das_month, 
		"mar"=3, 
		"apr"=4, 
		"may"=5, 
		"jun"=6,
		"jul"=7,
		"aug"=8,
		"sep"=9,
		"oct"=10,
		"nov"=11,
		"dec"=12, 
		"jan"=1, 
		"feb"=2
)


# replacing values for nameshort with actual names when existing ----------------------

ser_nameshort_datacall <- unique(res$ser_nameshort)
ser_nameshort_l <- tolower(ser_nameshort) # ser_nameshort has been saved in previous chunk from the database
ser_nameshort_datacall_l <- tolower(ser_nameshort_datacall)
ccc <- charmatch(ser_nameshort_datacall_l,ser_nameshort_l,nomatch=-1) # partial character match, 
index <- ccc>0
# charmatch return 0 when many matches are possible. Names have been corrected in the excel file to try to avoid this.
#ser_nameshort_datacall_l[ccc==0]
# res[tolower(res$ser_nameshort)%in%c("bro","fla"),] # two with many names => corrected in the database

ser_nameshort_datacall_l[index]<-ser_nameshort[ccc[index]]
dfser <- data.frame(ser_nameshort=ser_nameshort_datacall, ser_nameshort_base="", existing=FALSE, stringsAsFactors = FALSE)
dfser$existing[index]<- TRUE
dfser$ser_nameshort_base[index]<-ser_nameshort[ccc[index]]


# load series data ------------------------------------------------------------------------------

ser <- map(list_seasonality,function(X){			X[["series_info"]]		}) %>% 
		bind_rows()
Hmisc::describe(ser)
```

```
## ser 
## 
##  15  Variables      154  Observations
## ---------------------------------------------------------------------------
## ser_nameshort 
##        n  missing distinct 
##      152        2      152 
## 
## lowest : ALA  AllE AlsT AshE AtrT, highest: zm5T zm6T zm7T zm8T zm9T
## ---------------------------------------------------------------------------
## ser_namelong 
##        n  missing distinct 
##      150        4      147 
## 
## lowest : Alausa river                    Ätrafors, River Ätran           Baddoch Burn trap               Bann Coleraine trapping partial Beeleigh_Glass_<80mm           
## highest: zmaa_06                         zmaa_07                         zmaa_08                         zmaa_09                         zmaa_10                        
## ---------------------------------------------------------------------------
## ser_typ_id 
##        n  missing distinct 
##      150        4        3 
##                             
## Value          1     2     3
## Frequency     45    10    95
## Proportion 0.300 0.067 0.633
## ---------------------------------------------------------------------------
## ser_effort_uni_code 
##        n  missing distinct 
##        8      146        5 
##                                                   
## Value            1       G   index  nr day nr haul
## Frequency        3       1       1       2       1
## Proportion   0.375   0.125   0.125   0.250   0.125
## ---------------------------------------------------------------------------
## ser_comment 
##        n  missing distinct 
##      150        4       72 
## 
## lowest : 2 fyke nets                                                                                                                                                                             an eeltrap during 1981-1994 catching all eels migrating downstream, eels in lakes upstream were stocked in 1967.                                                                        an eeltrap since  1982 catching all eels migrating downstream, expect years 1989-1991 and 1999-2000 when the trap was not working properly. Eels in lakes upstream are stocked in 1978. an eeltrap since 1974 catching all eels migrating downstream, eels in lakes upstream are stocked in 1911, 1966 and 2007.                                                                an eeltrap since 1982 catching all eels migrating downstream, expect years 1991 and 1999-2004 when the trap was not working properly.all eels in lakes upstream are stocked in 1978.   
## highest: YS mixture  Fishing trap in the river between lakes Galuonai and Vašuokas                                                                                                               YS mixture  Fishing trap in the river Kertuoja                                                                                                                                          YS mixture  Fishing trap in the river Lakaja                                                                                                                                            YS mixture  Fishing trap in the river Šakarva                                                                                                                                           YS mixture  Fishing trap in the river Žeimena                                                                                                                                          
## ---------------------------------------------------------------------------
## ser_uni_code 
##        n  missing distinct 
##      150        4        5 
##                                                                  
## Value      (n/m3)*100      index         kg         nr     number
## Frequency           1         62         10         76          1
## Proportion      0.007      0.413      0.067      0.507      0.007
## ---------------------------------------------------------------------------
## ser_lfs_code 
##        n  missing distinct 
##      150        4        5 
##                                         
## Value          G    GY     S     Y    YS
## Frequency     12    13    89    30     6
## Proportion 0.080 0.087 0.593 0.200 0.040
## ---------------------------------------------------------------------------
## ser_hty_code 
##        n  missing distinct 
##      150        4        2 
##                       
## Value          F     T
## Frequency    137    13
## Proportion 0.913 0.087
## ---------------------------------------------------------------------------
## ser_locationdescription 
##        n  missing distinct 
##      150        4       84 
## 
## lowest : 3 River weirs                                                                                       a 30 ha study area in the Marais Breton                                                             Allington lock - at tidal limit of River Medway                                                     At the north-east part of the Vaccarres lagoon                                                      Backbarrow silver eel counter on the River Leven                                                   
## highest: Vilaine at the estuarine Arzal dam, the monitoring takes place on the fourth gate of the Arzal dam. Warnow River at Kessin, appr. 17 km from River mouth                                                Whole catchment                                                                                     Whole lake survey, tidal lake                                                                       Zandmaas                                                                                           
## ---------------------------------------------------------------------------
## ser_emu_nameshort 
##        n  missing distinct 
##      150        4       29 
## 
## lowest : DE_Warn  DK-inla  ES_Basq  FI_Finl  FR_Adou 
## highest: LV_Latv  NL_Neth  NO_total PL_Vist  SE_Inla 
## ---------------------------------------------------------------------------
## ser_cou_code 
##        n  missing distinct 
##      150        4       13 
##                                                                       
## Value         DE    DK    ES    FI    FR    GB    IE    LT    LV    NL
## Frequency      1     1     1     6    14    39    11     6     4    55
## Proportion 0.007 0.007 0.007 0.040 0.093 0.260 0.073 0.040 0.027 0.367
##                             
## Value         NO    PL    SE
## Frequency      2     1     9
## Proportion 0.013 0.007 0.060
## ---------------------------------------------------------------------------
## ser_area_division 
##        n  missing distinct 
##       15      139        5 
##                                              
## Value      27.3.a 27.3.d 27.4.a 27.4.c 27.8.b
## Frequency       6      5      2      1      1
## Proportion  0.400  0.333  0.133  0.067  0.067
## ---------------------------------------------------------------------------
## ser_tblcodeid 
##        n  missing distinct    value 
##        1      153        1   170034 
##                  
## Value      170034
## Frequency       1
## Proportion      1
## ---------------------------------------------------------------------------
## ser_x 
##        n  missing distinct     Info     Mean      Gmd      .05      .10 
##      150        4      125        1   373205   746387  -8.0980  -5.6433 
##      .25      .50      .75      .90      .95 
##  -0.3205  25.6048  51.9798  54.0847  57.0597 
##                           
## Value      0.0e+00 5.6e+07
## Frequency      149       1
## Proportion   0.993   0.007
## ---------------------------------------------------------------------------
## ser_y 
##        n  missing distinct     Info     Mean      Gmd      .05      .10 
##      150        4      128        1    64701   129362    4.108    4.195 
##      .25      .50      .75      .90      .95 
##    6.104   45.117   52.702   55.765   58.540 
##                           
## Value            0 9700000
## Frequency      149       1
## Proportion   0.993   0.007
## ---------------------------------------------------------------------------
```

```r
ser <-ser[!is.na(ser$ser_nameshort),]
# searching for a mismatch between names in ser and the others (both must return zero lines)
print(ser[!ser$ser_nameshort%in%dfser$ser_nameshort,],width = Inf)
```

```
## # A tibble: 0 x 15
## # ... with 15 variables: ser_nameshort <chr>, ser_namelong <chr>,
## #   ser_typ_id <chr>, ser_effort_uni_code <chr>, ser_comment <chr>,
## #   ser_uni_code <chr>, ser_lfs_code <chr>, ser_hty_code <chr>,
## #   ser_locationdescription <chr>, ser_emu_nameshort <chr>,
## #   ser_cou_code <chr>, ser_area_division <chr>, ser_tblcodeid <chr>,
## #   ser_x <dbl>, ser_y <dbl>
```

```r
print(dfser$ser_nameshort[!dfser$ser_nameshort%in%ser$ser_nameshort]) 
```

```
## character(0)
```

```r
# When everything is matching we can to a merge
ser2 <- merge(dfser,ser,by="ser_nameshort",all.x=TRUE,all.y=TRUE)
# replacing all existing series with data from base
ser2[ser2$existing,c(4:ncol(ser2))]<- t_series_ser[match(ser2[ser2$existing,"ser_nameshort_base"],t_series_ser$ser_nameshort),-1]

# check latitude : 4 is not a possible values, in fact NL has switched coordinates
range(ser2$ser_y, na.rm = TRUE)
```

```
## [1]  4.08163 61.22219
```

```r
# switch coordinates for NL

index_problem_NL <- which(ser2$ser_y<20 & !is.na(ser2$ser_y))
xtemp <-ser2$ser_y[index_problem_NL]
ser2$ser_y[index_problem_NL] <- ser2$ser_x[index_problem_NL]
ser2$ser_x[index_problem_NL] <- xtemp ; rm(xtemp, index_problem_NL)

# some summaries about data --------------------------------------------------------------------
# number of monthly seasonality data in the datacall
nrow(res) 
```

```
## [1] 8028
```

```r
# number of series in the datacall
nrow(ser2)
```

```
## [1] 152
```

```r
# test before joining that we not not loose any data
stopifnot(nrow(res %>%
						inner_join(ser2[,
										c("ser_nameshort",  "ser_lfs_code")], by="ser_nameshort"))==nrow(res))


# the following table are just copied and pasted in the markdown document readme.md file

# number per stage

knitr::kable(sum0 <- res %>%
				inner_join(ser2[,
								c("ser_nameshort",  "ser_lfs_code")], by="ser_nameshort") %>%
				group_by(ser_lfs_code) %>%
				summarize(N=n(), 
						Nseries=n_distinct(ser_nameshort)))%>%
				  kable_styling("striped", full_width = F)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> ser_lfs_code </th>
   <th style="text-align:right;"> N </th>
   <th style="text-align:right;"> Nseries </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> G </td>
   <td style="text-align:right;"> 772 </td>
   <td style="text-align:right;"> 12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:right;"> 870 </td>
   <td style="text-align:right;"> 14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 4628 </td>
   <td style="text-align:right;"> 88 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 1672 </td>
   <td style="text-align:right;"> 32 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 86 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
</tbody>
</table>

```r
# number per month
knitr::kable(sum0 <- res %>%
				inner_join(ser2[,
								c("ser_nameshort",  "ser_lfs_code")], by="ser_nameshort") %>%
				group_by(ser_lfs_code,das_month) %>%
				summarize(N=n()) %>% pivot_wider(names_from="das_month",values_from="N"))%>%
				  kable_styling("striped", full_width = F)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> ser_lfs_code </th>
   <th style="text-align:right;"> 1 </th>
   <th style="text-align:right;"> 2 </th>
   <th style="text-align:right;"> 3 </th>
   <th style="text-align:right;"> 4 </th>
   <th style="text-align:right;"> 5 </th>
   <th style="text-align:right;"> 6 </th>
   <th style="text-align:right;"> 7 </th>
   <th style="text-align:right;"> 8 </th>
   <th style="text-align:right;"> 9 </th>
   <th style="text-align:right;"> 10 </th>
   <th style="text-align:right;"> 11 </th>
   <th style="text-align:right;"> 12 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> G </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 52 </td>
   <td style="text-align:right;"> 71 </td>
   <td style="text-align:right;"> 92 </td>
   <td style="text-align:right;"> 97 </td>
   <td style="text-align:right;"> 75 </td>
   <td style="text-align:right;"> 75 </td>
   <td style="text-align:right;"> 57 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:right;"> 29 </td>
   <td style="text-align:right;"> 37 </td>
   <td style="text-align:right;"> 145 </td>
   <td style="text-align:right;"> 66 </td>
   <td style="text-align:right;"> 97 </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:right;"> 98 </td>
   <td style="text-align:right;"> 82 </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 32 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 229 </td>
   <td style="text-align:right;"> 224 </td>
   <td style="text-align:right;"> 419 </td>
   <td style="text-align:right;"> 438 </td>
   <td style="text-align:right;"> 507 </td>
   <td style="text-align:right;"> 276 </td>
   <td style="text-align:right;"> 234 </td>
   <td style="text-align:right;"> 380 </td>
   <td style="text-align:right;"> 523 </td>
   <td style="text-align:right;"> 543 </td>
   <td style="text-align:right;"> 523 </td>
   <td style="text-align:right;"> 332 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 64 </td>
   <td style="text-align:right;"> 66 </td>
   <td style="text-align:right;"> 86 </td>
   <td style="text-align:right;"> 184 </td>
   <td style="text-align:right;"> 202 </td>
   <td style="text-align:right;"> 208 </td>
   <td style="text-align:right;"> 192 </td>
   <td style="text-align:right;"> 188 </td>
   <td style="text-align:right;"> 202 </td>
   <td style="text-align:right;"> 114 </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:right;"> 67 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
  </tr>
</tbody>
</table>

```r
# series details
knitr::kable(sum1 <- res %>%
				inner_join(ser2[,
								c("ser_nameshort", "ser_namelong", "ser_typ_id", "ser_lfs_code",  "ser_emu_nameshort", "ser_cou_code")], by="ser_nameshort") %>%
				group_by(ser_nameshort,ser_lfs_code, ser_cou_code) %>%
				summarize(first.year=min(das_year),last.year= max(das_year), nb_year=1+max(das_year)-min(das_year),N=n()))%>%
  kable_styling("striped") %>%
  scroll_box(width = "600px", height = "400px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:400px; overflow-x: scroll; width:600px; "><table class="table table-striped" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> ser_nameshort </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> ser_lfs_code </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> ser_cou_code </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> first.year </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> last.year </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> nb_year </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> N </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> ALA </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> LT </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AllE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AlsT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> SE </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AshE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AtrT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> SE </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BadB </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2003 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 203 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bann </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 1933 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 87 </td>
   <td style="text-align:right;"> 87 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BeeG </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2006 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 56 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BowE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bro </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2008 </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 24 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BroE </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BroG </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BroS </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BurFe </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:right;"> 1987 </td>
   <td style="text-align:right;"> 1988 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BurFu </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:right;"> 1987 </td>
   <td style="text-align:right;"> 1988 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Burr </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 34 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BurS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:right;"> 1970 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 592 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CraE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 24 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DaugS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> LV </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 24 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DaugY </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> LV </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 24 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EmbE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EmsB </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> DE </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EmsH </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> DE </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 25 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Erne </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:right;"> 2009 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 58 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ErneS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:right;"> 2009 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 55 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fla </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 35 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FlaE </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 55 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FlaG </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 55 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ForT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> SE </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GarG </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 37 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GarY </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 2002 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 212 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GirB </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2003 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 203 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Girn </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2008 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 143 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GiSc </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 1991 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 29 </td>
   <td style="text-align:right;"> 340 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GraT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> SE </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Grey </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2009 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 108 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gud </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> DK </td>
   <td style="text-align:right;"> 2002 </td>
   <td style="text-align:right;"> 2005 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 28 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GVT </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> LT </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HallE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HauT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FI </td>
   <td style="text-align:right;"> 1993 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:right;"> 38 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> hv1T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> hv2T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> hv3T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> hv4T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> hv5T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> hv6T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> hv7T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij10T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij11T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij12T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij1T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij2T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij3T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij4T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij5T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij6T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij7T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij8T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ij9T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ImsaGY </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> NO </td>
   <td style="text-align:right;"> 2000 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 240 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ImsaS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NO </td>
   <td style="text-align:right;"> 2000 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 240 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Isle_G </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 2005 </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> KauT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FI </td>
   <td style="text-align:right;"> 1981 </td>
   <td style="text-align:right;"> 1994 </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> KavT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> SE </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> KER </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> LT </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LakT </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> LT </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 36 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LeaE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LevS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2000 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 103 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Liff </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LilS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> LV </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LilY </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> LV </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LonE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MajT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FI </td>
   <td style="text-align:right;"> 1974 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 45 </td>
   <td style="text-align:right;"> 123 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MarB_Y </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 1998 </td>
   <td style="text-align:right;"> 1999 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 18 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MerE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MillE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MolE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 46 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MorE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NeaS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 1907 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 113 </td>
   <td style="text-align:right;"> 113 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NMilE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2009 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 66 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nw10T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nw1T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nw2T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nw3T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nw4T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nw5T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nw6T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nw7T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nw8T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nw9T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NydT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> SE </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nz1T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 32 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nz2T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 32 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nz3T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 33 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nz4Y </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 32 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nz5T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 31 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OatY </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OirS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 2000 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 236 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OnkT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FI </td>
   <td style="text-align:right;"> 1983 </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 30 </td>
   <td style="text-align:right;"> 36 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oria </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> ES </td>
   <td style="text-align:right;"> 2005 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OstT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> SE </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RhDOG </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2000 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 60 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RhinY </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 2006 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 165 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rij10T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rij1T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rij2T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rij3T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rij4T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rij5T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rij6T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rij7T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rij8T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rij9T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RodE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 18 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RuuT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FI </td>
   <td style="text-align:right;"> 1982 </td>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 35 </td>
   <td style="text-align:right;"> 35 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sakt </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> LT </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ScorS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 2000 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 236 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SevNS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 23 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ShaE </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 44 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ShaKilS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:right;"> 2009 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ShaP </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Shie </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2002 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 215 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ShiF </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 35 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ShiM </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 71 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SkaT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> SE </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SomS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 43 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SouS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> StGeE </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> StGeG </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> StGeY </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> StoE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 33 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Stra </td>
   <td style="text-align:left;"> GY </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TedE </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 31 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> UShaS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:right;"> 2009 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 51 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VaaT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FI </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VaccY </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 2000 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 111 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VesT </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> SE </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VilS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 43 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VilY2 </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:right;"> 1996 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 24 </td>
   <td style="text-align:right;"> 278 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Vist </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> PL </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WarS </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> DE </td>
   <td style="text-align:right;"> 2009 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 264 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ZeiT </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> LT </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 24 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zm </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 28 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zm10T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zm1T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 28 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zm2T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zm3T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zm5T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zm6T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 28 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zm7T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zm8T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zm9T </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> NL </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
</tbody>
</table></div>

```r
# Saving data for Hilaire next analysis
save(res, ser2, file=str_c(datawd,"seasonality_tibbles_res_ser2.Rdata"))
```



```r
load( file=str_c(datawd,"saved_data.Rdata"))
load(file=str_c(datawd,"cou.Rdata"))
load(file=str_c(datawd1,"list_seasonality_timeseries.Rdata"))
load(file=str_c(datawd,"seasonality_tibbles_res_ser2.Rdata"))

# EFFECT OF LATITUDE ON MIGRATION TIMING IN GLASS EEL

# summarize the data set, first join usefull columns lfs code and ser_y from ser, 
# then calculate sum value for each series each year and join it back into the data set
# using the leading inner_join then calculate percentage per month which will fall between 0 and 1
# some trials about latitude show that this one seems to be working well for the glass eel plot below so I try to
# "discretize" the latitude

res3 <- left_join(res,
				res %>%		inner_join(ser2[,
										c("ser_nameshort",  "ser_lfs_code","ser_x","ser_y")], by="ser_nameshort") %>%
						group_by(ser_nameshort, das_year,ser_lfs_code, ser_y, ser_x) %>% 
						summarize(sum_per_year=sum(das_value,na.rm=TRUE)),
				by = c("ser_nameshort", "das_year")) %>%	
		mutate(perc_per_month=das_value/sum_per_year) %>% 
		mutate(lat_range=cut(ser_y,breaks=c(0,10,15,20,25,30,35,40,50,60,65,70)))

# example using ggplot and coord polar => not the best, problem with margins
#png(filename=str_c(imgwd,"seasonality_glass_eel_wrong.png"))
#x11()
gg1 <-res3 %>% filter(ser_lfs_code=='G') %>%
		group_by(ser_nameshort, lat_range, das_month) %>%
		summarize(average_per_per_month=mean(perc_per_month,na.rm=TRUE)) %>%
		ggplot(aes(x = das_month,
						fill = ser_nameshort)) +
		geom_col(aes(y=average_per_per_month)) + 
		#facet_wrap(~ser_nameshort)+
		xlab("month")+
		geom_text(aes(x=das_month, y=4,label = das_month), color = "navy", size=3)+
		facet_grid(~lat_range )+
		coord_polar()+		
		theme_void()
print(gg1)
```

```
## Warning: Removed 14 rows containing missing values (position_stack).
```

![](time_series_seasonality_files/figure-html/plots-1.png)<!-- -->

```r
#dev.off()		


# using a different approach with geom_arc_bar
# https://rviews.rstudio.com/2019/09/19/intro-to-ggforce/
# https://stackoverflow.com/questions/16184188/ggplot-facet-piechart-placing-text-in-the-middle-of-pie-chart-slices/47645727#47645727


# COMPUTE DATA FRAME FOR GLASS EEL WITH EXPLICIT ANGLES
resG <- left_join(
				
				res3 %>% filter(ser_lfs_code=='G') %>%
						group_by(ser_nameshort, ser_x, ser_y, lat_range, das_month) %>%   # this will also arrange the dataset
						summarize(sum_per_month=sum(das_value,na.rm=TRUE))
				,
				res3 %>% group_by (ser_nameshort) %>%
						summarize(sum_per_series=sum(das_value,na.rm=TRUE),
								nyear=n_distinct(das_year)),			
				
				by = c("ser_nameshort") 
		
		) %>%
		ungroup() %>%
		rename(month=das_month, series=ser_nameshort) %>%
		mutate(perc_per_month = sum_per_month / sum_per_series,
				series=str_c(series, "N=", nyear)) %>%
		group_by(series) %>%
		mutate(
				end_angle = 2*pi*(month-1)/12,
				start_angle = 2*pi*(month)/12
				
		) # for text label


# overall scaling for pie size
scale = max(sqrt(resG$perc_per_month))

dflab <- data.frame(month=c(1:12), 
		angle = 2*pi*(1:12-0.5)/12,
		end_angle = 2*pi*(1:12-1)/12,
		start_angle = 2*pi*(1:12)/12)


Y <-resG %>% group_by(series) %>% 
		summarize(y=first(ser_y))%>%pull(y)

# series ordered by latitude
resG$series <- factor(resG$series, levels= levels(as.factor(resG$series))[order(Y)])
# draw the circular plot

gg2 <- ggplot(resG) + 
		geom_arc_bar(aes(x0 = 0, y0 = 0, r0 = 0, r = scale,
						start = start_angle, end = end_angle, fill = as.factor(month)),color="grey80",alpha=0, data=dflab)+
		geom_arc_bar(aes(x0 = 0, y0 = 0, r0 = 0, r = sqrt(perc_per_month),
						start = start_angle, end = end_angle, fill = as.factor(month))) +
		geom_text(aes(x = 1.2*scale*sin(angle), y = 1.2*scale*cos(angle), label = month), data=dflab,
				hjust = 0.5, vjust = 0.5, col="grey50", size=3) +
		coord_fixed() +
		scale_fill_manual("month",values=rainbow(12))+
		scale_x_continuous(limits = c(-1, 1), name = "", breaks = NULL, labels = NULL) +
		scale_y_continuous(limits = c(-1, 1), name = "", breaks = NULL, labels = NULL) +
		ggtitle("Seasonality for glass eel migration, series ordered by latitude")+
		hrbrthemes::theme_ipsum_rc()+
		facet_wrap(~series) 
print(gg2)
```

```
## Warning in grid.Call(C_stringMetric, as.graphicsAnnot(x$label)): famille de
## police introuvable dans la base de données des polices Windows
```

```
## Warning in grid.Call(C_stringMetric, as.graphicsAnnot(x$label)): famille de
## police introuvable dans la base de données des polices Windows

## Warning in grid.Call(C_stringMetric, as.graphicsAnnot(x$label)): famille de
## police introuvable dans la base de données des polices Windows

## Warning in grid.Call(C_stringMetric, as.graphicsAnnot(x$label)): famille de
## police introuvable dans la base de données des polices Windows

## Warning in grid.Call(C_stringMetric, as.graphicsAnnot(x$label)): famille de
## police introuvable dans la base de données des polices Windows
```

```
## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
## famille de police introuvable dans la base de données des polices Windows

## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
## famille de police introuvable dans la base de données des polices Windows

## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
## famille de police introuvable dans la base de données des polices Windows

## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
## famille de police introuvable dans la base de données des polices Windows

## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
## famille de police introuvable dans la base de données des polices Windows
```

```
## Warning in grid.Call.graphics(C_text, as.graphicsAnnot(x$label), x$x,
## x$y, : famille de police introuvable dans la base de données des polices
## Windows
```

```
## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
## famille de police introuvable dans la base de données des polices Windows

## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
## famille de police introuvable dans la base de données des polices Windows

## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
## famille de police introuvable dans la base de données des polices Windows

## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
## famille de police introuvable dans la base de données des polices Windows
```

![](time_series_seasonality_files/figure-html/plots-2.png)<!-- -->

```r
# draw a map

resG <-st_as_sf(resG[!is.na(resG$ser_y),], coords = c("ser_x", "ser_y"), crs = 4326)
resG <- st_transform(x = resG, crs = 3035)
resG$lon<-st_coordinates(resG)[,1]
resG$lat<-st_coordinates(resG)[,2] 

#png(filename=str_c(imgwd,"map_seasonality_glass_eel.png"),width = 10, height = 8, units = 'in', res = 300)

# to avoid distortion below we use 3035 and not wgs84 (4326)
# the coefficient for sqrt(perc_per_month) is adjusted by trial and errors
gg3 <- ggplot(data = cou) +  geom_sf(fill= "antiquewhite") +
		geom_arc_bar(aes(x0 = lon, y0 = lat, r0 = 0, r = 2*10^5*sqrt(perc_per_month),  
						start = start_angle, end = end_angle, fill = as.factor(month)), 
				data=resG, 
				show.legend=FALSE,
				alpha=0.5) +		
  coord_sf(crs = "+init=epsg:3035",
						xlim=c(3,6)*10^6,	
						ylim=	c(2300000,4*10^6)  # st_bbox(resG)[c(2,4)
				) +
		scale_colour_manual(values=cols)+
		scale_size_continuous(range=c(0.5,15)) +
		xlab("Longitude") + 
		ylab("Latitude") + 
		ggtitle("glass eel seasonality")+ 
		annotation_scale(location = "bl", width_hint = 0.5) +
		annotation_north_arrow(location = "tr", which_north = "true", 
				pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
				style = north_arrow_fancy_orienteering) +
		theme(panel.grid.major = element_line(color = gray(.5), linetype = "dashed", size = 0.5), 
				panel.background = element_rect(fill = "aliceblue"))

print(gg3)
```

![](time_series_seasonality_files/figure-html/plots-3.png)<!-- -->

```r
#####################################################
# Silver eel
####################################################

resS <- left_join(
				
				res3 %>% filter(ser_lfs_code=='S') %>%
						group_by(ser_nameshort, ser_x, ser_y, lat_range, das_month) %>%   # this will also arrange the dataset
						summarize(sum_per_month=sum(das_value,na.rm=TRUE))
				,
				res3 %>%  filter(ser_lfs_code=='S')%>% group_by (ser_nameshort) %>%
						summarize(sum_per_series=sum(das_value,na.rm=TRUE),
								nyear=n_distinct(das_year)),			
				
				by = c("ser_nameshort") 
		
		) %>%
		ungroup() %>%
		rename(month=das_month, series=ser_nameshort) %>%
		mutate(perc_per_month = sum_per_month / sum_per_series,
				series=str_c(series, "N=", nyear)) %>%
		group_by(series) %>%
		mutate(
				end_angle = 2*pi*(month-1)/12,
				start_angle = 2*pi*(month)/12
		
		) # for text label

resSs <- st_as_sf(resS[!is.na(resS$ser_y),], coords = c("ser_x", "ser_y"), crs = 4326)
resSs <- st_transform(x = resSs, crs = 3035)
resSs$lon<-st_coordinates(resSs)[,1]
resSs$lat<-st_coordinates(resSs)[,2]
gg4 <- ggplot(data = cou) +  
		geom_sf(fill= "antiquewhite") +
				coord_sf(crs = "+init=epsg:3035",
						xlim=c(3,6)*10^6,	
						ylim=	st_bbox(resSs)[c(2,4)]
				) +
		geom_arc_bar(aes(x0 = lon, y0 = lat, r0 = 0, r = 2*10^5*sqrt(perc_per_month),
						start = start_angle, end = end_angle, fill = as.factor(month)), 
				data=resSs, 
				show.legend=FALSE,
				alpha=0.5) +		
		scale_colour_manual(values=cols)+
		scale_size_continuous(range=c(0.5,15)) +
		xlab("Longitude") + 
		ylab("Latitude") + 
		ggtitle("silver eel seasonality")+ 
		annotation_scale(location = "bl", width_hint = 0.5) +
		annotation_north_arrow(location = "tr", which_north = "true", 
				pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
				style = north_arrow_fancy_orienteering) +	
		theme(panel.grid.major = element_line(color = gray(.5), linetype = "dashed", size = 0.5), 
				panel.background = element_rect(fill = "aliceblue"))
print(gg4)
```

![](time_series_seasonality_files/figure-html/plots-4.png)<!-- -->

```r
# ploting all with columns
#x11()
res3 %>% filter(ser_lfs_code=='S') %>%
		
		ggplot(aes(x = das_month)) +
		geom_col(aes(y=perc_per_month, fill=ser_nameshort)) + 
		facet_wrap(~country)+
		xlab("month")
```

```
## Warning: Removed 153 rows containing missing values (position_stack).
```

![](time_series_seasonality_files/figure-html/plots-5.png)<!-- -->



