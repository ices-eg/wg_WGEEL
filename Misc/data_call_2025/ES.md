-----------------------------------------------------------
# ES
-----------------------------------------------------------

## Annex 1

### series


### dataseries
- in the template file:
  - removed row with empty eel_value eel_valu in updated data (since nothing was changed)
  
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
1 das_comment                1         0.833  17  42     0        5          0
2 das_dts_datasource         0         1       7   7     0        1          0
3 das_qal_comment            6         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean     sd       p0     p25    p50
1 das_id                0             1 9284.    1.87 9282     9283.   9284. 
2 das_value             0             1  358.  530.      0.375    8.53  182. 
3 das_ser_id            0             1   61.5  71.9    24       25.2    34.5
4 das_year              0             1 2025     0    2025     2025    2025  
5 das_effort            6             0  NaN    NA      NA       NA      NA  
6 das_qal_id            0             1    1     0       1        1       1  
     p75  p100 hist   
1 9286.  9287  "▇▃▃▃▃"
2  385.  1379. "▇▅▁▁▂"
3   43.8  207  "▇▁▁▁▂"
4 2025   2025  "▁▁▇▁▁"
5   NA     NA  " "    
6    1      1  "▁▁▇▁▁"
```

- 13 values updated in the db
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             13    
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
1 das_comment                0             1  42  43     0       13          0
2 das_dts_datasource        13             0  NA  NA     0        0          0
3 das_qal_comment           13             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean        sd       p0      p25
1 das_id                0             1 5312.    1970.     3918     3922    
2 das_value             0             1    0.391    0.0974    0.256    0.304
3 das_ser_id            0             1  207        0       207      207    
4 das_year              0             1 2015.       6.59   2006     2010    
5 das_effort           13             0  NaN       NA        NA       NA    
6 das_qal_id           13             0  NaN       NA        NA       NA    
       p50      p75     p100 hist   
1 3930     6860     8835     "▇▁▁▁▃"
2    0.390    0.479    0.522 "▇▃▂▃▇"
3  207      207      207     "▁▁▇▁▁"
4 2018     2021     2024     "▆▆▁▆▇"
5   NA       NA       NA     " "    
6   NA       NA       NA     " "    
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
1 gr_comment                2             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean      sd       p0      p25
1 gr_id                 0             1 5730.      0.707 5730     5730.   
2 gr_year               0             1 2025       0     2025     2025    
3 gr_number             0             1  304.    418.       9      157.   
4 grser_ser_id          0             1  116     129.      25       70.5  
5 lengthmm              0             1   71.3     9.43    64.7     68    
6 weightg               0             1    0.382   0.177    0.257    0.319
       p50      p75     p100 hist 
1 5730.    5731.    5731     ▇▁▁▁▇
2 2025     2025     2025     ▁▁▇▁▁
3  304.     452.     600     ▇▁▁▁▇
4  116      162.     207     ▇▁▁▁▇
5   71.3     74.7     78     ▇▁▁▁▇
6    0.382    0.444    0.507 ▇▁▁▁▇
```

### individual metrics
-  609 and 1218 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             609   
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
1 fi_comment              609             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou               609             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 2024-10-31 2025-02-26 2025-02-05
2 fi_lastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        4
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate        mean       sd         p0
1 fi_id                 0             1 3427225     176.     3426921   
2 fi_year               0             1    2025       0         2025   
3 fiser_ser_id          0             1      27.7    22.0         25   
4 lengthmm              0             1      64.9     3.61        55   
5 weightg               0             1       0.260   0.0467       0.15
         p25        p50        p75        p100 hist 
1 3427073    3427225    3427377    3427529     ▇▇▇▇▇
2    2025       2025       2025       2025     ▁▁▇▁▁
3      25         25         25        207     ▇▁▁▁▁
4      62         65         67         82     ▂▇▆▁▁
5       0.23       0.26       0.28       0.571 ▃▇▁▁▁
```

## Annex 2
### series

### dataseries
- in the template file:
  - remove row for AlCY since there is no eel_value

- 4 new values inserted in the database
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4     
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
1 das_comment                2           0.5 106 148     0        2          0
2 das_dts_datasource         0           1     7   7     0        1          0
3 das_qal_comment            4           0    NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean     sd       p0       p25
1 das_id                0          1    9296.     1.29  9294     9295.    
2 das_value             1          0.75    0.105  0.122    0.025    0.0340
3 das_ser_id            0          1     350.    92.3    212      350     
4 das_year              0          1    2024.     1     2022     2024.    
5 das_effort            1          0.75    7.67   2.08     6        6.5   
6 das_qal_id            0          1       2.25   2.06     0        0.75  
        p50      p75     p100 hist 
1 9296.     9296.    9297     ▇▇▁▇▇
2    0.0430    0.144    0.246 ▇▁▁▁▃
3  396.      397      397     ▂▁▁▁▇
4 2024      2024     2024     ▂▁▁▁▇
5    7         8.5     10     ▇▇▁▁▇
6    2.5       4        4     ▃▃▁▁▇
```
- 3 values deleted from the db (fom NalY)

