Loading the data
================

    load("seasonality_tibbles_res_ser2.Rdata")

Number of data series per stage: 12 pure glass eel stage, 6 pure silver
and 32 yellow. Only 20 mixed series, we will have to check their
classification.

    table(ser2$ser_lfs_code)

    ## 
    ##  G GY  S  Y YS 
    ## 12 14 88 32  6

Among mixed GY, only 4 of them are not already used by the WGEEL, so we
will have to check. For the others, we can use the wgeel classification.

    ser2[ser2$ser_lfs_code=="GY", c("ser_nameshort","ser_comment","ser_lfs_code")]

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

Glass Eel
=========

Data availability
-----------------

Given comments, mixed GY can be used as glass eel. What about
availability across months? Very few series are collected across all
months. Esti: I guess that in most on the cases the peak and the
sourronding months are provided, in the rest the abundance should be
low.... could the missing months be estimated using the trend of that
season? ShiF, ShiM, ImsaGY, Gry, GiSc, GarG seem to have a good monthly
coverage.

    recruitment <- subset(res, res$ser_nameshort %in% ser2$ser_nameshort[ser2$ser_lfs_code %in% c("G","GY")])
    table(recruitment$das_month,recruitment$ser_nameshort)

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

How many years are complete for all months?

    sapply(unique(recruitment$ser_nameshort),function(s)
      sum(colSums(table(recruitment$das_month[recruitment$ser_nameshort==s],
                        recruitment$das_year[recruitment$ser_nameshort==s])==1)==12))

    ##   EmsH   EmsB   Oria   GarG   GiSc Isle_G   ShiM   ShiF   Bann   Stra 
    ##      0      0      0      0     21      0      5      2      0      0 
    ##   BroG   BroE    Bro   Grey   BeeG   FlaG   FlaE    Fla  StGeG  StGeE 
    ##      0      0      0      9      0      0      0      0      0      0 
    ##   Erne   Burr   ShaE   Liff  RhDOG ImsaGY 
    ##      0      0      0      0      0     20

Data selection
--------------

First, we need to set up season of migration instead of calendar year.
Here, we split in november and a sesaon y will correspond to november -
december y-1 and january to october y.

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

### Reason for exclusion

-   Bann: no monthly data available
-   BeeG: Monitoring starts in April while migration is already high
-   BroE: same data as BroG but for elvers
-   Burr: temporal coverage is very variable and it is very difficult to
    locate the duration of the peak
-   Erne: sampling starts in March while migration is already rather
    high
-   Fla, FlaE and FlaG: twice the same series. Monitoring stards in May
    while abundance is sometimes already high
-   Isle\_G: limited number of seasons with a perhaps too limited
    monthly coverage
-   RhDOG: only 3 months per year, moreover, there are sometimes sevaral
    values per month in the same year
-   StGeE: same as stGeG but for elvers
-   Stra: no monthly data

### Reason for keeping

-   BroG: Monitoring starts in may but often with a zero catch, and
    continues till the end of the season. Only 2012 should be removed
    given comments
-   EmsB: While the number of sampled months is limited, it seems to
    appropriately covers the peak
-   EmsH: While the number of sampled months is limited, it seems to
    appropriately covers the peak
-   GarG: adequate monthly coverage
-   GiSc: adequate monthly coverage, already used by the WGEEL
-   Grey: perhaps a bit upstream (have to check for the presence of a
    fishery downstream) but very good monthly coverage
-   ImsaGY: very good coverage, already used by the WGEEL
-   Liff: the two seasons starting in March appears to be appropriate
-   ShaE: in 2012, monitoring starts in March leading to a good coverage
    of the whole season, for other years, it starts too late (May or
    latter)
-   ShiF and ShiM: traps running all years long therefore good coverage
    of the migration wave.
-   StGeG: only one year of data but good coverage of the migration wave
    (from march to october)

### to be discussed

