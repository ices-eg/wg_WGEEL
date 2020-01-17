---
title: "WKEELMIGRATION LANDINGS SEASONALITY DATA TREATMENT"
author: "Cédric Briand, Jan Dag Pohlmann, Estibaliz diaz and Hilaire Drouineau, "
date: "january 2020"
output: 
  html_document:
    keep_md: true
---



# preparing the files

see readme.md in this folder for notes on source file.


# reading the files





```r
load(file=str_c(datawd1,"list_seasonality.Rdata"))
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
##  14  Variables      12537  Observations
## ---------------------------------------------------------------------------
## eel_typ_name 
##        n  missing distinct 
##    12365      172        2 
##                                           
## Value      com_landings_kg rec_landings_kg
## Frequency            12209             156
## Proportion           0.987           0.013
## ---------------------------------------------------------------------------
## eel_year 
##        n  missing distinct     Info     Mean      Gmd      .05      .10 
##    12365      172      115    0.997     2010    7.506     2001     2002 
##      .25      .50      .75      .90      .95 
##     2006     2011     2015     2017     2018 
## 
## lowest : 1905 1906 1907 1908 1909, highest: 2015 2016 2017 2018 2019
## ---------------------------------------------------------------------------
## eel_month 
##        n  missing distinct 
##    12365      172       15 
## 
## APR (1008, 0.082), AUG (1084, 0.088), Dec (1, 0.000), DEC (974, 0.079),
## FEB (834, 0.067), JAN (849, 0.069), JUL (1110, 0.090), JUN (1080, 0.087),
## MAR (891, 0.072), MAY (1023, 0.083), NOV (1099, 0.089), OCT (1060, 0.086),
## REMAIN YEAR (213, 0.017), SEP (1029, 0.083), WHOLE YEAR (110, 0.009)
## ---------------------------------------------------------------------------
## eel_value 
##         n   missing  distinct      Info      Mean       Gmd       .05 
##     12327       210      6148      0.99      7052     13297     0.000 
##       .10       .25       .50       .75       .90       .95 
##     0.000     2.605   111.200   970.200  4964.700 22502.220 
## 
## lowest :      0.000      0.025      0.050      0.080      0.100
## highest: 667428.571 680000.000 701015.873 704158.730 805841.270
## ---------------------------------------------------------------------------
## eel_missvaluequal 
##        n  missing distinct 
##       39    12498        3 
##                             
## Value         ND    NM    NP
## Frequency      9    19    11
## Proportion 0.231 0.487 0.282
## ---------------------------------------------------------------------------
## eel_emu_nameshort 
##        n  missing distinct 
##    12365      172       46 
## 
## lowest : DE_Eide  DE_Elbe  DE_Schl  DE_Warn  DK_total
## highest: PL_Oder  PL_Vist  SE_East  SE_Inla  SE_West 
## ---------------------------------------------------------------------------
## eel_cou_code 
##        n  missing distinct 
##    12537        0       13 
##                                                                       
## Value          0    DE    DK    ES    FI    FR    GB    HR    IE    NL
## Frequency    172  2058   464  1074    96  3947  2452    72    35   430
## Proportion 0.014 0.164 0.037 0.086 0.008 0.315 0.196 0.006 0.003 0.034
##                             
## Value         NO    PL    SE
## Frequency    217   702   818
## Proportion 0.017 0.056 0.065
## ---------------------------------------------------------------------------
## eel_lfs_code 
##        n  missing distinct 
##    12365      172        4 
##                                   
## Value          G     S     Y    YS
## Frequency   2198  2921  3926  3320
## Proportion 0.178 0.236 0.318 0.268
## ---------------------------------------------------------------------------
## eel_hty_code 
##        n  missing distinct 
##    12365      172        7 
##                                                     
## Value          C     F    FT   FTC    MO     T    TC
## Frequency   1927  3441    12  1350   464  4532   639
## Proportion 0.156 0.278 0.001 0.109 0.038 0.367 0.052
## ---------------------------------------------------------------------------
## eel_area_division 
##        n  missing distinct 
##     4817     7720       12 
##                                                                       
## Value         27.3.a 27.3.b, c    27.3.d    27.4.b    27.4.c    27.7.a
## Frequency        460       728      1176       816       171       152
## Proportion     0.095     0.151     0.244     0.169     0.035     0.032
##                                                                       
## Value         27.7.d    27.7.e    27.8.c    27.9.a    37.1.1    37.2.1
## Frequency         86        82       404       257       413        72
## Proportion     0.018     0.017     0.084     0.053     0.086     0.015
## ---------------------------------------------------------------------------
## eel_comment 
##        n  missing distinct 
##     2371    10166       30 
## 
## lowest : 27.4.a also included                                                                                                                       All marine areas                                                                                                                           All marine areas. Preliminary data                                                                                                         area information is incomplete, but almost everything is from Ivc                                                                          Bristol Channel                                                                                                                           
## highest: total landings of one fisherman were reported monthly. But proportion of silvereel of total landings were only provided as a total (120kg) total landings of one fisherman were reported monthy. But proportion of silvereel of total landings were only provided as a total (100kg)  Two days fished using one fyke net (AUG). No eels caught                                                                                   two fishermen only reported yearly catch for yellow and silver eel combined which are excluded (total of 15kg in 2009)                     Vessels of the Nalón stop from February 17 to March 18, 2011.                                                                             
## ---------------------------------------------------------------------------
## source 
##        n  missing distinct 
##    12537        0       12 
## 
## lowest : DE_commercial_landings DK_commercial_landings ES_commercial_landings FL_commercial_landings FR_commercial_landings
## highest: IE_commercial_landings NL_commercial_landings NO_commercial_landings PL_commercial_landings SE_commercial_landings
## ---------------------------------------------------------------------------
## country 
##        n  missing distinct 
##    12537        0       12 
##                                                                       
## Value         DE    DK    ES    FL    FR    GB    HR    IE    NL    NO
## Frequency   2058   464  1074    96  3947  2452   244    35   430   217
## Proportion 0.164 0.037 0.086 0.008 0.315 0.196 0.019 0.003 0.034 0.017
##                       
## Value         PL    SE
## Frequency    702   818
## Proportion 0.056 0.065
## ---------------------------------------------------------------------------
## datasource 
##              n        missing       distinct          value 
##          12537              0              1 wkeelmigration 
##                          
## Value      wkeelmigration
## Frequency           12537
## Proportion              1
## ---------------------------------------------------------------------------
```

