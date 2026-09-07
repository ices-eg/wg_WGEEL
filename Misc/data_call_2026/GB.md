-----------------------------------------------------------
# GB
-----------------------------------------------------------

## Annex 1

### series
- 9 values updated in the db (grammar edit in the comment)

### dataseries
- in the template file:
  - we remove new data where the value is not available yet
  - ser_id were fixed (323, 322) because they had been changed to 1

- 20 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             20    
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
1 das_comment                1          0.95  22  72     0        9          0
2 das_dts_datasource         0          1      7   7     0        1          0
3 das_qal_comment           20          0     NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd   p0   p25   p50   p75
1 das_id                0           1   9476.      5.92  9466 9471. 9476. 9480.
2 das_value             4           0.8 3604.   6556.       3   31   404. 3285 
3 das_ser_id            0           1    239.     91.6      4  184.  188.  320.
4 das_year              0           1   2025.      0.224 2024 2025  2025  2025 
5 das_effort           20           0    NaN      NA       NA   NA    NA    NA 
6 das_qal_id            0           1      2.75    1.77     0    1     4     4 
   p100 hist   
1  9485 "▇▇▇▇▇"
2 23232 "▇▁▁▁▁"
3   377 "▁▁▇▁▇"
4  2025 "▁▁▁▁▇"
5    NA " "    
6     4 "▂▂▁▁▇"
```
- 2 values updated in the db

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
1 das_comment                0             1  51  51     0        1          0
2 das_dts_datasource         2             0  NA  NA     0        0          0
3 das_qal_comment            2             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean     sd   p0    p25    p50   p75
1 das_id                0             1 8698.   0.707 8697 8697.  8698.  8698.
2 das_value             0             1   94.5 82.7     36   65.2   94.5  124.
3 das_ser_id            0             1  322.   0.707  322  322.   322.   323.
4 das_year              0             1 2024    0     2024 2024   2024   2024 
5 das_effort            2             0  NaN   NA       NA   NA     NA     NA 
6 das_qal_id            0             1    1    0        1    1      1      1 
  p100 hist   
1 8698 "▇▁▁▁▇"
2  153 "▇▁▁▁▇"
3  323 "▇▁▁▁▇"
4 2024 "▁▁▇▁▁"
5   NA " "    
6    1 "▁▁▇▁▁"
```

### group metrics
 - 3 and 8 new values inserted in the group and metric tables
 
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             3     
Number of columns          10    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  7     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                2         0.333  32  32     0        1          0
2 gr_dts_datasource         0         1       7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean      sd      p0    p25     p50
1 gr_id                 0         1     5904      1     5903    5904.  5904   
2 gr_year               0         1     2025.     0.577 2024    2024.  2025   
3 gr_number             0         1      286    333.      30      98    166   
4 grser_ser_id          0         1      121.   102.       4      87.5  171   
5 lengthmm              0         1       94.3   42.4     69.5    69.8   70.2 
6 weightg               0         1        1.36   1.83     0.29    0.3    0.31
7 ageyear               1         0.667    0      0        0       0      0   
      p75    p100 hist 
1 5904.   5905    ▇▁▇▁▇
2 2025    2025    ▃▁▁▁▇
3  414     662    ▇▇▁▁▇
4  180     189    ▃▁▁▁▇
5  107.    143.   ▇▁▁▁▃
6    1.89    3.47 ▇▁▁▁▃
7    0       0    ▁▁▇▁▁
```

### individual metrics
- in the template file: 
  - new data: 
    - remove fi_id_cou 1832307 since it has no associated metrics
    - some qal_id are chenged to 0 since data will never be available
  
-  1452 and 3584 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1452  
Number of columns          12    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment             1452         0      NA  NA     0        0          0
2 fi_dts_datasource         0         1       7   7     0        1          0
3 fi_lfs_code               0         1       1   2     0        3          0
4 fi_id_cou               828         0.430   7   9     0      624          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 2024-05-17 2025-07-10 2025-04-25
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1       60
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate        mean      sd         p0
1 fi_id                 0         1     3587294.    419.    3586568   
2 fi_year               0         1        2025.      0.142    2024   
3 fiser_ser_id          0         1          97.3    85.6         4   
4 lengthmm              0         1          72.1    11.5        59   
5 weightg             148         0.898       0.369   0.490       0.14
6 ageyear             624         0.570       0       0           0   
         p25       p50        p75       p100 hist 
1 3586931.   3587294.  3587656.   3588019    ▇▇▇▇▇
2    2025       2025      2025       2025    ▁▁▁▁▇
3       4        172       172        189    ▇▁▁▁▇
4      68         71        74        190    ▇▁▁▁▁
5       0.26       0.3       0.35       6.61 ▇▁▁▁▁
6       0          0         0          0    ▁▁▇▁▁
```

