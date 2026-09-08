-----------------------------------------------------------
# IE
-----------------------------------------------------------

## Annex 1

### series


### dataseries

#### new

 9 new values inserted in the database
 
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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment                0             1  22 128     0        5          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            9             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean     sd        p0      p25      p50     p75   p100 hist   
1 das_id                0             1 10477    2.74 10473     10475    10477    10479   10481  "▇▇▃▇▇"
2 das_value             0             1   135. 366.       0.131     0.85     7.47    32.4  1111. "▇▁▁▁▁"
3 das_ser_id            0             1   126. 171.       5        37       47       72     425  "▇▁▁▁▂"
4 das_year              0             1  2026    0     2026      2026     2026     2026    2026  "▁▁▇▁▁"
5 das_effort            9             0   NaN   NA       NA        NA       NA       NA      NA  " "    
6 das_qal_id            0             1     1    0        1         1        1        1       1  "▁▁▇▁▁"


#### modified 


8 values updated in the db

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             8     
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
1 das_comment                0             1  24 165     0        4          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            8             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean     sd      p0     p25    p50   p75  p100 hist   
1 das_id                0             1 9641.   2.82 9637    9640.   9642.  9643. 9645  "▇▃▃▇▇"
2 das_value             0             1  536. 852.      1.02    3.44   15.3  871. 2349. "▇▂▂▁▂"
3 das_ser_id            0             1  132. 182.      5      29.2    46    158.  425  "▇▁▁▁▂"
4 das_year              0             1 2025    0    2025    2025    2025   2025  2025  "▁▁▇▁▁"
5 das_effort            8             0  NaN   NA      NA      NA      NA     NA    NA  " "    
6 das_qal_id            0             1    1    0       1       1       1      1     1  "▁▁▇▁▁"


### group metrics


 3 and 9 new values inserted in the group and metric tables
 
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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  12  55     0        2          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate     mean      sd       p0      p25      p50     p75     p100 hist 
1 gr_id                      0             1 6737       1     6736     6736.    6737     6738.   6738     ▇▁▇▁▇
2 gr_year                    0             1 2026       0     2026     2026     2026     2026    2026     ▁▁▇▁▁
3 gr_number                  0             1  381     408.      59      152.     244      542     840     ▇▇▁▁▇
4 grser_ser_id               0             1   49      38.1      5       37.5     70       71      72     ▃▁▁▁▇
5 lengthmm                   0             1   79.5     5.31    75.1     76.6     78       81.7    85.4   ▇▇▁▁▇
6 weightg                    0             1    0.954   0.341    0.616    0.782    0.948    1.12    1.30  ▇▁▇▁▇
7 g_in_gy_proportion         0             1    0.851   0.178    0.653    0.778    0.902    0.95    0.998 ▇▁▁▇▇

### individual metrics

problem of date format, no idea why... Some excel stuff....

#### new

 1143 and 2285 new values inserted in the fish and metric tables
 
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1143  
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
1 fi_comment             1143             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        3          0
4 fi_id_cou                 0             1  11  21     0     1142          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2025-07-15 2026-10-07 2026-05-19       21
2 fi_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate        mean     sd         p0        p25         p50         p75      p100 hist 
1 fi_id                 0         1     4568529     330.   4567958    4568244.   4568529     4568814.    4569100   ▇▇▇▇▇
2 fi_year               0         1        2026       0       2026       2026       2026        2026        2026   ▁▁▇▁▁
3 fiser_ser_id          0         1          22.7    29.4        5          5          5          70          72   ▇▁▁▁▃
4 lengthmm              0         1          76.3    27.4       50         66         70          73         231   ▇▁▁▁▁
5 weightg               1         0.999       0.895   2.36       0.12       0.29       0.339       0.399      17.8 ▇▁▁▁▁

## Annex 2

### series

No change