```r
print(res[is.na(res$eel_emu_nameshort),],n=1000)
```

```
## # A tibble: 172 x 14
##     eel_typ_name eel_year eel_month eel_value eel_missvaluequ~
##     <chr>           <dbl> <chr>         <dbl> <chr>           
##   1 <NA>               NA <NA>             NA <NA>            
##   2 <NA>               NA <NA>             NA <NA>            
##   3 <NA>               NA <NA>             NA <NA>            
##   4 <NA>               NA <NA>             NA <NA>            
##   5 <NA>               NA <NA>             NA <NA>            
##   6 <NA>               NA <NA>             NA <NA>            
##   7 <NA>               NA <NA>             NA <NA>            
##   8 <NA>               NA <NA>             NA <NA>            
##   9 <NA>               NA <NA>             NA <NA>            
##  10 <NA>               NA <NA>             NA <NA>            
##  11 <NA>               NA <NA>             NA <NA>            
##  12 <NA>               NA <NA>             NA <NA>            
##  13 <NA>               NA <NA>             NA <NA>            
##  14 <NA>               NA <NA>             NA <NA>            
##  15 <NA>               NA <NA>             NA <NA>            
##  16 <NA>               NA <NA>             NA <NA>            
##  17 <NA>               NA <NA>             NA <NA>            
##  18 <NA>               NA <NA>             NA <NA>            
##  19 <NA>               NA <NA>             NA <NA>            
##  20 <NA>               NA <NA>             NA <NA>            
##  21 <NA>               NA <NA>             NA <NA>            
##  22 <NA>               NA <NA>             NA <NA>            
##  23 <NA>               NA <NA>             NA <NA>            
##  24 <NA>               NA <NA>             NA <NA>            
##  25 <NA>               NA <NA>             NA <NA>            
##  26 <NA>               NA <NA>             NA <NA>            
##  27 <NA>               NA <NA>             NA <NA>            
##  28 <NA>               NA <NA>             NA <NA>            
##  29 <NA>               NA <NA>             NA <NA>            
##  30 <NA>               NA <NA>             NA <NA>            
##  31 <NA>               NA <NA>             NA <NA>            
##  32 <NA>               NA <NA>             NA <NA>            
##  33 <NA>               NA <NA>             NA <NA>            
##  34 <NA>               NA <NA>             NA <NA>            
##  35 <NA>               NA <NA>             NA <NA>            
##  36 <NA>               NA <NA>             NA <NA>            
##  37 <NA>               NA <NA>             NA <NA>            
##  38 <NA>               NA <NA>             NA <NA>            
##  39 <NA>               NA <NA>             NA <NA>            
##  40 <NA>               NA <NA>             NA <NA>            
##  41 <NA>               NA <NA>             NA <NA>            
##  42 <NA>               NA <NA>             NA <NA>            
##  43 <NA>               NA <NA>             NA <NA>            
##  44 <NA>               NA <NA>             NA <NA>            
##  45 <NA>               NA <NA>             NA <NA>            
##  46 <NA>               NA <NA>             NA <NA>            
##  47 <NA>               NA <NA>             NA <NA>            
##  48 <NA>               NA <NA>             NA <NA>            
##  49 <NA>               NA <NA>             NA <NA>            
##  50 <NA>               NA <NA>             NA <NA>            
##  51 <NA>               NA <NA>             NA <NA>            
##  52 <NA>               NA <NA>             NA <NA>            
##  53 <NA>               NA <NA>             NA <NA>            
##  54 <NA>               NA <NA>             NA <NA>            
##  55 <NA>               NA <NA>             NA <NA>            
##  56 <NA>               NA <NA>             NA <NA>            
##  57 <NA>               NA <NA>             NA <NA>            
##  58 <NA>               NA <NA>             NA <NA>            
##  59 <NA>               NA <NA>             NA <NA>            
##  60 <NA>               NA <NA>             NA <NA>            
##  61 <NA>               NA <NA>             NA <NA>            
##  62 <NA>               NA <NA>             NA <NA>            
##  63 <NA>               NA <NA>             NA <NA>            
##  64 <NA>               NA <NA>             NA <NA>            
##  65 <NA>               NA <NA>             NA <NA>            
##  66 <NA>               NA <NA>             NA <NA>            
##  67 <NA>               NA <NA>             NA <NA>            
##  68 <NA>               NA <NA>             NA <NA>            
##  69 <NA>               NA <NA>             NA <NA>            
##  70 <NA>               NA <NA>             NA <NA>            
##  71 <NA>               NA <NA>             NA <NA>            
##  72 <NA>               NA <NA>             NA <NA>            
##  73 <NA>               NA <NA>             NA <NA>            
##  74 <NA>               NA <NA>             NA <NA>            
##  75 <NA>               NA <NA>             NA <NA>            
##  76 <NA>               NA <NA>             NA <NA>            
##  77 <NA>               NA <NA>             NA <NA>            
##  78 <NA>               NA <NA>             NA <NA>            
##  79 <NA>               NA <NA>             NA <NA>            
##  80 <NA>               NA <NA>             NA <NA>            
##  81 <NA>               NA <NA>             NA <NA>            
##  82 <NA>               NA <NA>             NA <NA>            
##  83 <NA>               NA <NA>             NA <NA>            
##  84 <NA>               NA <NA>             NA <NA>            
##  85 <NA>               NA <NA>             NA <NA>            
##  86 <NA>               NA <NA>             NA <NA>            
##  87 <NA>               NA <NA>             NA <NA>            
##  88 <NA>               NA <NA>             NA <NA>            
##  89 <NA>               NA <NA>             NA <NA>            
##  90 <NA>               NA <NA>             NA <NA>            
##  91 <NA>               NA <NA>             NA <NA>            
##  92 <NA>               NA <NA>             NA <NA>            
##  93 <NA>               NA <NA>             NA <NA>            
##  94 <NA>               NA <NA>             NA <NA>            
##  95 <NA>               NA <NA>             NA <NA>            
##  96 <NA>               NA <NA>             NA <NA>            
##  97 <NA>               NA <NA>             NA <NA>            
##  98 <NA>               NA <NA>             NA <NA>            
##  99 <NA>               NA <NA>             NA <NA>            
## 100 <NA>               NA <NA>             NA <NA>            
## 101 <NA>               NA <NA>             NA <NA>            
## 102 <NA>               NA <NA>             NA <NA>            
## 103 <NA>               NA <NA>             NA <NA>            
## 104 <NA>               NA <NA>             NA <NA>            
## 105 <NA>               NA <NA>             NA <NA>            
## 106 <NA>               NA <NA>             NA <NA>            
## 107 <NA>               NA <NA>             NA <NA>            
## 108 <NA>               NA <NA>             NA <NA>            
## 109 <NA>               NA <NA>             NA <NA>            
## 110 <NA>               NA <NA>             NA <NA>            
## 111 <NA>               NA <NA>             NA <NA>            
## 112 <NA>               NA <NA>             NA <NA>            
## 113 <NA>               NA <NA>             NA <NA>            
## 114 <NA>               NA <NA>             NA <NA>            
## 115 <NA>               NA <NA>             NA <NA>            
## 116 <NA>               NA <NA>             NA <NA>            
## 117 <NA>               NA <NA>             NA <NA>            
## 118 <NA>               NA <NA>             NA <NA>            
## 119 <NA>               NA <NA>             NA <NA>            
## 120 <NA>               NA <NA>             NA <NA>            
## 121 <NA>               NA <NA>             NA <NA>            
## 122 <NA>               NA <NA>             NA <NA>            
## 123 <NA>               NA <NA>             NA <NA>            
## 124 <NA>               NA <NA>             NA <NA>            
## 125 <NA>               NA <NA>             NA <NA>            
## 126 <NA>               NA <NA>             NA <NA>            
## 127 <NA>               NA <NA>             NA <NA>            
## 128 <NA>               NA <NA>             NA <NA>            
## 129 <NA>               NA <NA>             NA <NA>            
## 130 <NA>               NA <NA>             NA <NA>            
## 131 <NA>               NA <NA>             NA <NA>            
## 132 <NA>               NA <NA>             NA <NA>            
## 133 <NA>               NA <NA>             NA <NA>            
## 134 <NA>               NA <NA>             NA <NA>            
## 135 <NA>               NA <NA>             NA <NA>            
## 136 <NA>               NA <NA>             NA <NA>            
## 137 <NA>               NA <NA>             NA <NA>            
## 138 <NA>               NA <NA>             NA <NA>            
## 139 <NA>               NA <NA>             NA <NA>            
## 140 <NA>               NA <NA>             NA <NA>            
## 141 <NA>               NA <NA>             NA <NA>            
## 142 <NA>               NA <NA>             NA <NA>            
## 143 <NA>               NA <NA>             NA <NA>            
## 144 <NA>               NA <NA>             NA <NA>            
## 145 <NA>               NA <NA>             NA <NA>            
## 146 <NA>               NA <NA>             NA <NA>            
## 147 <NA>               NA <NA>             NA <NA>            
## 148 <NA>               NA <NA>             NA <NA>            
## 149 <NA>               NA <NA>             NA <NA>            
## 150 <NA>               NA <NA>             NA <NA>            
## 151 <NA>               NA <NA>             NA <NA>            
## 152 <NA>               NA <NA>             NA <NA>            
## 153 <NA>               NA <NA>             NA <NA>            
## 154 <NA>               NA <NA>             NA <NA>            
## 155 <NA>               NA <NA>             NA <NA>            
## 156 <NA>               NA <NA>             NA <NA>            
## 157 <NA>               NA <NA>             NA <NA>            
## 158 <NA>               NA <NA>             NA <NA>            
## 159 <NA>               NA <NA>             NA <NA>            
## 160 <NA>               NA <NA>             NA <NA>            
## 161 <NA>               NA <NA>             NA <NA>            
## 162 <NA>               NA <NA>             NA <NA>            
## 163 <NA>               NA <NA>             NA <NA>            
## 164 <NA>               NA <NA>             NA <NA>            
## 165 <NA>               NA <NA>             NA <NA>            
## 166 <NA>               NA <NA>             NA <NA>            
## 167 <NA>               NA <NA>             NA <NA>            
## 168 <NA>               NA <NA>             NA <NA>            
## 169 <NA>               NA <NA>             NA <NA>            
## 170 <NA>               NA <NA>             NA <NA>            
## 171 <NA>               NA <NA>             NA <NA>            
## 172 <NA>               NA <NA>             NA <NA>            
## # ... with 9 more variables: eel_emu_nameshort <chr>, eel_cou_code <chr>,
## #   eel_lfs_code <chr>, eel_hty_code <chr>, eel_area_division <chr>,
## #   eel_comment <chr>, source <chr>, country <chr>, datasource <chr>
```