-  1 and 2 new values updated in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
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
1 fi_comment                0             1  68  68     0        1          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   2   2     0        1          0
4 fi_id_cou                 1             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 2024-05-08 2024-05-08 2024-05-08
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate       mean sd         p0        p25
1 fi_id                 0             1 2984920    NA 2984920    2984920   
2 fi_year               0             1    2024    NA    2024       2024   
3 fiser_ser_id          0             1       4    NA       4          4   
4 lengthmm              0             1      68    NA      68         68   
5 weightg               0             1       0.32 NA       0.32       0.32
         p50        p75       p100 hist 
1 2984920    2984920    2984920    ▁▁▇▁▁
2    2024       2024       2024    ▁▁▇▁▁
3       4          4          4    ▁▁▇▁▁
4      68         68         68    ▁▁▇▁▁
5       0.32       0.32       0.32 ▁▁▇▁▁
```

## Annex 2

### series

### dataseries
- in the template file:
  - remove the row where comment is "Not available in time for the 2025 data 
  call. Data may be available in future."
  
-  46 new values inserted in the database

```
1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             46    
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
1 das_comment               39         0.152  16  85     0        4          0
2 das_dts_datasource         0         1       7   7     0        1          0
3 das_qal_comment           46         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate      mean      sd   p0        p25
1 das_id                0         1     9546.     13.4    9524 9535.     
2 das_value             6         0.870    0.0299  0.0655    0    0.00216
3 das_ser_id            0         1      272.     14.4     247  260.     
4 das_year              0         1     2024       0      2024 2024      
5 das_effort            3         0.935   18.7    31.7       0    5      
6 das_qal_id            1         0.978    0.956   0.562     0    1      
         p50       p75     p100 hist 
1 9546.      9558.     9569     ▇▇▇▇▇
2    0.00621    0.0284    0.342 ▇▁▁▁▁
3  272.       283.      296     ▆▇▇▇▆
4 2024       2024      2024     ▁▁▇▁▁
5    9         18       187     ▇▁▁▁▁
6    1          1         4     ▁▇▁▁▁
```

-11 values updated in the db 

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             11    
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
1 das_comment                0             1  38  43     0       11          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment           11             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate      mean        sd         p0       p25
1 das_id                0             1 7288.     1851.     4866       5092     
2 das_value             0             1    0.0253    0.0340    0.00041    0.0014
3 das_ser_id            0             1  268        16.7     247        257     
4 das_year              0             1 2018.       10.0    1989       2017     
5 das_effort            0             1   37.5      40.4       5         10     
6 das_qal_id            0             1    1         0         1          1     
        p50       p75     p100 hist 
1 8278      8784.     8805     ▅▁▁▁▇
2    0.0048    0.0373    0.106 ▇▃▁▁▁
3  266       277       293     ▇▅▇▁▇
4 2022      2023      2023     ▁▁▁▁▇
5   15        59       121     ▇▁▂▁▁
6    1         1         1     ▁▁▇▁▁
```
### group metrics
- in template: removed row for LagY, KilY since there is no sample

-  35 and 66 new values inserted in the group and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             35    
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
1 gr_comment                0             1  28  64     0        2          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean    sd     p0    p25    p50   p75
1 gr_id                 0         1     6114    10.2 6097   6106.  6114   6122.
2 gr_year               0         1     2024     0   2024   2024   2024   2024 
3 gr_number             0         1       66.0  80.6    1      9     32     88 
4 grser_ser_id          0         1      276.   13.0  253    265    277    286.
5 lengthmm              0         1      294.  102.   143.   216.   278.   325.
6 weightg               4         0.886   90.6  88.0    6.6   33.4   56.2  105.
   p100 hist 
