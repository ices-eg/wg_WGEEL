-----------------------------------------------------------
# PL
-----------------------------------------------------------

## Annex 1
no data

## Annex 2

### series

### dataseries
-  1 new values inserted in the database (VisY)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
Number of columns          10    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment                0             1  17  17     0        1          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            1             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate mean sd   p0  p25  p50  p75 p100 hist 
1 das_id                0             1 9874 NA 9874 9874 9874 9874 9874 ▁▁▇▁▁
2 das_value             0             1  420 NA  420  420  420  420  420 ▁▁▇▁▁
3 das_ser_id            0             1  240 NA  240  240  240  240  240 ▁▁▇▁▁
4 das_year              0             1 2024 NA 2024 2024 2024 2024 2024 ▁▁▇▁▁
5 das_effort            0             1  170 NA  170  170  170  170  170 ▁▁▇▁▁
6 das_qal_id            0             1    1 NA    1    1    1    1    1 ▁▁▇▁▁
```


### group metrics
- 1 and 10 new values inserted in the group and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
Number of columns          17    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  14    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                1             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate    mean sd      p0
 1 gr_id                                      0             1 6250    NA 6250   
 2 gr_year                                    0             1 2024    NA 2024   
 3 gr_number                                  0             1  420    NA  420   
 4 grser_ser_id                               0             1  240    NA  240   
 5 lengthmm                                   0             1  520    NA  520   
 6 weightg                                    0             1  314    NA  314   
 7 ageyear                                    0             1    7    NA    7   
 8 differentiated_proportion                  0             1    1    NA    1   
 9 f_mean_lengthmm                            0             1  520    NA  520   
10 f_mean_weightg                             0             1  314    NA  314   
11 f_mean_age                                 0             1    7    NA    7   
12 s_in_ys_proportion                         0             1    0.07 NA    0.07
13 method_sex_(1=visual,0=use_length)         0             1    1    NA    1   
14 female_proportion                          0             1    1    NA    1   
       p25     p50     p75    p100 hist 
 1 6250    6250    6250    6250    ▁▁▇▁▁
 2 2024    2024    2024    2024    ▁▁▇▁▁
 3  420     420     420     420    ▁▁▇▁▁
 4  240     240     240     240    ▁▁▇▁▁
 5  520     520     520     520    ▁▁▇▁▁
 6  314     314     314     314    ▁▁▇▁▁
 7    7       7       7       7    ▁▁▇▁▁
 8    1       1       1       1    ▁▁▇▁▁
 9  520     520     520     520    ▁▁▇▁▁
10  314     314     314     314    ▁▁▇▁▁
11    7       7       7       7    ▁▁▇▁▁
12    0.07    0.07    0.07    0.07 ▁▁▇▁▁
13    1       1       1       1    ▁▁▇▁▁
14    1       1       1       1    ▁▁▇▁▁
```

### individual metrics
no data


## Annex 3
no data

## Annex 4
- in the template file, remove NP in new data since eel_value were reported

-  6 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             6     
Number of columns          16    
_______________________          
Column type frequency:           
  character                10    
  Date                     1     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0         1       7   7     0        2          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       2   2     0        1          0
 4 eel_hty_code              0         1       1   1     0        3          0
 5 eel_area_division         2         0.667   6   6     0        1          0
 6 eel_qal_comment           6         0      NA  NA     0        0          0
 7 eel_comment               6         0      NA  NA     0        0          0
 8 eel_missvaluequal         6         0      NA  NA     0        0          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd     p0     p25     p50
1 eel_id                0             1 602226.     1.87 602224 602225. 602226.
2 eel_typ_id            0             1      4      0         4      4       4 
3 eel_year              0             1   2024      0      2024   2024    2024 
4 eel_value             0             1  25703. 21854.     1775   7920.  23712.
5 eel_qal_id            0             1      1      0         1      1       1 
      p75   p100 hist 
