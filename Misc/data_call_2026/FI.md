-----------------------------------------------------------
# FI
-----------------------------------------------------------

## Annex 1 :done

### series

New series, be sure to set qal_id zero

### dataseries

3 modified (I removed effort = 1)
1 new

### group metrics

1 and 6 new values inserted in the group and metric tables

### individual metrics

 8 and 64 new values inserted in the fish and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             8     
Number of columns          17    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  11    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment                8             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou                 8             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2024-08-20 2024-10-07 2024-09-13        7
2 fi_lastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate        mean     sd         p0        p25        p50        p75       p100 hist 
 1 fi_id                                                         0             1 4608654.     2.45  4608650    4608652.   4608654.   4608655.   4608657    ▇▃▇▃▇
 2 fi_year                                                       0             1    2024      0        2024       2024       2024       2024       2024    ▁▁▇▁▁
 3 fiser_ser_id                                                  0             1     487      0         487        487        487        487        487    ▁▁▇▁▁
 4 lengthmm                                                      0             1     368.    46.8       316        321.       364        418.       421    ▇▂▂▁▇
 5 weightg                                                       0             1      75.6   38.0        34         34.8       79        105.       129    ▇▁▅▂▅
 6 eye_diam_meanmm                                               0             1       5.16   1.27        3.70       3.97       5.17       6.08       6.96 ▇▂▂▂▅
 7 pectoral_lengthmm                                             0             1      16.3    3.53       10.8       14.1       16.5       18.3       22.0  ▂▇▁▇▂
 8 differentiated_proportion                                     0             1       0      0           0          0          0          0          0    ▁▁▇▁▁
 9 anguillicola_intensity                                        0             1       2      4.87        0          0          0          1         14    ▇▁▁▁▁
10 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0             1       0      0           0          0          0          0          0    ▁▁▇▁▁
11 anguillicola_proportion                                       0             1       0.375  0.518       0          0          0          1          1    ▇▁▁▁▅



## Annex 2 :pending

### series

New series integrated : TaivY	Taivassalo coast

### dataseries

question sent

17 new values inserted in the database

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             17    
Number of columns          10    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment               14         0.176  17  39     0        3          0
2 das_dts_datasource         0         1       7   7     0        1          0
3 das_qal_comment           17         0      NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate      mean       sd        p0       p25   p50     p75  p100 hist 
1 das_id                0         1     10625        5.05  10617     10621     10625 10629   10633 ▇▆▆▆▇
2 das_value            14         0.176    24       26.0       9         9         9    31.5    54 ▇▁▁▁▃
3 das_ser_id            0         1       452.      41.1     405       405       483   483     507 ▆▁▁▇▁
4 das_year              0         1      2021.       3.11   2016      2019      2021  2023    2025 ▆▃▇▇▇
5 das_effort           14         0.176  1133.    1960.        0.593     0.796     1  1698.   3396 ▇▁▁▁▃
6 das_qal_id            1         0.941     0.188    0.403     0         0         0     0       1 ▇▁▁▁▂

### group metrics

question sent on proportions >1 evex

 3 and 24 new values inserted in the group and metric tables