1 6131  ▇▇▇▇▇
2 2024  ▁▁▇▁▁
3  322  ▇▂▂▁▁
4  296  ▇▇▅▇▇
5  598  ▆▇▂▁▁
6  401. ▇▂▂▁▁
```
### individual metrics
- 18 values deleted from fish table, cascade delete on metrics

- 2579 and 4374 new values inserted in the fish and metric tables
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2579  
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
1 fi_comment             2579        0       NA  NA     0        0          0
2 fi_dts_datasource         0        1        7   7     0        1          0
3 fi_lfs_code            2579        0       NA  NA     0        0          0
4 fi_id_cou              2363        0.0838   7   7     0      216          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 2024-06-03 2025-08-04 2025-08-04
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1       47
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate      mean    sd        p0       p25
1 fi_id                 0         1     3636767   745.  3635478   3636122. 
2 fi_year               0         1        2024     0      2024      2024  
3 fiser_ser_id          0         1         274.   14.4     247       261  
4 lengthmm              0         1         251.  122.       50       160  
5 weightg             784         0.696      64.8 106.        0.2       7.9
        p50       p75    p100 hist 
1 3636767   3637412.  3638056 ▇▇▇▇▇
2    2024      2024      2024 ▁▁▇▁▁
3     279       283       296 ▂▂▂▇▃
4     226       314       850 ▇▇▂▁▁
5      24.6      69.2    1197 ▇▁▁▁▁
```

-  23 and 23 new values updated in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             23    
Number of columns          10    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  4     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment                0         1      70  73     0        2          0
2 fi_dts_datasource         0         1       7   7     0        1          0
3 fi_lfs_code               1         0.957   1   1     0        1          0
4 fi_id_cou                23         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 1993-06-22 2021-09-07 2014-09-04
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1       15
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate      mean        sd      p0       p25
1 fi_id                 0             1 3092532.  314747.   1650542 3140340  
2 fi_year               0             1    2014.       5.63    1993    2013  
3 fiser_ser_id          0             1     276.       7.77     249     276  
4 lengthmm              0             1      64.3     35.1       27      57.5
      p50     p75    p100 hist 
1 3165932 3166394 3179279 ▁▁▁▁▇
2    2014    2018    2021 ▁▁▁▇▇
3     279     279     286 ▁▁▂▁▇
4      61      62     220 ▇▁▁▁▁
```

## Annex 3

### series
- 1 values updated in the db (ShiS - where distance to the sea was updated)

### dataseries
-  6 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             6     
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
1 das_comment                2         0.667  13  38     0        4          0
2 das_dts_datasource         0         1       7   7     0        1          0
3 das_qal_comment            6         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean    sd   p0    p25   p50     p75
1 das_id                0         1     9618.    1.87 9616 9617.  9618. 9620.  
2 das_value             2         0.667   87.8  87.1     9   38.2   66   116.  
3 das_ser_id            0         1      259.   63.7   201  202.   250   319.  
4 das_year              0         1     2024     0    2024 2024   2024  2024   
5 das_effort            5         0.167    2    NA       2    2      2     2   
6 das_qal_id            0         1        1.83  1.72    0    1      1     3.25
  p100 hist 
1 9621 ▇▃▃▃▃
2  210 ▇▃▁▁▃
3  327 ▇▁▁▂▅
4 2024 ▁▁▇▁▁
5    2 ▁▁▇▁▁
6    4 ▂▇▁▁▅
```

### group metrics
-  1 and 8 new values inserted in the group and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
Number of columns          15    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  12    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                1             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 gr_id                                                         0             1
 2 gr_year                                                       0             1
 3 gr_number                                                     0             1
 4 grser_ser_id                                                  0             1
 5 lengthmm                                                      0             1
 6 differentiated_proportion                                     0             1
 7 m_mean_lengthmm                                               0             1
 8 m_mean_weightg                                                0             1
 9 f_mean_lengthmm                                               0             1