- 9 values updated in the db
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             9     
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
1 das_comment                0             1  92  96     0        9          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            9             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean       sd        p0      p25
1 das_id                0             1 7242.    736.     6878      6880    
2 das_value             0             1    0.142   0.0378    0.0963    0.108
3 das_ser_id            0             1  397       0       397       397    
4 das_year              0             1 2018.      2.93   2014      2016    
5 das_effort            0             1    7       0         7         7    
6 das_qal_id            0             1    1       0         1         1    
       p50      p75     p100 hist 
1 6882     6884     8845     ▇▁▁▁▁
2    0.150    0.162    0.215 ▆▂▇▁▂
3  397      397      397     ▁▁▇▁▁
4 2018     2020     2023     ▇▇▇▇▃
5    7        7        7     ▁▁▇▁▁
6    1        1        1     ▁▁▇▁▁
```

### group metrics
-  3 values deleted from group table, cascade delete on metrics

-  3 and 6 new values inserted in the group and metric tables
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             3     
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
1 gr_comment                1         0.667   7 184     0        2          0
2 gr_dts_datasource         0         1       7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean    sd     p0    p25    p50    p75
1 gr_id                 0             1 5735     1   5734   5734.  5735   5736. 
2 gr_year               0             1 2024     0   2024   2024   2024   2024  
3 gr_number             0             1  134   118.    21     73    125    190. 
4 grser_ser_id          0             1  335   107.   212    304    396    396. 
5 lengthmm              0             1  233.   30.7  212.   215.   218.   243. 
6 weightg               0             1   49.5  42.6   19.2   25.1   31.0   64.6
    p100 hist 
1 5736   ▇▁▇▁▇
2 2024   ▁▁▇▁▁
3  256   ▇▁▇▁▇
4  397   ▃▁▁▁▇
5  268   ▇▁▁▁▃
6   98.2 ▇▁▁▁▃
```


-  9 and 18 new values modified in the group and metric tables (forgot to copy
the skim)


- for BidY 2024: put meg_qal_id = 4 for weight given the comment
```
update datawg.t_metricgroupseries_megser tmm set meg_qal_id =4 where meg_id in (

select meg_id from datawg.t_metricgroupseries_megser tmm left join datawg.t_groupseries_grser tgg on tmm.meg_gr_id = tgg.gr_id left join datawg.t_series_ser on tgg.grser_ser_id = ser_id 
where ser_nameshort  = 'BidY' and tgg.gr_year = 2024 and meg_mty_id = 2);
```


### individual metrics
-  464 values deleted from fish table, cascade delete on metrics
-  787 and 1900 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             787   
Number of columns          15    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  9     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment              277         0.648   7   7     0        1          0
2 fi_dts_datasource         0         1       7   7     0        1          0
3 fi_lfs_code              21         0.973   1   1     0        1          0
4 fi_id_cou               787         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 2014-09-24 2024-11-19 2024-09-17
2 fi_lastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1       42
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable             n_missing complete_rate         mean      sd
1 fi_id                             0        1      3428532      227.   
2 fi_year                           0        1         2021.       3.81 
3 fiser_ser_id                      0        1          337.      86.7  
4 lengthmm                        257        0.673      245.      93.8  
5 weightg                         268        0.659       37.3     44.9  
6 eye_diam_meanmm                 380        0.517        4.04     0.948
7 pectoral_lengthmm               615        0.219       13.1      2.70 
8 differentiated_proportion       534        0.321        0.0119   0.108
9 female_proportion               768        0.0241       0.316    0.478
          p0        p25        p50        p75       p100 hist 
