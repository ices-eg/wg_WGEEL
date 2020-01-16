Loading the data
================

    load("seasonality_tibbles_res_ser2.Rdata")

Number of data series per stage: 12 pure glass eel stage, 6 pure silver
and 32 yellow. Only 20 mixed series, we will have to check their
classification.

    table(ser2$ser_lfs_code)

    ## 
    ##  G GY  S  Y YS 
    ## 12 14 87 32  6

Among mixed GY, only 4 of them are not already used by the WGEEL, so we
will have to check. For the others, we can use the wgeel classification.

    ser2[ser2$ser_lfs_code=="GY",]

    ##     ser_nameshort ser_nameshort_base existing
    ## 7            Bann             BannGY     TRUE
    ## 10            Bro                       FALSE
    ## 11           BroE               BroE     TRUE
    ## 12           BroG               BroG     TRUE
    ## 22           EmsB             EmsBGY     TRUE
    ## 24           Erne             ErneGY     TRUE
    ## 26            Fla                       FALSE
    ## 27           FlaE               FlaE     TRUE
    ## 36           Grey             GreyGY     TRUE
    ## 60         ImsaGY             ImsaGY     TRUE
    ## 69           Liff             LiffGY     TRUE
    ## 119          ShaE                       FALSE
    ## 128         StGeE                       FALSE
    ## 132          Stra             StraGY     TRUE
    ##                              ser_namelong ser_typ_id ser_effort_uni_code
    ## 7         Bann Coleraine trapping partial          1                <NA>
    ## 10      Brownshilll Glass, Elvers, Yellow          1                <NA>
    ## 11            Brownshill_Elvers_>80<120mm          1                <NA>
    ## 12                 Brownshill_Glass_<80mm          1                <NA>
    ## 22  Ems (Bollingerfaehr) Elver monitoring          1              nr day
    ## 24         Erne Ballyshannon trapping all          1                <NA>
    ## 26         Flatford Glass, Elvers, Yellow          1                <NA>
    ## 27              Flatford_Elvers_>80<120mm          1                <NA>
    ## 36              Greylakes_Elvers (<120mm)          1                <NA>
    ## 60         Imsa Near Sandnes trapping all          1                <NA>
    ## 69                                 Liffey          1                <NA>
    ## 119             Shannon Ardnacrusha Elver          1                <NA>
    ## 128         St Germans Elvers (>80<120mm)          1                <NA>
    ## 132                            Strangford          1                <NA>
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
    ##     ser_uni_code ser_lfs_code ser_hty_code
    ## 7             kg           GY            F
    ## 10            nr           GY            F
    ## 11          <NA>           GY            F
    ## 12          <NA>           GY            F
    ## 22            nr           GY            F
    ## 24            kg           GY            F
    ## 26            nr           GY            F
    ## 27          <NA>           GY            F
    ## 36          <NA>           GY            F
    ## 60            nr           GY            F
    ## 69            kg           GY            F
    ## 119           kg           GY            F
    ## 128           nr           GY            F
    ## 132         <NA>           GY            F
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ser_locationdescription
    ## 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Coleraine
    ## 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Environment Agency trap counter at Brownshill on the River Great Ouse
    ## 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Environment Agency trap counter at Brownshill on the River Great Ouse
    ## 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Environment Agency trap counter at Brownshill on the River Great Ouse
    ## 22  Ems at the next weir upstream from tidal weir (6.4 km). \r\nEel ladder in the fish pass (which is then blocked for fish passage) set overnight (and in some instances at daytime also), from end of May the latest til at least mid of September. Usually sampling is performed in a core time frame of 90 days from early June til end of August and additional 30 days for sampling from May til September according to respective eel occurence.\r\n\r\nIn the first year 2013, when numbers of migrating eel increased, the eel no longer passed via the eel ladder but bypassed it by climbing the walls of the fish pass. From 2014, this bypass was succesfully blocked for all eels.
    ## 24                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       The Erne at Ballyshannon, 6 km from the sea at the Cathaleen Fall Dam. 
    ## 26                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     Environment Agency trap counter at Flatford, Judas Gap on the River Stour
    ## 27                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     Environment Agency trap counter at Flatford, Judas Gap on the River Stour
    ## 36                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     Environment Agency camera trap _Mixture of glass eel and elvers (<120mm), Greylake site, on river Parrett
    ## 60                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  Near Sandnes
    ## 69                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Trap located on the first dam in river Liffey (Dublin, Islandbridge) at the tidal limit,  10 km from the sea.
    ## 119                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Trap at tidal limit
    ## 128                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               St Germans pumping station at Middle Level Main Drain, just befor joining the Great Ouse River
    ## 132                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Location is at wetlands and wildfowl centre, Comber, which has several very large ponds draining into the Strangford Lough. 
    ##     ser_emu_nameshort ser_cou_code ser_area_division ser_tblcodeid
    ## 7             GB_NorE           GB            27.6.a        170004
    ## 10            GB_Angl           GB              <NA>          <NA>
    ## 11            GB_Angl           GB            27.4.c        170077
    ## 12            GB_Angl           GB            27.4.c        170075
    ## 22             DE_Ems           DE            27.4.c          <NA>
    ## 24            IE_NorW           IE            27.7.b        170009
    ## 26            GB_Angl           GB              <NA>          <NA>
    ## 27            GB_Angl           GB            27.4.c        170073
    ## 36            GB_SouW           GB            27.7.f        170078
    ## 60           NO_total           NO            27.4.a          <NA>
    ## 69            IE_East           IE            27.7.a          <NA>
    ## 119           IE_Shan           IE              <NA>          <NA>
    ## 128           GB_Angl           GB              <NA>          <NA>
    ## 132           GB_NorE           GB            27.7.a        170079
    ##           ser_x    ser_y
    ## 7   -6.42000000 55.12000
    ## 10   0.00853065 52.33534
    ## 11   0.00853065 52.33534
    ## 12   0.00853065 52.33534
    ## 22   7.31500000 52.98000
    ## 24  -8.17630600 54.49985
    ## 26   1.02137700 51.95888
    ## 27   1.02137700 51.95888
    ## 36  -2.88133310 51.04710
    ## 60   5.59000000 58.54000
    ## 69  -6.31430360 53.34649
    ## 119 -8.61000000 52.71000
    ## 128  0.34946500 52.70224
    ## 132 -5.55000000 54.37000