10 method_sex_(1=visual,0=use_length)                            0             1
11 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0             1
12 female_proportion                                             0             1
       mean sd       p0      p25      p50      p75     p100 hist 
 1 6169     NA 6169     6169     6169     6169     6169     ▁▁▇▁▁
 2 2024     NA 2024     2024     2024     2024     2024     ▁▁▇▁▁
 3    9     NA    9        9        9        9        9     ▁▁▇▁▁
 4  297     NA  297      297      297      297      297     ▁▁▇▁▁
 5  550.    NA  550.     550.     550.     550.     550.    ▁▁▇▁▁
 6    1     NA    1        1        1        1        1     ▁▁▇▁▁
 7  349     NA  349      349      349      349      349     ▁▁▇▁▁
 8   71     NA   71       71       71       71       71     ▁▁▇▁▁
 9  651     NA  651      651      651      651      651     ▁▁▇▁▁
10    1     NA    1        1        1        1        1     ▁▁▇▁▁
11    0     NA    0        0        0        0        0     ▁▁▇▁▁
12    0.667 NA    0.667    0.667    0.667    0.667    0.667 ▁▁▇▁▁
```

### individual metrics
-  136 and 427 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             136   
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
1 fi_comment              127        0.0662  18  18     0        1          0
2 fi_dts_datasource         0        1        7   7     0        1          0
3 fi_lfs_code               0        1        1   1     0        1          0
4 fi_id_cou                 9        0.934    5   5     0      127          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               9         0.934 2024-05-01 2024-10-23 2024-07-22
2 fi_lastupdate         0         1     2025-09-09 2025-09-09 2025-09-09
  n_unique
1       32
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 fi_id                                                         0        1     
 2 fi_year                                                       0        1     
 3 fiser_ser_id                                                  0        1     
 4 lengthmm                                                      0        1     
 5 weightg                                                      11        0.919 
 6 differentiated_proportion                                     0        1     
 7 anguillicola_intensity                                      133        0.0221
 8 evex_proportion                                             133        0.0221
 9 method_sex_(1=visual,0=use_length)                          127        0.0662
10 method_anguillicola_(1=stereomicroscope,0=visual_obs)       133        0.0221
11 female_proportion                                           127        0.0662
12 anguillicola_proportion                                     133        0.0221
          mean     sd        p0       p25       p50       p75    p100 hist 
 1 3640704.     39.4  3640636   3640670.  3640704.  3640737.  3640771 ▇▇▇▇▇
 2    2024       0       2024      2024      2024      2024      2024 ▁▁▇▁▁
 3     208.     23.8      201       201       201       203       297 ▇▁▁▁▁
 4     406.    153.       295       329       348       383.      908 ▇▁▁▁▁
 5     158.    288.        23.4      56.6      68.6      84.2    1450 ▇▁▁▁▁
 6       1       0          1         1         1         1         1 ▁▁▇▁▁
 7       5       2.65       2         4         6         6.5       7 ▇▁▁▇▇
 8       0       0          0         0         0         0         0 ▁▁▇▁▁
 9       1       0          1         1         1         1         1 ▁▁▇▁▁
10       0       0          0         0         0         0         0 ▁▁▇▁▁
11       0.667   0.5        0         0         1         1         1 ▃▁▁▁▇
12       1       0          1         1         1         1         1 ▁▁▇▁▁
```

## Annex 4
- in the template file:
  - removed some cell where there was just a space (so not dectected as NA by R)
  - removed some eel_area_division in freshwater

-  70 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             70    
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
 1 eel_emu_nameshort         0         1       6   7     0       14          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       1   1     0        3          0
 4 eel_hty_code              0         1       1   2     0        4          0
 5 eel_area_division        50         0.286   6   6     0        1          0
 6 eel_qal_comment          70         0      NA  NA     0        0          0
 7 eel_comment              46         0.343  10  14     0        2          0
 8 eel_missvaluequal        18         0.743   2   2     0        1          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd     p0     p25     p50
