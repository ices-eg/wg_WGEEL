-----------------------------------------------------------
# IE
-----------------------------------------------------------

## Annex 1

### series

### dataseries
-  9 new values inserted in the database

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
1 das_comment                0             1  13 126     0        8          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            9             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean     sd      p0     p25     p50
1 das_id                0             1 9632      2.74 9628    9630    9632   
2 das_value             0             1  474.   815.      1.93    2.96    3.63
3 das_ser_id            0             1  126.   171.      5      37      47   
4 das_year              0             1 2025      0    2025    2025    2025   
5 das_effort            9             0  NaN     NA      NA      NA      NA   
6 das_qal_id            0             1    1.33   1       1       1       1   
    p75  p100 hist   
1 9634  9636  "▇▇▃▇▇"
2  766. 2349. "▇▁▁▁▁"
3   72   425  "▇▁▁▁▂"
4 2025  2025  "▁▁▇▁▁"
5   NA    NA  " "    
6    1     4  "▇▁▁▁▁"
```

- 6 values updated in the db(update from provisional data)

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
1 das_comment                0             1  30  30     0        1          0
2 das_dts_datasource         0             1   7   7     0        2          0
3 das_qal_comment            6             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean      sd      p0     p25     p50
1 das_id                0             1 8774.  293.    8176    8892.   8894.  
2 das_value             0             1   10.1  14.8      1.15    2.13    5.54
3 das_ser_id            0             1  180.  190.      45      52.8    70   
4 das_year              0             1 2024.    0.408 2023    2024    2024   
5 das_effort            6             0  NaN    NA       NA      NA      NA   
6 das_qal_id            0             1    1     0        1       1       1   
      p75   p100 hist   
1 8895.   8896   "▂▁▁▁▇"
2    7.12   39.9 "▇▁▁▁▂"
3  336.    425   "▇▁▁▁▃"
4 2024    2024   "▂▁▁▁▇"
5   NA      NA   " "    
6    1       1   "▁▁▇▁▁"
```

### group metrics
-  2 and 6 new values inserted in the group and metric tables

```
[1] "this is what will be in the db"
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

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  55  55     0        1          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate     mean      sd       p0      p25
1 gr_id                      0             1 6178.     0.707  6178     6178.   
2 gr_year                    0             1 2025      0      2025     2025    
3 gr_number                  0             1  890.    75.7     836      863.   
4 grser_ser_id               0             1   38.5   47.4       5       21.8  
5 lengthmm                   0             1   79.8    6.01     75.5     77.6  
6 weightg                    0             1    0.722  0.0686    0.674    0.698
7 g_in_gy_proportion         0             1    0.940  0.0134    0.931    0.936
       p50      p75     p100 hist 
1 6178.    6179.    6179     ▇▁▁▁▇
2 2025     2025     2025     ▁▁▇▁▁
3  890.     916.     943     ▇▁▁▁▇
4   38.5     55.2     72     ▇▁▁▁▇
5   79.8     81.9     84     ▇▁▁▁▇
6    0.722    0.747    0.771 ▇▁▁▁▇
7    0.940    0.945    0.95  ▇▁▁▁▇
```

### individual metrics
-  2898 and 5134 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2898  
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
1 fi_comment             2610        0.0994   3   4     0        3          0
2 fi_dts_datasource         0        1        7   7     0        1          0
3 fi_lfs_code               0        1        1   1     0        2          0
4 fi_id_cou                 0        1       11  21     0     2887          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date            1169         0.597 2014-06-01 2025-12-12 2025-01-05
2 fi_lastupdate         0         1     2025-09-09 2025-09-09 2025-09-09
  n_unique
1       96
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate       mean     sd          p0        p25
1 fi_id                 0         1     3665360.   837.   3663911     3664635.  
2 fi_year               0         1        2023.     4.38    2014        2024   
3 fiser_ser_id          0         1          68.9   99.9        5           5   
4 lengthmm              0         1          79.5   24.5        0          69   
5 weightg             662         0.772       1.04   4.03       0.054       0.28
         p50       p75    p100 hist 
