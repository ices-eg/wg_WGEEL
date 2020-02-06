---
title: "Untitled"
author: "Hilaire Drouineau"
date: "12 janvier 2020"
output: 
  rmarkdown::html_document:
     keep_md: yes
     toc: yes
  rmarkdown::md_document:
     toc: yes
---






# Loading the data

```r
wdsource <-"~/Documents/Bordeaux/migrateurs/WGEEL/wkeelmigration/source/"
load(paste(wdsource,"seasonality_tibbles_res_ser2.Rdata",sep=""))
source("function_for_model.R")
```

Number of data series per stage: 12 pure glass eel stage, 6 pure silver and 32 yellow. Only 20 mixed series, we will have to check their classification.

```r
table(ser2$ser_lfs_code)
```

```
## 
##  G GY  S  Y YS 
## 12 14 88 32  6
```

Among mixed GY, only 4 of them are not already used by the WGEEL, so we will have to check. For the others, we can use the wgeel classification.

```r
ser2[ser2$ser_lfs_code=="GY", c("ser_nameshort","ser_comment","ser_lfs_code")]
```

```
##     ser_nameshort
## 7            Bann
## 10            Bro
## 11           BroE
## 12           BroG
## 22           EmsB
## 24           Erne
## 26            Fla
## 27           FlaE
## 36           Grey
## 60         ImsaGY
## 69           Liff
## 119          ShaE
## 128         StGeE
## 132          Stra
##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ser_comment
## 7   River Bann flowing from the Lough NeaghThe LNFCS catch young yellow eel (elvers) fished below a river-spanning sluice gate, which creates a barrier to upstream juvenile eel migration on the River Bann. \r\nThe catch used to be made using drag nets with an area of 0.94 m2, but this is almost zero for the last five year (2008-2013). Another part of the catch is made with a glass eel collector located just below an impassable step on the left bank of the river.\r\nAnd finally a stationary trap located on the other bank of the river is used. \r\n These, and elvers trapped at the same location are\ntransported upstream to be stocked into the Lough. These catches provide a time-series of â€˜naturalâ€™ recruitment into the Lough
## 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             The number of glass eels, elvers and yellow eels at Brownshill on the River Great Ouse combined.
## 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          The number of elvers (>80mm<120mm) counted at Brownshill on the River Great Ouse  *2012 represents a partial count.
## 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            The number of glass eel (<80 mm)  counted at Brownshill on the River Great Ouse *2012 represents a partial count.
## 22                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   The weir upstream from the tidal weir is sampled by an eel ladder.\r\nIn 2016, representative subsamples of the eels were taken and checked for alizarinred-S marks as part of the mark-recapture study at the tidal weir.
## 24                                                                                              Total trapping in kg glass eel + yellow\nFull trapping of elvers on the Erne commenced in 1980. Some discrepancies in the time series came to light in 2009. The Erne elver dataset has now been double checked and the presented data has been agreed by DCAL and AFBINI, the ESB, NRFB and MI.  Any discrepancies were not major and the data trend and pattern has not changed. Full trapping of elvers took place on the Erne from 1980 onwards, before it was only partial.\nIn 2011 the whole series corrected to include latest changes.  Traps were significantly upgraded in 2015.  3rd Trap inserted on opposite bank, catch reported as a comment.\n
## 26                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       The number of glass eels, elvers and yellow eels at t Flatford, Judas Gap on the River Stour combined.
## 27                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Elvers (>80<120 mm) trap counted at Flatford, Judas Gap on the River Stour
## 36                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       Camera trap _Mixture of glass eel and elvers (<120mm), Greylake site, on river Parrett
## 60                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  The stage is not really glass eel but elver
## 69                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        Trap installed in 2012, at one end of a long weir. Trap at tidal limit.  Refurbished in 2017. Series introduced 2017.
## 119                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Total catch, all traps by month
## 128                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      The number of elvers (>80<120mm) at St Germans Pumping station in 2014
## 132                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Scientific trapping using artificial glass eel substrate traps at flap valve freshwater interface. This is the 8th year of trapping at this site, which will become a new NI Index site after 10 years of data collection. 
##     ser_lfs_code
## 7             GY
## 10            GY
## 11            GY
## 12            GY
## 22            GY
## 24            GY
## 26            GY
## 27            GY
## 36            GY
## 60            GY
## 69            GY
## 119           GY
## 128           GY
## 132           GY
```


# Glass Eel
## Data availability
Given comments, mixed GY can be used as glass eel. What about availability across months? Very few series are collected across all months. Esti: I guess that in most on the cases the peak and the sourronding months are provided, in the rest the abundance should be low.... could the missing months be estimated using the trend of that season? ShiF, ShiM, ImsaGY, Gry, GiSc, GarG seem to have a good monthly coverage. 



```r
recruitment <- subset(res, res$ser_nameshort %in% ser2$ser_nameshort[ser2$ser_lfs_code %in% c("G","GY")])
table(recruitment$das_month,recruitment$ser_nameshort)
```

```
##     
##      Bann BeeG Bro BroE BroG Burr EmsB EmsH Erne Fla FlaE FlaG GarG GiSc
##   1     0    0   0    0    0    0    0    0    0   0    0    0    4   26
##   2     0    0   0    0    0    1    0    0    0   0    0    0    4   28
##   3    87    0   3    9    9    4    0    3    4   0    0    0    3   29
##   4     0   14   3    9    9    6    1    5    9   0    0    0    4   29
##   5     0   14   3    9    9    6    5    5   11   7   11   11    4   28
##   6     0   14   3    9    9    6    5    5   11   7   11   11    1   28
##   7     0   14   3    9    9    4    5    5   11   7   11   11    2   29
##   8     0    0   3    9    9    4    5    2   10   7   11   11    1   29
##   9     0    0   3    9    9    3    5    0    2   7   11   11    3   28
##   10    0    0   3    9    9    0    3    0    0   0    0    0    3   29
##   11    0    0   0    0    0    0    1    0    0   0    0    0    4   29
##   12    0    0   0    0    0    0    0    0    0   0    0    0    4   28
##     
##      Grey ImsaGY Isle_G Liff Oria RhDOG ShaE ShiF ShiM StGeE StGeG Stra
##   1     9     20      3    0    8     0    0    3    6     0     0    0
##   2     9     20      2    0    8     0    0    3    6     0     0    8
##   3     9     20      2    2    0    20    1    3    6     1     1    0
##   4     9     20      3    4    0    21    1    3    6     1     1    0
##   5     9     20      0    4    0    19    8    3    6     1     1    0
##   6     9     20      0    4    0     0   10    3    6     1     1    0
##   7     9     20      0    4    0     0   10    3    6     1     1    0
##   8     9     20      0    4    0     0   10    3    6     1     1    0
##   9     9     20      0    2    0     0    4    3    6     1     1    0
##   10    9     20      0    2    8     0    0    3    6     1     1    0
##   11    9     20      0    2    8     0    0    3    6     0     0    0
##   12    9     20      1    1    8     0    0    2    5     0     0    0
```

How many years are complete for all months?

```r
sapply(unique(recruitment$ser_nameshort),function(s)
  sum(colSums(table(recruitment$das_month[recruitment$ser_nameshort==s],
                    recruitment$das_year[recruitment$ser_nameshort==s])==1)==12))
```

```
##   EmsH   EmsB   Oria   GarG   GiSc Isle_G   ShiM   ShiF   Bann   Stra 
##      0      0      0      0     21      0      5      2      0      0 
##   BroG   BroE    Bro   Grey   BeeG   FlaG   FlaE    Fla  StGeG  StGeE 
##      0      0      0      9      0      0      0      0      0      0 
##   Erne   Burr   ShaE   Liff  RhDOG ImsaGY 
##      0      0      0      0      0     20
```


## Data selection
First, we need to set up season of migration instead of calendar year. Here, we split in november and a sesaon y will correspond to november - december y-1 and january to october y.


```r
recruitment$season <- ifelse(recruitment$das_month>10,
                             recruitment$das_year+1,
                             recruitment$das_year)
recruitment$month_in_season <- paste("m",ifelse(recruitment$das_month>10,
                                      recruitment$das_month-10,
                                      recruitment$das_month+2), #1 stands for nov,
                                      sep="")                   #2 dec, 3 jan
#this function is useful to see quickly the missing months for a given series
check_month_availabilty <- function(ns){
  table(recruitment_subset$month_in_season[recruitment_subset$ser_nameshort==ns],
        recruitment_subset$season[recruitment_subset$ser_nameshort==ns])
}
```

### Reason for exclusion
* Bann: no monthly data available
* BeeG: Monitoring starts in April while migration is already high
* BroE: same data as BroG but for elvers
* Burr: temporal coverage is very variable and it is very difficult to locate the duration of the peak
* Erne: sampling starts in March while migration is already rather high
* Fla, FlaE and FlaG: twice the same series. Monitoring stards in May while abundance is sometimes already high
* Isle_G: limited number of seasons with a perhaps too limited monthly coverage
* RhDOG: only 3 months per year, moreover, there are sometimes sevaral values per month in the same year
* StGeE: same as stGeG but for elvers
* Stra: no monthly data



### Reason for keeping
* BroG: Monitoring starts in may but often with a zero catch, and continues till the end of the season. Only 2012 should be removed given comments
* EmsB: While the number of sampled months is limited, it seems to appropriately covers the peak
* EmsH: While the number of sampled months is limited, it seems to appropriately covers the peak
* GarG: adequate monthly coverage
* GiSc: adequate monthly coverage, already used by the WGEEL
* Grey: perhaps a bit upstream (have to check for the presence of a fishery downstream) but very good monthly coverage
* ImsaGY: very good coverage, already used by the WGEEL
* Liff: the two seasons starting in March appears to be appropriate
* ShaE: in 2012, monitoring starts in March leading to a good coverage of the whole season, for other years, it starts too late (May or latter)
* ShiF and ShiM: traps running all years long therefore good coverage of the migration wave.
* StGeG: only one year of data but good coverage of the migration wave (from march to october)



### Final selection of data
Given selection of data, we make a subset of data:

```r
recruitment_subset <- subset(recruitment, recruitment$ser_nameshort %in%
                               c("BroG", "EmsB", "EmsH",
                                 "GarG", "GiSc", "Grey",
                                 "ImsaGY", "Liff", "ShaE",
                                 "ShiF", "StGeG","Oria"))
#remove 2012 for BroG
recruitment_subset <- subset(recruitment_subset,
                             recruitment_subset$ser_nameshort != "BroG" | 
                               recruitment_subset$season != 2012)

# keep all for EmsB
# remove seasons 2015 and 2016 
recruitment_subset <- subset(recruitment_subset,
                             recruitment_subset$ser_nameshort != "EmsH" | 
                               (!recruitment_subset$season %in% 2015:2016))

#GarG: we keep all years
#GiSc: remove 1991 (nov dec missing), 1998, 2003, 2015 (january missing) and
# 2014 (february missing)
recruitment_subset <- subset(recruitment_subset,
                             recruitment_subset$ser_nameshort != "GiSc" | 
                               (!recruitment_subset$season %in% c(1991,1998,
                                                                  2003,2014,
                                                                  2015,2020)))
#Grey: we removd 2018
recruitment_subset <- subset(recruitment_subset,
                             recruitment_subset$ser_nameshort != "Grey" | 
                               recruitment_subset$season != 2018)
#ImsaGY we removed 2020
recruitment_subset <- subset(recruitment_subset,
                             recruitment_subset$ser_nameshort != "ImsaGY" | 
                               recruitment_subset$season != 2020)

#Liff: we keep the two seasons starting in march (month 5)
recruitment_subset <- subset(recruitment_subset,
                             recruitment_subset$ser_nameshort != "Liff" | 
                               recruitment_subset$season %in% c(2017, 2019))

#ShaE: we keep only 2012
recruitment_subset <- subset(recruitment_subset,
                             recruitment_subset$ser_nameshort != "ShaE" | 
                               recruitment_subset$season == 2012)
#Shif: remove 2020
recruitment_subset <- subset(recruitment_subset,
                            (!recruitment_subset$ser_nameshort %in% c("ShiF","ShiM")) | 
                               recruitment_subset$season != 2020)

#StGeG we keep the single year
recruitment_subset <- subset(recruitment_subset,
                            (!recruitment_subset$ser_nameshort %in% c("StGeG")) | 
                               recruitment_subset$season != 2020)
#Oria, we keep season 2006 (before EMP) and 2018 (after EMP) just to show that 
#seasonality hasn't changed
recruitment_subset <- subset(recruitment_subset,
                            recruitment_subset$ser_nameshort != "Oria" | 
                               recruitment_subset$season %in% c(2006,2018))
```



## Data preparation
To run the model, we need a table in the wide format: one column per month, one row for a year x time series. It leads to a dataset with 82 rows.


```r
#we build a table with one row per season and one column per month (1:january)
recruitment_subset$emu <- ser2$ser_emu_nameshort[match(recruitment_subset$ser_nameshort,
                                                       ser2$ser_nameshort)]
recruitment_wide <- pivot_wider(data=recruitment_subset[, c("ser_nameshort",
                                                            "emu",
                                                     "country",
                                                     "season",
                                                     "das_month",
                                                     "das_value")],
                                names_from="das_month",
                                values_from="das_value")
names(recruitment_wide)[-(1:4)] <- paste("m",
                                        names(recruitment_wide)[-(1:4)],
                                        sep="")
```

We now replace NA value per zero since we selected our dataseries with missing months corresponding to insignificant months, and we compute proportions per month for each year.


```r
recruitment_wide <- recruitment_wide %>%
  replace_na(replace=list(m1=0,
                          m2=0,
                          m3=0,
                          m4=0,
                          m5=0,
                          m6=0,
                          m7=0,
                          m8=0,
                          m9=0,
                          m10=0,
                          m11=0,
                          m12=0))
recruitment_wide[, -(1:4)] <- recruitment_wide[, -(1:4)] + 1e-3
total_catch_year <- rowSums(recruitment_wide[, paste("m", 1:12, sep="")])
recruitment_wide <- recruitment_wide %>%
  mutate_at(.vars=paste("m",1:12,sep=""),function(x) x/total_catch_year)
```

The Commission asks us to compare the pattern before and after 2007, probably to see the effect of the Eel Regulation. It is therefore necessary to build a period index. However, since most countries implemented their EMPs only in 2009/2010, we split in 2010.


```r
recruitment_wide$period <- ifelse(recruitment_wide$season>2009,
                                  2,
                                  1)

kable(table(recruitment_wide$period,
       recruitment_wide$ser_nameshort),
      row.names=TRUE,
      caption="number of seasons per EMU and period")
```

<table>
<caption>number of seasons per EMU and period</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> BroG </th>
   <th style="text-align:right;"> EmsB </th>
   <th style="text-align:right;"> EmsH </th>
   <th style="text-align:right;"> GarG </th>
   <th style="text-align:right;"> GiSc </th>
   <th style="text-align:right;"> Grey </th>
   <th style="text-align:right;"> ImsaGY </th>
   <th style="text-align:right;"> Liff </th>
   <th style="text-align:right;"> Oria </th>
   <th style="text-align:right;"> ShaE </th>
   <th style="text-align:right;"> ShiF </th>
   <th style="text-align:right;"> StGeG </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

Only 4 series have data in the first period therefore period comparisons will be difficult. However, can now try to fit the model.

## Running the model

```r
group <- as.integer(interaction(recruitment_wide$ser_nameshort,
                                            recruitment_wide$period,
                                            drop=TRUE))
nb_occ_group <- table(group)
y <-as.matrix(recruitment_wide[, paste("m", 1:12, sep="")])
```

Now, we make a loop to select the number of clusters based on a DIC criterion


```r
cl <- makeCluster(3, 'FORK')
comparison <- parSapply(cl,2:7,
       function(nbclus){
         mydata <- build_data(nbclus)
         adapted <- FALSE
         while (!adapted){
           tryCatch({
             runjags.options(adapt.incomplete="error")
             res <- run.jags("jags_model.txt", monitor= c("deviance",
                                                          "alpha_group",
                                                          "cluster"),
                        summarise=FALSE, adapt=40000, method="parallel",
                        sample=2000,burnin=100000,n.chains=1,
                        inits=generate_init(nbclus, mydata)[[1]],
                        data=mydata)
                        adapted <- TRUE
                        res_mat <- as.matrix(as.mcmc.list(res))
                        silhouette <- median(compute_silhouette(res_mat))
                        nbused <- apply(res_mat, 1, function(iter){
                          length(table(iter[grep("cluster",
                                                 names(iter))]))
                        })
                        dic <- mean(res_mat[,1])+0.5*var(res_mat[,1])
                        stats <- c(dic,silhouette,mean(nbused))
                  }, error=function(e) {
                    print(paste("not adapted, restarting nbclus",nbclus))
                    }
                  )
         }
         stats
      })
stopCluster(cl)
best_recruitment <- data.frame(nbclus=2:(ncol(comparison)+1),
                                              dic=comparison[1, ],
                                              silhouette=comparison[2, ],
                                              used=comparison[3, ])
```


```r
load("recruitment_jags.rdata")
best_recruitment
```

```
##   nbclus       dic silhouette used
## 1      2 -17038.44  0.4244025    2
## 2      3 -17756.79  0.4000448    3
## 3      4 -17832.80  0.3162364    4
## 4      5 -18034.11  0.4614823    5
## 5      6 -18050.71  0.3688323    6
## 6      7 -18057.13  0.4127160    6
```

Five clusters has a good DIC, good silhouette and all clusters are used, therefore we take this value



```r
nbclus <- 5
mydata <-build_data(5)


adapted <- FALSE
while (!adapted){
   tryCatch({
      runjags.options(adapt.incomplete="error")
      myfit_recruitment <- run.jags("jags_model.txt", monitor= c("cluster", "esp", "alpha_group",
                                            "cluster", "centroid",
                                            "centroid_group",
                                            "distToClust", "duration_clus",
                                            "duration_group",
                                            "lambda","id_cluster",
                                            "centroid"),
                      summarise=FALSE, adapt=50000, method="parallel",
                      sample=10000,burnin=200000,n.chains=1, thin=5,
                      inits=generate_init(nbclus, mydata)[[1]], data=mydata)
      adapted <- TRUE
    }, error=function(e) {
       print(paste("not adapted, restarting nbclus",nbclus))
    })
}


save(myfit_recruitment, best_recruitment,
     file="recruitment_jags.rdata")
```

## Results
Once fitted, we can plot monthly pattern per cluster

```r
load("recruitment_jags.rdata")
nbclus <- 5
mydata <-build_data(5)
get_pattern_month <- function(res,type="cluster"){
  res_mat <- as.matrix(as.mcmc.list(res))
  if (type=="cluster"){
    sub_mat <- as.data.frame(res_mat[,grep("esp",colnames(res_mat))])
  }
  sub_mat <- sub_mat %>% 
    pivot_longer(cols=1:ncol(sub_mat),
                 names_to="param",
                 values_to="proportion")
  tmp <- lapply(as.character(sub_mat$param),function(p) strsplit(p,"[[:punct:]]"))
  sub_mat$cluster<-as.factor(
    as.integer(lapply(tmp, function(tt) tt[[1]][2])))
  sub_mat$month <- as.character(lapply(tmp,
                                       function(tt) paste("m",
                                                          tt[[1]][3],
                                                          sep="")))
  sub_mat$month <- factor(sub_mat$month, levels=paste("m", 1:12, sep=""))
  sub_mat
}


pat=get_pattern_month(myfit_recruitment)
clus_order=c("5","2","1","3","4")
pat$cluster=factor(match(pat$cluster,clus_order),
                   levels=as.character(1:7))

ggplot(pat,aes(x=month,y=proportion))+
  geom_boxplot(aes(fill=cluster),outlier.shape=NA) +
  scale_fill_manual(values=cols)+facet_wrap(.~cluster, ncol=1) +
  theme_igray()
```