### dataseries

 5 new values inserted in the database
 
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             5     
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
1 das_comment                0             1  59  83     0        2          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            5             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean      sd       p0      p25      p50      p75  p100 hist 
1 das_id                0             1 10493      1.58  10491    10492    10493    10494    10495 ▇▇▇▇▇
2 das_value             0             1     1.85   1.89      0.39     0.42     1.38     2.05     5 ▇▇▁▁▃
3 das_ser_id            0             1   279    117.      225      226      227      228      489 ▇▁▁▁▂
4 das_year              0             1  2026.     0.447  2025     2026     2026     2026     2026 ▂▁▁▁▇
5 das_effort            0             1    92     85.6      20       60       60       80      240 ▇▂▁▁▂
6 das_qal_id            0             1     1      0         1        1        1        1        1 ▁▁▇▁▁


### group metrics

#### new

 5 and 17 new values inserted in the group and metric tables
 
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             5     
Number of columns          16    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  13    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1   6  15     0        5          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate     mean      sd       p0      p25      p50      p75     p100 hist 
 1 gr_id                                                         0           1   6744       1.58  6742     6743     6744     6745     6746     ▇▇▇▇▇
 2 gr_year                                                       0           1   2026.      0.447 2025     2026     2026     2026     2026     ▂▁▁▁▇
 3 gr_number                                                     0           1    216.    384.      25       31       41       83      902     ▇▁▁▁▂
 4 grser_ser_id                                                  0           1    279     117.     225      226      227      228      489     ▇▁▁▁▂
 5 lengthmm                                                      0           1    431.     56.0    377      406      421      427      525.    ▇▇▁▁▃
 6 weightg                                                       0           1    411.    552.      98      129      149      290.    1389     ▇▁▁▁▂
 7 anguillicola_intensity                                        4           0.2    4.16   NA        4.16     4.16     4.16     4.16     4.16  ▁▁▇▁▁
 8 m_mean_lengthmm                                               4           0.2  383      NA      383      383      383      383      383     ▁▁▇▁▁
 9 f_mean_lengthmm                                               4           0.2  483      NA      483      483      483      483      483     ▁▁▇▁▁
10 method_sex_(1=visual,0=use_length)                            4           0.2    1      NA        1        1        1        1        1     ▁▁▇▁▁
11 method_anguillicola_(1=stereomicroscope,0=visual_obs)         4           0.2    0      NA        0        0        0        0        0     ▁▁▇▁▁
12 female_proportion                                             4           0.2    0.926  NA        0.926    0.926    0.926    0.926    0.926 ▁▁▇▁▁
13 anguillicola_proportion                                       4           0.2    0.463  NA        0.463    0.463    0.463    0.463    0.463 ▁▁▇▁▁

### individual metrics

1078 and 2692 new values inserted in the fish and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1078  
Number of columns          19    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  13    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment             1078             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou                 0             1  13  15     0     1076          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date             176         0.837 2025-06-24 2025-08-14 2025-06-26        6
2 fi_lastupdate         0         1     2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate        mean      sd         p0        p25        p50        p75       p100 hist 
 1 fi_id                                                         0        1      4570782.    311.    4570244    4570513.   4570782.   4571052.   4571321    ▇▇▇▇▇
 2 fi_year                                                       0        1         2025.      0.370    2025       2025       2025       2025       2026    ▇▁▁▁▂
 3 fiser_ser_id                                                  0        1          446.     97.1       225        489        489        489        489    ▂▁▁▁▇
 4 lengthmm                                                      0        1          507.    107.        291        425.       495        576.       958    ▅▇▅▁▁
 5 weightg                                                       3        0.997      264.    196.         45        132.       206        338.      1884    ▇▁▁▁▁
 6 eye_diam_meanmm                                             973        0.0974       5.27    1.46        2.85       4.08       5.21       6.22       8.72 ▆▆▇▂▃
 7 pectoral_lengthmm                                           974        0.0965      22.9     7.53       11.6       16.8       21.4       27.7       43.6  ▇▆▅▃▁
 8 differentiated_proportion                                  1023        0.0510       0       0           0          0          0          0          0    ▁▁▇▁▁
 9 anguillicola_intensity                                     1023        0.0510       1.89    2.99        0          0          0          2.5       13    ▇▁▁▁▁