1 3428139    3428336.   3428532    3428728.   3428925    ▇▇▇▇▇
2    2014       2017       2024       2024       2024    ▃▂▁▁▇
3     212        212        397        397        397    ▃▁▁▁▇
4      75        166.       244        317        569    ▆▆▇▁▁
5       0.6        7.1       25         54.7      350.   ▇▁▁▁▁
6       2.33       3.50       3.88       4.37       9.89 ▇▇▁▁▁
7       8.9       11.4       12.4       14.1       25    ▇▇▂▁▁
8       0          0          0          0          1    ▇▁▁▁▁
9       0          0          0          1          1    ▇▁▁▁▃
```

-  modified ind metric
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             22    
Number of columns          13    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  7     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment                0             1  30  73     0        3          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou                22             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date              22             0 Inf        -Inf       NA        
2 fi_lastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        0
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate       mean       sd         p0
1 fi_id                     0         1     3238234.   1898.    3235338   
2 fi_year                   0         1        2014       3.02     2010   
3 fiser_ser_id              0         1         396       0         396   
4 lengthmm                  0         1         533.    142.        166   
5 weightg                   2         0.909     430.    328.        148.  
6 eye_diam_meanmm           2         0.909       7.63    0.829       6.44
7 pectoral_lengthmm         3         0.864      26.3     6.90        9.48
        p25        p50        p75       p100 hist 
1 3236862.  3237601    3239734.   3242211    ▆▇▃▆▂
2    2012      2013       2016       2021    ▇▅▆▁▃
3     396       396        396        396    ▁▁▇▁▁
4     463       523        612.       782    ▁▁▇▅▃
5     214.      313.       479.      1380    ▇▃▁▁▁
6       7         7.44       8.02       9.48 ▇▇▇▂▂
7      21.9      25.2       32.0       39.2  ▁▁▇▅▂
```

## Annex 3

### series

### dataseries
- 3 values deleted from the db (NalS 2011 -2013)
- 4 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4     
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
1 das_comment                1          0.75  64 148     0        3          0
2 das_dts_datasource         0          1      7   7     0        1          0
3 das_qal_comment            4          0     NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate       mean      sd       p0        p25
1 das_id                0          1    9348.      1.29    9346     9347.     
2 das_value             1          0.75    0.00264 0.00186    0.001    0.00163
3 das_ser_id            0          1     400.      0.957    399      400.     
4 das_year              0          1    2024.      1       2022     2024.     
5 das_effort            1          0.75    5       2.65       2        4      
6 das_qal_id            0          1       2.25    2.06       0        0.75   
         p50        p75       p100 hist 
1 9348.      9348.      9349       ▇▇▁▇▇
2    0.00226    0.00346    0.00467 ▇▇▁▁▇
3  400.       401        401       ▃▁▃▁▇
4 2024       2024       2024       ▂▁▁▁▇
5    6          6.5        7       ▇▁▁▇▇
6    2.5        4          4       ▃▃▁▁▇
```

- 9 values updated in the db
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             9     
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
1 das_comment                0             1  94  98     0        9          0
2 das_dts_datasource         9             0  NA  NA     0        0          0
3 das_qal_comment            9             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate      mean        sd         p0       p25
1 das_id                0             1 7294.     666.      6975       6977     
2 das_value             0             1    0.0115   0.00336    0.00629    0.0103
3 das_ser_id            0             1  401        0        401        401     
4 das_year              0             1 2018.       2.93    2014       2016     
5 das_effort            0             1    7        0          7          7     
6 das_qal_id            0             1    1        0          1          1     
        p50       p75      p100 hist 
1 6979      6981      8851      ▇▁▁▁▁
2    0.0122    0.0128    0.0170 ▅▅▂▇▂
3  401       401       401      ▁▁▇▁▁
4 2018      2020      2023      ▇▇▇▇▃
5    7         7         7      ▁▁▇▁▁
6    1         1         1      ▁▁▇▁▁`
```

### group metrics
- in the template: 
  - BidY was changed for BidS in ser_nameshort new_group_metrics

-  3 values deleted from group table, cascade delete on metrics (NalS)
-  3 and 18 new values inserted in the group and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             3     
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
1 gr_comment                2         0.333  38  38     0        1          0
2 gr_dts_datasource         0         1       7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate     mean     sd
 1 gr_id                                      0         1     5771      1    
 2 gr_year                                    0         1     2024      0    
 3 gr_number                                  0         1        3.67   2.31 
 4 grser_ser_id                               0         1      400      1    
 5 m_mean_lengthmm                            0         1      368.    51.7  
 6 m_mean_weightg                             0         1       95.9   43.6  
 7 f_mean_lengthmm                            1         0.667  549     50.9  
 8 f_mean_weightg                             1         0.667  214.    74.8  
 9 female_proportion                          0         1        0.333  0.306
10 lengthmm                                   1         0.667  398     41.0  
11 weightg                                    1         0.667  119.    38.3  
12 method_sex_(1=visual,0=use_length)         2         0.333    0     NA    
       p0    p25    p50    p75   p100 hist 
 1 5770   5770.  5771   5772.  5772   ▇▁▇▁▇
 2 2024   2024   2024   2024   2024   ▁▁▇▁▁
 3    1      3      5      5      5   ▃▁▁▁▇
 4  399    400.   400    400.   401   ▇▁▇▁▇
 5  332.   338.   344.   386.   427   ▇▁▁▁▃
 6   66.4   70.8   75.3  111.   146   ▇▁▁▁▃
 7  513    531    549    567    585   ▇▁▁▁▇
 8  161    187.   214.   240.   267.  ▇▁▁▁▇
 9    0      0.2    0.4    0.5    0.6 ▇▁▁▇▇
10  369    384.   398    412.   427   ▇▁▁▁▇
11   91.9  105.   119.   132.   146   ▇▁▁▁▇
12    0      0      0      0      0   ▁▁▇▁▁
```

