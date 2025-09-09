-----------------------------------------------------------
# FR
-----------------------------------------------------------

## Annex 1

### series

1 line inserted : new series Brittany
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
Number of columns          26    
_______________________          
Column type frequency:           
  character                16    
  logical                  1     
  numeric                  9     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable           n_missing complete_rate min max empty n_unique whitespace
 1 ser_nameshort                   0             1   6   6     0        1          0
 2 ser_namelong                    0             1  30  30     0        1          0
 3 ser_effort_uni_code             0             1   5   5     0        1          0
 4 ser_comment                     0             1 287 287     0        1          0
 5 ser_uni_code                    0             1   5   5     0        1          0
 6 ser_lfs_code                    0             1   2   2     0        1          0
 7 ser_hty_code                    0             1   1   1     0        1          0
 8 ser_locationdescription         0             1  65  65     0        1          0
 9 ser_emu_nameshort               0             1   7   7     0        1          0
10 ser_cou_code                    0             1   2   2     0        1          0
11 ser_area_division               1             0  NA  NA     0        0          0
12 geom                            0             1  50  50     0        1          0
13 ser_qal_comment                 0             1  37  37     0        1          0
14 ser_ccm_wso_id                  0             1   2   2     0        1          0
15 ser_dts_datasource              0             1  10  10     0        1          0
16 ser_method                      0             1 271 271     0        1          0

── Variable type: logical ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable  n_missing complete_rate mean count 
1 ser_restocking         0             1    0 FAL: 1

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate   mean sd     p0    p25    p50    p75   p100 hist   
1 ser_id                    0             1 484    NA 484    484    484    484    484    "▁▁▇▁▁"
2 ser_typ_id                0             1   1    NA   1      1      1      1      1    "▁▁▇▁▁"
3 ser_tblcodeid             1             0 NaN    NA  NA     NA     NA     NA     NA    " "    
4 ser_x                     0             1  -2.75 NA  -2.75  -2.75  -2.75  -2.75  -2.75 "▁▁▇▁▁"
5 ser_y                     0             1  48.1  NA  48.1   48.1   48.1   48.1   48.1  "▁▁▇▁▁"
6 ser_sam_id                0             1   3    NA   3      3      3      3      3    "▁▁▇▁▁"
7 ser_qal_id                0             1   0    NA   0      0      0      0      0    "▁▁▇▁▁"
8 ser_distanceseakm         1             0 NaN    NA  NA     NA     NA     NA     NA    " "    
9 ser_sam_gear              0             1 242    NA 242    242    242    242    242    "▁▁▇▁▁"
### dataseries
#### New data
 17 new values inserted in the database
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             17    
Number of columns          10    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment               13         0.235  16  78     0        4          0
2 das_dts_datasource         0         1      10  10     0        1          0
3 das_qal_comment           17         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2025-09-08 2025-09-08 2025-09-08        1

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean        sd       p0    p25    p50     p75    p100 hist 
1 das_id                0         1       9320        5.05 9312     9316   9320    9324      9328 ▇▆▆▆▇
2 das_value             0         1     209500.  777268.      0.313  106.   115   16191   3217184 ▇▁▁▁▁
3 das_ser_id            0         1        369.     185.     42      300    485     485       485 ▂▁▁▁▇
4 das_year              0         1       2021.       3.78 2014     2018   2022    2024      2025 ▃▂▂▂▇
5 das_effort            1         0.941     67.1     97.3    11       17.5   19      90.8     358 ▇▂▁▁▁
6 das_qal_id           11         0.353      2.5      1.64    1        1      2.5     4         4 ▇▁▁▁▇

#### Modified data

41 values updated in the db

── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             41    
Number of columns          10    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment                1         0.976  60 209     0       11          0
2 das_dts_datasource        31         0.244   7   7     0        3          0
3 das_qal_comment           41         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2025-09-08 2025-09-08 2025-09-08        1

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean        sd        p0      p25     p50     p75    p100 hist 
1 das_id                0         1       4212.    2704.   1741      1751     2757    6512       8496 ▇▁▁▁▃
2 das_value             0         1     111800.  560038.      0.0982    0.903    1.55    6.42 3499511 ▇▁▁▁▁
3 das_ser_id            0         1         57.0     56.0    42        42       42      42        300 ▇▁▁▁▁
4 das_year              0         1       2012.       9.75 1994      2004     2014    2021       2024 ▃▃▃▃▇
5 das_effort            1         0.976    332.     108.    101       262.     380.    425.       432 ▂▁▂▂▇
6 das_qal_id            0         1          1        0       1         1        1       1          1 ▁▁▇▁▁