10 method_sex_(1=visual,0=use_length)                         1023        0.0510       1       0           1          1          1          1          1    ▁▁▇▁▁
11 method_anguillicola_(1=stereomicroscope,0=visual_obs)      1023        0.0510       0       0           0          0          0          0          0    ▁▁▇▁▁
12 female_proportion                                          1023        0.0510       0.909   0.290       0          1          1          1          1    ▁▁▁▁▇
13 anguillicola_proportion                                    1023        0.0510       0.455   0.503       0          0          0          1          1    ▇▁▁▁▇


## Annex 3

### series

No new series

### dataseries

 4 new values inserted in the database
 
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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment                0             1  24  66     0        4          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            4             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean      sd     p0    p25    p50    p75  p100 hist 
1 das_id                0             1 10502.    1.29 10501  10502. 10502. 10503. 10504 ▇▇▁▇▇
2 das_value             0             1  1629. 1324.     530.   550.  1374.  2453.  3237 ▇▁▁▃▃
3 das_ser_id            0             1   348.  137.     229    230.   348.   467.   468 ▇▁▁▁▇
4 das_year              0             1  2025     0     2025   2025   2025   2025   2025 ▁▁▇▁▁
5 das_effort            0             1   511.  622.     100    139    258.   631.  1428 ▇▁▁▁▂
6 das_qal_id            0             1     1     0        1      1      1      1      1 ▁▁▇▁▁


### group metrics

 4 and 44 new values inserted in the group and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4     
Number of columns          22    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  19    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                1          0.75  25  52     0        3          0
2 gr_dts_datasource         0          1      7   7     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate     mean        sd       p0      p25      p50      p75     p100 hist 
 1 gr_id                                                         0          1    6756.      1.29    6754     6755.    6756.    6756.    6757     ▇▇▁▇▇
 2 gr_year                                                       0          1    2025       0       2025     2025     2025     2025     2025     ▁▁▇▁▁
 3 gr_number                                                     0          1     787     360.       332      635      808      960     1200     ▇▁▇▇▇
 4 grser_ser_id                                                  0          1     348.    137.       229      230.     348.     467.     468     ▇▁▁▁▇
 5 lengthmm                                                      0          1     506.     88.9      424      440.     492.     559      616     ▇▁▁▃▃
 6 weightg                                                       0          1     307.    167.       155      179      281      409.     512     ▇▁▁▃▃
 7 anguillicola_intensity                                        2          0.5     5.24    0.0636     5.2      5.22     5.24     5.27     5.29  ▇▁▁▁▇
 8 m_mean_lengthmm                                               0          1     372.     11.2      358      365.     372.     379.     383     ▇▇▁▇▇
 9 m_mean_weightg                                                0          1      95.8    13.6       84       84.2     94.6    106.     110     ▇▁▁▁▇
10 f_mean_lengthmm                                               0          1     584.     88.1      480      527.     596      653      665     ▃▃▁▁▇
11 f_mean_weightg                                                0          1     429.    205.       216      275.     432.     586.     635.    ▇▁▁▁▇
12 s_in_ys_proportion                                            1          0.75    0.988   0.00249    0.986    0.987    0.988    0.989    0.991 ▇▇▁▁▇
13 method_sex_(1=visual,0=use_length)                            0          1       0.5     0.577      0        0        0.5      1        1     ▇▁▁▁▇
14 method_anguillicola_(1=stereomicroscope,0=visual_obs)         2          0.5     0       0          0        0        0        0        0     ▁▁▇▁▁
15 female_proportion                                             0          1       0.366   0.254      0.129    0.159    0.356    0.563    0.625 ▇▁▁▁▇
16 anguillicola_proportion                                       2          0.5     0.562   0.115      0.481    0.522    0.562    0.603    0.644 ▇▁▁▁▇
17 ageyear                                                       3          0.25   26.4    NA         26.4     26.4     26.4     26.4     26.4   ▁▁▇▁▁
18 m_mean_ageyear                                                3          0.25   20.9    NA         20.9     20.9     20.9     20.9     20.9   ▁▁▇▁▁
19 f_mean_age                                                    3          0.25   30.1    NA         30.1     30.1     30.1     30.1     30.1   ▁▁▇▁▁