-  9 and 18 new values modified in the group and metric tables (NalS)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             9     
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
1 gr_comment                0             1  38  39     0        9          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean      sd     p0    p25    p50
1 gr_id                 0             1 2551.  1042.   2024   2026   2028  
2 gr_year               0             1 2018.     2.93 2014   2016   2018  
3 gr_number             0             1   22.3    7.89   12     14     26  
4 grser_ser_id          0             1  401      0     401    401    401  
5 lengthmm              0             1  342.     7.35  334.   336.   341. 
6 weightg               0             1   77.0    6.77   69.2   71.1   76.9
     p75   p100 hist 
1 2030   4553   ▇▁▁▁▂
2 2020   2023   ▇▇▇▇▃
3   28     33   ▆▁▂▇▂
4  401    401   ▁▁▇▁▁
5  346.   356.  ▇▅▅▂▂
6   80.6   90.4 ▇▅▇▁▂
```

### individual metrics
-  21 values deleted from fish table, cascade delete on metrics (NalS)
-  107 and 633 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             107   
Number of columns          16    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  10    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment               11         0.897   7   7     0        1          0
2 fi_dts_datasource         0         1       7   7     0        1          0
3 fi_lfs_code               0         1       1   1     0        1          0
4 fi_id_cou               107         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 2014-09-24 2024-11-19 2017-09-29
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1       25
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate         mean
 1 fi_id                                      0         1     3534154     
 2 fi_year                                    0         1        2018.    
 3 fiser_ser_id                               0         1         401.    
 4 lengthmm                                   9         0.916     355.    
 5 weightg                                    9         0.916      89.7   
 6 eye_diam_meanmm                            0         1           5.65  
 7 pectoral_lengthmm                          0         1          16.8   
 8 differentiated_proportion                  9         0.916       0.561 
 9 method_sex_(1=visual,0=use_length)        43         0.598       0     
10 female_proportion                         46         0.570       0.0820
       sd        p0        p25        p50        p75       p100 hist 
 1 31.0   3534101   3534128.   3534154    3534180.   3534207    ▇▇▇▇▇
 2  3.33     2014      2015       2017       2020       2024    ▇▃▃▁▃
 3  0.284     399       401        401        401        401    ▁▁▁▁▇
 4 42.6       294       332        350        364.       540    ▆▇▁▁▁
 5 40.6        43        69         82.5       92.8      302.   ▇▂▁▁▁
 6  0.965       3.3       5.01       5.48       6.04       9.72 ▁▇▃▁▁
 7  2.30       11.6      15.5       16.4       17.9       27.2  ▂▇▃▁▁
 8  0.499       0         0          1          1          1    ▆▁▁▁▇
 9  0           0         0          0          0          0    ▁▁▇▁▁
10  0.277       0         0          0          0          1    ▇▁▁▁▁
```

-  816 and 2026 new values updated in the fish and metric tables
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             816   
Number of columns          15    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  9     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment              409         0.499   7  49     0       26          0
2 fi_dts_datasource         0         1       7   7     0        1          0
3 fi_lfs_code              12         0.985   1   1     0        1          0
4 fi_id_cou               816         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date             341         0.582 2007-08-17 2023-10-06 2013-09-13
2 fi_lastupdate         0         1     2025-09-09 2025-09-09 2025-09-09
  n_unique
1       51
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable                      n_missing complete_rate        mean
1 fi_id                                      0         1     3229599.   
2 fi_year                                    0         1        2014.   
3 fiser_ser_id                               0         1         400.   
4 lengthmm                                 497         0.391     422.   
5 weightg                                  497         0.391     189.   
6 eye_diam_meanmm                          530         0.350       7.27 
7 pectoral_lengthmm                        530         0.350      20.8  
8 female_proportion                        497         0.391       0.285
9 method_sex_(1=visual,0=use_length)       319         0.609       0    
          sd        p0        p25        p50        p75      p100 hist 
