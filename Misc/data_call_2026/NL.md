-----------------------------------------------------------
# NL
-----------------------------------------------------------

## Annex 1

Missing series in individual metrics;

### series

### dataseries

 6 new values inserted in the database

### group metrics

 2 and 2 new values inserted in the group and metric tables

### individual metrics

 585 and 585 new values inserted in the fish and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             585   
Number of columns          10    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  4     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment              585             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou               585             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2026-03-08 2026-05-24 2026-04-12       12
2 fi_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate      mean     sd      p0     p25     p50     p75    p100 hist 
1 fi_id                 0             1 4606094   169.   4605802 4605948 4606094 4606240 4606386 ▇▇▇▇▇
2 fi_year               0             1    2026     0       2026    2026    2026    2026    2026 ▁▁▇▁▁
3 fiser_ser_id          0             1      12     0         12      12      12      12      12 ▁▁▇▁▁
4 lengthmm              0             1      70.6   4.17      58      68      71      73      83 ▁▅▇▃▁
## Annex 2

### series

no change

### dataseries

 6 new values inserted in the database
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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment                6             0  NA  NA     0        0          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            6             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean    sd       p0      p25     p50     p75    p100 hist 
1 das_id                0             1 10544.   1.87 10541    10542.   10544.  10545.  10546   ▇▃▃▃▃
2 das_value             0             1    25.4 23.5      2.13     6.52    19.5    44.8    55.7 ▇▁▂▁▅
3 das_ser_id            0             1   300.  52.7    231      257      332.    334.    335   ▃▁▁▁▇
4 das_year              0             1  2025    0     2025     2025     2025    2025    2025   ▁▁▇▁▁
5 das_effort            0             1    27.2 12.7     12       20.2     23.5    34.2    47   ▂▇▁▂▂
6 das_qal_id            0             1     1    0        1        1        1       1       1   ▁▁▇▁▁

### group metrics

 6 and 6 new values inserted in the group and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             6     
Number of columns          8     
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                6             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean     sd   p0   p25   p50   p75 p100 hist 
1 gr_id                 0         1     6830.   1.87 6828 6829. 6830. 6832. 6833 ▇▃▃▃▃
2 gr_year               0         1     2025    0    2025 2025  2025  2025  2025 ▁▁▇▁▁
3 gr_number             4         0.333  260. 350.     12  136.  260.  383.  507 ▇▁▁▁▇
4 grser_ser_id          0         1      300.  52.7   231  257   332.  334.  335 ▃▁▁▁▇
5 lengthmm              0         1      404.  64.7   336  360.  394.  430.  511 ▇▁▅▁▂
### individual metrics

No individual metrics

## Annex 3

### series

### dataseries

 7 new values inserted in the database
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             7     
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
1 das_comment                7             0  NA  NA     0        0          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            7             0  NA  NA     0        0          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate      mean     sd         p0       p25       p50     p75    p100 hist 
1 das_id                0         1     10556      2.16  10553      10554.    10556     10558.  10559   ▇▃▃▃▇
2 das_value             1         0.857     7.47  11.1       0.0111     0.111     0.881    14.0    24.7 ▇▁▁▂▂
3 das_ser_id            0         1       259.    63.0     233        234.      236       238.    402   ▇▁▁▁▁
4 das_year              0         1      2025      0      2025       2025      2025      2025    2025   ▁▁▇▁▁
5 das_effort            1         0.857   239.    76.9     143        184.      240.      284.    346   ▇▁▇▃▃
6 das_qal_id            0         1         0.857  0.378     0          1         1         1       1   ▁▁▁▁▇

### group metrics

 6 and 6 new values inserted in the group and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             6     
Number of columns          8     
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                6             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean    sd   p0   p25   p50   p75 p100 hist   
1 gr_id                 0             1 6842.  1.87 6840 6841. 6842. 6844. 6845 "▇▃▃▃▃"
2 gr_year               0             1 2025   0    2025 2025  2025  2025  2025 "▁▁▇▁▁"
3 gr_number             6             0  NaN  NA      NA   NA    NA    NA    NA " "    
4 grser_ser_id          0             1  263. 68.0   233  234.  236   238.  402 "▇▁▁▁▂"
5 lengthmm              0             1  745  49.7   680  708.  750.  779.  807 "▇▃▁▇▃"


### individual metrics

No individual metrics 


## Annex 4


### new

 4 new values inserted in the database
 
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4     
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
 1 eel_emu_nameshort         0          1      7   7     0        1          0
 2 eel_cou_code              0          1      2   2     0        1          0
 3 eel_lfs_code              0          1      1   1     0        1          0
 4 eel_hty_code              0          1      1   2     0        4          0
 5 eel_area_division         3          0.25   6   6     0        1          0
 6 eel_qal_comment           4          0     NA  NA     0        0          0
 7 eel_comment               3          0.25 143 143     0        1          0
 8 eel_missvaluequal         2          0.5    2   2     0        1          0
 9 eel_datasource            0          1      7   7     0        1          0
