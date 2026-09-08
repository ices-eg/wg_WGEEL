-----------------------------------------------------------
# HR
-----------------------------------------------------------

## Annex 1 No


## Annex 2 No


## Annex 3 No

## Annex 4


#### new data

Note in the time series after 2023 you shift from Y to YS.
Is there are reason to change ?

> Commercial eel fishing in Croatia is restricted to the Neretva Delta and primarily targets silver eel, although some yellow eel may also be caught. More robust scientific monitoring started in 2022, and the fishery-dependent sampling data are reported under HR_Total_NeretvaDelta, within EMU_EAC (Eastern Adriatic Catchment).
> Therefore, the earlier reporting as Y only appears to be an inconsistency in the historical series rather than a change in the fishery. Please correct the historical data to YS as well.

 12 new values inserted in the database
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
 1 eel_emu_nameshort         0        1        8   8     0        1          0
 2 eel_cou_code              0        1        2   2     0        1          0
 3 eel_lfs_code              0        1        1   2     0        4          0
 4 eel_hty_code              0        1        1   2     0        4          0
 5 eel_area_division        11        0.0833   6   6     0        1          0
 6 eel_qal_comment          12        0       NA  NA     0        0          0
 7 eel_comment               5        0.583   34  34     0        1          0
 8 eel_missvaluequal         1        0.917    2   2     0        1          0
 9 eel_datasource            0        1        7   7     0        1          0
10 eel_dta_code              0        1        6   6     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean     sd      p0     p25     p50     p75    p100 hist 
1 eel_id                0        1      614238.  3.61  614232  614235. 614238. 614240. 614243  ▇▅▅▅▇
2 eel_typ_id            0        1           4   0          4       4       4       4       4  ▁▁▇▁▁
3 eel_year              0        1        2024.  0.515   2024    2024    2024    2025    2025  ▇▁▁▁▆
4 eel_value            11        0.0833    226. NA        226.    226.    226.    226.    226. ▁▁▇▁▁
5 eel_qal_id            0        1           1   0          1       1       1       1       1  ▁▁▇▁▁


#### updated data => historical series passed to YS

9 values updated in the db
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             18    
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
 1 eel_emu_nameshort         0           1     8   8     0        1          0
 2 eel_cou_code              0           1     2   2     0        1          0
 3 eel_lfs_code              0           1     1   2     0        2          0
 4 eel_hty_code              0           1     1   1     0        1          0
 5 eel_area_division         0           1     6   6     0        1          0
 6 eel_qal_comment           9           0.5  33  33     0        9          0
 7 eel_comment              18           0    NA  NA     0        0          0
 8 eel_missvaluequal        18           0    NA  NA     0        0          0
 9 eel_datasource            0           1     7   7     0        5          0
10 eel_dta_code              0           1     6   6     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean       sd      p0     p25      p50     p75    p100 hist 
1 eel_id                0             1 557063.  76253.   423057  553692. 597168   614260. 614264  ▃▁▁▃▇
2 eel_typ_id            0             1      4       0         4       4       4        4       4  ▁▁▇▁▁
3 eel_year              0             1   2018       2.66   2014    2016    2018     2020    2022  ▇▇▃▇▇
4 eel_value             0             1    448.    140.      149.    387.    460.     560.    610. ▂▁▇▅▇
5 eel_qal_id            0             1     13.5    12.9       1       1      13.5     26      26  ▇▁▁▁▇


## Annex 5

 10 new values inserted in the database

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             10    
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
 1 eel_emu_nameshort         0           1     8   8     0        1          0
 2 eel_cou_code              0           1     2   2     0        1          0
 3 eel_lfs_code              0           1     1   1     0        3          0
 4 eel_hty_code              0           1     1   2     0        4          0
 5 eel_area_division         8           0.2   6   6     0        1          0
 6 eel_qal_comment          10           0    NA  NA     0        0          0
 7 eel_comment               4           0.6  34  34     0        2          0
 8 eel_missvaluequal         2           0.8   2   2     0        1          0
 9 eel_datasource            0           1     7   7     0        1          0
10 eel_dta_code              0           1     6   6     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean    sd     p0     p25     p50     p75   p100 hist 
1 eel_id                0           1   613658. 3.03  613653 613655. 613658. 613660. 613662 ▇▇▇▇▇
2 eel_typ_id            0           1        6  0          6      6       6       6       6 ▁▁▇▁▁
3 eel_year              0           1     2025. 0.516   2024   2024    2025    2025    2025 ▅▁▁▁▇
4 eel_value             8           0.2      0  0          0      0       0       0       0 ▁▁▇▁▁


## Annex 6 No



## Annex 7 No


## Annex 8 No


## Annex 9

### samplinginfo


### group metrics