1 121453.    2235843   3244178.   3244450.   3244654.   3244858   ▁▁▁▁▇
2      4.41     2007      2011       2013       2018       2023   ▇▇▅▅▅
3      0.656     399       399        399        400        401   ▇▁▆▁▂
4    116.        297       342.       362        504.       796   ▇▁▂▂▁
5    184.         56.9      78.8       96        238.      1051   ▇▁▁▁▁
6      2.44        5         6.06       6.83       7.59      24.8 ▇▁▁▁▁
7      5.46       11.8      17.0       18.8       24.2       40.5 ▆▇▃▂▁
8      0.452       0         0          0          1          1   ▇▁▁▁▃
9      0           0         0          0          0          0   ▁▁▇▁▁
```

## Annex 4
- there was some duplicates in new_data, but this is really an update of 
old data so we keep the new data

- For duplicates 252 values replaced in the t_eelstock_ eel table (values from current datacall stored with code eel_qal_id 25)
, 0 values not replaced (values from current datacall stored with code eel_qal_id 25),


```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             504   
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
 1 eel_emu_nameshort         0       1         7   7     0        3          0
 2 eel_cou_code              0       1         2   2     0        1          0
 3 eel_lfs_code              0       1         1   2     0        4          0
 4 eel_hty_code              0       1         1   2     0        4          0
 5 eel_area_division       180       0.643     6   6     0        1          0
 6 eel_qal_comment         503       0.00198  15  15     0        1          0
 7 eel_comment             256       0.492    22 161     0        3          0
 8 eel_missvaluequal         8       0.984     2   2     0        2          0
 9 eel_datasource            0       1         7   7     0        7          0
10 eel_dta_code              0       1         6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd     p0     p25     p50
1 eel_id                0        1      542380. 59082.   381260 478437. 575585 
2 eel_typ_id            0        1           4      0         4      4       4 
3 eel_year              0        1        2011.     7.17   2000   2005    2012.
4 eel_value           496        0.0159   2325.  3391.      136    453.   1219 
5 eel_qal_id            0        1          13     12.0       1      1      13 
      p75   p100 hist 
1 597782. 597908 ▁▁▇▁▇
2      4       4 ▁▁▇▁▁
3   2017    2023 ▇▇▆▇▇
4   2106.  10344 ▇▁▁▁▁
5     25      25 ▇▁▁▁▇
```

-  238 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             238   
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
 1 eel_emu_nameshort         0         1       7   7     0       13          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       1   2     0        4          0
 4 eel_hty_code              0         1       1   2     0        4          0
 5 eel_area_division       158         0.336   6   6     0        3          0
 6 eel_qal_comment         238         0      NA  NA     0        0          0
 7 eel_comment             175         0.265  22  77     0        3          0
 8 eel_missvaluequal        12         0.950   2   2     0        2          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd       p0     p25
1 eel_id                0        1      598280.    68.8  598161   598220.
2 eel_typ_id            0        1           4      0         4        4 
3 eel_year              0        1        2022.     5.22   2000     2022.
4 eel_value           226        0.0504   5403. 10297.       61.6    198.
5 eel_qal_id            0        1           1      0         1        1 
      p50     p75    p100 hist 
1 598280. 598339. 598398  ▇▇▇▇▇
2      4       4       4  ▁▁▇▁▁
3   2024    2025    2025  ▁▁▁▁▇
4   1230.   2973.  33988. ▇▁▁▁▁
5      1       1       1  ▁▁▇▁▁
```

- 178 values updated in the db
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             356   
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
 1 eel_emu_nameshort         0         1       7   7     0        1          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       1   1     0        3          0
 4 eel_hty_code              0         1       1   2     0        3          0
 5 eel_area_division       178         0.5     6   6     0        2          0
 6 eel_qal_comment         178         0.5    33  33     0      178          0
 7 eel_comment             196         0.449  34  34     0        1          0
 8 eel_missvaluequal         0         1       2   2     0        1          0
 9 eel_datasource            0         1       7   7     0        5          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd     p0     p25     p50
1 eel_id                0             1 539405. 60558.   475908 476060. 576024.
2 eel_typ_id            0             1      4      0         4      4       4 
3 eel_year              0             1   2011.     6.51   2000   2005    2011 
4 eel_value           356             0    NaN     NA        NA     NA      NA 
5 eel_qal_id            0             1     13     12.0       1      1      13 
      p75   p100 hist   
