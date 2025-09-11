-----------------------------------------------------------
# LT
-----------------------------------------------------------

## Annex 1
No recrutment series
## Annex 2

Mail sent to Linas => pb with ind metrics.
### series

### dataseries

Note : Cédric I have put the missing lines (automatically filled in)
with as das_qal_id 0 (missing data).



### group metrics

Cédric : Changed kertY to kertY


### individual metrics



## Annex 3

### series

### dataseries
Note : Cédric I have put the missing lines (automatically filled in)
with as das_qal_id 0 (missing data).

 28 new values inserted in the database

── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             28    
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
1 das_comment               24         0.143  80 102     0        3          0
2 das_dts_datasource         0         1       7   7     0        1          0
3 das_qal_comment           28         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean     sd   p0    p25   p50    p75
1 das_id                0         1     9962.     8.23  9948 9955.  9962. 9968. 
2 das_value            24         0.143   52     35.4     22   27.2   43    67.8
3 das_ser_id            0         1      371.    33.8    348  349    350   423  
4 das_year              0         1     2018.     3.25  2015 2016   2017  2020. 
5 das_effort           28         0      NaN     NA       NA   NA     NA    NA  
6 das_qal_id            0         1        0.143  0.356    0    0      0     0  
  p100 hist   
1 9975 "▇▇▇▇▇"
2  100 "▇▁▃▁▃"
3  423 "▇▁▁▁▃"
4 2024 "▇▇▂▁▅"
5   NA " "    
6    1 "▇▁▁▁▁"

### group metrics

> Cedric fixed S in YS proportion SiesS 72 => 0.72 as this should have been a proportion
 4 and 55 new values inserted in the group and metric tables

── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4     
Number of columns          23    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  20    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  21  21     0        1          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 gr_id                                                         0          1   
 2 gr_year                                                       0          1   
 3 gr_number                                                     0          1   
 4 grser_ser_id                                                  0          1   
 5 lengthmm                                                      0          1   
 6 weightg                                                       0          1   
 7 ageyear                                                       0          1   
 8 differentiated_proportion                                     0          1   
 9 anguillicola_intensity                                        0          1   
10 f_mean_lengthmm                                               0          1   
11 f_mean_weightg                                                0          1   
12 f_mean_age                                                    0          1   
13 s_in_ys_proportion                                            0          1   
14 method_sex_(1=visual,0=use_length)                            0          1   
15 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0          1   
16 female_proportion                                             0          1   
17 anguillicola_proportion                                       0          1   
18 m_mean_lengthmm                                               3          0.25
19 m_mean_weightg                                                3          0.25
20 m_mean_ageyear                                                3          0.25
       mean      sd      p0      p25      p50      p75    p100 hist 
 1 6294.     1.29   6292    6293.    6294.    6294.    6295    ▇▇▁▇▇
 2 2024      0      2024    2024     2024     2024     2024    ▁▁▇▁▁
 3   52.2   35.1      23      27.5     43       67.8    100    ▇▁▃▁▃
 4  350.     1.29    348     349.     350.     350.     351    ▇▇▁▇▇
 5  707.    13.2     688     702.     712.     716      716    ▃▁▁▃▇
 6  710.    72.5     636     664.     700      746      803    ▇▇▇▁▇
 7   17.2    4.78     10.2    16.1     19.2     20.2     20.3  ▃▁▁▃▇
 8    0      0         0       0        0        0        0    ▁▁▇▁▁
 9    4.45   0.929     3.3     3.9      4.6      5.15     5.3  ▃▃▁▁▇
10  710.    17.6     688     702.     712.     720.     730    ▇▁▇▇▇
11  716.    75.9     636     664.     714.     766.     803    ▇▇▁▇▇
12   16.1    4.31     10.2    14.6     17.0     18.6     20.2  ▇▁▇▇▇
13    0.648  0.147     0.45    0.585    0.675    0.738    0.79 ▇▁▇▇▇
14    1      0         1       1        1        1        1    ▁▁▇▁▁
15    0      0         0       0        0        0        0    ▁▁▇▁▁
16    0.99   0.0200    0.96    0.99     1        1        1    ▂▁▁▁▇
17    0.725  0.0238    0.69    0.72     0.735    0.74     0.74 ▃▁▁▃▇
18  414     NA       414     414      414      414      414    ▁▁▇▁▁
19  138     NA       138     138      138      138      138    ▁▁▇▁▁
20   16     NA        16      16       16       16       16    ▁▁▇▁▁