```r
# all NA print(res[is.na(res$eel_emu_nameshort),],n=1000)
res <- res[!is.na(res$eel_emu_nameshort),]
# describe file again
Hmisc::describe(res)
```

```
## res 
## 
##  14  Variables      12365  Observations
## ---------------------------------------------------------------------------
## eel_typ_name 
##        n  missing distinct 
##    12365        0        2 
##                                           
## Value      com_landings_kg rec_landings_kg
## Frequency            12209             156
## Proportion           0.987           0.013
## ---------------------------------------------------------------------------
## eel_year 
##        n  missing distinct     Info     Mean      Gmd      .05      .10 
##    12365        0      115    0.997     2010    7.506     2001     2002 
##      .25      .50      .75      .90      .95 
##     2006     2011     2015     2017     2018 
## 
## lowest : 1905 1906 1907 1908 1909, highest: 2015 2016 2017 2018 2019
## ---------------------------------------------------------------------------
## eel_month 
##        n  missing distinct 
##    12365        0       15 
## 
## APR (1008, 0.082), AUG (1084, 0.088), Dec (1, 0.000), DEC (974, 0.079),
## FEB (834, 0.067), JAN (849, 0.069), JUL (1110, 0.090), JUN (1080, 0.087),
## MAR (891, 0.072), MAY (1023, 0.083), NOV (1099, 0.089), OCT (1060, 0.086),
## REMAIN YEAR (213, 0.017), SEP (1029, 0.083), WHOLE YEAR (110, 0.009)
## ---------------------------------------------------------------------------
## eel_value 
##         n   missing  distinct      Info      Mean       Gmd       .05 
##     12327        38      6148      0.99      7052     13297     0.000 
##       .10       .25       .50       .75       .90       .95 
##     0.000     2.605   111.200   970.200  4964.700 22502.220 
## 
## lowest :      0.000      0.025      0.050      0.080      0.100
## highest: 667428.571 680000.000 701015.873 704158.730 805841.270
## ---------------------------------------------------------------------------
## eel_missvaluequal 
##        n  missing distinct 
##       39    12326        3 
##                             
## Value         ND    NM    NP
## Frequency      9    19    11
## Proportion 0.231 0.487 0.282
## ---------------------------------------------------------------------------
## eel_emu_nameshort 
##        n  missing distinct 
##    12365        0       46 
## 
## lowest : DE_Eide  DE_Elbe  DE_Schl  DE_Warn  DK_total
## highest: PL_Oder  PL_Vist  SE_East  SE_Inla  SE_West 
## ---------------------------------------------------------------------------
## eel_cou_code 
##        n  missing distinct 
##    12365        0       12 
##                                                                       
## Value         DE    DK    ES    FI    FR    GB    HR    IE    NL    NO
## Frequency   2058   464  1074    96  3947  2452    72    35   430   217
## Proportion 0.166 0.038 0.087 0.008 0.319 0.198 0.006 0.003 0.035 0.018
##                       
## Value         PL    SE
## Frequency    702   818
## Proportion 0.057 0.066
## ---------------------------------------------------------------------------
## eel_lfs_code 
##        n  missing distinct 
##    12365        0        4 
##                                   
## Value          G     S     Y    YS
## Frequency   2198  2921  3926  3320
## Proportion 0.178 0.236 0.318 0.268
## ---------------------------------------------------------------------------
## eel_hty_code 
##        n  missing distinct 
##    12365        0        7 
##                                                     
## Value          C     F    FT   FTC    MO     T    TC
## Frequency   1927  3441    12  1350   464  4532   639
## Proportion 0.156 0.278 0.001 0.109 0.038 0.367 0.052
## ---------------------------------------------------------------------------
## eel_area_division 
##        n  missing distinct 
##     4817     7548       12 
##                                                                       
## Value         27.3.a 27.3.b, c    27.3.d    27.4.b    27.4.c    27.7.a
## Frequency        460       728      1176       816       171       152
## Proportion     0.095     0.151     0.244     0.169     0.035     0.032
##                                                                       
## Value         27.7.d    27.7.e    27.8.c    27.9.a    37.1.1    37.2.1
## Frequency         86        82       404       257       413        72
## Proportion     0.018     0.017     0.084     0.053     0.086     0.015
## ---------------------------------------------------------------------------
## eel_comment 
##        n  missing distinct 
##     2371     9994       30 
## 
## lowest : 27.4.a also included                                                                                                                       All marine areas                                                                                                                           All marine areas. Preliminary data                                                                                                         area information is incomplete, but almost everything is from Ivc                                                                          Bristol Channel                                                                                                                           
## highest: total landings of one fisherman were reported monthly. But proportion of silvereel of total landings were only provided as a total (120kg) total landings of one fisherman were reported monthy. But proportion of silvereel of total landings were only provided as a total (100kg)  Two days fished using one fyke net (AUG). No eels caught                                                                                   two fishermen only reported yearly catch for yellow and silver eel combined which are excluded (total of 15kg in 2009)                     Vessels of the Nalón stop from February 17 to March 18, 2011.                                                                             
## ---------------------------------------------------------------------------
## source 
##        n  missing distinct 
##    12365        0       12 
## 
## lowest : DE_commercial_landings DK_commercial_landings ES_commercial_landings FL_commercial_landings FR_commercial_landings
## highest: IE_commercial_landings NL_commercial_landings NO_commercial_landings PL_commercial_landings SE_commercial_landings
## ---------------------------------------------------------------------------
## country 
##        n  missing distinct 
##    12365        0       12 
##                                                                       
## Value         DE    DK    ES    FL    FR    GB    HR    IE    NL    NO
## Frequency   2058   464  1074    96  3947  2452    72    35   430   217
## Proportion 0.166 0.038 0.087 0.008 0.319 0.198 0.006 0.003 0.035 0.018
##                       
## Value         PL    SE
## Frequency    702   818
## Proportion 0.057 0.066
## ---------------------------------------------------------------------------
## datasource 
##              n        missing       distinct          value 
##          12365              0              1 wkeelmigration 
##                          
## Value      wkeelmigration
## Frequency           12365
## Proportion              1
## ---------------------------------------------------------------------------
```