![](jags_modelling_monitoring_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

We compute some statistics to characterize the clusters.

```r
#function to make circular shifting
table_characteristics(myfit_recruitment, 5,clus_order)
```

<table>
<caption>characteristics of clusters</caption>
 <thead>
<tr>
<th style="border-bottom:hidden" colspan="1"></th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="3"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">number of months to reach 80% of total</div></th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="3"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">month of centroid</div></th>
</tr>
  <tr>
   <th style="text-align:right;"> cluster </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> q2.5% </th>
   <th style="text-align:right;"> q97.5% </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> q2.5% </th>
   <th style="text-align:right;"> q97.5% </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 1.33 </td>
   <td style="text-align:right;"> 1.21 </td>
   <td style="text-align:right;"> 1.45 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4.99 </td>
   <td style="text-align:right;"> 4.84 </td>
   <td style="text-align:right;"> 5.15 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 5.89 </td>
   <td style="text-align:right;"> 5.77 </td>
   <td style="text-align:right;"> 6.00 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 6.95 </td>
   <td style="text-align:right;"> 6.80 </td>
   <td style="text-align:right;"> 7.12 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 7.09 </td>
   <td style="text-align:right;"> 7.03 </td>
   <td style="text-align:right;"> 7.15 </td>
  </tr>
</tbody>
</table>
Duration indicates the minimum number of months that covers 80% of the wave (1st column is the median, and the 2 next one quantiles 2.5% and 97.5% of credibility intervals). Centroid is the centroid of the migration wave (e.g. 11.5 would indicate a migration centred around mid november). The first column is the median and the two next one the quantiles 2.5 and 97.5%.

We can also look at the belonging of the different groups.

```r
groups <- interaction(recruitment_wide$ser_nameshort,
                                            recruitment_wide$period,
                                            drop=TRUE)
group_name <- levels(groups)

get_pattern_month <- function(res,mydata){
  
  tmp <- strsplit(as.character(group_name),
                  "\\.")
  ser <- as.character(lapply(tmp,function(tt){
    tt[1]
  }))
  period <- as.character(lapply(tmp,function(tt){
    tt[2]
  }))
  res_mat <- as.matrix(as.mcmc.list(res))
  country <- ser2$ser_cou_code[match(ser, ser2$ser_nameshort)]

  clus <- t(sapply(seq_len(length(unique(groups))), function(id){
    name_col <- paste("cluster[",id,"]",sep="")
    freq <- table(res_mat[,name_col])
    max_class <- names(freq)[order(freq,decreasing=TRUE)[1]]
    c(max_class,freq[as.character(1:nbclus)])
  }))
  storage.mode(clus) <- "numeric"
  classes <- as.data.frame(clus)
  names(classes) <- c("cluster", paste("clus",1:nbclus,sep=""))
  cbind.data.frame(data.frame(ser=ser, period=period,country=country),
                   classes)
}

myclassif <- get_pattern_month(myfit_recruitment)
col_toreorder=grep("clus[0-9]",names(myclassif))
names(myclassif)[col_toreorder]=paste("clus",
                                      match(paste("clus",1:nbclus,sep=""),
                                      paste("clus",clus_order,sep="")),
                                      sep="")
myclassif[,col_toreorder] <- myclassif%>%
  select(col_toreorder)%>%select(sort(names(.)))
```

```
## Note: Using an external vector in selections is ambiguous.
## ℹ Use `all_of(col_toreorder)` instead of `col_toreorder` to silence this message.
## ℹ See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
## This message is displayed once per session.
```

```r
myclassif$cluster=factor(match(myclassif$cluster,clus_order),
                   levels=as.character(1:7))

table_classif(myclassif,"series")
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> series </th>
   <th style="text-align:left;"> period </th>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> Max cluster </th>
   <th style="text-align:right;"> % clus 1 </th>
   <th style="text-align:right;"> % clus 2 </th>
   <th style="text-align:right;"> % clus 3 </th>
   <th style="text-align:right;"> % clus 4 </th>
   <th style="text-align:right;"> % clus 5 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Oria </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oria </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GiSc </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GarG </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GiSc </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EmsH </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Grey </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 82 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Grey </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> StGeG </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BroG </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ShiF </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EmsB </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Liff </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ShaE </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ImsaGY </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ImsaGY </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
</tbody>
</table>
The 1st cluster corresponds to series from the SoutWestern Europe, whatever the period. Cluster 2 corresponds to North Europe. Cluster 2 and 3 correspond to series in Great Britain or Germany, 4 to Ireland and 5 to Norway. These results confirm the spatial pattern in recruitment seasonality and highlight that no major changes have occured after 2010.

Showing it on a map:


```r
library(sf)
myclassif$x <- ser2$ser_x[match(myclassif$ser, ser2$ser_nameshort)]
myclassif$jit_x <- jitter(myclassif$x,amount=.5)
myclassif$y <- ser2$ser_y[match(myclassif$ser, ser2$ser_nameshort)]
myclassif$jit_y <- jitter(myclassif$y,amount=.5)
ggplot(data = cou) +  geom_sf(fill= "antiquewhite") +
		geom_point(data=myclassif,size=5,
		           aes(x=jit_x,y=jit_y,col=as.factor(cluster),pch=period)) +
  geom_segment(data=myclassif,
            aes(x=x,y=y,xend=jit_x,yend=jit_y,col=as.factor(cluster)))+
  scale_color_manual(values=cols) +theme_igray() +xlim(-20,30) + ylim(35,65)+
  xlab("")+ylab("")+labs(colour="cluster")
```

![](jags_modelling_monitoring_files/figure-html/unnamed-chunk-17-1.png)<!-- -->


## Exporting pattern per group

```r
tmp <- as.matrix(as.mcmc.list(myfit_recruitment))
name_col = colnames(tmp)

pattern_G_monitoring=do.call("rbind.data.frame",
                            lapply(seq_len(length(levels(groups))), function(g){
                              ser=substr(group_name[g],1,nchar(group_name[g])-2)
                              emu=ser2$ser_emu_nameshort[ser2$ser_nameshort == ser]
                              hty_code=ser2$ser_hty_code[ser2$ser_nameshort==ser]
                              median_pattern_group_monitoring(g, emu ,tmp, "G",group_name[g], hty_code)
                            }))
save(pattern_G_monitoring,file="pattern_G_monitoring.rdata")
```

## Similarity between and after 2010

```r
#which groups have data in both periods
occ=table(unique(recruitment_wide[,c("ser_nameshort", "period")])[,1])
tocompare=names(occ)[which(occ>1)]

simi=sapply(tocompare, function(s){
  g=grep(s,group_name)
  esp1=tmp[,grep(paste("alpha_group\\[",g[1],",",sep=""),name_col)]
  esp2=tmp[,grep(paste("alpha_group\\[",g[2],",",sep=""),name_col)]
  quantile(apply(cbind(esp1,esp2),
                 1,
                 function(x) sum(pmin(x[1:12],x[13:24]))),
           probs=c(0.025,.5,.975))
})

similarity=data.frame(emu=tocompare,t(simi))

table_similarity(similarity)
```

<table>
<caption>similarity</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> EMU </th>
   <th style="text-align:right;"> q2.5% </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> q97.5% </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> GiSc </td>
   <td style="text-align:right;"> 0.80 </td>
   <td style="text-align:right;"> 0.88 </td>
   <td style="text-align:right;"> 0.94 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Grey </td>
   <td style="text-align:right;"> 0.55 </td>
   <td style="text-align:right;"> 0.71 </td>
   <td style="text-align:right;"> 0.85 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ImsaGY </td>
   <td style="text-align:right;"> 0.89 </td>
   <td style="text-align:right;"> 0.93 </td>
   <td style="text-align:right;"> 0.96 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oria </td>
   <td style="text-align:right;"> 0.53 </td>
   <td style="text-align:right;"> 0.71 </td>
   <td style="text-align:right;"> 0.86 </td>
  </tr>
</tbody>
</table>


# Silver eel
## Data availability
There are 87 pure silver eel dataseries, this has several consequences:
* Given the high number of time series, we will only focus one pure silver eels data series and neglect YS data series (except if a data provider clearly tells us that we can add this data)
* We have to develop criterion to quickly check the reliability of the data and makes a quick sorting of the data.


##Data correction

Some corrections of errors found in the database

```r
###wrong year for BurS time series (january 1972 instead of 1973)

## corrected by Cedric directly in original files
# res$das_year[res$ser_nameshort == "BurS" &
#                       res$das_year == 1972 &
#                       res$das_month == 1 &
#                       res$das_value ==95 ] <- 1973
# 
# #for MajT, year 1987 is missing while there are duplicates for year 1989 
# res$das_year[res$ser_nameshort == "MajT" &
#                res$das_year == 1989 &
#                res$das_month == 11 &
#                res$das_value==1] <- 1987
# res$das_year[which(res$ser_nameshort == "MajT" &
#                res$das_year == 1989 &
#                res$das_month == 10 &
#                res$das_value==1)[1]] <- 1987
# res$das_year[res$ser_nameshort == "MajT" &
#                res$das_year == 1989 &
#                res$das_month < 10 &
#                res$das_month >5 ] <- 1987
# res$das_year[res$ser_nameshort == "MajT" &
#                res$das_year == 1989 &
#                res$das_month == 5 &
#                res$das_value==7] <- 1987
# #same series: confusion between 1991 and 1994
# res$das_year[res$ser_nameshort == "MajT" &
#                res$das_year == 1994 &
#                res$das_month == 5 &
#                res$das_value == 3] <- 1991
# res$das_year[res$ser_nameshort == "MajT" &
#                res$das_year == 1994 &
#                res$das_month == 11 &
#                res$das_value == 1] <- 1991
# 
# ###For Scorf, there are two data in June, we sum the two points
# scorf <- res %>%
#   filter(ser_nameshort == "ScorS", das_month == 6) %>%
#   group_by_at(vars(-one_of("das_value"))) %>%
#   summarise(das_value=sum(das_value))
# 
# res <- bind_rows(
#   res %>%
#   filter(res$ser_nameshort != "ScorS" | res$das_month != 6),
#   scorf)
# 
# ##Souston year typo
# res$das_year[res$ser_nameshort == "SouS" &
#                res$das_year == 2018 &
#                res$das_month == 12 &
#                res$das_value == 6060] <- 2017
  

#for WarS, data are separated in males and females, we merge both dataset
table(res$das_month[res$ser_nameshort == "WarS"],
      res$das_year[res$ser_nameshort == "WarS"])
```

```
##     
##      2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
##   1     2    2    2    2    2    2    2    2    2    2    2
##   2     2    2    2    2    2    2    2    2    2    2    2
##   3     2    2    2    2    2    2    2    2    2    2    2
##   4     2    2    2    2    2    2    2    2    2    2    2
##   5     2    2    2    2    2    2    2    2    2    2    2
##   6     2    2    2    2    2    2    2    2    2    2    2
##   7     2    2    2    2    2    2    2    2    2    2    2
##   8     2    2    2    2    2    2    2    2    2    2    2
##   9     2    2    2    2    2    2    2    2    2    2    2
##   10    2    2    2    2    2    2    2    2    2    2    2
##   11    2    2    2    2    2    2    2    2    2    2    2
##   12    3    1    2    2    2    2    2    2    2    2    2
```

```r
WarS <- res %>%
   filter(ser_nameshort == "WarS", !is.na(das_effort)) %>%
   group_by_at(vars(-one_of(c("das_comment","das_value")))) %>%
   summarise(das_value=sum(das_value))
 
res <- bind_rows(
   res %>%
   filter(res$ser_nameshort != "WarS"),
   WarS)
```

## Data selection
As for glass eel, we start by defining season consistent with ecological knowledge on migration. Downstream runs of European silver eels typically start in the autumn and may last until early spring (Brujs and Durif 2009), but we saw during WGEEL 2019 that peak in silver catches in Sweden is centered around August/September. Therefore, it is difficult to split season of migration in a similar way for all Europe. Therefore, we define a season of migration per series: we look to the month corresponding to the peak and at the month with the lowest catches. The month with lowest catch fmin define the beggining of the season (month_in_season=1) and season y stands for the 12 months from fmin y (e.g., if lowest migration is in december, season ranges from december to november, and season y denotes season from december y to november y+1).

```r
#creating season
#finding_peak

#finding_lowest_month


#season_creation

silvereel <- do.call("rbind.data.frame",
                     lapply(ser2$ser_nameshort[ser2$ser_lfs_code=="S"],
                            function(s)
                              season_creation(res[res$ser_nameshort==s,])))
months_peak_per_series<- unique(silvereel[,c("ser_nameshort","peak_month")])
names(silvereel)[which(names(silvereel)=="country")]<-"cou_code"
kable(table(months_peak_per_series$peak_month),
      col.names=c("month","number of series"),
      caption="number of series peaking in a given month")
```

<table>
<caption>number of series peaking in a given month</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> month </th>
   <th style="text-align:right;"> number of series </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:right;"> 12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:right;"> 32 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:right;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:right;"> 12 </td>
  </tr>
</tbody>
</table>

This confirms that most series peak in autumn, but that other peak in spring or summer.



## Building diagnostics of quality for series

```r
#to be considered as valid, we need:
#   at least 8 months including the peak (since there are often two peaks, one
#   in spring and one in autumn)
#   that the first month of data generally stands for a small proportion of catches
#   that the last month of data generally stands for a small proportion of catches
#   that there is no missing month between first and last month

#good_coverage_wave 
#checking_duplicate 
```


The previous function looks at different criterion: it put the data in the wide format and check if we have at least 3 months around the peak.  Moreover, it seeks for two extreme months when the cumulative catch is below 10%. If there is now missing month between these two extreme months, the season is kept. Using this function, we can make a preliminary screening of available series.


```r
kept_seasons <- lapply(unique(silvereel$ser_nameshort), function(s){
  sub_silver <- subset(silvereel, silvereel$ser_nameshort==s)
  good_coverage_wave(sub_silver)
})
```

```
## [1] "For AlsT not possible to define a season"
## [1] "For AtrT not possible to define a season"
## [1] "For  BadB  a good season should cover months: 4 to 10"
## [1] "For  BurS  a good season should cover months: 8 to 12"
## [1] "For  DaugS  a good season should cover months: 4 to 9"
## [1] "For  ErneS  a good season should cover months: 8 to 1"
## [1] "For ForT not possible to define a season"
## [1] "For  GirB  a good season should cover months: 5 to 11"
## [1] "For GraT not possible to define a season"
## [1] "For HauT not possible to define a season"
## [1] "For  hv1T  a good season should cover months: 9 to 3"
## [1] "For  hv2T  a good season should cover months: 9 to 3"
## [1] "For  hv3T  a good season should cover months: 9 to 3"
## [1] "For  hv4T  a good season should cover months: 9 to 3"
## [1] "For  hv5T  a good season should cover months: 9 to 3"
## [1] "For  hv6T  a good season should cover months: 9 to 3"
## [1] "For  hv7T  a good season should cover months: 9 to 3"
## [1] "For ij10T not possible to define a season"
## [1] "For ij11T not possible to define a season"
## [1] "For ij12T not possible to define a season"
## [1] "For ij1T not possible to define a season"
## [1] "For ij2T not possible to define a season"
## [1] "For ij3T not possible to define a season"
## [1] "For ij4T not possible to define a season"
## [1] "For ij5T not possible to define a season"
## [1] "For ij6T not possible to define a season"
## [1] "For ij7T not possible to define a season"
## [1] "For ij8T not possible to define a season"
## [1] "For ij9T not possible to define a season"
## [1] "For  ImsaS  a good season should cover months: 8 to 12"
## [1] "For  KauT  a good season should cover months: 3 to 10"
## [1] "For  KavT  a good season should cover months: 12 to 10"
## [1] "For LevS not possible to define a season"
## [1] "For  LilS  a good season should cover months: 7 to 6"
## [1] "For  MajT  a good season should cover months: 3 to 11"
## [1] "For NeaS not possible to define a season"
## [1] "For  nw10T  a good season should cover months: 9 to 3"
## [1] "For nw1T not possible to define a season"
## [1] "For nw2T not possible to define a season"
## [1] "For nw3T not possible to define a season"
## [1] "For nw4T not possible to define a season"
## [1] "For nw5T not possible to define a season"
## [1] "For nw6T not possible to define a season"
## [1] "For nw7T not possible to define a season"
## [1] "For nw8T not possible to define a season"
## [1] "For nw9T not possible to define a season"
## [1] "For NydT not possible to define a season"
## [1] "For  nz1T  a good season should cover months: 10 to 5"
## [1] "For  nz2T  a good season should cover months: 10 to 3"
## [1] "For  nz3T  a good season should cover months: 10 to 3"
## [1] "For  nz4Y  a good season should cover months: 10 to 5"
## [1] "For  nz5T  a good season should cover months: 10 to 5"
## [1] "For  OirS  a good season should cover months: 7 to 2"
## [1] "For OnkT not possible to define a season"
## [1] "For OstT not possible to define a season"
## [1] "For rij10T not possible to define a season"
## [1] "For rij1T not possible to define a season"
## [1] "For rij2T not possible to define a season"
## [1] "For rij3T not possible to define a season"
## [1] "For rij4T not possible to define a season"
## [1] "For rij5T not possible to define a season"
## [1] "For rij6T not possible to define a season"
## [1] "For rij7T not possible to define a season"
## [1] "For rij8T not possible to define a season"
## [1] "For rij9T not possible to define a season"
## [1] "For RuuT not possible to define a season"
## [1] "For  ScorS  a good season should cover months: 5 to 2"
## [1] "For  SevNS  a good season should cover months: 6 to 3"
## [1] "For ShaKilS not possible to define a season"
## [1] "For  Shie  a good season should cover months: 8 to 11"
## [1] "For  SkaT  a good season should cover months: 6 to 11"
## [1] "For  SomS  a good season should cover months: 9 to 4"
## [1] "For  SouS  a good season should cover months: 10 to 2"
## [1] "For  UShaS  a good season should cover months: 8 to 1"
## [1] "For  VaaT  a good season should cover months: 9 to 6"
## [1] "For VesT not possible to define a season"
## [1] "For VilS not possible to define a season"
## [1] "For  WarS  a good season should cover months: 4 to 12"
## [1] "For zm not possible to define a season"
## [1] "For zm10T not possible to define a season"
## [1] "For zm1T not possible to define a season"
## [1] "For zm2T not possible to define a season"
## [1] "For zm3T not possible to define a season"
## [1] "For zm5T not possible to define a season"
## [1] "For zm6T not possible to define a season"
## [1] "For zm7T not possible to define a season"
## [1] "For zm8T not possible to define a season"
## [1] "For zm9T not possible to define a season"
```

Finally, here are the series kept given previous criterion.

```r
names(kept_seasons) <- unique(silvereel$ser_nameshort)
#we removeDaugS since the number of caught eel is too limited to work on
#seaonality (4, 0 , 8 from 2017 to 2019)
#kept_seasons[["DaugS"]] <- NULL

kept_seasons[!sapply(kept_seasons,is.null)]
```

```
## $BadB
##  [1] 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016
## [15] 2017 2018 2019
## 
## $BurS
##  [1] 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983
## [15] 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997
## [29] 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011
## [43] 2012 2013 2014 2015 2016 2017 2018
## 
## $DaugS
## [1] 2017 2018 2019
## 
## $ErneS
## [1] 2014
## 
## $GirB
##  [1] 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016
## [15] 2017 2018 2019
## 
## $ImsaS
##  [1] 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013
## [15] 2014 2015 2016 2017 2018 2019
## 
## $KauT
## [1] 1984
## 
## $OirS
##  [1] 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013
## [15] 2014 2015 2016 2017 2018
## 
## $ScorS
##  [1] 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013
## [15] 2014 2015 2016 2017 2018
## 
## $Shie
##  [1] 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015
## [15] 2016 2017 2018 2019
## 
## $SomS
## [1] 2015
## 
## $SouS
## [1] 2012 2013 2014 2015 2016 2017 2018
## 
## $UShaS
## [1] 2011
## 
## $WarS
## [1] 2009 2011 2013 2015 2016 2019
```

## Data preparation
To run the model, we need a table in the wide format: one column per month, one row for a year x time series. 


```r
silvereel_subset <- subset(silvereel, 
                           mapply(function(season, series){
                             season %in% kept_seasons[[series]]
                           }, silvereel$season, silvereel$ser_nameshort))

silvereel_subset$emu <- ser2$ser_emu_nameshort[match(silvereel_subset$ser_nameshort,
                                                       ser2$ser_nameshort)]

silvereel_wide <- pivot_wider(data=silvereel_subset[, c("ser_nameshort",
                                                            "emu",
                                                     "cou_code",
                                                     "season",
                                                     "das_month",
                                                     "das_value")],
                                names_from="das_month",
                                values_from="das_value")
names(silvereel_wide)[-(1:4)] <- paste("m",
                                       names(silvereel_wide)[-(1:4)],
                                       sep="")
```

It leads to a dataset with 179 rows. Since seasons are not comparable among series, we keep calendar months (eg: 12 for decembre, not month in season), while rows indeed correspond to seasons.


We now replace NA value per zero since we selected our dataseries with missing months corresponding to insignificant months, and we compute proportions per month for each year.


```r
silvereel_wide <- silvereel_wide %>%
  replace_na(replace=list(m1=0,
                          m2=0,
                          m3=0,
                          m4=0,
                          m5=0,
                          m6=0,
                          m7=0,
                          m8=0,
                          m9=0,
                          m10=0,
                          m11=0,
                          m12=0))
silvereel_wide[, -(1:4)] <- silvereel_wide[, -(1:4)] + 1e-3
total_catch_year <- rowSums(silvereel_wide[, paste("m", 1:12, sep="")])
silvereel_wide <- silvereel_wide %>%
  mutate_at(.vars=paste("m",1:12,sep=""),function(x) x/total_catch_year)
```

The Commission asks us to compare the pattern before and after 2007, probably to see the effect of the Eel Regulation. It is therefore necessary to build a period index. However, since most countries implemented their EMPs only in 2009/2010, we split in 2010.


```r
silvereel_wide$period <- ifelse(silvereel_wide$season>2009,
                                  2,
                                  1)

kable(table(silvereel_wide$period,
       silvereel_wide$ser_nameshort),
      row.names=TRUE,
      caption="number of seasons per EMU and series")
```

<table>
<caption>number of seasons per EMU and series</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> BadB </th>
   <th style="text-align:right;"> BurS </th>
   <th style="text-align:right;"> DaugS </th>
   <th style="text-align:right;"> ErneS </th>
   <th style="text-align:right;"> GirB </th>
   <th style="text-align:right;"> ImsaS </th>
   <th style="text-align:right;"> KauT </th>
   <th style="text-align:right;"> OirS </th>
   <th style="text-align:right;"> ScorS </th>
   <th style="text-align:right;"> Shie </th>
   <th style="text-align:right;"> SomS </th>
   <th style="text-align:right;"> SouS </th>
   <th style="text-align:right;"> UShaS </th>
   <th style="text-align:right;"> WarS </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 40 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
</tbody>
</table>

The situation is better for silver eel than for glass eel, we have a good sets of time series with data both before and after 2009.


## Running the model

```r
group <- as.integer(interaction(silvereel_wide$ser_nameshort,
                                            silvereel_wide$period,
                                            drop=TRUE))
nb_occ_group <- table(group)
y <-as.matrix(silvereel_wide[, paste("m", 1:12, sep="")])
```

Know, we make a loop to select the number of clusters based on a DIC criterion


```r
cl <- makeCluster(3, 'FORK')
comparison <- parSapply(cl, 2:7,
       function(nbclus){
         mydata <- build_data(nbclus)
         adapted <- FALSE
         while (!adapted){
           tryCatch({
             runjags.options(adapt.incomplete="error")
             res <- run.jags("jags_model.txt", monitor= c("deviance",
                                                          "alpha_group",
                                                          "cluster"),
                        summarise=FALSE, adapt=40000, method="parallel",
                        sample=2000,burnin=100000,n.chains=1,
                        inits=generate_init(nbclus, mydata)[[1]],
                        data=mydata)
                        adapted <- TRUE
                        res_mat <- as.matrix(as.mcmc.list(res))
                        silhouette <- median(compute_silhouette(res_mat))
                        nbused <- apply(res_mat, 1, function(iter){
                          length(table(iter[grep("cluster",
                                                 names(iter))]))
                        })
                        dic <- mean(res_mat[,1])+0.5*var(res_mat[,1])
                        stats <- c(dic,silhouette,mean(nbused))
                  }, error=function(e) {
                    print(paste("not adapted, restarting nbclus",nbclus))
                    }
                  )
         }
         stats
      })
stopCluster(cl)


best_silver <- data.frame(nbclus=2:(ncol(comparison)+1),
                                              dic=comparison[1, ],
                                              silhouette=comparison[2, ],
                                     used=comparison[3,])
```


```r
load("silver_jags.rdata")
best_silver
```

```
##   nbclus       dic silhouette used
## 1      2 -32617.22  0.2485696    2
## 2      3 -25171.98  0.2768340    3
## 3      4 -33508.56  0.1733660    4
## 4      5 -33299.76  0.2073327    5
## 5      6 -34036.44  0.2594315    6
## 6      7 -34138.16  0.2291540    7
```

6 clusters provide a godd DIC and silhouette, and all clusters are used


```r
nbclus <- 6
mydata <-build_data(6)


adapted <- FALSE
while (!adapted){
   tryCatch({
      runjags.options(adapt.incomplete="error")
      myfit_silver <- run.jags("jags_model.txt", monitor= c("cluster", "esp", "alpha_group",
                                            "cluster", "centroid",
                                            "centroid_group",
                                            "distToClust", "duration_clus",
                                            "duration_group",
                                            "lambda","id_cluster",
                                            "centroid"),
                      summarise=FALSE, adapt=20000, method="parallel",
                      sample=10000,burnin=200000,n.chains=1, thin=5,
                      inits=generate_init(nbclus, mydata)[[1]], data=mydata)
      adapted <- TRUE
    }, error=function(e) {
       print(paste("not adapted, restarting nbclus",nbclus))
    })
}

save(myfit_silver, best_silver,
     file="silver_jags.rdata")
```

##Results
Once we fitted, we can plot monthly pattern per cluster

```r
load("silver_jags.rdata")
nbclus <- 6
mydata <-build_data(6)
get_pattern_month <- function(res,type="cluster"){
  res_mat <- as.matrix(as.mcmc.list(res))
  if (type=="cluster"){
    sub_mat <- as.data.frame(res_mat[,grep("esp",colnames(res_mat))])
  }
  sub_mat <- sub_mat %>% 
    pivot_longer(cols=1:ncol(sub_mat),
                 names_to="param",
                 values_to="proportion")
  tmp <- lapply(as.character(sub_mat$param),function(p) strsplit(p,"[[:punct:]]"))
  sub_mat$cluster<-as.factor(
    as.integer(lapply(tmp, function(tt) tt[[1]][2])))
  sub_mat$month <- as.character(lapply(tmp,
                                       function(tt) paste("m",
                                                          tt[[1]][3],
                                                          sep="")))
  sub_mat$month <- factor(sub_mat$month, levels=paste("m", 1:12, sep=""))
  sub_mat
}

pat=get_pattern_month(myfit_silver)
clus_order=c("1", "3", "4", "5", "6","2")
pat$cluster=factor(match(pat$cluster,clus_order),
                   levels=as.character(1:7))
ggplot(pat,aes(x=month,y=proportion))+
  geom_boxplot(aes(fill=cluster),outlier.shape=NA) +
  scale_fill_manual(values=cols)+facet_wrap(.~cluster, ncol=1)+
  theme_igray()
```

![](jags_modelling_monitoring_files/figure-html/unnamed-chunk-32-1.png)<!-- -->
We have 6 clusters. Many of them display migration in both spring and autum, while a few of them peak in summer.


```r
table_characteristics(myfit_silver, 6,clus_order)
```

<table>
<caption>characteristics of clusters</caption>
 <thead>
<tr>
<th style="border-bottom:hidden" colspan="1"></th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="3"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">number of months to reach 80% of total</div></th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="3"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">month of centroid</div></th>
</tr>
  <tr>
   <th style="text-align:right;"> cluster </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> q2.5% </th>
   <th style="text-align:right;"> q97.5% </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> q2.5% </th>
   <th style="text-align:right;"> q97.5% </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 7.63 </td>
   <td style="text-align:right;"> 7.21 </td>
   <td style="text-align:right;"> 8.01 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 6.56 </td>
   <td style="text-align:right;"> 6.21 </td>
   <td style="text-align:right;"> 6.96 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 6.32 </td>
   <td style="text-align:right;"> 5.99 </td>
   <td style="text-align:right;"> 6.70 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 8.27 </td>
   <td style="text-align:right;"> 8.18 </td>
   <td style="text-align:right;"> 8.36 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 9.92 </td>
   <td style="text-align:right;"> 9.88 </td>
   <td style="text-align:right;"> 9.97 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 11.17 </td>
   <td style="text-align:right;"> 11.08 </td>
   <td style="text-align:right;"> 11.26 </td>
  </tr>
</tbody>
</table>

We can look at the belonging of the different groups.

```r
groups <- interaction(silvereel_wide$ser_nameshort,
                                            silvereel_wide$period,
                                            drop=TRUE)
group_name <- levels(groups)


get_pattern_month <- function(res,mydata){
  
  tmp <- strsplit(as.character(group_name),
                  "\\.")
  ser <- as.character(lapply(tmp,function(tt){
    tt[1]
  }))
  country <- ser2$ser_cou_code[match(ser, ser2$ser_nameshort)]
  period <- as.character(lapply(tmp,function(tt){
    tt[2]
  }))
  res_mat <- as.matrix(as.mcmc.list(res))
  
  clus <- t(sapply(seq_len(length(unique(groups))), function(id){
    name_col <- paste("cluster[",id,"]",sep="")
    freq <- table(res_mat[,name_col])
    max_class <- names(freq)[order(freq,decreasing=TRUE)[1]]
    c(max_class,freq[as.character(1:nbclus)])
  }))
  storage.mode(clus) <- "numeric"
  classes <- as.data.frame(clus)
  names(classes) <- c("cluster", paste("clus",1:nbclus,sep=""))
  cbind.data.frame(data.frame(ser=ser, period=period, country=country),
                   classes)
}

myclassif_silver <- get_pattern_month(myfit_silver)
col_toreorder=grep("clus[0-9]",names(myclassif_silver))
names(myclassif_silver)[col_toreorder]=paste("clus",
                                      match(paste("clus",1:nbclus,sep=""),
                                      paste("clus",clus_order,sep="")),
                                      sep="")
myclassif_silver[,col_toreorder] <- myclassif_silver%>%
  select(col_toreorder)%>%select(sort(names(.)))
myclassif_silver$cluster=factor(match(myclassif_silver$cluster,clus_order),
                   levels=as.character(1:7))

table_classif(myclassif_silver, "series")
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> series </th>
   <th style="text-align:left;"> period </th>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> Max cluster </th>
   <th style="text-align:right;"> % clus 1 </th>
   <th style="text-align:right;"> % clus 2 </th>
   <th style="text-align:right;"> % clus 3 </th>
   <th style="text-align:right;"> % clus 4 </th>
   <th style="text-align:right;"> % clus 5 </th>
   <th style="text-align:right;"> % clus 6 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> BadB </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WarS </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WarS </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> KauT </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> FI </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DaugS </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> LV </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GirB </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BadB </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GirB </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OirS </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OirS </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Shie </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Shie </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BurS </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BurS </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> UShaS </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 90 </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ImsaS </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ImsaS </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ScorS </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ScorS </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SomS </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SouS </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ErneS </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> IE </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
</tbody>
</table>
The spatial pattern is a bit less obvious than for glass eel. However, looking at the map, we see that clusters 6 and  5, which display similar seasonality, are more located on the Western coasts of Europe (with most cluster 6 in the south, and most clusters 5 in the north). Cluster 2 is more typical of the Baltic Sea and clusster 4 from eastern Scotland.


```r
library(sf)
myclassif_silver$x <- ser2$ser_x[match(myclassif_silver$ser, ser2$ser_nameshort)]
myclassif_silver$jit_x <- jitter(myclassif_silver$x,amount=.5)
myclassif_silver$y <- ser2$ser_y[match(myclassif_silver$ser, ser2$ser_nameshort)]
myclassif_silver$jit_y <- jitter(myclassif_silver$y,amount=.5)
ggplot(data = cou) +  geom_sf(fill= "antiquewhite") +
		geom_point(data=myclassif_silver,size=5,
		           aes(x=jit_x,y=jit_y,col=as.factor(cluster),pch=period)) +
  geom_segment(data=myclassif_silver,
            aes(x=x,y=y,xend=jit_x,yend=jit_y,col=as.factor(cluster)))+
  scale_colour_manual(values=cols) +theme_igray() +xlim(-20,30) + ylim(35,65)+
  xlab("")+ylab("")+labs(colour="cluster")
```

![](jags_modelling_monitoring_files/figure-html/unnamed-chunk-35-1.png)<!-- -->




## Exporting pattern per group

```r
tmp <- as.matrix(as.mcmc.list(myfit_silver))
name_col = colnames(tmp)

pattern_S_monitoring=do.call("rbind.data.frame",
                            lapply(seq_len(length(levels(groups))), function(g){
                              ser=substr(group_name[g],1,nchar(group_name[g])-2)
                              emu=ser2$ser_emu_nameshort[ser2$ser_nameshort == ser]
                              hty_code=ser2$ser_hty_code[ser2$ser_nameshort==ser]
                              median_pattern_group_monitoring(g, emu ,tmp, "S",group_name[g], hty_code)
                            }))
save(pattern_S_monitoring,file="pattern_S_monitoring.rdata")
```

## Similarity between and after 2010

```r
#which groups have data in both periods
occ=table(unique(silvereel_wide[,c("ser_nameshort", "period")])[,1])
tocompare=names(occ)[which(occ>1)]

simi=sapply(tocompare, function(s){
  g=grep(s,group_name)
  esp1=tmp[,grep(paste("alpha_group\\[",g[1],",",sep=""),name_col)]
  esp2=tmp[,grep(paste("alpha_group\\[",g[2],",",sep=""),name_col)]
  quantile(apply(cbind(esp1,esp2),
                 1,
                 function(x) sum(pmin(x[1:12],x[13:24]))),
           probs=c(0.025,.5,.975))
})

similarity=data.frame(emu=tocompare,t(simi))

table_similarity(similarity)
```

<table>
<caption>similarity</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> EMU </th>
   <th style="text-align:right;"> q2.5% </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> q97.5% </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> BadB </td>
   <td style="text-align:right;"> 0.50 </td>
   <td style="text-align:right;"> 0.59 </td>
   <td style="text-align:right;"> 0.68 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BurS </td>
   <td style="text-align:right;"> 0.74 </td>
   <td style="text-align:right;"> 0.82 </td>
   <td style="text-align:right;"> 0.89 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GirB </td>
   <td style="text-align:right;"> 0.70 </td>
   <td style="text-align:right;"> 0.79 </td>
   <td style="text-align:right;"> 0.87 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ImsaS </td>
   <td style="text-align:right;"> 0.81 </td>
   <td style="text-align:right;"> 0.89 </td>
   <td style="text-align:right;"> 0.95 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OirS </td>
   <td style="text-align:right;"> 0.56 </td>
   <td style="text-align:right;"> 0.65 </td>
   <td style="text-align:right;"> 0.73 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ScorS </td>
   <td style="text-align:right;"> 0.65 </td>
   <td style="text-align:right;"> 0.74 </td>
   <td style="text-align:right;"> 0.84 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Shie </td>
   <td style="text-align:right;"> 0.82 </td>
   <td style="text-align:right;"> 0.90 </td>
   <td style="text-align:right;"> 0.94 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WarS </td>
   <td style="text-align:right;"> 0.57 </td>
   <td style="text-align:right;"> 0.71 </td>
   <td style="text-align:right;"> 0.84 </td>
  </tr>
</tbody>
</table>


# Yellow eel
## Data availability
There are 32 time series, i.e. more than for glass eels but less than for silver eels. It may be worthwile pooling some of the 6 YS series if the proportions of silver eels is not too important.


```r
kable(ser2[ser2$ser_lfs_code=="YS", c("ser_nameshort", "ser_emu_nameshort", "ser_comment", "ser_locationdescription")],row.names=FALSE)
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> ser_nameshort </th>
   <th style="text-align:left;"> ser_emu_nameshort </th>
   <th style="text-align:left;"> ser_comment </th>
   <th style="text-align:left;"> ser_locationdescription </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> ALA </td>
   <td style="text-align:left;"> LT_Lith </td>
   <td style="text-align:left;"> YS mixture  Fishing trap in the river Alausa </td>
   <td style="text-align:left;"> the river Alausa flows out of the lake Alausas (1077 ha). </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GVT </td>
   <td style="text-align:left;"> LT_Lith </td>
   <td style="text-align:left;"> YS mixture  Fishing trap in the river between lakes Galuonai and Vašuokas </td>
   <td style="text-align:left;"> Data colection program, data from commercial fishery fishing alowded 2 month in the river place </td>
  </tr>
  <tr>
   <td style="text-align:left;"> KER </td>
   <td style="text-align:left;"> LT_Lith </td>
   <td style="text-align:left;"> YS mixture  Fishing trap in the river Kertuoja </td>
   <td style="text-align:left;"> the river Kertuoja flows out of the lake Kertuojai (545 ha). </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LakT </td>
   <td style="text-align:left;"> LT_Lith </td>
   <td style="text-align:left;"> YS mixture  Fishing trap in the river Lakaja </td>
   <td style="text-align:left;"> Far inland River length 29.1 km;
Slope 39 cm / km.;
river basin area 432 km²; Monitoring place 8 month per year.
Average flow rate 4.11 m³ /s.;
Origin Lake Black Lakajai;
The mouth flows into the river Žeimena Baltic region. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sakt </td>
   <td style="text-align:left;"> LT_Lith </td>
   <td style="text-align:left;"> YS mixture  Fishing trap in the river Šakarva </td>
   <td style="text-align:left;"> Data colection program, data from commercial fishery fishing alowded 2 month in the river place </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ZeiT </td>
   <td style="text-align:left;"> LT_Lith </td>
   <td style="text-align:left;"> YS mixture  Fishing trap in the river Žeimena </td>
   <td style="text-align:left;"> Data colection program, data from commercial fishery fishing alowded 2 month per year in the river place </td>
  </tr>
</tbody>
</table>
GVT, Sakt and ZeiT are fishery based and fishery takes place only 2 months per year so we can't keep the data.


```r
table(res$das_year[res$ser_nameshort %in% c('ALA', 'LakT', 'KER')],
      res$das_month[res$ser_nameshort %in% c('ALA', 'LakT', 'KER')],
      res$ser_nameshort[res$ser_nameshort %in% c('ALA', 'LakT', 'KER')])
```

```
## , ,  = ALA
## 
##       
##        1 2 3 4 5 6 7 8 9 10 11 12
##   2017 0 0 0 0 0 0 0 0 0  0  0  0
##   2018 0 0 0 0 0 0 0 0 0  0  0  0
##   2019 0 0 0 0 0 0 0 0 0  1  0  0
## 
## , ,  = KER
## 
##       
##        1 2 3 4 5 6 7 8 9 10 11 12
##   2017 0 0 0 0 0 0 0 0 0  0  0  0
##   2018 0 0 0 0 0 0 0 0 0  0  0  0
##   2019 0 0 0 0 0 0 0 0 0  1  0  0
## 
## , ,  = LakT
## 
##       
##        1 2 3 4 5 6 7 8 9 10 11 12
##   2017 1 1 1 1 1 1 1 1 1  1  1  1
##   2018 1 1 1 1 1 1 1 1 1  1  1  1
##   2019 1 1 1 1 1 1 1 1 1  1  1  1
```
For ALA and KER, we only have one month of data, so we do not keep the data. LakT is a good candidate, however, it is noted that there are 8 months of monitoring per year while in the data, we have more data missing, therefore it is currently not possible to know whether a missing data stands for zero or no data. Moreover, looking at comment, it seems to correspond to migrating eels, i.e. an important proportion of silver eels. Therefore, we discard also this data series.

##Data correction
We have found some errors in series "MorE" and "VaccY" but don't know how to fix the mystakes, so currently, we remove them from our selection.

## Data selection
As for other stages, we start by defining season consistent with ecological knowledge on migration. However, there is no migration for yellow eels and peaks in data correspond more to seasonal a peak in activity. We have few information on the seasonality of yellow eels, therefore, similarly to silver eel, it is difficult to split season of migration in a similar way for all Europe. Therefore, we define a season of migration per series using the same procedure as for silver eels: the month with lowest activity fmin define the beggining of the season (month_in_season=1) and season y stands for the 12 months from fmin y (e.g., if lowest activity is in december, season ranges from december to november, and season y denotes season from december y to november y+1). 


```r
yelloweel <- do.call("rbind.data.frame",
                     lapply(ser2$ser_nameshort[ser2$ser_lfs_code=="Y"],
                            function(s)
                              season_creation(res[res$ser_nameshort==s,])))
months_peak_per_series<- unique(yelloweel[,c("ser_nameshort","peak_month")])
names(yelloweel)[which(names(yelloweel)=="country")]<-"cou_code"

kable(table(months_peak_per_series$peak_month),
      col.names=c("month","number of series"),
      caption="number of series peaking in a given month")
```

<table>
<caption>number of series peaking in a given month</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> month </th>
   <th style="text-align:right;"> number of series </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
</tbody>
</table>
Peaks of activity range from may to november. It might be possible to define a common season from february/march to january/february, but we prefer not imposing it without more precise information.


## Building diagnostics of quality for series
We used the functions used for silver eels to assess whether a time series offer a good coverage of a season of activity (e.g. good_coverage_wave and check_duplicate). 


```r
kept_seasons <- lapply(unique(yelloweel$ser_nameshort[!yelloweel$ser_nameshort %in%c("MorE","VaccY")]), function(s){
  sub_yellow <- subset(yelloweel, yelloweel$ser_nameshort==s)
  good_coverage_wave(sub_yellow)
})
```

```
## [1] "For  AllE  a good season should cover months: 5 to 9"
## [1] "For AshE not possible to define a season"
## [1] "For BowE not possible to define a season"
## [1] "For  BroS  a good season should cover months: 4 to 9"
## [1] "For BurFe not possible to define a season"
## [1] "For BurFu not possible to define a season"
## [1] "For CraE not possible to define a season"
## [1] "For  DaugY  a good season should cover months: 4 to 10"
## [1] "For EmbE not possible to define a season"
## [1] "For  GarY  a good season should cover months: 5 to 8"
## [1] "For Girn not possible to define a season"
## [1] "For  Gud  a good season should cover months: 6 to 11"
## [1] "For HallE not possible to define a season"
## [1] "For LeaE not possible to define a season"
## [1] "For  LilY  a good season should cover months: 6 to 5"
## [1] "For LonE not possible to define a season"
## [1] "For  MarB_Y  a good season should cover months: 11 to 10"
## [1] "For MerE not possible to define a season"
## [1] "For MillE not possible to define a season"
## [1] "For MolE not possible to define a season"
## [1] "For NMilE not possible to define a season"
## [1] "For  OatY  a good season should cover months: 4 to 9"
## [1] "For  RhinY  a good season should cover months: 5 to 7"
## [1] "For RodE not possible to define a season"
## [1] "For ShaP not possible to define a season"
## [1] "For StGeY not possible to define a season"
## [1] "For StoE not possible to define a season"
## [1] "For  TedE  a good season should cover months: 4 to 10"
## [1] "For  VilY2  a good season should cover months: 1 to 11"
## [1] "For Vist not possible to define a season"
```

Finally, here are the series kept given previous criterion.

```r
names(kept_seasons) <- unique(yelloweel$ser_nameshort[!yelloweel$ser_nameshort %in%c("MorE","VaccY")])
kept_seasons[!sapply(kept_seasons,is.null)]
```

```
## $AllE
## [1] 2012 2013 2014 2015 2016 2017 2018 2019
## 
## $BroS
## [1] 2011 2012 2013 2014 2015 2016 2017 2018 2019
## 
## $DaugY
## [1] 2017 2018 2019
## 
## $GarY
##  [1] 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015
## [15] 2016 2017 2018 2019
## 
## $Gud
## [1] 2001 2003 2004
## 
## $OatY
## [1] 2013 2014 2015
## 
## $RhinY
##  [1] 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
## 
## $TedE
## [1] 2017
## 
## $VilY2
##  [1] 1999 2001 2002 2003 2004 2007 2008 2009 2010 2011 2012 2013 2014 2015
## [15] 2016 2017 2018
```
## Data preparation
We carry out the same procedure a for other stages. 


```r
yelloweel_subset <- subset(yelloweel, 
                           mapply(function(season, series){
                             season %in% kept_seasons[[series]]
                           }, yelloweel$season, yelloweel$ser_nameshort))

yelloweel_subset$emu <- ser2$ser_emu_nameshort[match(yelloweel_subset$ser_nameshort,
                                                       ser2$ser_nameshort)]

yelloweel_wide <- pivot_wider(data=yelloweel_subset[, c("ser_nameshort",
                                                            "emu",
                                                     "cou_code",
                                                     "season",
                                                     "das_month",
                                                     "das_value")],
                                names_from="das_month",
                                values_from="das_value")
names(yelloweel_wide)[-(1:4)] <- paste("m",
                                       names(yelloweel_wide)[-(1:4)],
                                       sep="")
###we count the number of zeros per lines to remove lines without enough
###fishes
data_poor <- data.frame(yelloweel_wide$ser_nameshort,
                        yelloweel_wide$season,
                  zero=rowSums(yelloweel_wide[, -(1:4)] == 0, na.rm=TRUE),
           tot=rowSums(yelloweel_wide[, -(1:4)], na.rm=TRUE))
table_datapoor(data_poor %>% filter(tot<100))
```

<table>
<caption>"data poor"" situation</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> EMU </th>
   <th style="text-align:right;"> season </th>
   <th style="text-align:right;"> number of zero </th>
   <th style="text-align:right;"> total catch </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> DaugY </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 14 </td>
  </tr>
</tbody>
</table>
Given the limited number of eels caught in DaugY in 2018, we remove this series.


```r
yelloweel_wide <- yelloweel_wide %>%
  filter(ser_nameshort != "DaugY" | season != 2018)
```

It leads to a dataset with 75 rows. Since seasons are not comparable among series, we keep traditional month (eg: 12 for decembre, not month in season), while rows indeed correspond to seasons.

We now replace NA value per zero since we selected our dataseries with missing months corresponding to insignificant months, and we compute proportions per month for each year.


```r
yelloweel_wide <- yelloweel_wide %>%
  replace_na(replace=list(m1=0,
                          m2=0,
                          m3=0,
                          m4=0,
                          m5=0,
                          m6=0,
                          m7=0,
                          m8=0,
                          m9=0,
                          m10=0,
                          m11=0,
                          m12=0))
yelloweel_wide[, -(1:4)] <- yelloweel_wide[, -(1:4)] + 1e-3
total_catch_year <- rowSums(yelloweel_wide[, paste("m", 1:12, sep="")])
yelloweel_wide <- yelloweel_wide %>%
  mutate_at(.vars=paste("m",1:12,sep=""),function(x) x/total_catch_year)
```

The Commission asks us to compare the pattern before and after 2007, probably to see the effect of the Eel Regulation. It is therefore necessary to build a period index. However, since most countries implemented their EMPs only in 2009/2010, we split in 2010.


```r
yelloweel_wide$period <- ifelse(yelloweel_wide$season>2009,
                                  2,
                                  1)

kable(table(yelloweel_wide$period,
       yelloweel_wide$ser_nameshort),
      row.names=TRUE,
      caption="number of seasons per series and period")
```

<table>
<caption>number of seasons per series and period</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> AllE </th>
   <th style="text-align:right;"> BroS </th>
   <th style="text-align:right;"> DaugY </th>
   <th style="text-align:right;"> GarY </th>
   <th style="text-align:right;"> Gud </th>
   <th style="text-align:right;"> OatY </th>
   <th style="text-align:right;"> RhinY </th>
   <th style="text-align:right;"> TedE </th>
   <th style="text-align:right;"> VilY2 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
</tbody>
</table>
The situation is an intermediate between glass eel and silver eel.


## Running the model

```r
group <- as.integer(interaction(yelloweel_wide$ser_nameshort,
                                            yelloweel_wide$period,
                                            drop=TRUE))
nb_occ_group <- table(group)
y <-as.matrix(yelloweel_wide[, paste("m", 1:12, sep="")])
```

Now, we make a loop to select the number of clusters based on a DIC criterion


```r
cl <- makeCluster(7, 'FORK')
comparison <- parSapply(cl, 2:7,
       function(nbclus){
         mydata <- build_data(nbclus)
         adapted <- FALSE
         while (!adapted){
           tryCatch({
             runjags.options(adapt.incomplete="error")
             res <- run.jags("jags_model.txt", monitor= c("deviance",
                                                          "alpha_group",
                                                          "cluster"),
                        summarise=FALSE, adapt=40000, method="parallel",
                        sample=2000,burnin=100000,n.chains=1,
                        inits=generate_init(nbclus, mydata)[[1]],
                        data=mydata)
                        adapted <- TRUE
                        res_mat <- as.matrix(as.mcmc.list(res))
                        silhouette <- median(compute_silhouette(res_mat))
                        nbused <- apply(res_mat, 1, function(iter){
                          length(table(iter[grep("cluster",
                                                 names(iter))]))
                        })
                        dic <- mean(res_mat[,1])+0.5*var(res_mat[,1])
                        stats <- c(dic,silhouette,mean(nbused))
                  }, error=function(e) {
                    print(paste("not adapted, restarting nbclus",nbclus))
                    }
                  )
         }
         stats
      })
stopCluster(cl)


best_yellow <- data.frame(nbclus=2:(ncol(comparison)+1),
                                              dic=comparison[1, ],
                                              silhouette=comparison[2, ],
                                              used=comparison[3, ])

save(best_yellow, file="yellow_jags.rdata")
```


```r
load("yellow_jags.rdata")
best_yellow
```

```
##   nbclus       dic silhouette used
## 1      2 -19385.21  0.1730357    2
## 2      3 -20047.01  0.3082806    3
## 3      4 -20189.05  0.3232710    4
## 4      5 -20284.06  0.1757271    5
## 5      6 -20362.54  0.1696675    5
## 6      7 -20313.50  0.3382333    5
```

4 appears to be a good compromise (good silhouette and all clusters are used).


```r
nbclus <- 4
mydata <-build_data(nbclus)




adapted <- FALSE
while (!adapted){
   tryCatch({
      runjags.options(adapt.incomplete="error")
      myfit_yellow <- run.jags("jags_model.txt", monitor= c("cluster", "esp", "alpha_group",
                                            "cluster", "centroid",
                                            "centroid_group",
                                            "distToClust", "duration_clus",
                                            "duration_group",
                                            "lambda","id_cluster",
                                            "centroid"),
                      summarise=FALSE, adapt=20000, method="parallel",
                      sample=10000,burnin=200000,n.chains=1, thin=5,
                      inits=generate_init(nbclus, mydata)[[1]], data=mydata)
      adapted <- TRUE
    }, error=function(e) {
       print(paste("not adapted, restarting nbclus",nbclus))
    })
}


save(myfit_yellow, best_yellow,
     file="yellow_jags.rdata")
```

## Results
Once fitted, we can plot monthly pattern per cluster

```r
load("yellow_jags.rdata")
nbclus <- 4
mydata <-build_data(nbclus)
get_pattern_month <- function(res,type="cluster"){
  res_mat <- as.matrix(as.mcmc.list(res))
  if (type=="cluster"){
    sub_mat <- as.data.frame(res_mat[,grep("esp",colnames(res_mat))])
  }
  sub_mat <- sub_mat %>% 
    pivot_longer(cols=1:ncol(sub_mat),
                 names_to="param",
                 values_to="proportion")
  tmp <- lapply(as.character(sub_mat$param),function(p) strsplit(p,"[[:punct:]]"))
  sub_mat$cluster<-as.factor(
    as.integer(lapply(tmp, function(tt) tt[[1]][2])))
  sub_mat$month <- as.character(lapply(tmp,
                                       function(tt) paste("m",
                                                          tt[[1]][3],
                                                          sep="")))
  sub_mat$month <- factor(sub_mat$month, levels=paste("m", 1:12, sep=""))
  sub_mat
}

pat=get_pattern_month(myfit_yellow)
clus_order=c("3","4","2","1")
pat$cluster=factor(match(pat$cluster,clus_order ),
                   levels=as.character(1:7))

ggplot(pat,aes(x=month,y=proportion))+
  geom_boxplot(aes(fill=cluster),outlier.shape=NA) +
  scale_fill_manual(values=cols)+facet_wrap(.~cluster, ncol=1)+
  theme_igray()
```

![](jags_modelling_monitoring_files/figure-html/unnamed-chunk-51-1.png)<!-- -->


```r
table_characteristics(myfit_yellow, 4, clus_order)
```

<table>
<caption>characteristics of clusters</caption>
 <thead>
<tr>
<th style="border-bottom:hidden" colspan="1"></th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="3"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">number of months to reach 80% of total</div></th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="3"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">month of centroid</div></th>
</tr>
  <tr>
   <th style="text-align:right;"> cluster </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> q2.5% </th>
   <th style="text-align:right;"> q97.5% </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> q2.5% </th>
   <th style="text-align:right;"> q97.5% </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 6.92 </td>
   <td style="text-align:right;"> 6.66 </td>
   <td style="text-align:right;"> 7.18 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 6.22 </td>
   <td style="text-align:right;"> 6.17 </td>
   <td style="text-align:right;"> 6.27 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 7.25 </td>
   <td style="text-align:right;"> 7.11 </td>
   <td style="text-align:right;"> 7.38 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 9.36 </td>
   <td style="text-align:right;"> 9.11 </td>
   <td style="text-align:right;"> 9.62 </td>
  </tr>
</tbody>
</table>

Cluster 2 corresponds to a migration concentrated in June and July. Cluster 3
is a bit similar, but more widespread from May to september. Cluster 4 has a
delayed peak with a high proportion in late summer / early autumn. Clusters 1 is widespread from spring to autumn.


We can look at the belonging of the different groups.

```r
groups <- interaction(yelloweel_wide$ser_nameshort,
                                            yelloweel_wide$period,
                                            drop=TRUE)
group_name <- levels(groups)


get_pattern_month <- function(res,mydata){
  
  tmp <- strsplit(as.character(group_name),
                  "\\.")
  ser <- as.character(lapply(tmp,function(tt){
    tt[1]
  }))
  country <- ser2$ser_cou_code[match(ser, ser2$ser_nameshort)]
  period <- as.character(lapply(tmp,function(tt){
    tt[2]
  }))
  res_mat <- as.matrix(as.mcmc.list(res))
  
  clus <- t(sapply(seq_len(length(unique(groups))), function(id){
    name_col <- paste("cluster[",id,"]",sep="")
    freq <- table(res_mat[,name_col])
    max_class <- names(freq)[order(freq,decreasing=TRUE)[1]]
    c(max_class,freq[as.character(1:nbclus)])
  }))
  storage.mode(clus) <- "numeric"
  classes <- as.data.frame(clus)
  names(classes) <- c("cluster", paste("clus",1:nbclus,sep=""))
  cbind.data.frame(data.frame(ser=ser, period=period, country=country),
                   classes)
}

myclassif_yellow <- get_pattern_month(myfit_yellow)
col_toreorder=grep("clus[0-9]",names(myclassif_yellow))
names(myclassif_yellow)[col_toreorder]=paste("clus",
                                      match(paste("clus",1:nbclus,sep=""),
                                      paste("clus",clus_order,sep="")),
                                      sep="")
myclassif_yellow[,col_toreorder] <- myclassif_yellow%>%
  select(col_toreorder)%>%select(sort(names(.)))

myclassif_yellow$cluster=factor(match(myclassif_yellow$cluster, clus_order),
                   levels=as.character(1:7))

table_classif(myclassif_yellow,type="series")
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> series </th>
   <th style="text-align:left;"> period </th>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> Max cluster </th>
   <th style="text-align:right;"> % clus 1 </th>
   <th style="text-align:right;"> % clus 2 </th>
   <th style="text-align:right;"> % clus 3 </th>
   <th style="text-align:right;"> % clus 4 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> VilY2 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VilY2 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GarY </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RhinY </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GarY </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RhinY </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> FR </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DaugY </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> LV </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AllE </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BroS </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OatY </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gud </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DK </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TedE </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> GB </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
</tbody>
</table>

The spatial pattern is also quite clear with cluster 1 (widespread) and 2 (summer) in France. In northern part, series are in clusters 3  and 4 corresponding to summer and autumn. It should be noted that, contrary to glass eels and silver eel, there is no clear migration for yellow eels. Indeed, eels display an ontongenic shift during their life stage, from a migratory behaviour towards sedentary behaviour (Imbert et al. 2010). 
Consequently, given the predominence of younger or older eels, which vary depending on the position in the river basin, 
a series may correspond to a seasonality of migration, to a seasonality of activity of sedentary eels, or to a mixture of both. 
Moreover, environmental conditions that trigger migration or activity may also vary depending on the position in the river basin 
and complexify the comparison of the time series. The sampling method may also alter the results: many time series are collected upstream fishways, 
and the attractivity / passability of those fishway vary among seasons. In northern part, series are in clusters 


```r
library(sf)
myclassif_yellow$x <- ser2$ser_x[match(myclassif_yellow$ser, ser2$ser_nameshort)]
myclassif_yellow$jit_x <- jitter(myclassif_yellow$x,amount=.5)
myclassif_yellow$y <- ser2$ser_y[match(myclassif_yellow$ser, ser2$ser_nameshort)]
myclassif_yellow$jit_y <- jitter(myclassif_yellow$y,amount=.5)
ggplot(data = cou) +  geom_sf(fill= "antiquewhite") +
		geom_point(data=myclassif_yellow, size=5,
		           aes(x=jit_x,y=jit_y,col=as.factor(cluster),pch=period)) +
  geom_segment(data=myclassif_yellow,
            aes(x=x,y=y,xend=jit_x,yend=jit_y,col=as.factor(cluster)))+
  scale_color_manual(values=cols) +
  theme_igray() +xlim(-20,30) + ylim(35,65)+
  xlab("")+ylab("")+labs(colour="cluster")
```

![](jags_modelling_monitoring_files/figure-html/unnamed-chunk-54-1.png)<!-- -->


## Exporting pattern per group

```r
tmp <- as.matrix(as.mcmc.list(myfit_yellow))
name_col = colnames(tmp)

pattern_Y_monitoring=do.call("rbind.data.frame",
                            lapply(seq_len(length(levels(groups))), function(g){
                              ser=substr(group_name[g],1,nchar(group_name[g])-2)
                              emu=ser2$ser_emu_nameshort[ser2$ser_nameshort == ser]
                              hty_code=ser2$ser_hty_code[ser2$ser_nameshort==ser]
                              median_pattern_group_monitoring(g, emu ,tmp, "G",group_name[g], hty_code)
                            }))
                                   
  
  
save(pattern_Y_monitoring,file="pattern_Y_monitoring.rdata")
```

## Similarity between and after 2010

```r
#which groups have data in both periods
occ=table(unique(yelloweel_wide[,c("ser_nameshort", "period")])[,1])
tocompare=names(occ)[which(occ>1)]

simi=sapply(tocompare, function(s){
  g=grep(s,group_name)
  esp1=tmp[,grep(paste("alpha_group\\[",g[1],",",sep=""),name_col)]
  esp2=tmp[,grep(paste("alpha_group\\[",g[2],",",sep=""),name_col)]
  quantile(apply(cbind(esp1,esp2),
                 1,
                 function(x) sum(pmin(x[1:12],x[13:24]))),
           probs=c(0.025,.5,.975))
})

similarity=data.frame(emu=tocompare,t(simi))

table_similarity(similarity)
```

<table>
<caption>similarity</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> EMU </th>
   <th style="text-align:right;"> q2.5% </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> q97.5% </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> GarY </td>
   <td style="text-align:right;"> 0.70 </td>
   <td style="text-align:right;"> 0.78 </td>
   <td style="text-align:right;"> 0.87 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RhinY </td>
   <td style="text-align:right;"> 0.73 </td>
   <td style="text-align:right;"> 0.86 </td>
   <td style="text-align:right;"> 0.95 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> VilY2 </td>
   <td style="text-align:right;"> 0.72 </td>
   <td style="text-align:right;"> 0.81 </td>
   <td style="text-align:right;"> 0.89 </td>
  </tr>
</tbody>
</table>


# Summary of data usage

```r
#glass eel
nrow(recruitment_wide%>% group_by(ser_nameshort)%>% count())
```

```
## [1] 12
```

```r
#yellow eel 
nrow(yelloweel_wide%>%group_by(ser_nameshort)%>% count())
```

```
## [1] 9
```

```r
#silver eel fresh
nrow(silvereel_wide%>%group_by(ser_nameshort)%>% count())
```

```
## [1] 14
```