1 3665360.   3666084.  3666808 ▇▇▇▇▇
2    2025       2025      2025 ▂▁▁▁▇
3      46         72       425 ▇▁▁▁▁
4      73         78       250 ▁▇▁▁▁
5       0.36       0.5     165 ▇▁▁▁▁
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
1 fi_comment                0             1  14  14     0        1          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou                 0             1  10  10     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 2024-05-10 2024-05-10 2024-05-10
2 fi_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate       mean sd         p0        p25
1 fi_id                 0             1 3253747    NA 3253747    3253747   
2 fi_year               0             1    2024    NA    2024       2024   
3 fiser_ser_id          0             1      70    NA      70         70   
4 lengthmm              0             1     156    NA     156        156   
5 weightg               0             1       5.09 NA       5.09       5.09
         p50        p75       p100 hist 
1 3253747    3253747    3253747    ▁▁▇▁▁
2    2024       2024       2024    ▁▁▇▁▁
3      70         70         70    ▁▁▇▁▁
4     156        156        156    ▁▁▇▁▁
5       5.09       5.09       5.09 ▁▁▇▁▁
```

## Annex 2

### series
- there is a now series: MuckY form Lough Muckno
- in the template: added the ser_typ_id to MuckY
- 1 new values inserted in the database
 
 
### dataseries
-  12 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             12    
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
1 das_comment                1         0.917  59  83     0        3          0
2 das_dts_datasource         0         1       7   7     0        1          0
3 das_qal_comment           12         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean      sd      p0     p25     p50
1 das_id                0         1     9652.      3.61  9646    9649.   9652.  
2 das_value             1         0.917    3.74    3.56     0.37    1.10    1.84
3 das_ser_id            0         1      362     133.     225     228.    370.  
4 das_year              0         1     2020.      5.24  2012    2016.   2020.  
5 das_effort            1         0.917  140.    102.      20      60     120   
6 das_qal_id            0         1        0.917   0.289    0       1       1   
      p75    p100 hist 
1 9654.   9657    ▇▅▅▅▇
2    6.01    9.82 ▇▁▁▁▂
3  489     489    ▇▁▁▁▇
4 2025    2025    ▃▂▁▁▇
5  205     360    ▇▆▃▂▂
6    1       1    ▁▁▁▁▇
```


### group metrics
- in the templates:
  - fixed proportions that had been provided as percentages

- 5 and 20 new values inserted in the group and metric tables
 
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             5     
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
1 gr_comment                0             1  15  15     0        1          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 gr_id                                                         0           1  
 2 gr_year                                                       0           1  
 3 gr_number                                                     0           1  
 4 grser_ser_id                                                  0           1  
 5 lengthmm                                                      0           1  
 6 weightg                                                       0           1  
 7 ageyear                                                       4           0.2
 8 differentiated_proportion                                     4           0.2
 9 anguillicola_intensity                                        4           0.2
10 f_mean_lengthmm                                               4           0.2
11 f_mean_weightg                                                4           0.2
12 f_mean_age                                                    4           0.2
13 method_sex_(1=visual,0=use_length)                            4           0.2
14 method_anguillicola_(1=stereomicroscope,0=visual_obs)         4           0.2
15 female_proportion                                             4           0.2
16 anguillicola_proportion                                       4           0.2
       mean     sd       p0      p25      p50      p75     p100 hist 
 1 6186      1.58  6184     6185     6186     6187     6188     ▇▇▇▇▇
 2 2025.     0.447 2024     2025     2025     2025     2025     ▂▁▁▁▇
 3   56.8   32.7     22       27       61       74      100     ▇▁▃▃▃
 4  232.    11.5    225      226      227      228      252     ▇▁▁▁▂
 5  438.    56.9    399      401      417      436      536     ▇▂▁▁▂
 6  170.    82.3    121      123      129      161      314     ▇▂▁▁▂
 7   16     NA       16       16       16       16       16     ▁▁▇▁▁
 8    1     NA        1        1        1        1        1     ▁▁▇▁▁
 9    0.052 NA        0.052    0.052    0.052    0.052    0.052 ▁▁▇▁▁