```r
# All ND, NP or NM
print(res[is.na(res$eel_value),],n=40)
```

```
## # A tibble: 38 x 14
##    eel_typ_name eel_year eel_month eel_value eel_missvaluequ~
##    <chr>           <dbl> <chr>         <dbl> <chr>           
##  1 com_landing~     2000 WHOLE YE~        NA NM              
##  2 com_landing~     2001 WHOLE YE~        NA NM              
##  3 com_landing~     2002 WHOLE YE~        NA NM              
##  4 com_landing~     2003 WHOLE YE~        NA NM              
##  5 com_landing~     2004 WHOLE YE~        NA NM              
##  6 com_landing~     2005 WHOLE YE~        NA NM              
##  7 com_landing~     2006 WHOLE YE~        NA NM              
##  8 com_landing~     2007 WHOLE YE~        NA NM              
##  9 com_landing~     2008 WHOLE YE~        NA NM              
## 10 com_landing~     2000 WHOLE YE~        NA NM              
## 11 com_landing~     2001 WHOLE YE~        NA NM              
## 12 com_landing~     2002 WHOLE YE~        NA NM              
## 13 com_landing~     2003 WHOLE YE~        NA NM              
## 14 com_landing~     2004 WHOLE YE~        NA NM              
## 15 com_landing~     2005 WHOLE YE~        NA NM              
## 16 com_landing~     2006 WHOLE YE~        NA NM              
## 17 com_landing~     2007 WHOLE YE~        NA NM              
## 18 com_landing~     2008 WHOLE YE~        NA NM              
## 19 com_landing~     2000 WHOLE YE~        NA ND              
## 20 com_landing~     2001 WHOLE YE~        NA ND              
## 21 com_landing~     2002 WHOLE YE~        NA ND              
## 22 com_landing~     2003 WHOLE YE~        NA ND              
## 23 com_landing~     2004 WHOLE YE~        NA ND              
## 24 com_landing~     2005 WHOLE YE~        NA ND              
## 25 com_landing~     2006 WHOLE YE~        NA ND              
## 26 com_landing~     2007 WHOLE YE~        NA ND              
## 27 com_landing~     2008 WHOLE YE~        NA ND              
## 28 com_landing~     2009 WHOLE YE~        NA NP              
## 29 com_landing~     2010 WHOLE YE~        NA NP              
## 30 com_landing~     2011 WHOLE YE~        NA NP              
## 31 com_landing~     2012 WHOLE YE~        NA NP              
## 32 com_landing~     2013 WHOLE YE~        NA NP              
## 33 com_landing~     2014 WHOLE YE~        NA NP              
## 34 com_landing~     2015 WHOLE YE~        NA NP              
## 35 com_landing~     2016 WHOLE YE~        NA NP              
## 36 com_landing~     2017 WHOLE YE~        NA NP              
## 37 com_landing~     2018 WHOLE YE~        NA NP              
## 38 com_landing~     2019 WHOLE YE~        NA NP              
## # ... with 9 more variables: eel_emu_nameshort <chr>, eel_cou_code <chr>,
## #   eel_lfs_code <chr>, eel_hty_code <chr>, eel_area_division <chr>,
## #   eel_comment <chr>, source <chr>, country <chr>, datasource <chr>
```