1 598725. 598814 "▇▁▁▁▇"
2      4       4 "▁▁▇▁▁"
3   2016    2023 "▇▇▆▇▅"
4     NA      NA " "    
5     25      25 "▇▁▁▁▇"
```




After the data integration, Y and S for ES_Murc where merged into YS with a SQL$
query.

```
select * from datawg.t_eelstock_eel tee where eel_year = 2025 and eel_typ_id =4 and tee.eel_emu_nameshort = 'ES_Murc' and eel_lfs_code = 'Y' and eel_hty_code = 'C';
select * from datawg.t_eelstock_eel tee where eel_year = 2025 and eel_typ_id =4 and tee.eel_emu_nameshort = 'ES_Murc' and eel_lfs_code = 'S' and eel_hty_code = 'C';
select * from datawg.t_eelstock_eel tee where eel_year = 2025 and eel_typ_id =4 and tee.eel_emu_nameshort = 'ES_Murc' and eel_lfs_code = 'YS' and eel_hty_code = 'C';


update datawg.t_eelstock_eel tee set eel_qal_id = 25, eel_qal_comment ='merge to YS' where eel_year = 2025 and eel_typ_id =4 and tee.eel_emu_nameshort = 'ES_Murc' and eel_lfs_code = 'Y' and eel_hty_code = 'C';
update datawg.t_eelstock_eel tee set eel_qal_id = 25, eel_qal_comment ='merge to YS' where eel_year = 2025 and eel_typ_id =4 and tee.eel_emu_nameshort = 'ES_Murc' and eel_lfs_code = 'S' and eel_hty_code = 'C';
update datawg.t_eelstock_eel tee set eel_value = 18833, eel_comment ='sum of Y, S, YS' where eel_year = 2025 and eel_typ_id =4 and tee.eel_emu_nameshort = 'ES_Murc' and eel_lfs_code = 'YS' and eel_hty_code = 'C';



select * from datawg.t_eelstock_eel tee where eel_year = 2025 and eel_typ_id =4 and tee.eel_emu_nameshort = 'ES_Murc' and eel_lfs_code = 'Y' and eel_hty_code = 'C';
select * from datawg.t_eelstock_eel tee where eel_year = 2025 and eel_typ_id =4 and tee.eel_emu_nameshort = 'ES_Murc' and eel_lfs_code = 'S' and eel_hty_code = 'C';
select * from datawg.t_eelstock_eel tee where eel_year = 2025 and eel_typ_id =4 and tee.eel_emu_nameshort = 'ES_Murc' and eel_lfs_code = 'YS' and eel_hty_code = 'C';
```


## Annex 5
- there were a few duplicates in the template, but exactly the same
of comment change so we accept the new version

- For duplicates 10 values replaced in the t_eelstock_ eel table (values from current datacall stored with code eel_qal_id 25)
, 0 values not replaced (values from current datacall stored with code eel_qal_id 25),

-  182 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             182   
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
 1 eel_emu_nameshort         0       1         7   7     0       13          0
 2 eel_cou_code              0       1         2   2     0        1          0
 3 eel_lfs_code              0       1         1   1     0        3          0
 4 eel_hty_code              0       1         1   2     0        4          0
 5 eel_area_division       181       0.00549   6   6     0        1          0
 6 eel_qal_comment         182       0        NA  NA     0        0          0
 7 eel_comment             169       0.0714   31  39     0        2          0
 8 eel_missvaluequal         0       1         2   2     0        1          0
 9 eel_datasource            0       1         7   7     0        1          0
10 eel_dta_code              0       1         6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean     sd     p0     p25     p50
1 eel_id                0             1 599104. 52.7   599013 599058. 599104.
2 eel_typ_id            0             1      6   0          6      6       6 
3 eel_year              0             1   2024.  0.399   2024   2024    2024 
4 eel_value           182             0    NaN  NA         NA     NA      NA 
5 eel_qal_id            0             1      1   0          1      1       1 
      p75   p100 hist   
1 599149. 599194 "▇▇▇▇▇"
2      6       6 "▁▁▇▁▁"
3   2024    2025 "▇▁▁▁▂"
4     NA      NA " "    
5      1       1 "▁▁▇▁▁"
```