2 and 31 new values inserted in the group and metric tables
31 rows
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2     
Number of columns          24    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  20    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                1           0.5 124 124     0        1          0
2 gr_dts_datasource         0           1     7   7     0        1          0
3 grsa_lfs_code             0           1     2   2     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate     mean       sd       p0      p25      p50      p75    p100 hist 
 1 gr_id                                                         0           1   6716.      0.707  6716     6716.    6716.    6717.    6717    ▇▁▁▁▇
 2 gr_year                                                       0           1   2025       0      2025     2025     2025     2025     2025    ▁▁▇▁▁
 3 gr_number                                                     0           1    130.    128.       40       85.2    130.     176.     221    ▇▁▁▁▇
 4 grsa_sai_id                                                   0           1    856      33.9     832      844      856      868      880    ▇▁▁▁▇
 5 lengthmm                                                      0           1    420.     16.3     408      414.     420.     425.     431    ▇▁▁▁▇
 6 weightg                                                       0           1    187.      4.17    184.     186.     187.     189.     190.   ▇▁▁▁▇
 7 ageyear                                                       0           1      3.7     0.283     3.5      3.6      3.7      3.8      3.9  ▇▁▁▁▇
 8 differentiated_proportion                                     0           1      0.81    0.0849    0.75     0.78     0.81     0.84     0.87 ▇▁▁▁▇
 9 m_mean_lengthmm                                               0           1    376.     10.6     369      373.     376.     380.     384    ▇▁▁▁▇
10 m_mean_weightg                                                0           1    104.     17.0      92.5     98.5    104.     110.     116.   ▇▁▁▁▇
11 m_mean_ageyear                                                0           1      2.85    1.20      2        2.42     2.85     3.28     3.7  ▇▁▁▁▇
12 f_mean_lengthmm                                               0           1    542.     37.5     516      529.     542.     556.     569    ▇▁▁▁▇
13 f_mean_weightg                                                0           1    376.     25.6     358.     367.     376.     385.     394.   ▇▁▁▁▇
14 f_mean_age                                                    0           1      5.6     0.566     5.2      5.4      5.6      5.8      6    ▇▁▁▁▇
15 s_in_ys_proportion                                            0           1      0.55    0.636     0.1      0.325    0.55     0.775    1    ▇▁▁▁▇
16 method_sex_(1=visual,0=use_length)                            0           1      1       0         1        1        1        1        1    ▁▁▇▁▁
17 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0           1      0.5     0.707     0        0.25     0.5      0.75     1    ▇▁▁▁▇
18 female_proportion                                             0           1      0.405   0.148     0.3      0.352    0.405    0.458    0.51 ▇▁▁▁▇
19 anguillicola_proportion                                       0           1      0.252   0.251     0.075    0.164    0.252    0.341    0.43 ▇▁▁▁▇
20 anguillicola_intensity                                        1           0.5    1.1    NA         1.1      1.1      1.1      1.1      1.1  ▁▁▇▁▁

### individual metrics


261 and 2725 new values inserted in the fish and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             261   
Number of columns          23    
_______________________          
Column type frequency:           
  character                5     
  Date                     2     
  numeric                  16    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment              233         0.107  17  32     0        2          0
2 fi_dts_datasource         0         1       7   7     0        1          0
3 fi_lfs_code               0         1       1   2     0        3          0
4 fisa_geom               261         0      NA  NA     0        0          0
5 fi_id_cou                40         0.847   7   8     0      193          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2025-01-29 2025-12-26 2025-06-15       16
2 fi_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate        mean      sd         p0        p25       p50       p75      p100 hist 
 1 fi_id                                                         0         1     4567188      75.5   4567058    4567123    4567188   4567253   4567318   ▇▇▇▇▇
 2 fi_year                                                       0         1        2025       0        2025       2025       2025      2025      2025   ▁▁▇▁▁
 3 fisa_sai_id                                                   0         1         873.     17.3       832        880        880       880       880   ▂▁▁▁▇
 4 fisa_x_4326                                                   0         1          15.9     1.38       13.6       14.0       16.0      17.4      17.6 ▇▁▆▆▇
 5 fisa_y_4326                                                   0         1          44.0     0.848      43.0       43.1       43.8      45.1      45.4 ▇▇▂▁▇
 6 lengthmm                                                      0         1         410.    137.         39        353        389       459      1024   ▁▇▃▁▁
 7 weightg                                                       0         1         189.    275.          1.92      79.9      113.      186.     1862.  ▇▁▁▁▁
 8 eye_diam_meanmm                                               0         1           5.57    1.76        1.42       4.42       5.2       6.3      11.9 ▁▇▅▁▁
 9 pectoral_lengthmm                                             0         1          18.3     7.26        2.51      13.2       17.6      22.3      41.4 ▂▇▇▂▁
10 differentiated_proportion                                     0         1           0.770   0.422       0          1          1         1         1   ▂▁▁▁▇
11 anguillicola_intensity                                       37         0.858       1.16    2.04        0          0          0         2        15   ▇▁▁▁▁
12 method_sex_(1=visual,0=use_length)                            0         1           1       0           1          1          1         1         1   ▁▁▇▁▁
13 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0         1           0.847   0.361       0          1          1         1         1   ▂▁▁▁▇
14 female_proportion                                            60         0.770       0.478   0.501       0          0          0         1         1   ▇▁▁▁▇
15 anguillicola_proportion                                       0         1           0.379   0.486       0          0          0         1         1   ▇▁▁▁▅
16 ageyear                                                      49         0.812       3.85    1.81        0          3          4         4        12   ▃▇▃▁▁