10  536     NA      536      536      536      536      536     ▁▁▇▁▁
11  314     NA      314      314      314      314      314     ▁▁▇▁▁
12   16     NA       16       16       16       16       16     ▁▁▇▁▁
13    1     NA        1        1        1        1        1     ▁▁▇▁▁
14    0     NA        0        0        0        0        0     ▁▁▇▁▁
15    1     NA        1        1        1        1        1     ▁▁▇▁▁
16    0.67  NA        0.67     0.67     0.67     0.67     0.67  ▁▁▇▁▁
```

-  1 and 6 new values modified in the group and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
Number of columns          13    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  10    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  15  15     0        1          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable             n_missing complete_rate     mean sd       p0
 1 gr_id                             0             1 3919     NA 3919    
 2 gr_year                           0             1 2022     NA 2022    
 3 gr_number                         0             1 1623     NA 1623    
 4 grser_ser_id                      0             1  252     NA  252    
 5 lengthmm                          0             1  554     NA  554    
 6 weightg                           0             1  343     NA  343    
 7 differentiated_proportion         0             1    0.97  NA    0.97 
 8 anguillicola_intensity            0             1    3.6   NA    3.6  
 9 female_proportion                 0             1    0.97  NA    0.97 
10 anguillicola_proportion           0             1    0.555 NA    0.555
        p25      p50      p75     p100 hist 
 1 3919     3919     3919     3919     ▁▁▇▁▁
 2 2022     2022     2022     2022     ▁▁▇▁▁
 3 1623     1623     1623     1623     ▁▁▇▁▁
 4  252      252      252      252     ▁▁▇▁▁
 5  554      554      554      554     ▁▁▇▁▁
 6  343      343      343      343     ▁▁▇▁▁
 7    0.97     0.97     0.97     0.97  ▁▁▇▁▁
 8    3.6      3.6      3.6      3.6   ▁▁▇▁▁
 9    0.97     0.97     0.97     0.97  ▁▁▇▁▁
10    0.555    0.555    0.555    0.555 ▁▁▇▁▁
```

### individual metrics
- in the template:
  - new data: changed BFUY for BFuY
  - fi_id was updated to remove weight, but remving a metric does not work in the
  shiny, so it was put in deleted and paste in new also

-  1 values deleted from fish table, cascade delete on metrics (the one from updated)
-  4742 and 15294 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4742  
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
1 fi_comment             4641        0.0213   1  76     0        2          0
2 fi_dts_datasource         0        1        7   7     0        1          0
3 fi_lfs_code               0        1        1   1     0        2          0
4 fi_id_cou                 0        1       12  28     0     4742          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date             144         0.970 2001-08-15 2025-11-07 2016-07-28
2 fi_lastupdate         0         1     2025-09-10 2025-09-10 2025-09-10
  n_unique
1       34
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 fi_id                                                         0        1     
 2 fi_year                                                       0        1     
 3 fiser_ser_id                                                  0        1     
 4 lengthmm                                                      1        1.00  
 5 weightg                                                       1        1.00  
 6 ageyear                                                    4280        0.0974
 7 differentiated_proportion                                  4253        0.103 
 8 anguillicola_intensity                                     4253        0.103 
 9 method_sex_(1=visual,0=use_length)                         4253        0.103 
10 method_anguillicola_(1=stereomicroscope,0=visual_obs)      4253        0.103 
11 female_proportion                                          4261        0.101 
12 anguillicola_proportion                                    4253        0.103 
13 eye_diam_meanmm                                            3529        0.256 
14 pectoral_lengthmm                                          3531        0.255 
          mean       sd         p0        p25        p50        p75       p100
 1 3681960.    1369.    3679590    3680775.   3681960.   3683146.   3684331   
 2    2016.       2.84     2001       2013       2016       2017       2025   
 3     474.      60.1       225        489        489        489        489   
 4     481.      97.0       248        408        469        547        910   
 5     220.     156.         26        114        173        286       2043   
 6      13.0     20.1       -99         14         16         18         30   
 7       0.984    0.127       0          1          1          1          1   
 8       2.99     4.72        0          0          1          4         62   
 9       0.967    0.178       0          1          1          1          1   
