-----------------------------------------------------------
# DK
-----------------------------------------------------------

## Annex 1

### series

### dataseries
- removed rows GudeY	2025, HartY	2024, HartY	2025 since not data were available


### group metrics
- removed rows GudeY	2025, HartY	2024, HartY	2025 since not data were available
- remove some duplicates (provided last year but almost empty)

```
-- remove group 'HellGY' 2024 since it reprovided in 2025
delete from datawg.t_groupseries_grser where gr_id in 
   (select gr_id from datawg.t_metricgroupseries_megser tmm left join datawg.t_groupseries_grser tgg on tmm.meg_gr_id = gr_id 
       left join datawg.t_series_ser tss  on tss.ser_id = tgg.grser_ser_id   where tss.ser_nameshort ='HellGY' and tgg.gr_year = 2024 );
-- remove group 'GudeY' 2024 since it reprovided in 2025
delete from datawg.t_groupseries_grser where gr_id in
    (select gr_id from datawg.t_metricgroupseries_megser tmm left join datawg.t_groupseries_grser tgg on tmm.meg_gr_id = gr_id 
        left join datawg.t_series_ser tss  on tss.ser_id = tgg.grser_ser_id   where tss.ser_nameshort ='GudeY' and tgg.gr_year = 2024 );
```
-  6 and 6 new values inserted in the group and metric tables

```
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

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                6             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean      sd     p0    p25    p50
1 gr_id                 0             1 5708.     1.87  5706   5707.  5708. 
2 gr_year               0             1 2025.     0.516 2024   2024.  2025  
3 gr_number             0             1  122.   176.       1      8.5   13  
4 grser_ser_id          0             1  107.    76.0     38     64.2   65.5
5 weightg               0             1    1.06   1.38     0.5    0.5    0.5
     p75    p100 hist 
1 5710.  5711    ▇▃▃▃▃
2 2025   2025    ▃▁▁▁▇
3  250    368    ▇▁▁▁▃
4  170.   204    ▇▁▁▁▃
5    0.5    3.88 ▇▁▁▁▂
```

### individual metrics
- no data


## Annex 2
### series
- no modification

### dataseries
-  2 new values inserted in the database

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
1 das_comment                1           0.5  38  38     0        1          0
2 das_dts_datasource         0           1     7   7     0        1          0
3 das_qal_comment            2           0    NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean    sd        p0      p25
1 das_id                0             1 9274.    0.707 9274      9274.   
2 das_value             0             1    0.691 0.861    0.0828    0.387
3 das_ser_id            0             1  192     0      192       192    
4 das_year              0             1 2024.    0.707 2024      2024.   
5 das_effort            0             1    3     0        3         3    
6 das_qal_id            0             1    1     0        1         1    
       p50      p75   p100 hist 
1 9274.    9275.    9275   ▇▁▁▁▇
2    0.691    0.996    1.3 ▇▁▁▁▇
3  192      192      192   ▁▁▇▁▁
4 2024.    2025.    2025   ▇▁▁▁▇
5    3        3        3   ▁▁▇▁▁
6    1        1        1   ▁▁▇▁▁
```

### group metrics
- fix the template file: remove update since all rows are deleted. Move the two
data VVeY	2022 and 2023 from updates (since they were deleted) to new data

- 14 values deleted from group table, cascade delete on metrics

- 4 and 4 new values inserted in the group and metric tables (only length since 2022)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             4     
Number of columns          8     
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                4             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean    sd     p0     p25    p50
1 gr_id                 0             1 5720.   1.29 5718   5719.   5720. 
2 gr_year               0             1 2024.   1.29 2022   2023.   2024. 
3 gr_number             4             0  NaN   NA      NA     NA      NA  
4 grser_ser_id          0             1  192    0     192    192     192  
5 lengthmm              0             1   11.0  2.54    8.4    9.13   11.1
     p75   p100 hist   
1 5720.  5721   "▇▇▁▇▇"
2 2024.  2025   "▇▇▁▇▇"
3   NA     NA   " "    
4  192    192   "▁▁▇▁▁"
5   13.0   13.6 "▇▁▁▁▇"
```

### individual metrics
- no data


## Annex 3

### series

### dataseries
-  2 new values inserted in the database

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
1 das_comment                2             0  NA  NA     0        0          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            2             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean     sd     p0   p25    p50    p75
1 das_id                0             1 9278.   0.707 9278   9278. 9278.  9279. 
2 das_value             0             1    8.1  0.283    7.9    8     8.1    8.2
3 das_ser_id            0             1  211    0      211    211   211    211  
4 das_year              0             1 2024.   0.707 2023   2023. 2024.  2024. 
5 das_effort            2             0  NaN   NA       NA     NA    NA     NA  
6 das_qal_id            0             1    1    0        1      1     1      1  
    p100 hist   