10 eel_dta_code              0          1      6   6     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean        sd     p0     p25     p50     p75   p100 hist 
1 eel_id                0           1   615368.      1.29 615367 615368. 615368. 615369. 615370 ▇▇▁▇▇
2 eel_typ_id            0           1        4       0         4      4       4       4       4 ▁▁▇▁▁
3 eel_year              0           1     2025       0      2025   2025    2025    2025    2025 ▁▁▇▁▁
4 eel_value             2           0.5 213772  300510.     1279 107526. 213772  320018. 426265 ▇▁▁▁▇
5 eel_qal_id            0           1        1       0         1      1       1       1       1 ▁▁▇▁▁

#### modified

Much smaller coastal landings Y 19000 - > 4600 in 2018

1 values updated in the db

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

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0           1     7   7     0        1          0
 2 eel_cou_code              0           1     2   2     0        1          0
 3 eel_lfs_code              0           1     2   2     0        1          0
 4 eel_hty_code              0           1     1   1     0        1          0
 5 eel_area_division         0           1     6   6     0        1          0
 6 eel_qal_comment           1           0.5  33  33     0        1          0
 7 eel_comment               0           1    82  82     0        1          0
 8 eel_missvaluequal         2           0    NA  NA     0        0          0
 9 eel_datasource            0           1     7   7     0        2          0
10 eel_dta_code              0           1     6   6     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean      sd     p0       p25      p50      p75   p100 hist 
1 eel_id                0             1 584617   43498.  553859 569238    584617   599996   615375 ▇▁▁▁▇
2 eel_typ_id            0             1      4       0        4      4         4        4        4 ▁▁▇▁▁
3 eel_year              0             1   2018       0     2018   2018      2018     2018     2018 ▁▁▇▁▁
4 eel_value             0             1  11832.  10136.    4665   8249.    11832.   15416.   19000 ▇▁▁▁▇
5 eel_qal_id            0             1     13.5    17.7      1      7.25     13.5     19.8     26 ▇▁▁▁▇


## Annex 5

 6 new values inserted in the database

## Annex 6

 1 new values inserted in the database

## Annex 7

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
 1 eel_emu_nameshort         0             1   7   7     0        1          0
 2 eel_cou_code              0             1   2   2     0        1          0
 3 eel_lfs_code              0             1   1   2     0        3          0
 4 eel_hty_code              0             1   1   1     0        1          0
 5 eel_area_division        10             0  NA  NA     0        0          0
 6 eel_qal_comment          10             0  NA  NA     0        0          0
 7 eel_comment              10             0  NA  NA     0        0          0
 8 eel_missvaluequal        10             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean         sd      p0     p25      p50     p75    p100 hist 
1 eel_id                0             1 615656.       3.03  615651  615653. 615656.  615658.  615660 ▇▇▇▇▇
2 eel_typ_id            0             1      8.5      0.527      8       8       8.5      9        9 ▇▁▁▁▇
3 eel_year              0             1   2025.       1.23    2023    2024    2025     2026     2026 ▃▃▁▃▇
4 eel_value             0             1 379990.  913669.       833.   6814.  11576.   14229  2863644 ▇▁▁▁▁
5 eel_qal_id            0             1      1        0          1       1       1        1        1 ▁▁▇▁▁

## Annex 8

 1 new values inserted in the database

## Annex 9

### samplinginfo

one new sampling NL_Neth_marketISJMM integrated (had to add the S ...)

### group metrics


### individual metrics

 839 and 5793 new values inserted in the fish and metric tables
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             839   
Number of columns          19    
_______________________          
Column type frequency:           
  character                5     
  Date                     2     
  numeric                  12    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment                0             1  65  65     0        1          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        2          0
4 fisa_geom               839             0  NA  NA     0        0          0
5 fi_id_cou                 0             1   8   8     0      839          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2025-04-21 2025-09-22 2025-06-25       27
2 fi_lastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate        mean      sd         p0       p25        p50        p75       p100 hist 
 1 fi_id                                                         0         1     4607391     242.    4606972    4607182.  4607391    4607600.   4607810    ▇▇▇▇▇
 2 fi_year                                                       0         1        2025       0        2025       2025      2025       2025       2025    ▁▁▇▁▁
 3 fisa_sai_id                                                   0         1         676.    329.        353        353       353       1010       1010    ▇▁▁▁▇
 4 fisa_x_4326                                                   0         1           5.21    0.488       3.73       5.2       5.28       5.32       6.30 ▂▂▅▇▂
 5 fisa_y_4326                                                   0         1          52.6     0.401      51.5       52.5      52.5       52.8       53.3  ▂▁▇▇▁
 6 lengthmm                                                      0         1         528.    167.        221        396       483        656.       991    ▃▇▃▃▁
 7 weightg                                                       0         1         388.    414.         18        104       200        534.      2210    ▇▂▁▁▁
 8 differentiated_proportion                                    26         0.969       1       0           1          1         1          1          1    ▁▁▇▁▁
 9 method_sex_(1=visual,0=use_length)                           26         0.969       1       0           1          1         1          1          1    ▁▁▇▁▁
10 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0         1           0       0           0          0         0          0          0    ▁▁▇▁▁
11 female_proportion                                            26         0.969       0.977   0.151       0          1         1          1          1    ▁▁▁▁▇
12 anguillicola_proportion                                       2         0.998       0.489   0.500       0          0         0          1          1    ▇▁▁▁▇