10       0        0           0          0          0          0          0   
11       0.981    0.136       0          1          1          1          1   
12       0.656    0.475       0          0          1          1          1   
13       4.78     1.20        2.11       3.84       4.64       5.51       9.76
14      21.5      5.92        7.5       17.1       20.6       25.2       50.4 
   hist 
 1 ▇▇▇▇▇
 2 ▁▁▃▇▁
 3 ▁▁▁▁▇
 4 ▂▇▅▁▁
 5 ▇▁▁▁▁
 6 ▁▁▁▁▇
 7 ▁▁▁▁▇
 8 ▇▁▁▁▁
 9 ▁▁▁▁▇
10 ▁▁▇▁▁
11 ▁▁▁▁▇
12 ▅▁▁▁▇
13 ▃▇▅▁▁
14 ▃▇▃▁▁
```

-  26 and 63 new values updated in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             26    
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
1 fi_comment                0             1  60  60     0        1          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou                 0             1  12  13     0       26          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date              18         0.308 2008-01-10 2019-01-09 2009-09-10
2 fi_lastupdate         0         1     2025-09-10 2025-09-10 2025-09-10
  n_unique
1        7
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate       mean      sd
 1 fi_id                                      0        1      3311485.   5996.  
 2 fi_year                                    0        1         2007.      7.89
 3 fiser_ser_id                               0        1          230       0   
 4 lengthmm                                  24        0.0769     490      39.6 
 5 weightg                                   22        0.154      265      37.2 
 6 method_sex_(1=visual,0=use_length)         0        1            0       0   
 7 female_proportion                          0        1            1       0   
 8 eye_diam_meanmm                           25        0.0385       2.53   NA   
 9 pectoral_lengthmm                         25        0.0385       8.92   NA   
10 differentiated_proportion                 23        0.115        1       0   
           p0        p25        p50        p75       p100 hist 
 1 3296929    3312313.   3312387    3312482.   3323251    ▂▁▇▁▁
 2    1988       2009       2009       2009       2019    ▂▁▁▇▁
 3     230        230        230        230        230    ▁▁▇▁▁
 4     462        476        490        504        518    ▇▁▁▁▇
 5     210        259.       280        286.       290    ▂▁▁▁▇
 6       0          0          0          0          0    ▁▁▇▁▁
 7       1          1          1          1          1    ▁▁▇▁▁
 8       2.53       2.53       2.53       2.53       2.53 ▁▁▇▁▁
 9       8.92       8.92       8.92       8.92       8.92 ▁▁▇▁▁
10       1          1          1          1          1    ▁▁▇▁▁
```
## Annex 3

### series

### dataseries
-  4 new values inserted in the database

### group metrics
- 3 and 26 new values inserted in the group and metric tables
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             3     
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
1 gr_comment                2         0.333 122 122     0        1          0
2 gr_dts_datasource         0         1       7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 gr_id                                                         0         1    
 2 gr_year                                                       0         1    
 3 gr_number                                                     0         1    
 4 grser_ser_id                                                  0         1    
 5 lengthmm                                                      0         1    
 6 weightg                                                       0         1    
 7 differentiated_proportion                                     2         0.333
 8 anguillicola_intensity                                        0         1    
 9 method_sex_(1=visual,0=use_length)                            2         0.333
