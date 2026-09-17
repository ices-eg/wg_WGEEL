-----------------------------------------------------------
# PT
-----------------------------------------------------------

## Annex 1

### series
no change

### dataseries

 3 new values inserted in the database
 
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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment                1         0.667  91 190     0        2          0
2 das_dts_datasource         0         1       7   7     0        1          0
3 das_qal_comment            3         0      NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean     sd    p0     p25   p50     p75  p100 hist 
1 das_id                0         1     10662    1    10661 10662.  10662 10662.  10663 ▇▁▇▁▇
2 das_value             0         1       470. 448.      82   224.    367   664.    960 ▇▇▁▁▇
3 das_ser_id            0         1       141   99.0     27   109     191   198     205 ▃▁▁▁▇
4 das_year              0         1      2026    0     2026  2026    2026  2026    2026 ▁▁▇▁▁
5 das_effort            1         0.667     5    1.41     4     4.5     5     5.5     6 ▇▁▁▁▇
6 das_qal_id            1         0.667     2    1.41     1     1.5     2     2.5     3 ▇▁▁▁▇


### group metrics

 2 and 5 new values inserted in the group and metric tables
 
  2 and 5 new values inserted in the group and metric tables[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2     
Number of columns          10    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  7     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  73  84     0        2          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate     mean        sd      p0      p25      p50      p75     p100 hist 
1 gr_id                      0           1   6892.      0.707   6892    6892.    6892.    6893.    6893     ▇▁▁▁▇
2 gr_year                    0           1   2026       0       2026    2026     2026     2026     2026     ▁▁▇▁▁
3 gr_number                  0           1    460     198.       320     390      460      530      600     ▇▁▁▁▇
4 grser_ser_id               0           1    198       9.90     191     194.     198      202.     205     ▇▁▁▁▇
5 lengthmm                   0           1     69.5     0.707     69      69.2     69.5     69.8     70     ▇▁▁▁▇
6 weightg                    0           1      0.323   0.00424    0.32    0.322    0.323    0.324    0.326 ▇▁▁▁▇
7 g_in_gy_proportion         1           0.5    1      NA          1       1        1        1        1     ▁▁▇▁▁
### individual metrics

 920 and 1840 new values inserted in the fish and metric tables
 
 [1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             920   
Number of columns          11    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment              920             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou               920             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2025-10-20 2026-05-16 2026-03-18       10
2 fi_lastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate        mean       sd         p0         p25        p50         p75       p100 hist 
1 fi_id                 0             1 4614002.    266.     4613542    4613772.    4614002.   4614231.    4614461    ▇▇▇▇▇
2 fi_year               0             1    2026.      0.413     2025       2026        2026       2026        2026    ▂▁▁▁▇
3 fiser_ser_id          0             1     200.      6.67       191        191         205        205         205    ▅▁▁▁▇
4 lengthmm              0             1      69.4     4.00        57         67          70         72          81    ▁▃▇▅▁
5 weightg               0             1       0.324   0.0702       0.15       0.275       0.32       0.371       0.57 ▂▇▇▂▁

## Annex 2

### series

### dataseries

 2 new values inserted in the database

### group metrics

 2 and 4 new values inserted in the group and metric tables
 
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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  13  23     0        2          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean      sd     p0    p25    p50    p75   p100 hist 
1 gr_id                 0             1 6896.    0.707 6896   6896.  6896.  6897.  6897   ▇▁▁▁▇
2 gr_year               0             1 2025     0     2025   2025   2025   2025   2025   ▁▁▇▁▁
3 gr_number             0             1  509   107.     433    471    509    547    585   ▇▁▁▁▇
4 grser_ser_id          0             1  242.    0.707  241    241.   242.   242.   242   ▇▁▁▁▇
5 lengthmm              0             1  196.   26.4    177    186.   196.   205.   214.  ▇▁▁▁▇
6 weightg               0             1   19.7   8.44    13.7   16.7   19.7   22.6   25.6 ▇▁▁▁▇

### individual metrics

920 and 1840 new values inserted in the fish and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             920   
Number of columns          11    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment              920             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou               920             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2025-10-20 2026-05-16 2026-03-18       10
2 fi_lastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate        mean       sd         p0         p25        p50         p75       p100 hist 
1 fi_id                 0             1 4615842.    266.     4615382    4615612.    4615842.   4616071.    4616301    ▇▇▇▇▇
2 fi_year               0             1    2026.      0.413     2025       2026        2026       2026        2026    ▂▁▁▁▇
3 fiser_ser_id          0             1     200.      6.67       191        191         205        205         205    ▅▁▁▁▇
4 lengthmm              0             1      69.4     4.00        57         67          70         72          81    ▁▃▇▅▁
5 weightg               0             1       0.324   0.0702       0.15       0.275       0.32       0.371       0.57 ▂▇▇▂▁


## Annex 3

### series

### dataseries

 2 new values inserted in the database

### group metrics

note : I converted percentages to proportions

 2 and 24 new values inserted in the group and metric tables
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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  11  46     0        2          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate     mean      sd       p0      p25      p50      p75     p100 hist 
 1 gr_id                                                         0             1 6900.     0.707  6900     6900.    6900.    6901.    6901     ▇▁▁▁▇
 2 gr_year                                                       0             1 2025      0      2025     2025     2025     2025     2025     ▁▁▇▁▁
 3 gr_number                                                     0             1    6      0         6        6        6        6        6     ▁▁▇▁▁
 4 grser_ser_id                                                  0             1  244.     0.707   243      243.     244.     244.     244     ▇▁▁▁▇
 5 lengthmm                                                      0             1  331.    15.0     321.     326.     331.     337.     342     ▇▁▁▁▇
 6 weightg                                                       0             1   68.2    4.30     65.1     66.6     68.2     69.7     71.2   ▇▁▁▁▇
 7 ageyear                                                       0             1    5.98   2.44      4.25     5.11     5.98     6.84     7.7   ▇▁▁▁▇
 8 differentiated_proportion                                     0             1    1      0         1        1        1        1        1     ▁▁▇▁▁
 9 anguillicola_intensity                                        0             1    1.76   0.0919    1.7      1.73     1.76     1.80     1.83  ▇▁▁▁▇
10 m_mean_lengthmm                                               0             1  331.    14.6     321.     326.     331.     336.     342.    ▇▁▁▁▇
11 m_mean_weightg                                                0             1   68.2    4.32     65.1     66.6     68.2     69.7     71.2   ▇▁▁▁▇
12 m_mean_ageyear                                                0             1    5.98   2.44      4.25     5.11     5.98     6.84     7.7   ▇▁▁▁▇
13 method_sex_(1=visual,0=use_length)                            0             1    1      0         1        1        1        1        1     ▁▁▇▁▁
14 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0             1    0.5    0.707     0        0.25     0.5      0.75     1     ▇▁▁▁▇
15 female_proportion                                             0             1    0      0         0        0        0        0        0     ▁▁▇▁▁
16 anguillicola_proportion                                       0             1    0.750  0.118     0.667    0.708    0.750    0.791    0.833 ▇▁▁▁▇


### individual metrics

12 and 130 new values inserted in the fish and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             12    
Number of columns          20    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  14    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment               12             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou                12             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2025-02-07 2025-11-09 2025-10-08        7
2 fi_lastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate       mean     sd         p0        p25        p50        p75       p100 hist 
 1 fi_id                                                         0         1     4617228.    3.61  4617222    4617225.   4617228.   4617230.   4617233    ▇▅▅▅▇
 2 fi_year                                                       0         1        2025     0        2025       2025       2025       2025       2025    ▁▁▇▁▁
 3 fiser_ser_id                                                  0         1         244.    0.522     243        243        244.       244        244    ▇▁▁▁▇
 4 lengthmm                                                      0         1         331.   16.0       305        322.       336.       340.       353    ▃▂▃▇▆
 5 weightg                                                       0         1          68.2  11.1        50.6       62.4       67.4       74.0       91.7  ▇▇▇▅▂
 6 ageyear                                                       2         0.833       6.3   2.16        3          5.25       7          7         10    ▃▂▇▂▂
 7 eye_diam_meanmm                                               0         1           5.78  0.382       5.20       5.49       5.85       6.02       6.35 ▅▂▃▇▂
 8 pectoral_lengthmm                                             0         1          17.7   1.08       16.2       17.2       17.4       18.1       20.4  ▂▇▂▁▁
 9 differentiated_proportion                                     0         1           1     0           1          1          1          1          1    ▁▁▇▁▁
10 anguillicola_intensity                                        0         1           1.75  1.54        0          0.75       1          3          4    ▆▇▁▆▃
11 method_sex_(1=visual,0=use_length)                            0         1           1     0           1          1          1          1          1    ▁▁▇▁▁
12 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0         1           0.5   0.522       0          0          0.5        1          1    ▇▁▁▁▇
13 female_proportion                                             0         1           0     0           0          0          0          0          0    ▁▁▇▁▁
14 anguillicola_proportion                                       0         1           0.75  0.452       0          0.75       1          1          1    ▂▁▁▁▇

## Annex 4

2 new values inserted in the database

## Annex 5

24 new values inserted in the database ( all NP)


## Annex 6 No other landings



## Annex 7 No restocking


## Annex 8

 1 new values inserted in the database

## Annex 9 :  No annex