### individual metrics


 3148 and 14081 new values inserted in the fish and metric tables
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             3148  
Number of columns          19    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  13    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment             3148             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou                 0             1  11  19     0     3147          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2025-01-09 2025-12-15 2025-10-20       74
2 fi_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate        mean      sd         p0       p25        p50        p75      p100 hist 
 1 fi_id                                                         0        1      4574286.    909.    4572712    4573499.  4574286.   4575072.   4575859   ▇▇▇▇▇
 2 fi_year                                                       0        1         2025       0        2025       2025      2025       2025       2025   ▁▁▇▁▁
 3 fiser_ser_id                                                  0        1          352.    119.        229        230       467        467        468   ▇▁▁▁▇
 4 lengthmm                                                      0        1          481.    135.        200        372       450        560        990   ▃▇▃▂▁
 5 weightg                                                       2        0.999      262.    264.         10         90       170        321.      2130   ▇▁▁▁▁
 6 differentiated_proportion                                   332        0.895        0.427   0.495       0          0         0          1          1   ▇▁▁▁▆
 7 anguillicola_intensity                                     2926        0.0705       2.98    5.57        0          0         1.5        4         68   ▇▁▁▁▁
 8 method_sex_(1=visual,0=use_length)                         1726        0.452        0.276   0.447       0          0         0          1          1   ▇▁▁▁▃
 9 method_anguillicola_(1=stereomicroscope,0=visual_obs)      2926        0.0705       0       0           0          0         0          0          0   ▁▁▇▁▁
10 female_proportion                                          1726        0.452        0.517   0.500       0          0         1          1          1   ▇▁▁▁▇
11 anguillicola_proportion                                    2926        0.0705       0.568   0.497       0          0         1          1          1   ▆▁▁▁▇
12 eye_diam_meanmm                                            2408        0.235        6.89    1.61        3.54       5.7       6.66       7.75      13.0 ▃▇▅▁▁
13 pectoral_lengthmm                                          2427        0.229       26.4     8.40       11.5       19.5      24.8       31.8       52.9 ▆▇▆▂▁

## Annex 4

72 new values inserted in the database
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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
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

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean   sd     p0     p25     p50     p75   p100 hist 
1 eel_id                0         1     614848. 20.9 614813 614831. 614848. 614866. 614884 ▇▇▇▇▇
2 eel_typ_id            0         1          4   0        4      4       4       4       4 ▁▁▇▁▁
3 eel_year              0         1       2026   0     2026   2026    2026    2026    2026 ▁▁▇▁▁
4 eel_value            48         0.333      0   0        0      0       0       0       0 ▁▁▇▁▁
5 eel_qal_id            0         1          1   0        1      1       1       1       1 ▁▁▇▁▁

## Annex 5

 72 new values inserted in the database
 
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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
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

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean   sd     p0     p25     p50     p75   p100 hist 
1 eel_id                0         1     615020. 20.9 614985 615003. 615020. 615038. 615056 ▇▇▇▇▇
2 eel_typ_id            0         1          6   0        6      6       6       6       6 ▁▁▇▁▁
3 eel_year              0         1       2026   0     2026   2026    2026    2026    2026 ▁▁▇▁▁
4 eel_value            60         0.167      0   0        0      0       0       0       0 ▁▁▇▁▁
5 eel_qal_id            0         1          1   0        1      1       1       1       1 ▁▁▇▁▁


## Annex 6


 14 new values inserted in the database

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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0             1   7   7     0        3          0
 2 eel_cou_code              0             1   2   2     0        1          0
 3 eel_lfs_code              0             1   1   2     0        4          0
 4 eel_hty_code              0             1   1   1     0        1          0
 5 eel_area_division        14             0  NA  NA     0        0          0
 6 eel_qal_comment          14             0  NA  NA     0        0          0
 7 eel_comment               0             1  72 319     0        7          0
 8 eel_missvaluequal        14             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean          sd        p0     p25      p50     p75    p100 hist 