```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             20    
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
 3 eel_lfs_code              0           1     1   1     0        3          0
 4 eel_hty_code              0           1     1   1     0        2          0
 5 eel_area_division        18           0.1   6   6     0        1          0
 6 eel_qal_comment          20           0    NA  NA     0        0          0
 7 eel_comment              18           0.1  71  71     0        1          0
 8 eel_missvaluequal         0           1     2   2     0        1          0
 9 eel_datasource            0           1     7   7     0        2          0
10 eel_dta_code              0           1     6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean      sd     p0     p25     p50
1 eel_id                0             1 581737. 17709.  564461 564477. 581742.
2 eel_typ_id            0             1      6      0        6      6       6 
3 eel_year              0             1   2024      0     2024   2024    2024 
4 eel_value            20             0    NaN     NA       NA     NA      NA 
5 eel_qal_id            0             1     13     12.3      1      1      13 
      p75   p100 hist   
1 598997. 599002 "▇▁▁▁▇"
2      6       6 "▁▁▇▁▁"
3   2024    2024 "▁▁▇▁▁"
4     NA      NA " "    
5     25      25 "▇▁▁▁▇"
```
## Annex 6
empty file


## Annex 7
- in the template file,
  - we removed fao_areas in habitat F and T where provided
  - in delete data, we removed extra columns that had been added
  - there are duplicates so ask Esti and Maria to fix them

- 42 values deleted in the db (ES_Anda)
-  36 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             36    
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
 3 eel_lfs_code              0             1   1   2     0        6          0
 4 eel_hty_code              0             1   1   1     0        2          0
 5 eel_area_division        36             0  NA  NA     0        0          0
 6 eel_qal_comment          36             0  NA  NA     0        0          0
 7 eel_comment              36             0  NA  NA     0        0          0
 8 eel_missvaluequal        36             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean         sd       p0      p25
1 eel_id                0             1 602316.      10.5   602298   602307. 
2 eel_typ_id            0             1      8.5      0.507      8        8  
3 eel_year              0             1   2016.       3.80    2011     2014  
4 eel_value             0             1 131966.  480746.         4.5     83.7
5 eel_qal_id            0             1      1        0          1        1  
       p50     p75    p100 hist 
1 602316.  602324.  602333 ▇▇▇▇▇
2      8.5      9        9 ▇▁▁▁▇
3   2016.    2018     2024 ▂▇▂▁▂
4    484.    4692  2100063 ▇▁▁▁▁
5      1        1        1 ▁▁▇▁▁
```

## Annex 8
- file transmitted by Maria K after the start of the meeting
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
 7 eel_comment               0             1  77  77     0        1          0
 8 eel_missvaluequal         1             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean sd     p0    p25    p50    p75
1 eel_id                0             1 608806 NA 608806 608806 608806 608806
2 eel_typ_id            0             1     11 NA     11     11     11     11
3 eel_year              0             1   2024 NA   2024   2024   2024   2024
4 eel_value             0             1 356970 NA 356970 356970 356970 356970
5 eel_qal_id            0             1      1 NA      1      1      1      1
    p100 hist 
1 608806 ▁▁▇▁▁
2     11 ▁▁▇▁▁
3   2024 ▁▁▇▁▁
4 356970 ▁▁▇▁▁
5      1 ▁▁▇▁▁
```

## Annex 9

### samplinginfo
- 4 values updated in the db (comments)

### group metrics
-  16 and 32 new values inserted in the group and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             16    
Number of columns          10    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment               15        0.0625   7   7     0        1          0
2 gr_dts_datasource         0        1        7   7     0        1          0
3 grsa_lfs_code             0        1        1   2     0        4          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean     sd       p0     p25   p50
1 gr_id                 0             1 5794.   4.76 5786     5790.   5794.
2 gr_year               0             1 2022.   2.87 2018     2019    2022 
3 gr_number             0             1  150. 242.      1        2.75   21 
4 grsa_sai_id           0             1  666.  21.1   629      646.    678.
5 lengthmm              0             1  338. 157.     63.0    268.    369.
6 weightg               0             1  137. 137.      0.227   39.4   111.
    p75  p100 hist 