1 eel_id                0         1     600240.   20.4   600206 600223. 600240.
2 eel_typ_id            0         1          4     0          4      4       4 
3 eel_year              0         1       2024.    0.168   2024   2024    2024 
4 eel_value            52         0.257   3353. 6787.        21    105.    324.
5 eel_qal_id            0         1          1     0          1      1       1 
      p75   p100 hist 
1 600258. 600275 ▇▇▇▇▇
2      4       4 ▁▁▇▁▁
3   2024    2025 ▇▁▁▁▁
4   1794.  26000 ▇▁▁▁▁
5      1       1 ▁▁▇▁▁
```

## Annex 5
- 56 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             56    
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
 1 eel_emu_nameshort         0         1       6   7     0       14          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       1   1     0        1          0
 4 eel_hty_code              0         1       1   2     0        4          0
 5 eel_area_division        56         0      NA  NA     0        0          0
 6 eel_qal_comment          56         0      NA  NA     0        0          0
 7 eel_comment              48         0.143  61  61     0        1          0
 8 eel_missvaluequal         0         1       2   2     0        1          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean   sd     p0     p25     p50
1 eel_id                0             1 600374. 16.3 600346 600360. 600374.
2 eel_typ_id            0             1      6   0        6      6       6 
3 eel_year              0             1   2024   0     2024   2024    2024 
4 eel_value            56             0    NaN  NA       NA     NA      NA 
5 eel_qal_id            0             1      1   0        1      1       1 
      p75   p100 hist   
1 600387. 600401 "▇▇▇▇▇"
2      6       6 "▁▁▇▁▁"
3   2024    2024 "▁▁▇▁▁"
4     NA      NA " "    
5      1       1 "▁▁▇▁▁"
```
## Annex 6
-  3 new values inserted in the database
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             3     
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
 3 eel_lfs_code              0         1       1   1     0        1          0
 4 eel_hty_code              0         1       1   1     0        1          0
 5 eel_area_division         3         0      NA  NA     0        0          0
 6 eel_qal_comment           3         0      NA  NA     0        0          0
 7 eel_comment               0         1      98 118     0        2          0
 8 eel_missvaluequal         2         0.333   2   2     0        1          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean      sd     p0     p25    p50
1 eel_id                0         1     600459    1     600458 600458. 600459
2 eel_typ_id            0         1         32    0         32     32      32
3 eel_year              0         1       2024.   0.577   2024   2024    2024
4 eel_value             1         0.667    951  829.       365    658     951
5 eel_qal_id            0         1          1    0          1      1       1
      p75   p100 hist 
1 600460. 600460 ▇▁▇▁▇
2     32      32 ▁▁▇▁▁
3   2024.   2025 ▇▁▁▁▃
4   1244    1537 ▇▁▁▁▇
5      1       1 ▁▁▇▁▁
```

## Annex 7
- one value had missing eel_qal_id, put 1 since the comment suggests it is ok
- 10 new values inserted in the database

```
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

── Variable type: character ────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0           1     7   7     0        3          0
 2 eel_cou_code              0           1     2   2     0        1          0
 3 eel_lfs_code              0           1     1   1     0        1          0
 4 eel_hty_code              0           1     1   1     0        1          0
 5 eel_area_division        10           0    NA  NA     0        0          0
 6 eel_qal_comment          10           0    NA  NA     0        0          0
 7 eel_comment               0           1    12  85     0        3          0
 8 eel_missvaluequal         4           0.6   2   2     0        1          0
 9 eel_datasource            0           1     7   7     0        1          0
10 eel_dta_code              0           1     6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean          sd     p0     p25
1 eel_id                0           1   600468.        3.03  600464 600466.
2 eel_typ_id            0           1        8.5       0.527      8      8 
3 eel_year              0           1     2024.        0.516   2024   2024 
4 eel_value             6           0.4 590352.  1140108.       410    852.
5 eel_qal_id            0           1        1         0          1      1 
       p50     p75    p100 hist 
