-----------------------------------------------------------
# PT
-----------------------------------------------------------

## Annex 1

### series

### dataseries
-  3 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             3     
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
1 das_comment                1         0.667  91 163     0        2          0
2 das_dts_datasource         0         1       7   7     0        1          0
3 das_qal_comment            3         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean      sd   p0     p25    p50
1 das_id                0         1     9933     1     9932 9932.   9933  
2 das_value             0         1      498.  404.     214  266.    319  
3 das_ser_id            0         1      141    99.0     27  109     191  
4 das_year              0         1     2025     0     2025 2025    2025  
5 das_effort            1         0.667    5.5   0.707    5    5.25    5.5
6 das_qal_id            1         0.667    1     0        1    1       1  
      p75 p100 hist 
1 9934.   9934 ▇▁▇▁▇
2  640.    960 ▇▁▁▁▃
3  198     205 ▃▁▁▁▇
4 2025    2025 ▁▁▇▁▁
5    5.75    6 ▇▁▁▁▇
6    1       1 ▁▁▇▁▁
```

- a das_qal_id was missing and set afterwards with an sql query

`update datawg.t_dataseries_das tdd  set das_qal_id = 1 where das_id in (select das_id from datawg.t_dataseries_das left join datawg.t_series_ser tss on ser_id = das_ser_id where tss.ser_nameshort = 'MiPoG' and das_year = 2025); `



### group metrics
-  2 and 4 new values inserted in the group and metric tables (length weight)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2     
Number of columns          9     
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  73  84     0        2          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean       sd      p0      p25
1 gr_id                 0             1 6278.     0.707   6278    6278.   
2 gr_year               0             1 2025      0       2025    2025    
3 gr_number             0             1  532.    96.9      463     497.   
4 grser_ser_id          0             1  198      9.90     191     194.   
5 lengthmm              0             1   68.5    0.707     68      68.2  
6 weightg               0             1    0.314  0.00566    0.31    0.312
       p50      p75     p100 hist 
1 6278.    6279.    6279     ▇▁▁▁▇
2 2025     2025     2025     ▁▁▇▁▁
3  532.     566.     600     ▇▁▁▁▇
4  198      202.     205     ▇▁▁▁▇
5   68.5     68.8     69     ▇▁▁▁▇
6    0.314    0.316    0.318 ▇▁▁▁▇
```

### individual metrics
- 1062 and 2124 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1062  
Number of columns          11    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment             1062             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou              1062             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date            1062             0 Inf        -Inf       NA        
2 fi_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        0
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate        mean       sd         p0
1 fi_id                 0             1 3853048.    307.     3852517   
2 fi_year               0             1    2025.      0.391     2024   
3 fiser_ser_id          0             1     199.      6.95       191   
4 lengthmm              0             1      69.1     4.21        53   
5 weightg               0             1       0.317   0.0727       0.13
         p25        p50         p75       p100 hist 
1 3852782.   3853048.   3853313.    3853578    ▇▇▇▇▇
2    2025       2025       2025        2025    ▂▁▁▁▇
3     191        205        205         205    ▆▁▁▁▇
4      66         69         72          85    ▁▂▇▂▁
5       0.27       0.31       0.354       0.63 ▁▇▅▁▁
```

## Annex 2

### series

### dataseries
- 2 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2     
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
1 das_comment                0             1  52  55     0        2          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            2             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean      sd        p0       p25
1 das_id                0             1 9938.    0.707   9938      9938.    
2 das_value             0             1    0.103 0.00845    0.0965    0.0995
3 das_ser_id            0             1  242.    0.707    241       241.    
4 das_year              0             1 2024     0       2024      2024     
5 das_effort            0             1   31.5   6.36      27        29.2   
6 das_qal_id            0             1    1     0          1         1     
       p50      p75     p100 hist 
1 9938.    9939.    9939     ▇▁▁▁▇
2    0.103    0.106    0.108 ▇▁▁▁▇
3  242.     242.     242     ▇▁▁▁▇
4 2024     2024     2024     ▁▁▇▁▁
5   31.5     33.8     36     ▇▁▁▁▇
6    1        1        1     ▁▁▇▁▁
```