-   Oria: first, monthly coverage in a bit limited (october and february
    represent 10% of yearly catches each), moreover, the GLM model
    included a month effect so the monthly pattern is similar every year
    by construction (as such, we should only consider one year). ESTI.
    OK. We could provide real densities (GE/m3) if you think that
    including more years could help.

### Final selection of data

Given selection of data, we make a subset of data:

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

Data preparation
----------------

To run the model, we need a table in the wide format: one column per
month, one row for a year x time series. It leads to a dataset with 82
rows.

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

We now replace NA value per zero since we selected our dataseries with
missing months corresponding to insignificant months, and we compute
proportions per month for each year.

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
    total_catch_year <- rowSums(recruitment_wide[, paste("m", 1:12, sep="")])
    recruitment_wide <- recruitment_wide %>%
      mutate_at(.vars=paste("m",1:12,sep=""),function(x) x/total_catch_year)

The Commission asks us to compare the pattern before and after 2007,
probably to see the effect of the Eel Regulation. It is therefore
necessary to build a period index. However, since most countries
implemented their EMPs only in 2009/2010, we split in 2010.

    recruitment_wide$period <- ifelse(recruitment_wide$season>2009,
                                      2,
                                      1)

    table(recruitment_wide$period,
           recruitment_wide$ser_nameshort)

    ##    
    ##     BroG EmsB EmsH GarG GiSc Grey ImsaGY Liff Oria ShaE ShiF StGeG
    ##   1    0    0    0    0   16    1     10    0    1    0    0     0
    ##   2    8    5    3    4    8    8     10    2    1    1    3     1

Only 4 series have data in the first period therefore period comparisons
will be difficult. However, can now try to fit the model.

Running the model
-----------------

### Building data

    group <- as.integer(interaction(recruitment_wide$ser_nameshort,
                                                recruitment_wide$period,
                                                drop=TRUE))
    y <-as.matrix(recruitment_wide[, paste("m", 1:12, sep="")])


    build_data <- function(nbclus){
      list(y=y, #observations
           group=group, #group identifier (a group is a period x series)
           nbm=12, #number of month
           nbclust=nbclus)# number of clusters
    }

Silver eel
==========

Data availability
-----------------

There are 87 pure silver eel dataseries, this has several consequences:
\* Given the high number of time series, we will only focus one pure
silver eels data series and neglect YS data series (except if a data
provider clearly tells us that we can add this data) \* We have to
develop criterion to quickly check the reliability of the data and makes
a quick sorting of the data.

Data correction
---------------

Some corrections of errors found in the database

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

    WarS <- res %>%
       filter(ser_nameshort == "WarS", !is.na(das_effort)) %>%
       group_by_at(vars(-one_of(c("das_comment","das_value")))) %>%
       summarise(das_value=sum(das_value))
     
    res <- bind_rows(
       res %>%
       filter(res$ser_nameshort != "WarS"),
       WarS)

Data selection
--------------

