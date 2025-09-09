-----------------------------------------------------------
# FR (Integration Cédric)
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


+ an additional that was inserted after a fix
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
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
1 fi_comment                0             1  30  30     0        1          0
2 fi_dts_datasource         0             1  10  10     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou                 1             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2017-03-16 2017-03-16 2017-03-16        1
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09        1

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate        mean sd          p0         p25         p50         p75        p100 hist 
1 fi_id                 0             1 2709236     NA 2709236     2709236     2709236     2709236     2709236     ▁▁▇▁▁
2 fi_year               0             1    2017     NA    2017        2017        2017        2017        2017     ▁▁▇▁▁
3 fiser_ser_id          0             1      67     NA      67          67          67          67          67     ▁▁▇▁▁
4 weightg               0             1       0.219 NA       0.219       0.219       0.219       0.219       0.219 ▁▁▇▁▁


-- after fix with the shiny

── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             81    
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
1 fi_comment                0         1      27  28     0        2          0
2 fi_dts_datasource         0         1       7   7     0        1          0
3 fi_lfs_code              13         0.840   1   1     0        1          0
4 fi_id_cou                81         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 1997-07-20 1999-04-23 1999-04-14       13
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09        1

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean       sd      p0     p25     p50     p75    p100 hist 
1 fi_id                 0             1 2533095. 4842.    2506533 2534678 2534698 2534718 2534738 ▁▁▁▁▇
2 fi_year               0             1    1999.    0.422    1997    1999    1999    1999    1999 ▁▁▂▁▇
3 fiser_ser_id          0             1      61     0          61      61      61      61      61 ▁▁▇▁▁
4 lengthmm              0             1     164.  107.         60      97     110     232     505 ▇▂▂▁▁

Note : debugging from locahost and forgot to change some code in R
Here's the fix

```sql 

-- fix error for France datasource

UPDATE datawg.t_dataseries_das
SET das_dts_datasource = 'dc_2025'
WHERE das_dts_datasource = 'wkemp_2025'
AND das_last_update > '2025-09-05'; --17

SELECT * FROM datawg.t_fishseries_fiser as tff 
WHERE tff.fi_dts_datasource = 'wkemp_2025'
AND tff.fi_lastupdate  > '2025-09-05'; 

UPDATE datawg.t_fishseries_fiser
SET fi_dts_datasource = 'dc_2025'
WHERE fi_dts_datasource = 'wkemp_2025'
AND fi_lastupdate > '2025-09-05'; --52045

SELECT * FROM datawg.t_groupseries_grser 
WHERE gr_dts_datasource = 'wkemp_2025'
AND gr_lastupdate  > '2025-09-05'; 

UPDATE datawg.t_groupseries_grser 
SET gr_dts_datasource = 'dc_2025'
WHERE gr_dts_datasource = 'wkemp_2025'
AND gr_dts_datasource > '2025-09-05'; --17

SELECT * FROM datawg.t_metricgroupseries_megser
WHERE meg_dts_datasource = 'wkemp_2025'
AND meg_last_update   > '2025-09-05'; 

UPDATE datawg.t_metricgroupseries_megser
SET meg_dts_datasource = 'dc_2025'
WHERE meg_dts_datasource = 'wkemp_2025'
AND meg_last_update > '2025-09-05'; --20

SELECT * FROM datawg.t_metricindseries_meiser
WHERE mei_dts_datasource = 'wkemp_2025'
AND mei_last_update   > '2025-09-05'; 

UPDATE datawg.t_metricindseries_meiser
SET mei_dts_datasource = 'dc_2025'
WHERE mei_dts_datasource = 'wkemp_2025'
AND mei_last_update   > '2025-09-05'; --52811

```

## Annex 2

### series

### dataseries

#### new dataseries

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

── Variable type: character ────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment               17             0  NA  NA     0        0          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment           17             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean     sd       p0      p25
1 das_id                0             1 9380      5.05  9372     9376    
2 das_value             0             1    0.536  0.440    0.053    0.178
3 das_ser_id            0             1  293.    65.6    213      218    
4 das_year              0             1 2024      0     2024     2024    
5 das_effort            0             1   12.9   12.6      2        4    
6 das_qal_id            0             1    1      0        1        1    
       p50     p75    p100 hist 
1 9380     9384    9388    ▇▆▆▆▇
2    0.403    0.81    1.38 ▇▁▃▂▂
3  303      372     376    ▇▁▇▁▇
4 2024     2024    2024    ▁▁▇▁▁
5   10       15      52    ▇▂▁▁▁
6    1        1       1    ▁▁▇▁▁

#### updated dataseries

194 values updated in the db

─ Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             194   
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
1 das_comment                0         1      22 174     0        2          0
2 das_dts_datasource       139         0.284   7   7     0        4          0
3 das_qal_comment          194         0      NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean       sd       p0      p25
1 das_id                0             1 6100.    1456.    4067     5470.   
2 das_value             0             1    0.543    0.485    0.029    0.154
3 das_ser_id            0             1  295.      61.4    213      218    
4 das_year              0             1 2016.       4.51  2002     2013    
5 das_effort            0             1   10.3      8.46     1        4    
6 das_qal_id            0             1    1        0        1        1    
       p50      p75    p100 hist 
1 5518.    6589.    8573    ▆▇▇▁▆
2    0.392    0.756    2.03 ▇▃▂▁▁
3  303      372      376    ▆▁▇▁▆
4 2017     2020     2023    ▁▂▅▆▇
5    9       12       51    ▇▂▁▁▁
6    1        1        1    ▁▁▇▁▁