### individual metrics

 41 and 294 new values inserted in the fish and metric tables
 
 [1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             41    
Number of columns          18    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  12    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment               41             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou                41             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2025-04-27 2025-10-12 2025-05-07        6
2 fi_lastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate        mean      sd         p0       p25       p50        p75      p100 hist 
 1 fi_id                                                         0         1     4610842      12.0   4610822    4610832   4610842   4610852    4610862   ▇▇▇▇▇
 2 fi_year                                                       0         1        2025       0        2025       2025      2025      2025       2025   ▁▁▇▁▁
 3 fiser_ser_id                                                  0         1         428.     39.2       406        406       406       406        507   ▇▁▁▁▁
 4 lengthmm                                                      0         1         884.     78.5       719        824       878       949       1007   ▂▇▇▇▇
 5 weightg                                                       0         1        1334.    366.        553       1032      1372      1620       1955   ▃▇▆▆▆
 6 eye_diam_meanmm                                               0         1          11.0     1.25        8.48      10.1      10.6      11.7       14.2 ▂▇▆▃▁
 7 pectoral_lengthmm                                             0         1          44.7     4.98       35.8       41.3      45.0      48.5       54.7 ▅▅▇▅▃
 8 anguillicola_intensity                                       25         0.390       5.06    9.41        0          0         1         2.25      27   ▇▁▁▁▁
 9 method_sex_(1=visual,0=use_length)                            0         1           0       0           0          0         0         0          0   ▁▁▇▁▁
10 method_anguillicola_(1=stereomicroscope,0=visual_obs)        25         0.390       0       0           0          0         0         0          0   ▁▁▇▁▁
11 female_proportion                                             0         1           1       0           1          1         1         1          1   ▁▁▇▁▁
12 anguillicola_proportion                                      25         0.390       0.562   0.512       0          0         1         1          1   ▆▁▁▁▇

## Annex 3 : done

### series

### dataseries

#### modified

10 values updated in the db
(I changed effort values)
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             10    
Number of columns          10    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment                0             1  60  60     0        1          0
2 das_dts_datasource         0             1   7   7     0        4          0
3 das_qal_comment           10             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean     sd   p0   p25   p50   p75 p100 hist   
1 das_id                0             1 7477  774.   7033 7035. 7038. 7694. 9203 "▇▁▁▁▁"
2 das_value             0             1  357  157.    175  222.  354   415.  662 "▇▅▇▂▂"
3 das_ser_id            0             1  412    0     412  412   412   412   412 "▁▁▇▁▁"
4 das_year              0             1 2018.   3.03 2014 2016. 2018. 2021. 2023 "▇▇▇▇▇"
5 das_effort           10             0  NaN   NA      NA   NA    NA    NA    NA " "    
6 das_qal_id            0             1    1    0       1    1     1     1     1 "▁▁▇▁▁"

#### new

2 rows

### group metrics

#### modified

 2 and 14 new values modified in the group and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2     
Number of columns          14    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  11    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                2             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate  mean     sd    p0    p25   p50   p75  p100 hist 
 1 gr_id                                      0             1 5784.  0.707 5784  5784.  5784. 5785. 5785  ▇▁▁▁▇
 2 gr_year                                    0             1 2024   0     2024  2024   2024  2024  2024  ▁▁▇▁▁
 3 gr_number                                  0             1  102. 91.2     37    69.2  102.  134.  166  ▇▁▁▁▇
 4 grser_ser_id                               0             1  412.  0.707  411   411.   412.  412.  412  ▇▁▁▁▇
 5 lengthmm                                   0             1  857. 31.6    835.  846.   857.  868.  879. ▇▁▁▁▇
 6 weightg                                    0             1 1186. 34.5   1161. 1173.  1186. 1198. 1210. ▇▁▁▁▇
 7 differentiated_proportion                  0             1    1   0        1     1      1     1     1  ▁▁▇▁▁
 8 f_mean_lengthmm                            0             1  857. 31.6    835.  846.   857.  868.  879. ▇▁▁▁▇
 9 f_mean_weightg                             0             1 1186. 34.5   1161. 1173.  1186. 1198. 1210. ▇▁▁▁▇
10 method_sex_(1=visual,0=use_length)         0             1    0   0        0     0      0     0     0  ▁▁▇▁▁
11 female_proportion                          0             1    1   0        1     1      1     1     1  ▁▁▇▁▁



#### new

 1 and 7 new values inserted in the group and metric tables
 
 [1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
Number of columns          14    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  11    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                1             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate  mean sd    p0   p25   p50   p75  p100 hist 
 1 gr_id                                      0             1 6862  NA 6862  6862  6862  6862  6862  ▁▁▇▁▁
 2 gr_year                                    0             1 2025  NA 2025  2025  2025  2025  2025  ▁▁▇▁▁
 3 gr_number                                  0             1   85  NA   85    85    85    85    85  ▁▁▇▁▁
 4 grser_ser_id                               0             1  412  NA  412   412   412   412   412  ▁▁▇▁▁
 5 lengthmm                                   0             1  891. NA  891.  891.  891.  891.  891. ▁▁▇▁▁
 6 weightg                                    0             1 1276. NA 1276. 1276. 1276. 1276. 1276. ▁▁▇▁▁
 7 differentiated_proportion                  0             1    1  NA    1     1     1     1     1  ▁▁▇▁▁
 8 f_mean_lengthmm                            0             1  891. NA  891.  891.  891.  891.  891. ▁▁▇▁▁
 9 f_mean_weightg                             0             1 1276. NA 1276. 1276. 1276. 1276. 1276. ▁▁▇▁▁
10 method_sex_(1=visual,0=use_length)         0             1    0  NA    0     0     0     0     0  ▁▁▇▁▁
11 female_proportion                          0             1    1  NA    1     1     1     1     1  ▁▁▇▁▁


### individual metrics

 

## Annex 4 :done


### duplicates

For duplicates 8 values replaced in the t_eelstock_ eel table (values from current datacall stored with code eel_qal_id 26)
0 values not replaced (values from current datacall stored with code eel_qal_id 26), 
Note : (I first inserted 8 wrong values from the wrong datacall file) 

[[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             16    
Number of columns          16    
_______________________          
Column type frequency:           
  character                10    
  Date                     1     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0           1     7   7     0        1          0
 2 eel_cou_code              0           1     2   2     0        1          0
 3 eel_lfs_code              0           1     1   1     0        3          0
 4 eel_hty_code              0           1     1   2     0        4          0
 5 eel_area_division        16           0    NA  NA     0        0          0
 6 eel_qal_comment           8           0.5  42  42     0        1          0
 7 eel_comment               8           0.5  34  34     0        1          0
 8 eel_missvaluequal         0           1     2   2     0        1          0
 9 eel_datasource            0           1     7   7     0        1          0
10 eel_dta_code              0           1     6   6     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean       sd     p0     p25      p50     p75   p100 hist   
1 eel_id                0             1 614272.  1463.    612851 612855. 614272.  615688. 615692 "▇▁▁▁▇"
2 eel_typ_id            0             1      4      0          4      4       4        4       4 "▁▁▇▁▁"
3 eel_year              0             1   2024.     0.516   2024   2024    2024.    2025    2025 "▇▁▁▁▇"
4 eel_value            16             0    NaN     NA         NA     NA      NA       NA      NA " "    
5 eel_qal_id            0             1     13.5   12.9        1      1      13.5     26      26 "▇▁▁▁▇"

#### new
 1 new values inserted in the database
 
#### updated

6 values updated in the db

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             12    
Number of columns          16    
_______________________          
Column type frequency:           
  character                10    
  Date                     1     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0        1        7   7     0        1          0
 2 eel_cou_code              0        1        2   2     0        1          0
 3 eel_lfs_code              0        1        2   2     0        1          0
 4 eel_hty_code              0        1        1   1     0        2          0
 5 eel_area_division         8        0.333    6   6     0        1          0
 6 eel_qal_comment           6        0.5     33  33     0        6          0
 7 eel_comment              11        0.0833  33  33     0        1          0
 8 eel_missvaluequal        11        0.0833   2   2     0        1          0
 9 eel_datasource            0        1        7   7     0        4          0
10 eel_dta_code              0        1        6   6     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean       sd     p0     p25      p50     p75   p100 hist 
1 eel_id                0         1     602109.  19038.   553540 599380. 607552.  615705. 615708 ▁▁▁▅▇
2 eel_typ_id            0         1          4       0         4      4       4        4       4 ▁▁▇▁▁
3 eel_year              0         1       2023.      1.11   2021   2022    2023     2024    2024 ▃▃▁▇▇
4 eel_value             1         0.917    454.    609.        0     47     306      518    2000 ▇▂▁▁▁
5 eel_qal_id            0         1         13.5    13.1       1      1      13.5     26      26 ▇▁▁▁▇


## Annex 5 

#### updated

3 values updated in the db

#### duplicates

no change => ignored

#### new

 2 new values inserted in the database
 
## Annex 6

Already integrated


## Annex 7

 6 new values inserted in the database

## Annex 8

no annex

## Annex 9

### samplinginfo


### group metrics


### individual metrics