### group metrics

#### new group metrics

15 and 17 new values inserted in the group and metric tables

── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             15    
Number of columns          10    
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  7     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                1         0.933  16 146     0        4          0
2 gr_dts_datasource         0         1      10  10     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09        1

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate      mean      sd        p0       p25       p50       p75       p100 hist 
1 gr_id                      0        1      5747         4.47 5740      5744.     5747      5750.      5754      ▇▇▇▇▇
2 gr_year                    0        1      2020.        3.72 2014      2018.     2021      2024.      2025      ▃▂▂▂▇
3 gr_number                  1        0.933  3104      4893.     30      1663.     1936      2400.     19899      ▇▁▁▁▁
4 grser_ser_id               0        1       388.      176.     50       392.      485       485        485      ▂▁▁▁▇
5 lengthmm                   0        1        74.4      27.3     0.252    70        71        73.5      127.     ▁▁▇▁▂
6 g_in_gy_proportion        14        0.0667    0.0036   NA       0.0036    0.0036    0.0036    0.0036     0.0036 ▁▁▇▁▁
7 weightg                   14        0.0667    2.13     NA       2.13      2.13      2.13      2.13       2.13   ▁▁▇▁▁

#### modified group metrics

 2 and 3 new values modified in the group and metric tables

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

── Variable type: character ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  40  61     0        2          0
2 gr_dts_datasource         0             1  10  10     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09        1

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean      sd      p0     p25     p50     p75    p100 hist 
1 gr_id                 0           1   4162     153.   4054    4108    4162    4216    4270    ▇▁▁▁▇
2 gr_year               0           1   2023       1.41 2022    2022.   2023    2024.   2024    ▇▁▁▁▇
3 gr_number             0           1   4660    5074.   1072    2866    4660    6454    8248    ▇▁▁▁▇
4 grser_ser_id          0           1    175     177.     50     112.    175     238.    300    ▇▁▁▁▇
5 lengthmm              0           1    107.      2.47  106.    106.    107.    108.    109    ▇▁▁▁▇
6 weightg               1           0.5    1.76   NA       1.76    1.76    1.76    1.76    1.76 ▁▁▇▁▁

### individual metrics
#### new individual metric

51989 and 52755 new values inserted in the fish and metric tables

── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             51989 
Number of columns          11    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment            51989         0      NA  NA     0        0          0
2 fi_dts_datasource         0         1      10  10     0        1          0
3 fi_lfs_code           32060         0.383   1   1     0        2          0
4 fi_id_cou              9067         0.826  11  15     0    42922          0

── Variable type: Date ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2014-06-05 2025-01-22 2023-07-13      302
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09        1

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate       mean       sd          p0     p25     p50     p75    p100 hist 
1 fi_id                 0        1      3455707    15008.   3429713     3442710 3455707 3468704 3481701 ▇▇▇▇▇
2 fi_year               0        1         2022.       2.98    2014        2020    2023    2024    2025 ▁▁▁▁▇
3 fiser_ser_id          0        1          290.     192.        61          61     300     485     485 ▇▁▃▁▇
4 lengthmm              0        1           99.5     33.4       42          70      86     127     343 ▇▅▁▁▁
5 weightg           51223        0.0147       7.97     5.28       0.165       5       7       9      54 ▇▂▁▁▁

#### Modified 

 56 and 56 new values updated in the fish and metric tables

── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             56    
Number of columns          10    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  4     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment                0             1  27  38     0        2          0
2 fi_dts_datasource         0             1  10  10     0        1          0
3 fi_lfs_code              56             0  NA  NA     0        0          0
4 fi_id_cou                56             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 1997-07-20 2021-07-27 2000-06-22       27
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09        1

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate      mean       sd      p0      p25      p50      p75    p100 hist 
1 fi_id                 0             1 2583983.  61543.   2506533 2542470. 2543572. 2659460. 2683648 ▅▇▁▁▇
2 fi_year               0             1    2006.      9.16    1997    2000.    2000     2017     2021 ▇▁▁▁▃
3 fiser_ser_id          0             1      61       0         61      61       61       61       61 ▁▁▇▁▁
4 lengthmm              0             1      57.7     5.14      52      52       60       62       64 ▇▁▁▁▇

## Annex 2

### series

### dataseries


### group metrics


### individual metrics



## Annex 3

### series

### dataseries


### group metrics


### individual metrics



## Annex 4


## Annex 5


## Annex 6



## Annex 7



## Annex 8


## Annex 10

### samplinginfo


### group metrics


### individual metrics