1 9279   "▇▁▁▁▇"
2    8.3 "▇▁▁▁▇"
3  211   "▁▁▇▁▁"
4 2024   "▇▁▁▁▇"
5   NA   " "    
6    1   "▁▁▇▁▁"
```

### group metrics
- in the template file, ser_nameshort is missing in new group metrics, but since 
there is only a single series, we put RibS

- 2 and 6 new values inserted in the group and metric tables (length, weight, 
prop female)

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
1 gr_comment                0             1  45  45     0        1          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate     mean     sd     p0      p25
1 gr_id                     0             1 5726.     0.707 5726   5726.   
2 gr_year                   0             1 2024.     0.707 2023   2023.   
3 gr_number                 2             0  NaN     NA       NA     NA    
4 grser_ser_id              0             1  211      0      211    211    
5 lengthmm                  0             1  492     31.1    470    481    
6 weightg                   0             1  244.    53.0    206    225.   
7 female_proportion         0             1    0.595  0.134    0.5    0.548
       p50      p75    p100 hist   
1 5726.    5727.    5727    "▇▁▁▁▇"
2 2024.    2024.    2024    "▇▁▁▁▇"
3   NA       NA       NA    " "    
4  211      211      211    "▁▁▇▁▁"
5  492      503      514    "▇▁▁▁▇"
6  244.     262.     281    "▇▁▁▁▇"
7    0.595    0.642    0.69 "▇▁▁▁▇"
```

### individual metrics
- no data


## Annex 4
- in the template, 
  - updated data was removed since it was previously corrected by
  Cédric in the db (eel_id 569486 moved to freshwater instead of coastal and 
  removed fao_code)
  - removed data from DK_total in new data since the data for DK_Mari and DK_Inla
  are provided
  
  -  737 new values inserted in the database
  - we removed the data from DK_total that had just been inserted (rows were
  hidden in the template file) with an sql query `delete from datawg.t_eelstock_eel te where te.eel_emu_nameshort = 'DK_total' and eel_datasource = 'dc_2025';`
  . 288 rows deleted



```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             737   
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
 1 eel_emu_nameshort         0        1        7   8     0        3          0
 2 eel_cou_code              0        1        2   2     0        1          0
 3 eel_lfs_code              0        1        1   1     0        3          0
 4 eel_hty_code              0        1        1   2     0        4          0
 5 eel_area_division       713        0.0326   9   9     0        1          0
 6 eel_qal_comment         737        0       NA  NA     0        0          0
 7 eel_comment               8        0.989   25  93     0        3          0
 8 eel_missvaluequal         4        0.995    2   2     0        2          0
 9 eel_datasource            0        1        7   7     0        1          0
10 eel_dta_code              0        1        6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd     p0     p25     p50
1 eel_id                0       1       594812    213.   594444 594628  594812 
2 eel_typ_id            0       1            4      0         4      4       4 
3 eel_year              0       1         2011.     6.73   2000   2005    2011 
4 eel_value           733       0.00543  25178  40787.      599   2338.   7069.
5 eel_qal_id            0       1            1      0         1      1       1 
      p75    p100 hist 
1 594996  595180  ▇▇▇▇▇
2      4       4  ▁▁▇▁▁
3   2017    2024  ▇▇▇▇▅
4  29909.  85975. ▇▁▁▁▂
5      1       1  ▁▁▇▁▁
```
## Annex 5
- in the template file: we removed all rows related to DK_total since data are
provided per emu

-  500 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             500   
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
 1 eel_emu_nameshort         0       1         7   7     0        2          0
 2 eel_cou_code              0       1         2   2     0        1          0
 3 eel_lfs_code              0       1         1   1     0        3          0
 4 eel_hty_code              0       1         1   2     0        4          0
 5 eel_area_division       499       0.00200   9   9     0        1          0
 6 eel_qal_comment         500       0        NA  NA     0        0          0
 7 eel_comment               8       0.984    25  34     0        2          0
 8 eel_missvaluequal         2       0.996     2   2     0        2          0
 9 eel_datasource            0       1         7   7     0        1          0
10 eel_dta_code              0       1         6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean      sd     p0     p25     p50
1 eel_id                0       1       596172.  144.   595922 596047. 596172.
2 eel_typ_id            0       1            6     0         6      6       6 
3 eel_year              0       1         2011.    7.34   2000   2005    2010 
4 eel_value           498       0.00400   3280  1895.     1940   2610    3280 
5 eel_qal_id            0       1            1     0         1      1       1 
      p75   p100 hist 
1 596296. 596421 ▇▇▇▇▇
2      6       6 ▁▁▇▁▁
3   2018    2024 ▇▇▆▆▆
4   3950    4620 ▇▁▁▁▇
5      1       1 ▁▁▇▁▁
```

- 2 values updated in the db (eel_year is changed)

```
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