10 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0         1    
11 female_proportion                                             2         0.333
12 anguillicola_proportion                                       0         1    
13 m_mean_lengthmm                                               1         0.667
14 m_mean_weightg                                                1         0.667
15 f_mean_lengthmm                                               1         0.667
16 f_mean_weightg                                                1         0.667
       mean      sd       p0      p25      p50      p75    p100 hist 
 1 6195       1     6194     6194.    6195     6196.    6196    ▇▁▇▁▇
 2 2024       0     2024     2024     2024     2024     2024    ▁▁▇▁▁
 3  674.    255.     518      526.     535      752.     968    ▇▁▁▁▃
 4  388.    137.     230      348.     467      468.     468    ▃▁▁▁▇
 5  451      68.4    410      412.     413      472.     530    ▇▁▁▁▃
 6  213.    112.     146      148.     151      247      343    ▇▁▁▁▃
 7    0.9    NA        0.9      0.9      0.9      0.9      0.9  ▁▁▇▁▁
 8    4.56    2.18     2.2      3.6      5        5.74     6.49 ▇▁▁▇▇
 9    0      NA        0        0        0        0        0    ▁▁▇▁▁
10    0       0        0        0        0        0        0    ▁▁▇▁▁
11    0.49   NA        0.49     0.49     0.49     0.49     0.49 ▁▁▇▁▁
12    0.798   0.135    0.660    0.732    0.804    0.867    0.93 ▇▁▇▁▇
13  371       5.66   367      369      371      373      375    ▇▁▁▁▇
14   89       2.83    87       88       89       90       91    ▇▁▁▁▇
15  569      63.6    524      546.     569      592.     614    ▇▁▁▁▇
16  382.    142.     281      331.     382.     432.     482    ▇▁▁▁▇
```

### individual metrics
- in the template : changed not recorded to "" in lfs_code

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             11214 
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
1 fi_comment            10246        0.0863  55  55     0        1          0
2 fi_dts_datasource         0        1        7   7     0        1          0
3 fi_lfs_code              19        0.998    1   1     0        2          0
4 fi_id_cou                 0        1       13  22     0    11213          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 2011-10-26 2025-02-21 2015-11-08
2 fi_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1      194
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 fi_id                                                         0        1     
 2 fi_year                                                       0        1     
 3 fiser_ser_id                                                  0        1     
 4 lengthmm                                                      1        1.00  
 5 weightg                                                       2        1.00  
 6 eye_diam_meanmm                                            6801        0.394 
 7 pectoral_lengthmm                                          6785        0.395 
 8 anguillicola_intensity                                    10278        0.0835
 9 method_anguillicola_(1=stereomicroscope,0=visual_obs)     10276        0.0836
10 anguillicola_proportion                                   10278        0.0835
11 differentiated_proportion                                 10292        0.0822
12 method_sex_(1=visual,0=use_length)                        10292        0.0822
13 female_proportion                                         10353        0.0768
14 ageyear                                                   10467        0.0666
           mean       sd      p0        p25       p50        p75      p100 hist 
 1 3828662.     3237.    3823055 3825858.   3828662.  3831465.   3834268   ▇▇▇▇▇
 2    2016.        4.60     2011    2012       2015      2020       2024   ▇▆▂▁▅
 3     447.       66.6       230     467        467       467        468   ▁▁▁▁▇
 4     489.      142.          0     372        425       601       1041   ▁▇▅▃▁
 5     279.      279.          0      90        135       400.      2785   ▇▁▁▁▁
 6       6.66      2.13      -99       5.64       6.5       7.52      14.2 ▁▁▁▁▇
 7      25.7       7.63      -99      19.7       23.4      31.0       59.5 ▁▁▁▇▅
 8       2.45      4.31        0       0          0         3         39   ▇▁▁▁▁
 9       0.0544    0.227       0       0          0         0          1   ▇▁▁▁▁
10       0.482     0.500       0       0          0         1          1   ▇▁▁▁▇
11       1         0           1       1          1         1          1   ▁▁▇▁▁
12       0.930     0.256       0       1          1         1          1   ▁▁▁▁▇
13       0.453     0.498       0       0          0         1          1   ▇▁▁▁▆
14      19.0       4.81        0      16         18        22         38   ▁▃▇▂▁
```