1 eel_id                0             1 614964.        4.18  614957    614960. 614964.  614967.  614970 ▇▇▅▇▇
2 eel_typ_id            0             1     32.5       0.519     32        32      32.5     33       33 ▇▁▁▁▇
3 eel_year              0             1   2025         0       2025      2025    2025     2025     2025 ▁▁▇▁▁
4 eel_value             0             1 815234.  2334005.         0.49   1132.  23308.   90368. 8610000 ▇▁▁▁▁
5 eel_qal_id            0             1      1         0          1         1       1        1        1 ▁▁▇▁▁

## Annex 7

 14 new values inserted in the database

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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0             1   7   7     0        3          0
 2 eel_cou_code              0             1   2   2     0        1          0
 3 eel_lfs_code              0             1   1   2     0        4          0
 4 eel_hty_code              0             1   1   1     0        1          0
 5 eel_area_division        14             0  NA  NA     0        0          0
 6 eel_qal_comment          14             0  NA  NA     0        0          0
 7 eel_comment              14             0  NA  NA     0        0          0
 8 eel_missvaluequal        14             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean          sd        p0     p25      p50     p75    p100 hist 
1 eel_id                0             1 615136.        4.18  615129    615132. 615136.  615139.  615142 ▇▇▅▇▇
2 eel_typ_id            0             1      8.5       0.519      8         8       8.5      9        9 ▇▁▁▁▇
3 eel_year              0             1   2025         0       2025      2025    2025     2025     2025 ▁▁▇▁▁
4 eel_value             0             1 815234.  2334005.         0.49   1132.  23308.   90368. 8610000 ▇▁▁▁▁
5 eel_qal_id            0             1      1         0          1         1       1        1        1 ▁▁▇▁▁

## Annex 8

The 2025 line saying no aquaculture was already there and marked as duplicate. Nothing to do.

## Annex 9

### samplinginfo

Note I have changed the names and removed the & which caused issues in the processing
I had to correct some names with underscores

4 new sampling

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4     
Number of columns          13    
_______________________          
Column type frequency:           
  character                10    
  Date                     1     
  numeric                  2     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable         n_missing complete_rate min max empty n_unique whitespace
 1 sai_name                      0          1     15  19     0        4          0
 2 sai_cou_code                  0          1      2   2     0        1          0
 3 sai_emu_nameshort             0          1      7   7     0        2          0
 4 sai_area_division             4          0     NA  NA     0        0          0
 5 sai_hty_code                  0          1      1   1     0        1          0
 6 sai_comment                   3          0.25  45  45     0        1          0
 7 sai_samplingobjective         0          1      3   4     0        2          0
 8 sai_samplingstrategy          0          1     17  17     0        1          0
 9 sai_protocol                  0          1     12  12     0        1          0
10 sai_dts_datasource            0          1      7   7     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable  n_missing complete_rate min        max        median     n_unique
1 sai_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate mean   sd  p0  p25  p50  p75 p100 hist 
1 sai_id                0             1 990. 1.29 989 990. 990. 991.  992 ▇▇▁▇▇
2 sai_qal_id            0             1   1  0      1   1    1    1     1 ▁▁▇▁▁

### group metrics

 9 and 56 new values inserted in the group and metric tables
you forgot to put underscore in the two Corrib series names

1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             9     
Number of columns          19    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  15    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                5         0.444  27  52     0        3          0
2 gr_dts_datasource         0         1       7   7     0        1          0
3 grsa_lfs_code             0         1       1   2     0        2          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate     mean       sd       p0      p25      p50      p75     p100 hist 
 1 gr_id                                                         0         1     6782       2.74   6778     6780     6782     6784     6786     ▇▇▃▇▇
 2 gr_year                                                       0         1     2025.      0.5    2024     2024     2025     2025     2025     ▃▁▁▁▇
 3 gr_number                                                     0         1      978.    526.      284      581      953     1245     1946     ▇▂▇▂▂
 4 grsa_sai_id                                                   0         1      844.    316.      286     1001     1002     1003     1004     ▂▁▁▁▇
 5 lengthmm                                                      0         1      627.    101.      464      582      650      686      786     ▅▅▂▇▂
 6 weightg                                                       6         0.333  483.    466.      182      214      246      633     1020     ▇▁▁▁▃
 7 anguillicola_intensity                                        7         0.222    4.88    3.03      2.73     3.80     4.88     5.95     7.02  ▇▁▁▁▇
 8 m_mean_lengthmm                                               0         1      382      19.8     345      378      381      390      416     ▂▂▇▃▂
 9 f_mean_lengthmm                                               0         1      633.    110.      451      597      672      693      788     ▅▁▅▇▅