1 602228. 602229 ▇▃▃▃▃
2      4       4 ▁▁▇▁▁
3   2024    2024 ▁▁▇▁▁
4  45772.  49237 ▇▁▁▂▅
5      1       1 ▁▁▇▁▁
```


## Annex 5
- in the template file, remove NP in new data since eel_value were reported
-  2 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2     
Number of columns          16    
_______________________          
Column type frequency:           
  character                10    
  Date                     1     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0             1   7   7     0        2          0
 2 eel_cou_code              0             1   2   2     0        1          0
 3 eel_lfs_code              0             1   2   2     0        1          0
 4 eel_hty_code              0             1   1   1     0        1          0
 5 eel_area_division         2             0  NA  NA     0        0          0
 6 eel_qal_comment           2             0  NA  NA     0        0          0
 7 eel_comment               2             0  NA  NA     0        0          0
 8 eel_missvaluequal         2             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd     p0     p25     p50
1 eel_id                0             1 602236.    0.707 602236 602236. 602236.
2 eel_typ_id            0             1      6     0          6      6       6 
3 eel_year              0             1   2024     0       2024   2024    2024 
4 eel_value             0             1  16830. 2744.     14890  15860.  16830.
5 eel_qal_id            0             1      1     0          1      1       1 
      p75   p100 hist 
1 602237. 602237 ▇▁▁▁▇
2      6       6 ▁▁▇▁▁
3   2024    2024 ▁▁▇▁▁
4  17801.  18771 ▇▁▁▁▇
5      1       1 ▁▁▇▁▁
```

## Annex 6
no data


## Annex 7
- in template file, fill cou_code where missing
-  8 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             8     
Number of columns          16    
_______________________          
Column type frequency:           
  character                10    
  Date                     1     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0             1   7   7     0        2          0
 2 eel_cou_code              0             1   2   2     0        1          0
 3 eel_lfs_code              0             1   1   2     0        2          0
 4 eel_hty_code              0             1   1   1     0        1          0
 5 eel_area_division         8             0  NA  NA     0        0          0
 6 eel_qal_comment           8             0  NA  NA     0        0          0
 7 eel_comment               8             0  NA  NA     0        0          0
 8 eel_missvaluequal         8             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean         sd     p0     p25
1 eel_id                0             1 602244.       2.45  602240 602242.
2 eel_typ_id            0             1      8.5      0.535      8      8 
3 eel_year              0             1   2024        0       2024   2024 
4 eel_value             0             1 256638.  380038.        12   6777.
5 eel_qal_id            0             1      1        0          1      1 
       p50     p75   p100 hist 
1 602244.  602245. 602247 ▇▃▇▃▇
2      8.5      9       9 ▇▁▁▁▇
3   2024     2024    2024 ▁▁▇▁▁
4  23154.  421010. 931356 ▇▂▁▁▃
5      1        1       1 ▁▁▇▁▁
```

## Annex 8
-  1 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
Number of columns          16    
_______________________          
Column type frequency:           
  character                10    
  Date                     1     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0             1   8   8     0        1          0
 2 eel_cou_code              0             1   2   2     0        1          0
 3 eel_lfs_code              0             1   2   2     0        1          0
 4 eel_hty_code              1             0  NA  NA     0        0          0
 5 eel_area_division         1             0  NA  NA     0        0          0
 6 eel_qal_comment           1             0  NA  NA     0        0          0
 7 eel_comment               1             0  NA  NA     0        0          0
 8 eel_missvaluequal         1             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean sd     p0    p25    p50    p75
1 eel_id                0             1 602256 NA 602256 602256 602256 602256
2 eel_typ_id            0             1     11 NA     11     11     11     11
3 eel_year              0             1   2023 NA   2023   2023   2023   2023
4 eel_value             0             1  35775 NA  35775  35775  35775  35775
5 eel_qal_id            0             1      1 NA      1      1      1      1
    p100 hist 
1 602256 ▁▁▇▁▁
2     11 ▁▁▇▁▁
3   2023 ▁▁▇▁▁
4  35775 ▁▁▇▁▁
5      1 ▁▁▇▁▁
```

## Annex 9

### samplinginfo


### group metrics
-  4 and 36 new values inserted in the group and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4     
Number of columns          17    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  13    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                4             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0
3 grsa_lfs_code             0             1   1   1     0        2          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate   mean      sd
 1 gr_id                                      0             1 6254.    1.29 
 2 gr_year                                    0             1 2024     0    
 3 gr_number                                  0             1  211.  167.   
 4 grsa_sai_id                                0             1   68.5   0.577
 5 lengthmm                                   0             1  662   129.   
 6 weightg                                    0             1  738.  440.   
 7 ageyear                                    0             1    9.5   2.38 
 8 differentiated_proportion                  0             1    1     0    
 9 f_mean_lengthmm                            0             1  662   129.   