### group metrics

#### new group metrics

 19 and 32 new values inserted in the group and metric tables
─ Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             19    
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
1 gr_comment               13         0.316  38 200     0        6          0
2 gr_dts_datasource         0         1       7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate     mean      sd       p0      p25
1 gr_id                      0        1      5835       5.63  5826     5830.   
2 gr_year                    0        1      2024.      0.713 2021     2024    
3 gr_number                  0        1       303.    334.       7       79.5  
4 grser_ser_id               0        1       302.     66.8    213      218.   
5 lengthmm                   0        1       273.    131.     156      181    
6 weightg                    7        0.632   137.    142.       9       26.2  
7 s_in_ys_proportion        18        0.0526    0.008  NA        0.008    0.008
       p50      p75     p100 hist 
1 5835     5840.    5844     ▇▇▆▇▇
2 2024     2024     2024     ▁▁▁▁▇
3  225      326.    1168     ▇▃▁▁▂
4  304      373      376     ▇▁▇▁▇
5  218.     320.     576.    ▇▁▁▁▁
6   80.8    198      429.    ▇▃▁▂▁
7    0.008    0.008    0.008 ▁▁▇▁▁

#### updated group metrics

 14 and 28 new values modified in the group and metric tables

── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             14    
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
1 gr_comment                0             1 211 214     0       14          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean      sd     p0    p25    p50
1 gr_id                 0             1 3512.  1086.   1857   2426.  4136. 
2 gr_year               0             1 2020      3.28 2013   2018   2022. 
3 gr_number             0             1  294.   182.     67    138    294  
4 grser_ser_id          0             1  240.    50.3   213    216    217  
5 lengthmm              0             1  259.    24.0   231.   236.   255. 
6 weightg               0             1   71.4   25.3    46.9   57.0   61.4
     p75  p100 hist 
1 4144.  4324  ▃▁▁▁▇
2 2022   2023  ▂▂▁▃▇
3  390    630  ▇▃▆▂▃
4  217    374  ▇▁▂▁▁
5  283.   291  ▇▃▂▃▆
6   74.2  131. ▇▃▁▁▂

### individual metrics

#### deleted individual metrics


Deleted lines :

2722586	2023-06-27	2023		2024-09-10	dc_2024		306	adr_43893
2722587	2023-06-27	2023		2024-09-10	dc_2024		306	adr_43894
2722593	2023-06-27	2023		2024-09-10	dc_2024		306	adr_43900
2722595	2023-06-27	2023		2024-09-10	dc_2024		306	adr_43902
2722596	2023-06-27	2023		2024-09-10	dc_2024		306	adr_43903
2722600	2023-06-27	2023		2024-09-10	dc_2024		306	adr_43907
2722602	2023-06-27	2023		2024-09-10	dc_2024		306	adr_43909
2722609	2023-07-06	2023		2024-09-10	dc_2024		218	adr_43916
2722610	2023-07-06	2023		2024-09-10	dc_2024

#### updated individual metrics

 59 and 81 new values updated in the fish and metric tables

── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             59    
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
1 fi_comment                0             1  23  23     0        1          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code              59             0  NA  NA     0        0          0
4 fi_id_cou                59             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 1995-09-13 1996-10-17 1995-09-18        7
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09        1

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean     sd     p0      p25      p50     p75   p100 hist 
1 fi_id                 0         1     290564  17.2   290535 290550.  290564   290578. 290593 ▇▇▇▇▇
2 fi_year               0         1       1995.  0.492   1995   1995     1995     1996    1996 ▇▁▁▁▅
3 fiser_ser_id          0         1        214   0        214    214      214      214     214 ▁▁▇▁▁
4 lengthmm              0         1        380. 51.5      314    353      370      392.    580 ▇▇▁▁▁
5 weightg              37         0.373    102. 70.8       51     65.8     75.5     88     331 ▇▁▁▁▁

#### new individual metrics

6342 and 10070 new values inserted in the fish and metric tables

── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             6342  
Number of columns          13    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  7     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment             6342         0      NA  NA     0        0          0
2 fi_dts_datasource         0         1       7   7     0        1          0
3 fi_lfs_code            4921         0.224   1   1     0        2          0
4 fi_id_cou              1168         0.816   8  12     0     5174          0

── Variable type: Date ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 2021-07-26 2024-10-17 2024-09-02       69
2 fi_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09        1

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate       mean       sd         p0        p25       p50        p75      p100 hist 
1 fi_id                     0        1      3576192.   1831.    3573022    3574607.   3576192.  3577778.   3579363   ▇▇▇▇▇
2 fi_year                   0        1         2024.      0.570    2021       2024       2024      2024       2024   ▁▁▁▁▇
3 fiser_ser_id              0        1          257.     56.8       213        217        219       303        376   ▇▁▃▁▂
4 lengthmm                  0        1          204.    115.         51        122        168       254.       790   ▇▃▁▁▁
5 weightg                3267        0.485       46.7    96.8         1          4         13        41       1176   ▇▁▁▁▁
6 eye_diam_meanmm        6015        0.0516       4.70    1.52        1.67       3.61       4.6       5.73      10.6 ▃▇▅▁▁
7 pectoral_lengthmm      6016        0.0514      17.9     6.47        5.8       13.1       17.2      22.0       36.8 ▃▇▆▂▁

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