1 5797. 5801  ▇▆▆▆▆
2 2024  2025  ▇▁▂▁▇
3  160.  720  ▇▂▁▁▂
4  684   685  ▂▂▁▁▇
5  426.  548. ▃▁▃▇▃
6  154.  443. ▇▇▂▁▂
```


-  14 and 28 new values modified in the group and metric tables
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             14    
Number of columns          10    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  36  40     0       14          0
2 gr_dts_datasource         0             1   7   7     0        1          0
3 grsa_lfs_code             0             1   1   1     0        2          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean     sd     p0    p25    p50
1 gr_id                 0             1 4242.  683.   3810   3825.  3832. 
2 gr_year               0             1 2020.    1.87 2018   2018   2019  
3 gr_number             0             1   59.9  81.4     2     13.2   35.5
4 grsa_sai_id           0             1  642     5.75  637    637    641  
5 lengthmm              0             1  341.   52.7   286.   308.   329. 
6 weightg               0             1  109.   56.7    72.3   80.7   91.4
     p75  p100 hist 
1 4908.  5292  ▇▁▁▁▃
2 2021.  2024  ▇▁▂▁▁
3   64.2  318  ▇▁▁▁▁
4  645    655  ▇▁▇▁▁
5  354.   490  ▇▅▂▁▁
6  100.   290. ▇▂▁▁▁
```
### individual metrics
- in the template file:
  - we removed some individual data that were almost empty
  and for which lfs_code was not provided
  - we removed species that have an incorrect sampling "ES_Murc_BIO / ES_Murc_CON"
  - removed an extra space in "ES_Murc_BIO "
  - fishes with fi_id 887274 to 887277 were both in updated and deleted... we removed them


-  1553 values deleted from fish table, cascade delete on metrics
-  4533 and 13848 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4533  
Number of columns          17    
_______________________          
Column type frequency:           
  character                5     
  Date                     2     
  numeric                  10    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment             4533             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   2     0        4          0
4 fisa_geom              4533             0  NA  NA     0        0          0
5 fi_id_cou              4533             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date            2637         0.418 2022-11-23 2025-03-13 2024-04-17
2 fi_lastupdate         0         1     2025-09-09 2025-09-09 2025-09-09
  n_unique
1       35
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable             n_missing complete_rate       mean      sd
 1 fi_id                             0         1     3565094    1309.  
 2 fi_year                           0         1        2023.      2.12
 3 fisa_sai_id                       0         1         665.     18.3 
 4 fisa_x_4326                       0         1          -3.77    4.16
 5 fisa_y_4326                       0         1          40.5     2.98
 6 lengthmm                          0         1         239.    153.  
 7 weightg                         113         0.975      59.7   105.  
 8 eye_diam_meanmm                2849         0.371       4.67    4.05
 9 pectoral_lengthmm              2829         0.376      15.6     6.03
10 differentiated_proportion      3026         0.332       0       0   
            p0        p25        p50        p75       p100 hist 
 1 3562828     3563961    3565094    3566227    3567360    ▇▇▇▇▇
 2    2018        2022       2024       2024       2025    ▂▁▂▂▇
 3     629         645        678        679        685    ▃▂▁▂▇
 4      -8.63       -6.08      -5.54       2.61       3.19 ▂▇▁▁▃
 5      36.2        36.7       42.0       42.3       43.6  ▇▁▁▅▇
 6      47.5        77.2      241        339        782    ▇▆▃▁▁
 7       0.114       0.42      23.8       67.2     2917    ▇▁▁▁▁
 8       1.42        3.47       4.42       5.5      158.   ▇▁▁▁▁
 9       2.69       12.0       14.5       18.7       40.6  ▂▇▃▁▁
10       0           0          0          0          0    ▁▁▇▁▁
```

- 37 and 81 new values updated in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             37    
Number of columns          15    
_______________________          
Column type frequency:           
  character                5     
  Date                     2     
  numeric                  8     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment               37             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        2          0
4 fisa_geom                37             0  NA  NA     0        0          0
5 fi_id_cou                37             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 2013-03-12 2022-03-25 2022-03-25
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        6
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate       mean          sd        p0
1 fi_id                 0         1     2871480.   1056706.    886733   
2 fi_year               0         1        2020.         3.76    2013   
3 fisa_sai_id           0         1         673.         9.65     648   
4 fisa_x_4326          29         0.216      -6.31       0.953     -7.45
5 fisa_y_4326          29         0.216      36.9        0.408     36.5 
6 lengthmm              0         1         292.        61.9      164   
7 weightg               1         0.973      47.5       44.6        6   
8 ageyear              29         0.216       0          0          0   
         p25        p50        p75       p100 hist 
1 3418925    3418934    3418943    3418952    ▂▁▁▁▇
2    2022       2022       2022       2022    ▂▁▁▁▇
3     678        678        678        678    ▂▁▁▁▇
4      -7.00      -6.51      -5.84      -4.94 ▇▂▅▁▅
5      36.6       36.9       37.3       37.5  ▇▁▁▂▆
6     260        280        320        500    ▃▇▇▁▁
7      25.1       35         49.2      233    ▇▂▁▁▁
8       0          0          0          0    ▁▁▇▁▁
```