As for glass eel, we start by defining season consistent with ecological
knowledge on migration. Downstream runs of European silver eels
typically start in the autumn and may last until early spring (Brujs and
Durif 2009), but we saw during WGEEL 2019 that peak in silver catches in
Sweden is centered around August/September. Therefore, it is difficult
to split season of migration in a similar way for all Europe. Therefore,
we define a season of migration per series: we look to the month
corresponding to the peak of migration and define the season from 5
months before to 6 months after. The name of the season is defined as
the year of the peak.

    #function to make circular shifting
    shifter <- function(x, n = 1) {
         if (n == 0) x else c(tail(x, -n), head(x, n))
    }

    #creating season
    finding_peak <- function(data){
      mean_per_month <- tapply(data$das_value,list(data$das_month),mean,na.rm=TRUE)
      peak_month <-as.integer(names(sort(mean_per_month,decreasing=TRUE)))[1]
      peak_month
    }

    finding_lowest_month <- function(data){
      mean_per_month <- tapply(data$das_value,list(data$das_month),mean,na.rm=TRUE)
      lowest_month <-as.integer(names(sort(mean_per_month)))[1]
      lowest_month
    }


    season_creation<-function(data){
      peak_month <- finding_peak(data) #2 3 4 5 6 7 8 9 10 11 12 1
      lowest_month <- finding_lowest_month(data)
      #season_order <- shifter(1:12,peak_month-6)
      season_order <- shifter(1:12,lowest_month-1)
      data$month_in_season <- as.factor(match(data$das_month,season_order))
      data$season <- ifelse(data$das_month < lowest_month,
                            data$das_year-1,
                            data$das_year)
      data$peak_month <- peak_month
      data$lowest_month <- lowest_month
      data
    }

    silvereel <- do.call("rbind.data.frame",
                         lapply(ser2$ser_nameshort[ser2$ser_lfs_code=="S"],
                                function(s)
                                  season_creation(res[res$ser_nameshort==s,])))
    months_peak_per_series<- unique(silvereel[,c("ser_nameshort","peak_month")])
    table(months_peak_per_series$peak_month)

    ## 
    ##  1  4  5  6  8  9 10 11 12 
    ##  1  4  4  1  5 12 32 17 12

This confirms that most series peak in autumn, but that other peak in
spring or summer.

Building diagnostics of quality for series
------------------------------------------

    #to be considered as valid, we need:
    #   at least 8 months including the peak (since there are often two peaks, one
    #   in spring and one in autumn)
    #   that the first month of data generally stands for a small proportion of catches
    #   that the last month of data generally stands for a small proportion of catches
    #   that there is no missing month between first and last month

    good_coverage_wave <- function(mydata){
      
      checking_duplicate(mydata)
      peak_month <- unique(mydata$peak_month)
      lowest_month <- unique(mydata$lowest_month)
      original_months <- shifter(1:12,lowest_month-1)
      #we put data in wide format with one row per seasaon
      
      data_wide <- mydata[,c("season",
                           "month_in_season",
                           "das_value")] %>%
                          spread(month_in_season,
                               das_value,
                               drop=FALSE)
      data_wide <- data_wide[,c(1:12,"season")]
      mean_per_month <- colMeans(data_wide[,1:12],na.rm=TRUE)
      mean_per_month <- mean_per_month / sum(mean_per_month, na.rm=TRUE)
      
      cum_sum <- 
        cumsum(sort(mean_per_month, decreasing=TRUE)) / 
        sum(mean_per_month, na.rm=TRUE)
      
      #we take the last month to have at least 95% of catches and which stands for
      #less than 10 % of catches
      bound <- min(which(cum_sum > .95 &
                             mean_per_month[as.integer(names(cum_sum))]<.05))
      if (is.infinite(bound) | sum(is.na(mean_per_month))>6){
        print(paste("For",
                    unique(mydata$ser_nameshort),
                    "not possible to define a season"))
        return (NULL)
      }
        
      min_max <- range(as.integer(names(cum_sum)[1:bound]))
      fmin  <- min_max[1]
      lmin <- min_max[2]
      
      if ((fmin>1 & mean_per_month[fmin]>.05 & is.na(mean_per_month[fmin+1])) |
          (lmin<12 & mean_per_month[lmin]>.05 & is.na(mean_per_month[lmin+1]))){
            print(paste("For",
                    unique(mydata$ser_nameshort),
                    "not possible to define a season"))
            return (NULL)
        
      }
        
      
      print(paste("For ",
                  unique(mydata$ser_nameshort),
                  " a good season should cover months:",
                  original_months[fmin],
                  "to",
                  original_months[lmin]))
      
    #  if ((lmin - fmin) < 8) return(NULL)
      keeping <- data_wide%>%
        mutate(num_na=rowSums(is.na(select(.,num_range("",fmin:lmin))))) %>%
        filter(num_na==0)
      if (nrow(keeping)==0) return(NULL)
      keeping$season
    }

    checking_duplicate <- function(mydata){
      counts_data <- table(mydata$das_year, mydata$das_month)
      if (sum(counts_data > 1)) {
        dup <- which(counts_data > 1, arr.ind = TRUE)
        print(paste("##duplicates series",unique(mydata$ser_nameshort)))
        stop(paste(rownames(counts_data)[dup[,1]],
                   colnames(counts_data)[dup[, 2]],
                   collapse = "\n"))
      }
    }