### group metrics
-  2 and 4 new values inserted in the group and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2     
Number of columns          9     
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  13  23     0        2          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean      sd     p0    p25    p50
1 gr_id                 0             1 6282.    0.707 6282   6282.  6282. 
2 gr_year               0             1 2024     0     2024   2024   2024  
3 gr_number             0             1  476   173.     354    415    476  
4 grser_ser_id          0             1  242.    0.707  241    241.   242. 
5 lengthmm              0             1  182.    6.36   178    180.   182. 
6 weightg               0             1   16.1   4.77    12.7   14.4   16.1
     p75   p100 hist 
1 6283.  6283   ▇▁▁▁▇
2 2024   2024   ▁▁▇▁▁
3  537    598   ▇▁▁▁▇
4  242.   242   ▇▁▁▁▇
5  185.   187   ▇▁▁▁▇
6   17.8   19.4 ▇▁▁▁▇
```

### individual metrics
-  79 and 644 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             79    
Number of columns          18    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  12    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment               77        0.0253  14  14     0        1          0
2 fi_dts_datasource         0        1        7   7     0        1          0
3 fi_lfs_code               0        1        1   1     0        1          0
4 fi_id_cou                79        0       NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date              51         0.354 2024-04-19 2024-10-23 2024-07-31
2 fi_lastupdate         0         1     2025-09-10 2025-09-10 2025-09-10
  n_unique
1        8
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 fi_id                                                         0         1    
 2 fi_year                                                       0         1    
 3 fiser_ser_id                                                  0         1    
 4 lengthmm                                                      0         1    
 5 weightg                                                       0         1    
 6 ageyear                                                       2         0.975
 7 differentiated_proportion                                     0         1    
 8 anguillicola_intensity                                        1         0.987
 9 method_sex_(1=visual,0=use_length)                           24         0.696
10 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0         1    
11 female_proportion                                            39         0.506
12 anguillicola_proportion                                       1         0.987
          mean     sd         p0       p25     p50       p75     p100 hist 
 1 3854680     22.9   3854641    3854660.  3854680 3854700.  3854719  ▇▇▇▇▇
 2    2024      0        2024       2024      2024    2024      2024  ▁▁▇▁▁
 3     241.     0.481     241        241       241     242       242  ▇▁▁▁▅
 4     277.    88.7        69        226.      260     322.      554  ▁▇▆▁▁
 5      50.1   57.2         0.15      16.9      30      60.6     299. ▇▂▁▁▁
 6       4.05   1.84        1          3         4       5         9  ▃▇▂▃▁
 7       0.506  0.503       0          0         1       1         1  ▇▁▁▁▇
 8       2.71   3.71        0          1         2       3        19  ▇▂▁▁▁
 9       1      0           1          1         1       1         1  ▁▁▇▁▁
10       1      0           1          1         1       1         1  ▁▁▇▁▁
11       0.275  0.452       0          0         0       1         1  ▇▁▁▁▃
12       0.769  0.424       0          1         1       1         1  ▂▁▁▁▇
```

## Annex 3

### series

### dataseries
- 2 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2     
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
1 das_comment                0             1  21  31     0        2          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            2             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate       mean       sd         p0
1 das_id                0             1 9942.      0.707    9942      
2 das_value             0             1    0.00512 0.000616    0.00468
3 das_ser_id            0             1  244.      0.707     243      
4 das_year              0             1 2024       0        2024      
5 das_effort            0             1   15.5     3.54       13      
6 das_qal_id            0             1    1       0           1      
         p25        p50        p75       p100 hist 