1 600468.  600471.  600473 ▇▇▇▇▇
2      8.5      9        9 ▇▁▁▁▇
3   2024     2025     2025 ▇▁▁▁▅
4  30500   620000  2300000 ▇▁▁▁▂
5      1        1        1 ▁▁▇▁▁
```


## Annex 8
no data

## Annex 9

### samplinginfo


### group metrics
- remove a few lines that were not from annex 9 but from annex 3
- fixed percentages to proportions
-  4 and 40 new values inserted in the group and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4     
Number of columns          20    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  16    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                4             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0
3 grsa_lfs_code             0             1   1   1     0        2          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-29 2025-09-29 2025-09-29
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 gr_id                                                         0          1   
 2 gr_year                                                       0          1   
 3 gr_number                                                     0          1   
 4 grsa_sai_id                                                   0          1   
 5 lengthmm                                                      0          1   
 6 weightg                                                       0          1   
 7 differentiated_proportion                                     0          1   
 8 anguillicola_intensity                                        0          1   
 9 f_mean_lengthmm                                               1          0.75
10 f_mean_weightg                                                1          0.75
11 method_sex_(1=visual,0=use_length)                            0          1   
12 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0          1   
13 female_proportion                                             0          1   
14 anguillicola_proportion                                       0          1   
15 m_mean_lengthmm                                               3          0.25
16 m_mean_weightg                                                3          0.25
       mean       sd      p0      p25     p50      p75     p100 hist 
 1 6422.      1.29   6420    6421.    6422.   6422.    6423     ▇▇▁▇▇
 2 2024.      0.5    2024    2024     2024    2024.    2025     ▇▁▁▁▂
 3   81.2    80.7      20      24.5     55.5   112.     194     ▇▃▁▁▃
 4  297.      0.957   296     296      296.    297.     298     ▇▁▃▁▃
 5  490      82.1     372     470.     514     534.     560     ▃▁▁▃▇
 6  229.    104.       96     174      244.    298.     332     ▃▁▃▁▇
 7    0.995   0.0100    0.98    0.995    1       1        1     ▂▁▁▁▇
 8    6.1     2.54      4.6     4.82     4.95    6.22     9.9   ▇▁▁▁▂
 9  529.     28.7     503     514      525     542.     560     ▇▇▁▁▇
10  273      67.1     200     244.     287     310.     332     ▇▁▁▇▇
11    1       0         1       1        1       1        1     ▁▁▇▁▁
12    0       0         0       0        0       0        0     ▁▁▇▁▁
13    0.745   0.497     0       0.735    0.99    1        1     ▂▁▁▁▇
14    0.712   0.0559    0.64    0.685    0.72    0.747    0.769 ▇▁▇▇▇
15  372      NA       372     372      372     372      372     ▁▁▇▁▁
16   96      NA        96      96       96      96       96     ▁▁▇▁▁
```

### individual metrics
- remove a few lines that were not from annex 9 but from annex 3
- fixed fisa_x_4326 (updated) that was detected as character instead of double

- 325 and 2600 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             325   
Number of columns          20    
_______________________          
Column type frequency:           
  character                5     
  Date                     2     
  numeric                  13    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment                0             1   2   2     0        1          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        2          0
4 fisa_geom               325             0  NA  NA     0        0          0
5 fi_id_cou                 0             1   2   2     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date             325             0 Inf        -Inf       NA        
2 fi_lastupdate         0             1 2025-09-29 2025-09-29 2025-09-29
  n_unique
1        0
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 fi_id                                                         0             1
 2 fi_year                                                       0             1
 3 fisa_sai_id                                                   0             1
 4 fisa_x_4326                                                   0             1
 5 fisa_y_4326                                                   0             1
 6 lengthmm                                                      0             1
 7 weightg                                                       0             1
 8 differentiated_proportion                                     0             1
 9 anguillicola_intensity                                        0             1
10 method_sex_(1=visual,0=use_length)                            0             1
11 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0             1
12 female_proportion                                             0             1
13 anguillicola_proportion                                       0             1
          mean       sd         p0        p25        p50        p75       p100
 1 3937040      94.0    3936878    3936959    3937040    3937121    3937202   
 2    2024.      0.241     2024       2024       2024       2024       2025   
 3     297.      0.875      296        296        296        298        298   
 4      -6.43    0.0297      -6.48      -6.48      -6.41      -6.41      -6.41
 5      54.7     0.0604      54.6       54.6       54.6       54.7       54.7 
 6     509.     83.1         35        458        501        556        773   
 7     252.    167.          55        150        202        302       1160   
 8       0.988   0.110        0          1          1          1          1   
 9       6.26    9.79         0          0          3          9         90   