```r
# removing those rows
res <- res[!is.na(res$eel_value),]
nrow(res) 
```

```
## [1] 12327
```

```r
unique(res$eel_month)
```

```
##  [1] "JAN"         "FEB"         "MAR"         "APR"         "MAY"        
##  [6] "JUN"         "JUL"         "AUG"         "SEP"         "OCT"        
## [11] "NOV"         "DEC"         "WHOLE YEAR"  "REMAIN YEAR" "Dec"
```

```r
res$eel_month <- tolower(res$eel_month)
# removing whole year and missing year
resw <- res[res$eel_month%in%c("whole year"),]
print(resw)
```

```
## # A tibble: 72 x 14
##    eel_typ_name eel_year eel_month eel_value eel_missvaluequ~
##    <chr>           <dbl> <chr>         <dbl> <chr>           
##  1 com_landing~     2001 whole ye~   30402   <NA>            
##  2 com_landing~     2000 whole ye~   35489   <NA>            
##  3 com_landing~     2014 whole ye~     138.  <NA>            
##  4 com_landing~     2014 whole ye~    6233.  <NA>            
##  5 com_landing~     2014 whole ye~    5626.  <NA>            
##  6 com_landing~     2014 whole ye~      33.9 <NA>            
##  7 com_landing~     2015 whole ye~      17   <NA>            
##  8 com_landing~     2015 whole ye~     106.  <NA>            
##  9 com_landing~     2015 whole ye~    1301.  <NA>            
## 10 com_landing~     2015 whole ye~    1378.  <NA>            
## # ... with 62 more rows, and 9 more variables: eel_emu_nameshort <chr>,
## #   eel_cou_code <chr>, eel_lfs_code <chr>, eel_hty_code <chr>,
## #   eel_area_division <chr>, eel_comment <chr>, source <chr>,
## #   country <chr>, datasource <chr>
```

```r
# ONLY GB_Neag and this is whole_year not remain year
resr <- res[res$eel_month%in%c("remain year"),]
print(resr)
```

```
## # A tibble: 213 x 14
##    eel_typ_name eel_year eel_month eel_value eel_missvaluequ~
##    <chr>           <dbl> <chr>         <dbl> <chr>           
##  1 com_landing~     1922 remain y~    419000 <NA>            
##  2 com_landing~     1923 remain y~    172000 <NA>            
##  3 com_landing~     1924 remain y~    190000 <NA>            
##  4 com_landing~     1925 remain y~    137000 <NA>            
##  5 com_landing~     1926 remain y~    173000 <NA>            
##  6 com_landing~     1927 remain y~    148000 <NA>            
##  7 com_landing~     1928 remain y~    187000 <NA>            
##  8 com_landing~     1929 remain y~     88000 <NA>            
##  9 com_landing~     1930 remain y~    146000 <NA>            
## 10 com_landing~     1931 remain y~    227000 <NA>            
## # ... with 203 more rows, and 9 more variables: eel_emu_nameshort <chr>,
## #   eel_cou_code <chr>, eel_lfs_code <chr>, eel_hty_code <chr>,
## #   eel_area_division <chr>, eel_comment <chr>, source <chr>,
## #   country <chr>, datasource <chr>
```

```r
res <-res[!res$eel_month%in%c("whole year", "remain year"),]
# recode the month
res$eel_month <- recode(res$eel_month, 
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
Hmisc::describe(res$eel_month)
```

```
## res$eel_month 
##        n  missing distinct     Info     Mean      Gmd      .05      .10 
##    12042        0       12    0.993    6.719     3.86        1        2 
##      .25      .50      .75      .90      .95 
##        4        7       10       11       12 
##                                                                       
## Value          1     2     3     4     5     6     7     8     9    10
## Frequency    849   834   891  1008  1023  1080  1110  1084  1029  1060
## Proportion 0.071 0.069 0.074 0.084 0.085 0.090 0.092 0.090 0.085 0.088
##                       
## Value         11    12
## Frequency   1099   975
## Proportion 0.091 0.081
```