-  26 and 63 new values updated in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             26    
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
1 fi_comment                0             1  60  60     0        1          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou                 0             1  12  13     0       26          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date              18         0.308 2008-01-10 2019-01-09 2009-09-10
2 fi_lastupdate         0         1     2025-09-10 2025-09-10 2025-09-10
  n_unique
1        7
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate       mean      sd
 1 fi_id                                      0        1      3311485.   5996.  
 2 fi_year                                    0        1         2007.      7.89
 3 fiser_ser_id                               0        1          230       0   
 4 lengthmm                                  24        0.0769     490      39.6 
 5 weightg                                   22        0.154      265      37.2 
 6 method_sex_(1=visual,0=use_length)         0        1            0       0   
 7 female_proportion                          0        1            1       0   
 8 eye_diam_meanmm                           25        0.0385       2.53   NA   
 9 pectoral_lengthmm                         25        0.0385       8.92   NA   
10 differentiated_proportion                 23        0.115        1       0   
           p0        p25        p50        p75       p100 hist 
 1 3296929    3312313.   3312387    3312482.   3323251    ▂▁▇▁▁
 2    1988       2009       2009       2009       2019    ▂▁▁▇▁
 3     230        230        230        230        230    ▁▁▇▁▁
 4     462        476        490        504        518    ▇▁▁▁▇
 5     210        259.       280        286.       290    ▂▁▁▁▇
 6       0          0          0          0          0    ▁▁▇▁▁
 7       1          1          1          1          1    ▁▁▇▁▁
 8       2.53       2.53       2.53       2.53       2.53 ▁▁▇▁▁
 9       8.92       8.92       8.92       8.92       8.92 ▁▁▇▁▁
10       1          1          1          1          1    ▁▁▇▁▁
```
## Annex 4
-  72 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             72    
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
 1 eel_emu_nameshort         0         1       7   7     0        6          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       1   1     0        3          0
 4 eel_hty_code              0         1       1   2     0        4          0
 5 eel_area_division        72         0      NA  NA     0        0          0
 6 eel_qal_comment          72         0      NA  NA     0        0          0
 7 eel_comment               0         1      14  34     0        3          0
 8 eel_missvaluequal        24         0.667   2   2     0        1          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean   sd     p0     p25     p50
1 eel_id                0         1     600568. 20.9 600532 600550. 600568.
2 eel_typ_id            0         1          4   0        4      4       4 
3 eel_year              0         1       2025   0     2025   2025    2025 
4 eel_value            48         0.333      0   0        0      0       0 
5 eel_qal_id            0         1          1   0        1      1       1 
      p75   p100 hist 
1 600585. 600603 ▇▇▇▇▇
2      4       4 ▁▁▇▁▁
3   2025    2025 ▁▁▇▁▁
4      0       0 ▁▁▇▁▁
5      1       1 ▁▁▇▁▁
```

## Annex 5
-  72 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             72    
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
 1 eel_emu_nameshort         0         1       7   7     0        6          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       1   1     0        3          0
 4 eel_hty_code              0         1       1   2     0        4          0
 5 eel_area_division        72         0      NA  NA     0        0          0
 6 eel_qal_comment          72         0      NA  NA     0        0          0
 7 eel_comment               0         1      25  76     0        4          0
 8 eel_missvaluequal        12         0.833   2   2     0        1          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean   sd     p0     p25     p50
1 eel_id                0         1     600712. 20.9 600676 600694. 600712.
2 eel_typ_id            0         1          6   0        6      6       6 
3 eel_year              0         1       2025   0     2025   2025    2025 
4 eel_value            60         0.167      0   0        0      0       0 
5 eel_qal_id            0         1          1   0        1      1       1 
      p75   p100 hist 