1 9942.      9942.      9943.      9943       ▇▁▁▁▇
2    0.00490    0.00512    0.00534    0.00556 ▇▁▁▁▇
3  243.       244.       244.       244       ▇▁▁▁▇
4 2024       2024       2024       2024       ▁▁▇▁▁
5   14.2       15.5       16.8       18       ▇▁▁▁▇
6    1          1          1          1       ▁▁▇▁▁
```


### group metrics
-  2 and 15 new values inserted in the group and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2     
Number of columns          19    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  16    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  11  26     0        2          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate    mean      sd
 1 gr_id                                      0           1   6286.    0.707 
 2 gr_year                                    0           1   2024     0     
 3 gr_number                                  0           1     10     0     
 4 grser_ser_id                               0           1    244.    0.707 
 5 lengthmm                                   0           1    340    24.0   
 6 weightg                                    0           1     80.3  24.8   
 7 ageyear                                    1           0.5    5    NA     
 8 differentiated_proportion                  1           0.5    1    NA     
 9 m_mean_lengthmm                            1           0.5  339    NA     
10 m_mean_weightg                             1           0.5   73.4  NA     
11 m_mean_ageyear                             1           0.5    5    NA     
12 f_mean_lengthmm                            1           0.5  518    NA     
13 f_mean_weightg                             1           0.5  317.   NA     
14 f_mean_age                                 1           0.5    6    NA     
15 method_sex_(1=visual,0=use_length)         1           0.5    1    NA     
16 female_proportion                          0           1      0.05  0.0707
       p0      p25     p50      p75   p100 hist 
 1 6286   6286.    6286.   6287.    6287   ▇▁▁▁▇
 2 2024   2024     2024    2024     2024   ▁▁▇▁▁
 3   10     10       10      10       10   ▁▁▇▁▁
 4  243    243.     244.    244.     244   ▇▁▁▁▇
 5  323    332.     340     348.     357   ▇▁▁▁▇
 6   62.8   71.5     80.3    89.1     97.8 ▇▁▁▁▇
 7    5      5        5       5        5   ▁▁▇▁▁
 8    1      1        1       1        1   ▁▁▇▁▁
 9  339    339      339     339      339   ▁▁▇▁▁
10   73.4   73.4     73.4    73.4     73.4 ▁▁▇▁▁
11    5      5        5       5        5   ▁▁▇▁▁
12  518    518      518     518      518   ▁▁▇▁▁
13  317.   317.     317.    317.     317.  ▁▁▇▁▁
14    6      6        6       6        6   ▁▁▇▁▁
15    1      1        1       1        1   ▁▁▇▁▁
16    0      0.025    0.05    0.075    0.1 ▇▁▁▁▇
```

### individual metrics
-  20 and 165 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             20    
Number of columns          20    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  14    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment               19        0.0500  14  14     0        1          0
2 fi_dts_datasource         0        1        7   7     0        1          0
3 fi_lfs_code               0        1        1   1     0        1          0
4 fi_id_cou                20        0       NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date              20             0 Inf        -Inf       NA        
2 fi_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        0
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 fi_id                                                         0          1   
 2 fi_year                                                       0          1   
 3 fiser_ser_id                                                  0          1   
 4 lengthmm                                                      0          1   
 5 weightg                                                       0          1   
 6 ageyear                                                      10          0.5 
 7 eye_diam_meanmm                                               0          1   
 8 pectoral_lengthmm                                             0          1   
 9 differentiated_proportion                                     9          0.55
10 anguillicola_intensity                                        9          0.55
11 method_sex_(1=visual,0=use_length)                            9          0.55
12 method_anguillicola_(1=stereomicroscope,0=visual_obs)         9          0.55
13 female_proportion                                             0          1   
14 anguillicola_proportion                                       9          0.55
          mean     sd         p0        p25        p50        p75       p100
 1 3854808.     5.92  3854799    3854804.   3854808.   3854813.   3854818   
 2    2024      0        2024       2024       2024       2024       2024   
 3     244.     0.513     243        243        244.       244        244   
 4     341.    50.5       291        309.       330        347.       518   
 5      80.3   59.5        45.5       53.4       65.4       77.4      317.  
 6       4.9    0.738       4          4.25       5          5          6   
 7       6.45   0.774       5.15       5.96       6.22       7.00       7.90
 8      17.0    3.05       13.9       15.6       16.8       17.6       28.7 
 9       1      0           1          1          1          1          1   