The previous function looks at different criterion: it put the data in
the wide format and check if we have at least 3 months around the peak.
Moreover, it seeks for two extreme months when the cumulative catch is
below 10%. If there is now missing month between these two extreme
months, the season is kept. Using this function, we can make a
preliminary screening of available series.

    kept_seasons <- lapply(unique(silvereel$ser_nameshort), function(s){
      sub_silver <- subset(silvereel, silvereel$ser_nameshort==s)
      good_coverage_wave(sub_silver)
    })

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
    ## [1] "For  rij6T  a good season should cover months: 5 to 4"
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

Finally, here are the series kept given previous criterion.

    names(kept_seasons) <- unique(silvereel$ser_nameshort)
    kept_seasons[!sapply(kept_seasons,is.null)]

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

Data preparation
----------------

To run the model, we need a table in the wide format: one column per
month, one row for a year x time series. It leads to a dataset with 82
rows. Since seasn are not comparable among years, months correspond to
original months (eg: 12 for decembre, not month in season), while rows
indeed correspond tos season

    silvereel_subset <- subset(silvereel, 
                               mapply(function(season, series){
                                 season %in% kept_seasons[[series]]
                               }, silvereel$season, silvereel$ser_nameshort))

    silvereel_subset$emu <- ser2$ser_emu_nameshort[match(silvereel_subset$ser_nameshort,
                                                           ser2$ser_nameshort)]

    silvereel_wide <- pivot_wider(data=silvereel_subset[, c("ser_nameshort",
                                                                "emu",
                                                         "country",
                                                         "season",
                                                         "das_month",
                                                         "das_value")],
                                    names_from="das_month",
                                    values_from="das_value")
    names(silvereel_wide)[-(1:4)] <- paste("m",
                                           names(silvereel_wide)[-(1:4)],
                                           sep="")

We now replace NA value per zero since we selected our dataseries with
missing months corresponding to insignificant months, and we compute
proportions per month for each year.

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
    total_catch_year <- rowSums(silvereel_wide[, paste("m", 1:12, sep="")])
    silvereel_wide <- silvereel_wide %>%
      mutate_at(.vars=paste("m",1:12,sep=""),function(x) x/total_catch_year)

The Commission asks us to compare the pattern before and after 2007,
probably to see the effect of the Eel Regulation. It is therefore
necessary to build a period index. However, since most countries
implemented their EMPs only in 2009/2010, we split in 2010.

    silvereel_wide$period <- ifelse(silvereel_wide$season>2009,
                                      2,
                                      1)

    table(silvereel_wide$period,
           silvereel_wide$ser_nameshort)

    ##    
    ##     BadB BurS DaugS ErneS GirB ImsaS KauT OirS ScorS Shie SomS SouS UShaS
    ##   1    7   40     0     0    7    10    1   10    10    8    0    0     0
    ##   2   10    9     3     1   10    10    0    9     9   10    1    7     1
    ##    
    ##     WarS
    ##   1    1
    ##   2    5

The situation is better for silver eel than for glass eel, we have a
good sets of time series with data both before and after 2009.

Running the model
-----------------

### Building data

    group <- as.integer(interaction(silvereel_wide$ser_nameshort,
                                                silvereel_wide$period,
                                                drop=TRUE))
    y <-as.matrix(silvereel_wide[, paste("m", 1:12, sep="")])


    build_data <- function(nbclus){
      list(y=y, #observations
           group=group, #group identifier (a group is a period x series)
           nbm=12, #number of month
           nbclust=nbclus)# number of clusters
    }