Glass Eel
=========

Data availability
-----------------

Given comments, mixed GY can be used as glass eel. What about
availability across months? Very few series are collected across all
months. ShiF, ShiM, ImsaGY, Gry, GiSc, GarG seem to have a good monthly
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
    by construction (as such, we should only consider one year)

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

    recruitment_subset$emu <- ser2$ser_emu_nameshort[match(recruitment_subset$ser_nameshort,
                                                           ser2$ser_nameshort)]
    recruitment_wide <- pivot_wider(data=recruitment_subset[, c("ser_nameshort",
                                                                "emu",
                                                         "country",
                                                         "season",
                                                         "month_in_season",
                                                         "das_value")],
                                    names_from="month_in_season",
                                    values_from="das_value")

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

    season_creation<-function(data){
      peak_month <- finding_peak(data) #2 3 4 5 6 7 8 9 10 11 12 1
      season_order <- shifter(1:12,peak_month-6)
      before <- season_order[1:6]
      after <- season_order[7:12]
      data$month_in_season <- as.factor(match(data$das_month,season_order))
      data$season <- ifelse(data$das_month %in% before & data$das_month>peak_month,
                            data$das_year+1,
                            ifelse(data$das_month %in% after & data$das_month<peak_month,
                                   data$das_year-1,
                                   data$das_year))
      data$peak_month <- peak_month
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
    ##  1  4  3  1  5 12 32 17 12

This confirms that most series peak in autumn, but that other peak in
spring or summer.

Building diagnostics of quality for series
------------------------------------------

    #to be considered as valid, we need:
    #   at least 4 months including the peak
    #   that the first month of data generally stands for a small proportion of catches
    #   that the last month of data generally stands for a small proportion of catches
    #   that there is no missing month between first and last month

    good_coverage_wave <- function(mydata){
      peak_month <- unique(mydata$peak_month)
      #we put data in wide format with one row per seasaon
      data_wide <- mydata[,c("season",
                           "month_in_season",
                           "das_value")] %>%
                          spread(month_in_season,
                               das_value,
                               drop=FALSE)
      data_wide <- data_wide[,c(1:12,"season")]
      catch_per_season <- rowSums(data_wide[,1:12],na.rm=TRUE)
      data_wide <- data_wide %>% mutate_at(vars(num_range("",1:12)), function(x) x/catch_per_season)
      mean_per_month <- colMeans(data_wide[,-ncol(data_wide)],na.rm=TRUE)
      
      ###we seek the first and last month below 5% 
      fmin = min(which(mean_per_month<.1))
      lmin = max(which(mean_per_month<.1))
      
      if (fmin>5 | lmin<7) return(NULL)
      keeping <- data_wide%>%
        mutate(num_na=rowSums(is.na(select(.,num_range("",fmin:lmin))))) %>%
        filter(num_na==0)
      if (nrow(keeping)==0) return(NULL)
      keeping$season
    }

having\_wave&lt;-function(data){ \#we put it in the wide format
data\_wide &lt;- pivot\_wider(data\[,c("season", "das\_month",
"das\_value"),\], names\_from="das\_month", values\_from="das\_value") }
\`\`\`