### individual metrics

 208 and 2238 new values inserted in the fish and metric tables

 ── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             208   
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
1 fi_comment              208             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        2          0
4 fi_id_cou               208             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 2024-05-15 2024-09-15 2024-05-15
2 fi_lastupdate         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1        2
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 fi_id                                                         0         1    
 2 fi_year                                                       0         1    
 3 fiser_ser_id                                                  0         1    
 4 lengthmm                                                      0         1    
 5 weightg                                                       0         1    
 6 ageyear                                                       0         1    
 7 eye_diam_meanmm                                               0         1    
 8 pectoral_lengthmm                                             0         1    
 9 differentiated_proportion                                     0         1    
10 anguillicola_intensity                                       50         0.760
11 method_sex_(1=visual,0=use_length)                            0         1    
12 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0         1    
13 female_proportion                                             0         1    
14 anguillicola_proportion                                       0         1    
          mean       sd        p0        p25      p50      p75      p100 hist 
 1 3897790.     60.2    3897686   3897738.   3897790. 3897841. 3897893   ▇▇▇▇▇
 2    2024       0         2024      2024       2024     2024     2024   ▁▁▇▁▁
 3     349.      1.30       348       348        349      351      351   ▇▂▁▂▅
 4     712.     98.1        398       660        718.     765.    1035   ▁▂▇▂▁
 5     739.    285.         120       578.       718.     874.    2206   ▃▇▂▁▁
 6      14.9     6.58         6        10         12       21       39   ▇▃▃▁▁
 7       8.19    1.38         4.6       7.24       8        9       13.2 ▁▇▆▂▁
 8      32.4     5.87        18        28         32       36       58   ▂▇▅▁▁
 9       0       0            0         0          0        0        0   ▁▁▇▁▁
10       7.25    4.08         1         4          8       10       21   ▇▇▃▁▁
11       1       0            1         1          1        1        1   ▁▁▇▁▁
12       0       0            0         0          0        0        0   ▁▁▇▁▁
13       0.995   0.0693       0         1          1        1        1   ▁▁▁▁▇
14       0.769   0.422        0         1          1        1        1   ▂▁▁▁▇


## Annex 4

 13 new values inserted in the database

── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             13    
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
 1 eel_emu_nameshort         0         1       7   8     0        2          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       1   2     0        4          0
 4 eel_hty_code              0         1       1   2     0        4          0
 5 eel_area_division         6         0.538   6   6     0        1          0
 6 eel_qal_comment          13         0      NA  NA     0        0          0
 7 eel_comment               5         0.615  30  34     0        2          0
 8 eel_missvaluequal         5         0.615   2   2     0        1          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd     p0    p25    p50
1 eel_id                0         1     608728     3.89  608722 608725 608728
2 eel_typ_id            0         1          4     0          4      4      4
3 eel_year              0         1       2024.    0.480   2023   2023   2024
4 eel_value             8         0.385   1901. 1379.        38   1435   2041
5 eel_qal_id            0         1          1     0          1      1      1
     p75   p100 hist 
1 608731 608734 ▇▅▇▅▇
2      4      4 ▁▁▇▁▁
3   2024   2024 ▃▁▁▁▇
4   2127   3863 ▃▃▇▁▃
5      1      1 ▁▁▇▁▁


## Annex 5
Note : I had to remove some duplicates
 19 new values inserted in the database
 ── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             19    
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
 4 eel_hty_code              0         1       1   2     0        4          0
 5 eel_area_division         9         0.526   6   6     0        1          0
 6 eel_qal_comment          19         0      NA  NA     0        0          0
 7 eel_comment              12         0.368  22  34     0        2          0
 8 eel_missvaluequal         0         1       2   2     0        2          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean     sd     p0     p25    p50
1 eel_id                0             1 608770   5.63  608761 608766. 608770
2 eel_typ_id            0             1      6   0          6      6       6
3 eel_year              0             1   2024.  0.496   2023   2023    2024
4 eel_value            19             0    NaN  NA         NA     NA      NA
5 eel_qal_id            0             1      1   0          1      1       1
      p75   p100 hist   
1 608774. 608779 "▇▇▆▇▇"
2      6       6 "▁▁▇▁▁"
3   2024    2024 "▅▁▁▁▇"
4     NA      NA " "    
5      1       1 "▁▁▇▁▁"


## Annex 6
Wrong structure but no data : ignoring the file.
NP are only needed for landings and recr. landings.

## Annex 7

 2 new values inserted in the database


## Annex 8

No data as in many other country => we should stop trying to collect these data
 1 new values inserted in the database

## Annex 9

Nothing to do.