```r
# number of data per emu
#res %>% mutate("freq"=1) %>% filter(eel_year>2000 & eel_year<2019) %>%
#xtabs ( formula=freq ~ eel_year + eel_month +eel_emu_nameshort)


res <- res[order(res$eel_typ_name,res$eel_emu_nameshort, res$eel_year, res$eel_month,res$eel_lfs_code,res$eel_hty_code),]
res$id <- 1:nrow(res)

# some of the data have more than two rows per month per year, it's OK for germany but there is a problem with the
# Polish file
res %>% mutate("freq"=1) %>% filter(eel_year>2000 & eel_year<2019) %>%
		xtabs ( formula=freq ~ eel_year + eel_month +eel_emu_nameshort +eel_lfs_code)%>%
		as.data.frame() %>% filter(Freq>2)%>% kable()%>% kable_styling() %>%
		scroll_box(width = "500px", height = "200px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:200px; overflow-x: scroll; width:500px; "><table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_year </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_month </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_emu_nameshort </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_lfs_code </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Freq </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Eide </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 25 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 15 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 24 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 26 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 15 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> PL_Oder </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> PL_Vist </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> PL_Vist </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> PL_Vist </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> PL_Vist </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> PL_Vist </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> PL_Vist </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
</tbody>
</table></div>

```r
# temporarily dropping those files
res <-res%>%filter(!eel_emu_nameshort%in% c('PL_Oder','PL_Vist'))

# SEARCHING FOR DUPLICATES-----------------------------------------------------------

duplicates <- res %>% mutate("freq"=1) %>% filter(eel_year>2000 & eel_year<2019) %>%
		xtabs ( formula=freq ~ eel_year + eel_month +eel_emu_nameshort +eel_lfs_code+eel_hty_code+eel_typ_name)%>%
		as.data.frame() %>% filter(Freq>1)

kable(duplicates)%>% kable_styling() %>%
		scroll_box(width = "500px", height = "200px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:200px; overflow-x: scroll; width:500px; "><table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_year </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_month </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_emu_nameshort </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_lfs_code </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_hty_code </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_typ_name </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Freq </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Murc </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Murc </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Murc </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> IE_West </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> IE_West </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> IE_West </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> IE_West </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> SE_Inla </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> IE_West </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> IE_West </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> IE_West </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> IE_West </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> IE_West </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> IE_West </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> IE_West </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Cata </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> FI_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> FI_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> FI_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> FI_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> FI_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> FI_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> FI_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> FI_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_landings_kg </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
</tbody>
</table></div>

```r
# =>DUPLICATED VALUES SENT TO ESTI ...

colnames(res) <-gsub("eel_","",colnames(res))


# COMMERCIAL AND RECREATIONAL -----------------------------------------------------------

# The only recreational landings there are the boat fishery for glass eel in Spain
# I'm not using the type, we'll work with both commercial and recreational as a single category.

res %>% filter(typ_name=="rec_landings_kg") %>% select(emu_nameshort) %>% distinct()
```



<table>
 <thead>
  <tr>
   <th style="text-align:left;"> emu_nameshort </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> ES_Basq </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ES_Cata </td>
  </tr>
</tbody>
</table>

```r
# Currently I have what I have identified as duplicates, since I'm calculating percentage I do the sum

res1 <- 	res %>%	group_by(emu_nameshort,lfs_code,hty_code,year,month) %>% 
		summarize(value=sum(value))


unique(res$emu_nameshort)
```

```
##  [1] "DE_Eide"  "DE_Elbe"  "DE_Schl"  "DE_Warn"  "DK_total" "ES_Astu" 
##  [7] "ES_Cant"  "ES_Cata"  "ES_Gali"  "ES_Mino"  "ES_Murc"  "ES_Vale" 
## [13] "FI_total" "FR_Adou"  "FR_Arto"  "FR_Bret"  "FR_Cors"  "FR_Garo" 
## [19] "FR_Loir"  "FR_Rhin"  "FR_Rhon"  "FR_Sein"  "GB_Angl"  "GB_Dee"  
## [25] "GB_Humb"  "GB_Nort"  "GB_NorW"  "GB_Seve"  "GB_SouE"  "GB_SouW" 
## [31] "GB_Tham"  "GB_total" "GB_Wale"  "HR_total" "IE_East"  "IE_West" 
## [37] "NL_total" "NO_total" "SE_East"  "SE_Inla"  "SE_West"  "ES_Basq"
```

```r
unique(res$hty_code)
```

```
## [1] "C"   "F"   "T"   "MO"  "FTC" "FT"  "TC"
```

```r
table(res$hty_code)
```



<table>
 <thead>
  <tr>
   <th style="text-align:right;"> C </th>
   <th style="text-align:right;"> F </th>
   <th style="text-align:right;"> FT </th>
   <th style="text-align:right;"> FTC </th>
   <th style="text-align:right;"> MO </th>
   <th style="text-align:right;"> T </th>
   <th style="text-align:right;"> TC </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1776 </td>
   <td style="text-align:right;"> 3173 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1341 </td>
   <td style="text-align:right;"> 464 </td>
   <td style="text-align:right;"> 4384 </td>
   <td style="text-align:right;"> 199 </td>
  </tr>
</tbody>
</table>

```r
# there are only three lines with hty code 'FT' in Ireland, I'm correcting them to F
res$hty_code[res$hty_code=='FT'] <- 'F'

# Now I don't remember why we put this  :it's fortunate that we don't use that in a dabase. 
# How will we ever treat those categories ?
# "FTC" "FT"  "TC" 

unique(res$lfs_code) # OK
```

```
## [1] "S"  "Y"  "YS" "G"
```





# Silver eels


```r
fnplot <- function(emu, lfs, hty,colfill="grey10"){
	res2 <- res %>% 
			filter(emu_nameshort==emu,
					lfs_code==lfs,
					hty_code %in% hty) %>%
			group_by(emu_nameshort,year,month)%>%
			summarize(value=sum(value))
	
	res3 <- left_join (res2,					
					res2 %>% group_by(emu_nameshort,year)%>%		
							summarize(sum_per_year=sum(value,na.rm=TRUE)),
					by = c("emu_nameshort","year")) %>%	
			mutate(perc_per_month=100*value/sum_per_year) 
	
	if (nrow(res3)>1){
		
		g <- ggplot(res3,aes(x = month)) +
				geom_col(aes(y=perc_per_month),fill=colfill,color="black")+
				xlab("month")+
				ylab("percentage catch")+
				facet_wrap(~year)+
				theme_bw()+
				ggtitle(str_c("Percentage per month ",emu, " ", lfs," ",paste0(hty,collapse="+")))
		
		print(g)
	}
}


for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'S',
			hty = c("C","TC","T"),
			emu=the_emu)
}
```

![](landings_seasonality_files/figure-html/s-1.png)<!-- -->![](landings_seasonality_files/figure-html/s-2.png)<!-- -->![](landings_seasonality_files/figure-html/s-3.png)<!-- -->![](landings_seasonality_files/figure-html/s-4.png)<!-- -->![](landings_seasonality_files/figure-html/s-5.png)<!-- -->![](landings_seasonality_files/figure-html/s-6.png)<!-- -->

```
## Warning: Removed 26 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/s-7.png)<!-- -->

```
## Warning: Removed 39 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/s-8.png)<!-- -->

```
## Warning: Removed 30 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/s-9.png)<!-- -->

```
## Warning: Removed 9 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/s-10.png)<!-- -->![](landings_seasonality_files/figure-html/s-11.png)<!-- -->

```
## Warning: Removed 31 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/s-12.png)<!-- -->

```
## Warning: Removed 7 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/s-13.png)<!-- -->![](landings_seasonality_files/figure-html/s-14.png)<!-- -->![](landings_seasonality_files/figure-html/s-15.png)<!-- -->

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'S',
			hty = c("F"),
			emu=the_emu, 
			colfill= "navyblue")	
}
```

![](landings_seasonality_files/figure-html/s-16.png)<!-- -->![](landings_seasonality_files/figure-html/s-17.png)<!-- -->![](landings_seasonality_files/figure-html/s-18.png)<!-- -->![](landings_seasonality_files/figure-html/s-19.png)<!-- -->![](landings_seasonality_files/figure-html/s-20.png)<!-- -->![](landings_seasonality_files/figure-html/s-21.png)<!-- -->![](landings_seasonality_files/figure-html/s-22.png)<!-- -->![](landings_seasonality_files/figure-html/s-23.png)<!-- -->![](landings_seasonality_files/figure-html/s-24.png)<!-- -->

```
## Warning: Removed 9 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/s-25.png)<!-- -->