── Variable type: character ────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0           1     7   7     0        2          0
 2 eel_cou_code              0           1     2   2     0        1          0
 3 eel_lfs_code              0           1     2   2     0        1          0
 4 eel_hty_code              0           1     1   1     0        2          0
 5 eel_area_division         2           0.5   9   9     0        1          0
 6 eel_qal_comment           2           0.5  33  33     0        2          0
 7 eel_comment               0           1    15  18     0        2          0
 8 eel_missvaluequal         2           0.5   2   2     0        1          0
 9 eel_datasource            0           1     7   7     0        2          0
10 eel_dta_code              0           1     6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean        sd     p0     p25     p50
1 eel_id                0           1   585030. 13732.    573138 573139. 585030.
2 eel_typ_id            0           1        6      0          6      6       6 
3 eel_year              0           1     2024.     0.577   2023   2023    2024.
4 eel_value             2           0.5   4100      0       4100   4100    4100 
5 eel_qal_id            0           1       13     13.9        1      1      13 
      p75   p100 hist 
1 596922. 596923 ▇▁▁▁▇
2      6       6 ▁▁▇▁▁
3   2024    2024 ▇▁▁▁▇
4   4100    4100 ▁▁▇▁▁
5     25      25 ▇▁▁▁▇
```

## Annex 6
 no data


## Annex 7
- template file:
  - fix format in new data: reported kg in number in two separate rows instead of one
  - updated data does not seem to be updated at all => ignored
  
-  16 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             16    
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
 1 eel_emu_nameshort         0          1      7   7     0        2          0
 2 eel_cou_code              0          1      2   2     0        1          0
 3 eel_lfs_code              0          1      2   2     0        1          0
 4 eel_hty_code              0          1      1   1     0        2          0
 5 eel_area_division         4          0.75   6   9     0        3          0
 6 eel_qal_comment          16          0     NA  NA     0        0          0
 7 eel_comment              16          0     NA  NA     0        0          0
 8 eel_missvaluequal        16          0     NA  NA     0        0          0
 9 eel_datasource            0          1      7   7     0        1          0
10 eel_dta_code              0          1      6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean         sd     p0     p25
1 eel_id                0             1 600508.       4.76  600500 600504.
2 eel_typ_id            0             1      8.5      0.516      8      8 
3 eel_year              0             1   2022.       3.61    2018   2018 
4 eel_value             0             1 153636.  371018.        28    280 
5 eel_qal_id            0             1      1        0          1      1 
       p50     p75    p100 hist 
1 600508.  600511.  600515 ▇▆▆▆▆
2      8.5      9        9 ▇▁▁▁▇
3   2022.    2025     2025 ▇▁▁▁▇
4   6141.   42000  1223600 ▇▁▁▁▁
5      1        1        1 ▁▁▇▁▁
```


## Annex 8
- in the template: 
  - removed an empty row in deleted data
  - fix DK_inla to DK_Inla in one of the worsksheet
  - fix the eel_id in updated data for DK_total 2018 (to 523539)
  
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
1 eel_datelastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean sd     p0    p25    p50    p75
1 eel_id                0             1 596932 NA 596932 596932 596932 596932
2 eel_typ_id            0             1     11 NA     11     11     11     11
3 eel_year              0             1   2024 NA   2024   2024   2024   2024
4 eel_value             0             1  93720 NA  93720  93720  93720  93720
5 eel_qal_id            0             1      1 NA      1      1      1      1
    p100 hist 
1 596932 ▁▁▇▁▁
2     11 ▁▁▇▁▁
3   2024 ▁▁▇▁▁
4  93720 ▁▁▇▁▁
5      1 ▁▁▇▁▁
```


- 3 values updated in the db
```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             6     
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
 1 eel_emu_nameshort         0         1       8   8     0        1          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       1   2     0        2          0
 4 eel_hty_code              5         0.167   1   1     0        1          0
 5 eel_area_division         6         0      NA  NA     0        0          0
 6 eel_qal_comment           3         0.5    33  59     0        3          0
 7 eel_comment               4         0.333  16  18     0        2          0
 8 eel_missvaluequal         5         0.167   2   2     0        1          0
 9 eel_datasource            0         1       7   7     0        4          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-08 2025-09-08 2025-09-08
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean        sd     p0     p25     p50
1 eel_id                0         1     547592.  68299.   423339 529616. 572394.
2 eel_typ_id            0         1         11       0        11     11      11 
3 eel_year              0         1       2019.      1.86   2017   2017.   2018 
4 eel_value             1         0.833 636400  306925.   455000 455000  532000 
5 eel_qal_id            0         1         13      13.1       1      1      13 
      p75    p100 hist 
1 596942.  596943 ▂▁▂▂▇
2     11       11 ▁▁▇▁▁
3   2020.    2021 ▇▇▁▁▇
4 561000  1179000 ▇▁▁▁▂
5     25       25 ▇▁▁▁▇
```

- 5 values deleted in the db

## Annex 10
no data

### samplinginfo


### group metrics


### individual metrics