1 600729. 600747 ▇▇▇▇▇
2      6       6 ▁▁▇▁▁
3   2025    2025 ▁▁▇▁▁
4      0       0 ▁▁▇▁▁
5      1       1 ▁▁▇▁▁
```

## Annex 6
-  14 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             14    
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
 1 eel_emu_nameshort         0             1   7   7     0        3          0
 2 eel_cou_code              0             1   2   2     0        1          0
 3 eel_lfs_code              0             1   1   2     0        4          0
 4 eel_hty_code              0             1   1   1     0        1          0
 5 eel_area_division        14             0  NA  NA     0        0          0
 6 eel_qal_comment          14             0  NA  NA     0        0          0
 7 eel_comment               0             1  72 319     0        8          0
 8 eel_missvaluequal        14             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean          sd         p0     p25
1 eel_id                0             1 600826.        4.18  600820     600823.
2 eel_typ_id            0             1     32.5       0.519     32         32 
3 eel_year              0             1   2024         0       2024       2024 
4 eel_value             0             1 436584.  1538550.         0.225    404.
5 eel_qal_id            0             1      1         0          1          1 
       p50     p75    p100 hist 
1 600826.  600830.  600833 ▇▇▅▇▇
2     32.5     33       33 ▇▁▁▁▇
3   2024     2024     2024 ▁▁▇▁▁
4   9572.   47933. 5780645 ▇▁▁▁▁
5      1        1        1 ▁▁▇▁▁
```


## Annex 7
-  14 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             14    
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
 1 eel_emu_nameshort         0             1   7   7     0        3          0
 2 eel_cou_code              0             1   2   2     0        1          0
 3 eel_lfs_code              0             1   1   2     0        4          0
 4 eel_hty_code              0             1   1   1     0        1          0
 5 eel_area_division        14             0  NA  NA     0        0          0
 6 eel_qal_comment          14             0  NA  NA     0        0          0
 7 eel_comment               0             1  62 319     0        7          0
 8 eel_missvaluequal        14             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean          sd         p0     p25
1 eel_id                0             1 600854.        4.18  600848     600851.
2 eel_typ_id            0             1      8.5       0.519      8          8 
3 eel_year              0             1   2024         0       2024       2024 
4 eel_value             0             1 436561.  1538556.         0.225    404.
5 eel_qal_id            0             1      1         0          1          1 
       p50     p75    p100 hist 
1 600854.  600858.  600861 ▇▇▅▇▇
2      8.5      9        9 ▇▁▁▁▇
3   2024     2024     2024 ▁▁▇▁▁
4   9572.   47733  5780645 ▇▁▁▁▁
5      1        1        1 ▁▁▇▁▁
```


## Annex 8
-  1 new values inserted in the database (NP)

## Annex 9

### samplinginfo
- 16 new values inserted in the database (corresponding to a phd data collection)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             16    
Number of columns          13    
_______________________          
Column type frequency:           
  character                10    
  Date                     1     
  numeric                  2     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
   skim_variable         n_missing complete_rate min max empty n_unique
 1 sai_name                      0         1      13  23     0       16
 2 sai_cou_code                  0         1       2   2     0        1
 3 sai_emu_nameshort             0         1       7   7     0        3
 4 sai_area_division            16         0      NA  NA     0        0
 5 sai_hty_code                  0         1       1   1     0        1
 6 sai_comment                   1         0.938  68  90     0        2
 7 sai_samplingobjective         0         1       3  29     0        2
 8 sai_samplingstrategy          0         1      17  17     0        1
 9 sai_protocol                  0         1      12  31     0        3
10 sai_dts_datasource            0         1       7   7     0        1
   whitespace
 1          0
 2          0
 3          0
 4          0
 5          0
 6          0
 7          0
 8          0
 9          0
10          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable  n_missing complete_rate min        max        median    
1 sai_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate mean   sd  p0  p25  p50  p75 p100 hist 
1 sai_id                0             1 888. 4.76 881 885. 888. 892.  896 ▇▆▆▆▆
2 sai_qal_id            0             1   1  0      1   1    1    1     1 ▁▁▇▁▁
```

- another sampling as added in a second stage (IE_West_BurrS)