```
## Warning: Removed 8 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/s-26.png)<!-- -->![](landings_seasonality_files/figure-html/s-27.png)<!-- -->![](landings_seasonality_files/figure-html/s-28.png)<!-- -->![](landings_seasonality_files/figure-html/s-29.png)<!-- -->![](landings_seasonality_files/figure-html/s-30.png)<!-- -->![](landings_seasonality_files/figure-html/s-31.png)<!-- -->

# Glass eel


```r
res %>% filter(lfs_code=="G") %>% select(hty_code) %>% distinct()
```



<table>
 <thead>
  <tr>
   <th style="text-align:left;"> hty_code </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> T </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FTC </td>
  </tr>
</tbody>
</table>

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'G',
			hty = c("T"),
			emu=the_emu, 
			colfill= "tomato1")	
}
```

![](landings_seasonality_files/figure-html/g-1.png)<!-- -->![](landings_seasonality_files/figure-html/g-2.png)<!-- -->![](landings_seasonality_files/figure-html/g-3.png)<!-- -->![](landings_seasonality_files/figure-html/g-4.png)<!-- -->![](landings_seasonality_files/figure-html/g-5.png)<!-- -->![](landings_seasonality_files/figure-html/g-6.png)<!-- -->![](landings_seasonality_files/figure-html/g-7.png)<!-- -->![](landings_seasonality_files/figure-html/g-8.png)<!-- -->![](landings_seasonality_files/figure-html/g-9.png)<!-- -->![](landings_seasonality_files/figure-html/g-10.png)<!-- -->![](landings_seasonality_files/figure-html/g-11.png)<!-- -->![](landings_seasonality_files/figure-html/g-12.png)<!-- -->

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'G',
			hty = c("F"),
			emu=the_emu, 
			colfill= "violetred")	
}
```

![](landings_seasonality_files/figure-html/g-13.png)<!-- -->![](landings_seasonality_files/figure-html/g-14.png)<!-- -->![](landings_seasonality_files/figure-html/g-15.png)<!-- -->

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'G',
			hty = c("FTC"),
			emu=the_emu, 
			colfill= "firebrick")	
}
```

![](landings_seasonality_files/figure-html/g-16.png)<!-- -->![](landings_seasonality_files/figure-html/g-17.png)<!-- -->![](landings_seasonality_files/figure-html/g-18.png)<!-- -->![](landings_seasonality_files/figure-html/g-19.png)<!-- -->


# Yellow


```r
res %>% filter(lfs_code=="Y") %>% select(hty_code) %>% distinct()
```



<table>
 <thead>
  <tr>
   <th style="text-align:left;"> hty_code </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> C </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MO </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FTC </td>
  </tr>
</tbody>
</table>

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'Y',
			hty = c("C"),
			emu=the_emu, 
			colfill= "green")	
}
```

![](landings_seasonality_files/figure-html/y-1.png)<!-- -->![](landings_seasonality_files/figure-html/y-2.png)<!-- -->![](landings_seasonality_files/figure-html/y-3.png)<!-- -->![](landings_seasonality_files/figure-html/y-4.png)<!-- -->

```
## Warning: Removed 20 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/y-5.png)<!-- -->

```
## Warning: Removed 39 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/y-6.png)<!-- -->

```
## Warning: Removed 8 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/y-7.png)<!-- -->![](landings_seasonality_files/figure-html/y-8.png)<!-- -->![](landings_seasonality_files/figure-html/y-9.png)<!-- -->