10       1.82   1.89        0          0          2          3          6   
11       1      0           1          1          1          1          1   
12       1      0           1          1          1          1          1   
13       0.05   0.224       0          0          0          0          1   
14       0.636  0.505       0          0          1          1          1   
   hist 
 1 ▇▇▇▇▇
 2 ▁▁▇▁▁
 3 ▇▁▁▁▇
 4 ▇▂▁▁▁
 5 ▇▁▁▁▁
 6 ▅▁▇▁▃
 7 ▂▇▂▃▂
 8 ▇▇▁▁▁
 9 ▁▁▇▁▁
10 ▇▃▅▁▂
11 ▁▁▇▁▁
12 ▁▁▇▁▁
13 ▇▁▁▁▁
14 ▅▁▁▁▇
```


## Annex 4
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
 1 eel_emu_nameshort         0           1     7   7     0        2          0
 2 eel_cou_code              0           1     2   2     0        1          0
 3 eel_lfs_code              0           1     1   1     0        2          0
 4 eel_hty_code              0           1     1   1     0        1          0
 5 eel_area_division         1           0.5   6   6     0        1          0
 6 eel_qal_comment           2           0    NA  NA     0        0          0
 7 eel_comment               0           1    25  31     0        2          0
 8 eel_missvaluequal         2           0    NA  NA     0        0          0
 9 eel_datasource            0           1     7   7     0        1          0
10 eel_dta_code              0           1     6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd      p0     p25     p50
1 eel_id                0             1 607992.    0.707 607992  607992. 607992.
2 eel_typ_id            0             1      4     0          4       4       4 
3 eel_year              0             1   2024.    0.707   2024    2024.   2024.
4 eel_value             0             1   2480. 3036.       334.   1407.   2480.
5 eel_qal_id            0             1      1     0          1       1       1 
      p75   p100 hist 
1 607993. 607993 ▇▁▁▁▇
2      4       4 ▁▁▇▁▁
3   2025.   2025 ▇▁▁▁▇
4   3554.   4627 ▇▁▁▁▇
5      1       1 ▁▁▇▁▁
```


## Annex 5
-  24 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             24    
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
 3 eel_lfs_code              0             1   1   1     0        3          0
 4 eel_hty_code              0             1   1   2     0        4          0
 5 eel_area_division        24             0  NA  NA     0        0          0
 6 eel_qal_comment          24             0  NA  NA     0        0          0
 7 eel_comment              24             0  NA  NA     0        0          0
 8 eel_missvaluequal         0             1   2   2     0        1          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean    sd     p0     p25     p50
1 eel_id                0             1 608008.  7.07 607996 608002. 608008.
2 eel_typ_id            0             1      6   0         6      6       6 
3 eel_year              0             1   2024   0      2024   2024    2024 
4 eel_value            24             0    NaN  NA        NA     NA      NA 
5 eel_qal_id            0             1      1   0         1      1       1 
      p75   p100 hist   
1 608013. 608019 "▇▇▆▇▇"
2      6       6 "▁▁▇▁▁"
3   2024    2024 "▁▁▇▁▁"
4     NA      NA " "    
5      1       1 "▁▁▇▁▁"
```


## Annex 6
no data


## Annex 7
no data


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
 3 eel_lfs_code              0             1   1   1     0        1          0
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
  skim_variable n_missing complete_rate    mean sd      p0     p25     p50
1 eel_id                0             1 608051  NA 608051  608051  608051 
2 eel_typ_id            0             1     11  NA     11      11      11 
3 eel_year              0             1   2023  NA   2023    2023    2023 
4 eel_value             0             1    598. NA    598.    598.    598.
5 eel_qal_id            0             1      1  NA      1       1       1 
      p75    p100 hist 
1 608051  608051  ▁▁▇▁▁
2     11      11  ▁▁▇▁▁
3   2023    2023  ▁▁▇▁▁
4    598.    598. ▁▁▇▁▁
5      1       1  ▁▁▇▁▁
```

## Annex 9
no data