10       1       0            1          1          1          1          1   
11       0       0            0          0          0          0          0   
12       0.908   0.290        0          1          1          1          1   
13       0.68    0.467        0          0          1          1          1   
   hist 
 1 ▇▇▇▇▇
 2 ▇▁▁▁▁
 3 ▇▁▁▁▃
 4 ▅▁▁▁▇
 5 ▇▁▁▁▅
 6 ▁▁▅▇▁
 7 ▇▃▁▁▁
 8 ▁▁▁▁▇
 9 ▇▁▁▁▁
10 ▁▁▇▁▁
11 ▁▁▇▁▁
12 ▁▁▁▁▇
13 ▃▁▁▁▇
```

- 1861 and 8920 new values updated in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1861  
Number of columns          25    
_______________________          
Column type frequency:           
  character                5     
  Date                     2     
  numeric                  18    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment                0             1  75 175     0        9          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        2          0
4 fisa_geom              1861             0  NA  NA     0        0          0
5 fi_id_cou              1861             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date            1861             0 Inf        -Inf       NA        
2 fi_lastupdate         0             1 2025-09-29 2025-09-29 2025-09-29
  n_unique
1        0
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 fi_id                                                         0        1     
 2 fi_year                                                       0        1     
 3 fisa_sai_id                                                   0        1     
 4 fisa_x_4326                                                   0        1     
 5 fisa_y_4326                                                   0        1     
 6 lengthmm                                                      0        1     
 7 weightg                                                      40        0.979 
 8 ageyear                                                    1353        0.273 
 9 anguillicola_intensity                                      294        0.842 
10 female_proportion                                             0        1     
11 evex_proportion                                            1690        0.0919
12 hva_proportion                                             1690        0.0919
13 differentiated_proportion                                  1761        0.0537
14 method_sex_(1=visual,0=use_length)                         1761        0.0537
15 method_anguillicola_(1=stereomicroscope,0=visual_obs)      1621        0.129 
16 anguillicola_proportion                                    1621        0.129 
17 eye_diam_meanmm                                            1721        0.0752
18 pectoral_lengthmm                                          1721        0.0752
           mean       sd         p0        p25        p50        p75       p100
 1 3200748      537.     3199818    3200283    3200748    3201213    3201678   
 2    2019.       2.96      2014       2017       2020       2022       2023   
 3     297.       0.837      296        296        297        298        298   
 4      -6.45     0.0312      -6.48      -6.48      -6.48      -6.41      -6.41
 5      54.7      0.0636      54.6       54.6       54.7       54.7       54.7 
 6     518.     113.         275        422        510        592       1045   
 7     300.     255.          28        130        240        380       2560   
 8      13.0      3.17         6         10         13         15         23   
 9       6.29     9.18         0          1          3          8        140   
10       0.973    0.162        0          1          1          1          1   
11       0.0409   0.199        0          0          0          0          1   
12       0        0            0          0          0          0          0   
13       1        0            1          1          1          1          1   
14       1        0            1          1          1          1          1   
15       0        0            0          0          0          0          0   
16       0.712    0.454        0          0          1          1          1   
17       1        0            1          1          1          1          1   
18       1        0            1          1          1          1          1   
   hist 
 1 ▇▇▇▇▇
 2 ▃▃▅▅▇
 3 ▇▁▅▁▅
 4 ▇▁▁▁▇
 5 ▇▁▁▁▇
 6 ▅▇▅▁▁
 7 ▇▁▁▁▁
 8 ▃▇▇▃▁
 9 ▇▁▁▁▁
10 ▁▁▁▁▇
11 ▇▁▁▁▁
12 ▁▁▇▁▁
13 ▁▁▇▁▁
14 ▁▁▇▁▁
15 ▁▁▇▁▁
16 ▃▁▁▁▇
17 ▁▁▇▁▁
18 ▁▁▇▁▁
```