```
## Warning: Removed 31 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/y-10.png)<!-- -->

```
## Warning: Removed 7 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/y-11.png)<!-- -->![](landings_seasonality_files/figure-html/y-12.png)<!-- -->![](landings_seasonality_files/figure-html/y-13.png)<!-- -->

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'Y',
			hty = c("F"),
			emu=the_emu, 
			colfill= "greenyellow")	
}
```

![](landings_seasonality_files/figure-html/y-14.png)<!-- -->![](landings_seasonality_files/figure-html/y-15.png)<!-- -->![](landings_seasonality_files/figure-html/y-16.png)<!-- -->![](landings_seasonality_files/figure-html/y-17.png)<!-- -->![](landings_seasonality_files/figure-html/y-18.png)<!-- -->![](landings_seasonality_files/figure-html/y-19.png)<!-- -->![](landings_seasonality_files/figure-html/y-20.png)<!-- -->![](landings_seasonality_files/figure-html/y-21.png)<!-- -->![](landings_seasonality_files/figure-html/y-22.png)<!-- -->![](landings_seasonality_files/figure-html/y-23.png)<!-- -->![](landings_seasonality_files/figure-html/y-24.png)<!-- -->![](landings_seasonality_files/figure-html/y-25.png)<!-- -->![](landings_seasonality_files/figure-html/y-26.png)<!-- -->![](landings_seasonality_files/figure-html/y-27.png)<!-- -->

```
## Warning: Removed 8 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/y-28.png)<!-- -->![](landings_seasonality_files/figure-html/y-29.png)<!-- -->![](landings_seasonality_files/figure-html/y-30.png)<!-- -->![](landings_seasonality_files/figure-html/y-31.png)<!-- -->![](landings_seasonality_files/figure-html/y-32.png)<!-- -->![](landings_seasonality_files/figure-html/y-33.png)<!-- -->![](landings_seasonality_files/figure-html/y-34.png)<!-- -->

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'Y',
			hty = c("T"),
			emu=the_emu, 
			colfill= "limegreen")	
}
```

![](landings_seasonality_files/figure-html/y-35.png)<!-- -->![](landings_seasonality_files/figure-html/y-36.png)<!-- -->

```
## Warning: Removed 12 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/y-37.png)<!-- -->

```
## Warning: Removed 72 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/y-38.png)<!-- -->![](landings_seasonality_files/figure-html/y-39.png)<!-- -->![](landings_seasonality_files/figure-html/y-40.png)<!-- -->![](landings_seasonality_files/figure-html/y-41.png)<!-- -->![](landings_seasonality_files/figure-html/y-42.png)<!-- -->

```
## Warning: Removed 60 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/y-43.png)<!-- -->

```
## Warning: Removed 6 rows containing missing values (position_stack).
```

![](landings_seasonality_files/figure-html/y-44.png)<!-- -->![](landings_seasonality_files/figure-html/y-45.png)<!-- -->

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'Y',
			hty = c("MO"),
			emu=the_emu, 
			colfill= "olivedrab")	
}
```

![](landings_seasonality_files/figure-html/y-46.png)<!-- -->

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'Y',
			hty = c("FTC"),
			emu=the_emu, 
			colfill= "springgreen")	
}
```

![](landings_seasonality_files/figure-html/y-47.png)<!-- -->![](landings_seasonality_files/figure-html/y-48.png)<!-- -->![](landings_seasonality_files/figure-html/y-49.png)<!-- -->![](landings_seasonality_files/figure-html/y-50.png)<!-- -->![](landings_seasonality_files/figure-html/y-51.png)<!-- -->![](landings_seasonality_files/figure-html/y-52.png)<!-- -->![](landings_seasonality_files/figure-html/y-53.png)<!-- -->![](landings_seasonality_files/figure-html/y-54.png)<!-- -->![](landings_seasonality_files/figure-html/y-55.png)<!-- -->![](landings_seasonality_files/figure-html/y-56.png)<!-- -->

# Yellow silver


```r
res %>% filter(lfs_code=="YS") %>% select(hty_code) %>% distinct()
```



<table>
 <thead>
  <tr>
   <th style="text-align:left;"> hty_code </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> C </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FTC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TC </td>
  </tr>
</tbody>
</table>

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'YS',
			hty = c("C"),
			emu=the_emu, 
			colfill= "plum")	
}
```

![](landings_seasonality_files/figure-html/ys-1.png)<!-- -->![](landings_seasonality_files/figure-html/ys-2.png)<!-- -->![](landings_seasonality_files/figure-html/ys-3.png)<!-- -->![](landings_seasonality_files/figure-html/ys-4.png)<!-- -->

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'YS',
			hty = c("F"),
			emu=the_emu, 
			colfill= "purple")	
}
```

![](landings_seasonality_files/figure-html/ys-5.png)<!-- -->![](landings_seasonality_files/figure-html/ys-6.png)<!-- -->![](landings_seasonality_files/figure-html/ys-7.png)<!-- -->![](landings_seasonality_files/figure-html/ys-8.png)<!-- -->![](landings_seasonality_files/figure-html/ys-9.png)<!-- -->![](landings_seasonality_files/figure-html/ys-10.png)<!-- -->![](landings_seasonality_files/figure-html/ys-11.png)<!-- -->![](landings_seasonality_files/figure-html/ys-12.png)<!-- -->

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'YS',
			hty = c("T"),
			emu=the_emu, 
			colfill= "magenta")	
}
```

![](landings_seasonality_files/figure-html/ys-13.png)<!-- -->![](landings_seasonality_files/figure-html/ys-14.png)<!-- -->![](landings_seasonality_files/figure-html/ys-15.png)<!-- -->![](landings_seasonality_files/figure-html/ys-16.png)<!-- -->![](landings_seasonality_files/figure-html/ys-17.png)<!-- -->![](landings_seasonality_files/figure-html/ys-18.png)<!-- -->![](landings_seasonality_files/figure-html/ys-19.png)<!-- -->![](landings_seasonality_files/figure-html/ys-20.png)<!-- -->![](landings_seasonality_files/figure-html/ys-21.png)<!-- -->![](landings_seasonality_files/figure-html/ys-22.png)<!-- -->

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'YS',
			hty = c("FTC"),
			emu=the_emu, 
			colfill= "violet")	
}
```

![](landings_seasonality_files/figure-html/ys-23.png)<!-- -->

```r
for (the_emu in unique(res$emu_nameshort)){
	fnplot(lfs = 'YS',
			hty = c("TC"),
			emu=the_emu, 
			colfill= "hotpink")	
}
```

![](landings_seasonality_files/figure-html/ys-24.png)<!-- -->