10 method_sex_(1=visual,0=use_length)                            0         1        0.222   0.441     0        0        0        0        1     ▇▁▁▁▂
11 method_anguillicola_(1=stereomicroscope,0=visual_obs)         7         0.222    0       0         0        0        0        0        0     ▁▁▇▁▁
12 female_proportion                                             0         1        0.948   0.0320    0.912    0.924    0.946    0.974    0.999 ▇▂▂▂▃
13 anguillicola_proportion                                       7         0.222    0.723   0.0718    0.673    0.698    0.723    0.749    0.774 ▇▁▁▁▇
14 m_mean_weightg                                                8         0.111   70      NA        70       70       70       70       70     ▁▁▇▁▁
15 f_mean_weightg                                                8         0.111 1020      NA      1020     1020     1020     1020     1020     ▁▁▇▁▁

### individual metrics


I remember you (Russell) had issues with pasting dates. It's still the case
often the dates in your files are pasted as text and not identified as date.
I needed to convert them.
Some are missing again from Burrishoole in the sampling info but I have integrated.

you forgot to put underscore in the two Corrib series names

12722 and 41382 new values inserted in the fish and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             12722 
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
1 fi_comment            12722             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        2          0
4 fisa_geom             12722             0  NA  NA     0        0          0
5 fi_id_cou                 0             1  13  39     0    12716          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date            4940         0.612 2009-06-23 2026-11-02 2024-01-09       58
2 fi_lastupdate         0         1     2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate         mean       sd         p0        p25        p50        p75       p100 hist 
 1 fi_id                                                         0       1       4585836.     3673.    4579476    4582656.   4585836.   4589017.   4592197    ▇▇▇▇▇
 2 fi_year                                                       0       1          2022.        4.58     2009       2017       2024       2025       2025    ▁▁▂▁▇
 3 fisa_sai_id                                                   0       1           749.      341.        286        287       1002       1003       1004    ▅▁▁▁▇
 4 fisa_x_4326                                                   0       1            -8.29      0.742      -9.58      -9.11      -7.99      -7.66      -7.49 ▅▃▁▅▇
 5 fisa_y_4326                                                   0       1            54.0       0.460      53.4       53.5       54.2       54.4       54.5  ▇▁▁▂▇
 6 lengthmm                                                      1       1.000       598.      130.        250        504        590        690       1080    ▂▇▇▂▁
 7 weightg                                                    7661       0.398       329.      307.         40        159        231        356       2790    ▇▁▁▁▁
 8 eye_diam_meanmm                                            9713       0.237         5.16      1.17        2.13       4.37       4.99       5.81      12.2  ▂▇▂▁▁
 9 pectoral_lengthmm                                          9767       0.232        21.4       5.22        5.94      17.7       20.7       24.5       47.9  ▁▇▅▁▁
10 differentiated_proportion                                 12375       0.0273        0.666     0.472       0          0          1          1          1    ▅▁▁▁▇
11 anguillicola_intensity                                    12606       0.00912       3.72      5.89        0          0          2          5         39    ▇▁▁▁▁
12 method_sex_(1=visual,0=use_length)                         4367       0.657         0.0415    0.200       0          0          0          0          1    ▇▁▁▁▁
13 method_anguillicola_(1=stereomicroscope,0=visual_obs)     12606       0.00912       0         0           0          0          0          0          0    ▁▁▇▁▁
14 female_proportion                                          4367       0.657         0.932     0.251       0          1          1          1          1    ▁▁▁▁▇
15 anguillicola_proportion                                   12606       0.00912       0.724     0.449       0          0          1          1          1    ▃▁▁▁▇
16 ageyear                                                   12491       0.0182       28.3       8.71        5         22.5       29         34         59    ▁▆▇▂▁