### group metrics
-  15 and 30 new values inserted in the group and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             15    
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
1 gr_comment               15             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0
3 grsa_lfs_code             0             1   1   1     0        2          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean      sd    p0    p25   p50   p75
1 gr_id                 0             1 6207     4.47  6200  6204.  6207  6210.
2 gr_year               0             1 2024.    0.258 2024  2024   2024  2024 
3 gr_number             0             1   14.7  14.0      1     4.5   11    18 
4 grsa_sai_id           0             1  904     4.47   897   900.   904   908.
5 lengthmm              0             1  654.   79.3    503.  607.   626.  697.
6 weightg               0             1  491.  168.     214.  386.   461.  605.
   p100 hist 
1 6214  ▇▇▇▇▇
2 2025  ▇▁▁▁▁
3   46  ▇▇▁▁▂
4  911  ▇▇▇▇▇
5  825. ▁▇▃▃▁
6  867. ▂▇▃▃▁
```

### individual metrics
- in the template file, fixed Y/S to YS
- 4028 and 16673 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4028  
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
1 fi_comment             4026      0.000497  35  36     0        2          0
2 fi_dts_datasource         0      1          7   7     0        1          0
3 fi_lfs_code               0      1          1   2     0        3          0
4 fisa_geom              4028      0         NA  NA     0        0          0
5 fi_id_cou                 0      1          9  28     0     3958          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date             455         0.887 1983-09-21 2025-01-28 2017-05-23
2 fi_lastupdate         0         1     2025-09-10 2025-09-10 2025-09-10
  n_unique
1       90
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 fi_id                                                         0        1     
 2 fi_year                                                       0        1     
 3 fisa_sai_id                                                   0        1     
 4 fisa_x_4326                                                  22        0.995 
 5 fisa_y_4326                                                  14        0.997 
 6 lengthmm                                                      2        1.00  
 7 weightg                                                     129        0.968 
 8 eye_diam_meanmm                                            2022        0.498 
 9 pectoral_lengthmm                                          2025        0.497 
10 ageyear                                                    3147        0.219 
11 differentiated_proportion                                  3116        0.226 
12 anguillicola_intensity                                     3653        0.0931
13 method_sex_(1=visual,0=use_length)                         3116        0.226 
14 method_anguillicola_(1=stereomicroscope,0=visual_obs)      3653        0.0931
15 female_proportion                                          3119        0.226 
16 anguillicola_proportion                                    3653        0.0931
          mean        sd         p0        p25        p50        p75       p100
 1 3843340.    1163.     3841327    3842334.   3843340.   3844347.   3845354   
 2    2014.       6.17      1987       2011       2016       2017       2025   
 3     912.       1.87       897        912        912        912        914   
 4      -7.47     0.869       -9.58      -7.08      -7.08      -7.08      -7.08
 5      53.8      0.168       52.8       53.8       53.8       53.8       54.1 
 6     515.     104.         231        440        505        582       1079.  
 7     263.     196.           0        138.       212        330       2640   
 8       5.48     1.33         1.92       4.54       5.36       6.26      12   
 9      22.9      5.84         7.2       18.6       22.3       26.6       52   
10      23.0      8.79         7         16         22         30         52   
11       0.997    0.0573       0          1          1          1          1   
12       4.82     6.60         0          1          3          6.5       48   
13       0.891    0.311        0          1          1          1          1   
14       0        0            0          0          0          0          0   
15       0.798    0.402        0          1          1          1          1   
16       0.773    0.419        0          1          1          1          1   
   hist 
 1 ▇▇▇▇▇
 2 ▁▁▁▇▂
 3 ▁▁▁▁▇
 4 ▁▁▁▁▇
 5 ▁▁▁▁▇
 6 ▂▇▃▁▁
 7 ▇▁▁▁▁
 8 ▂▇▃▁▁
 9 ▂▇▅▁▁
10 ▇▇▆▂▁
11 ▁▁▁▁▇
12 ▇▁▁▁▁
13 ▁▁▁▁▇
14 ▁▁▇▁▁
15 ▂▁▁▁▇
16 ▂▁▁▁▇
```