10 f_mean_weightg                             0             1  738.  440.   
11 f_mean_age                                 0             1    9.5   2.38 
12 method_sex_(1=visual,0=use_length)         0             1    1     0    
13 female_proportion                          0             1    1     0    
     p0     p25    p50    p75 p100 hist 
 1 6252 6253.   6254.  6254.  6255 ▇▇▁▇▇
 2 2024 2024    2024   2024   2024 ▁▁▇▁▁
 3   67   73.8   186.   324    405 ▇▁▁▃▃
 4   68   68      68.5   69     69 ▇▁▁▁▇
 5  520  569.    677    770.   774 ▃▃▁▁▇
 6  295  392.    766.  1111.  1127 ▇▁▁▁▇
 7    7    7.75    9.5   11.2   12 ▇▁▁▃▃
 8    1    1       1      1      1 ▁▁▇▁▁
 9  520  569.    677    770.   774 ▃▃▁▁▇
10  295  392.    766.  1111.  1127 ▇▁▁▁▇
11    7    7.75    9.5   11.2   12 ▇▁▁▃▃
12    1    1       1      1      1 ▁▁▇▁▁
13    1    1       1      1      1 ▁▁▇▁▁
```

### individual metrics
-  841 and 9014 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             841   
Number of columns          23    
_______________________          
Column type frequency:           
  character                5     
  Date                     2     
  numeric                  16    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment              841             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        2          0
4 fisa_geom               841             0  NA  NA     0        0          0
5 fi_id_cou               841             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date             841             0 Inf        -Inf       NA        
2 fi_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        0
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 fi_id                                                         0         1    
 2 fi_year                                                       0         1    
 3 fisa_sai_id                                                   0         1    
 4 fisa_x_4326                                                 841         0    
 5 fisa_y_4326                                                 841         0    
 6 lengthmm                                                      0         1    
 7 weightg                                                       0         1    
 8 ageyear                                                     195         0.768
 9 eye_diam_meanmm                                               0         1    
10 pectoral_lengthmm                                             0         1    
11 differentiated_proportion                                     0         1    
12 anguillicola_intensity                                       21         0.975
13 method_sex_(1=visual,0=use_length)                            0         1    
14 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0         1    
15 female_proportion                                             0         1    
16 anguillicola_proportion                                      21         0.975
          mean      sd         p0        p25        p50        p75      p100
 1 3849839     243.    3849419    3849629    3849839    3850049    3850259  
 2    2024       0        2024       2024       2024       2024       2024  
 3      68.6     0.497      68         68         69         69         69  
 4     NaN      NA          NA         NA         NA         NA         NA  
 5     NaN      NA          NA         NA         NA         NA         NA  
 6     588.    120.        360        500        550        650        990  
 7     479.    377.        107        234        306        593       2248  
 8       8.05    2.88        3          6          7         10         25  
 9       7.15   10.6         3.16       5.55       6.24       7.45     263. 
10      25.1     6.23       10.0       20.9       23.5       28.4       48.7
11       1       0           1          1          1          1          1  
12       3.84    8.17        0          0          0          4.25      95  
13       1       0           1          1          1          1          1  
14       0       0           0          0          0          0          0  
15       1       0           1          1          1          1          1  
16       0.417   0.493       0          0          0          1          1  
   hist   
 1 "▇▇▇▇▇"
 2 "▁▁▇▁▁"
 3 "▆▁▁▁▇"
 4 " "    
 5 " "    
 6 "▂▇▂▂▁"
 7 "▇▁▁▁▁"
 8 "▇▆▂▁▁"
 9 "▇▁▁▁▁"
10 "▁▇▃▂▁"
11 "▁▁▇▁▁"
12 "▇▁▁▁▁"
13 "▁▁▇▁▁"
14 "▁▁▇▁▁"
15 "▁▁▇▁▁"
16 "▇▁▁▁▆"
```


