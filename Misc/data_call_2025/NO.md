-----------------------------------------------------------
# NO
-----------------------------------------------------------

## Annex 1

### series

### dataseries
- in the template, we remove ImsaGY 2025 that os empty

-  1 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
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
1 das_comment                1             0  NA  NA     0        0          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            1             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate mean sd   p0  p25  p50  p75 p100 hist   
1 das_id                0             1 9868 NA 9868 9868 9868 9868 9868 "▁▁▇▁▁"
2 das_value             0             1 1424 NA 1424 1424 1424 1424 1424 "▁▁▇▁▁"
3 das_ser_id            0             1   29 NA   29   29   29   29   29 "▁▁▇▁▁"
4 das_year              0             1 2024 NA 2024 2024 2024 2024 2024 "▁▁▇▁▁"
5 das_effort            1             0  NaN NA   NA   NA   NA   NA   NA " "    
6 das_qal_id            0             1    1 NA    1    1    1    1    1 "▁▁▇▁▁"
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
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean      sd     p0      p25     p50
1 gr_id                 0             1 6244.     0.707 6244   6244.    6244.  
2 gr_year               0             1 2024.     0.707 2023   2023.    2024.  
3 gr_number             0             1  396.   101.     324    360.     396.  
4 grser_ser_id          0             1   29      0       29     29       29   
5 lengthmm              0             1   93.5   13.4     84     88.8     93.5 
6 weightg               0             1    1.10   0.559    0.7    0.898    1.10
      p75    p100 hist 
1 6245.   6245    ▇▁▁▁▇
2 2024.   2024    ▇▁▁▁▇
3  431.    467    ▇▁▁▁▇
4   29      29    ▁▁▇▁▁
5   98.2   103    ▇▁▁▁▇
6    1.29    1.49 ▇▁▁▁▇
```


### individual metrics
no data


## Annex 2

### series
- edit of area division for SkaY (from 27.4.a to 27.3.7)

### dataseries
- in the template file:
  - updated data: put a qal_id to SkaY 2009 given the comment (!!Series was 
  truncated that year)
  - most of the updated data are strictly similar to existing ones so the shiny
  ignore them
  
-  1 new values inserted in the database (SkaY)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
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
1 das_comment                1             0  NA  NA     0        0          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            1             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean sd      p0     p25     p50
1 das_id                0             1 9870    NA 9870    9870    9870   
2 das_value             0             1    0.04 NA    0.04    0.04    0.04
3 das_ser_id            0             1  239    NA  239     239     239   
4 das_year              0             1 2024    NA 2024    2024    2024   
5 das_effort            0             1  160    NA  160     160     160   
6 das_qal_id            0             1    1    NA    1       1       1   
      p75    p100 hist 
1 9870    9870    ▁▁▇▁▁
2    0.04    0.04 ▁▁▇▁▁
3  239     239    ▁▁▇▁▁
4 2024    2024    ▁▁▇▁▁
5  160     160    ▁▁▇▁▁
6    1       1    ▁▁▇▁▁
```

- 1 values updated in the db (the eel_qal_id)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
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
1 das_comment                0             1  32  32     0        1          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            1             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean sd       p0      p25      p50
1 das_id                0             1 4555     NA 4555     4555     4555    
2 das_value             0             1    0.106 NA    0.106    0.106    0.106
3 das_ser_id            0             1  239     NA  239      239      239    
4 das_year              0             1 2009     NA 2009     2009     2009    
5 das_effort            1             0  NaN     NA   NA       NA       NA    
6 das_qal_id            0             1    4     NA    4        4        4    
       p75     p100 hist   
1 4555     4555     "▁▁▇▁▁"
2    0.106    0.106 "▁▁▇▁▁"
3  239      239     "▁▁▇▁▁"
4 2009     2009     "▁▁▇▁▁"
5   NA       NA     " "    
6    4        4     "▁▁▇▁▁"
```

### group metrics
no data

### individual metrics
-  18 and 18 new values inserted in the fish and metric tables (only length)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             18    
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
1 fi_comment               18             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   2   2     0        1          0
4 fi_id_cou                 0             1   6   6     0       18          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date              18             0 Inf        -Inf       NA        
2 fi_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        0
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean      sd      p0      p25
1 fi_id                 0             1 3849392.   5.34  3849383 3849387.
2 fi_year               0             1    2023.   0.502    2023    2023 
3 fiser_ser_id          0             1     239    0         239     239 
4 lengthmm              0             1     644. 134.        400     550 
       p50      p75    p100 hist 
1 3849392. 3849396. 3849400 ▇▆▇▆▇
2    2023     2024     2024 ▇▁▁▁▅
3     239      239      239 ▁▁▇▁▁
4     640      750      850 ▃▆▆▇▅
```


## Annex 3

### series

### dataseries
-  1 new values inserted in the database (ImsaS 2024)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
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
1 das_comment                1             0  NA  NA     0        0          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            1             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate mean sd   p0  p25  p50  p75 p100 hist   
1 das_id                0             1 9872 NA 9872 9872 9872 9872 9872 "▁▁▇▁▁"
2 das_value             0             1 2129 NA 2129 2129 2129 2129 2129 "▁▁▇▁▁"
3 das_ser_id            0             1  196 NA  196  196  196  196  196 "▁▁▇▁▁"
4 das_year              0             1 2024 NA 2024 2024 2024 2024 2024 "▁▁▇▁▁"
5 das_effort            1             0  NaN NA   NA   NA   NA   NA   NA " "    
6 das_qal_id            0             1    1 NA    1    1    1    1    1 "▁▁▇▁▁"
```

- 1 values updated in the db (ImsaS 2023)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
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
1 das_comment                1             0  NA  NA     0        0          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            1             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate mean sd   p0  p25  p50  p75 p100 hist   
1 das_id                0             1 8578 NA 8578 8578 8578 8578 8578 "▁▁▇▁▁"
2 das_value             0             1 2213 NA 2213 2213 2213 2213 2213 "▁▁▇▁▁"
3 das_ser_id            0             1  196 NA  196  196  196  196  196 "▁▁▇▁▁"
4 das_year              0             1 2023 NA 2023 2023 2023 2023 2023 "▁▁▇▁▁"
5 das_effort            1             0  NaN NA   NA   NA   NA   NA   NA " "    
6 das_qal_id            0             1    1 NA    1    1    1    1    1 "▁▁▇▁▁"
```

### group metrics
-  1 and 6 new values inserted in the group and metric tables

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
1 gr_comment                1             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate mean sd   p0  p25
 1 gr_id                                      0             1 6248 NA 6248 6248
 2 gr_year                                    0             1 2024 NA 2024 2024
 3 gr_number                                  0             1  653 NA  653  653
 4 grser_ser_id                               0             1  196 NA  196  196
 5 lengthmm                                   0             1  717 NA  717  717
 6 weightg                                    0             1  700 NA  700  700
 7 f_mean_lengthmm                            0             1  717 NA  717  717
 8 f_mean_weightg                             0             1  700 NA  700  700
 9 method_sex_(1=visual,0=use_length)         0             1    1 NA    1    1
10 female_proportion                          0             1    1 NA    1    1
    p50  p75 p100 hist 
 1 6248 6248 6248 ▁▁▇▁▁
 2 2024 2024 2024 ▁▁▇▁▁
 3  653  653  653 ▁▁▇▁▁
 4  196  196  196 ▁▁▇▁▁
 5  717  717  717 ▁▁▇▁▁
 6  700  700  700 ▁▁▇▁▁
 7  717  717  717 ▁▁▇▁▁
 8  700  700  700 ▁▁▇▁▁
 9    1    1    1 ▁▁▇▁▁
10    1    1    1 ▁▁▇▁▁
```


### individual metrics
no data


## Annex 4
- in the template file, remove eel_area_division in F in updated_data
-  4 new values inserted in the database

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
 1 eel_emu_nameshort         0          1      8   8     0        1          0
 2 eel_cou_code              0          1      2   2     0        1          0
 3 eel_lfs_code              0          1      1   1     0        1          0
 4 eel_hty_code              0          1      1   2     0        4          0
 5 eel_area_division         3          0.25   6   6     0        1          0
 6 eel_qal_comment           4          0     NA  NA     0        0          0
 7 eel_comment               4          0     NA  NA     0        0          0
 8 eel_missvaluequal         1          0.75   2   2     0        1          0
 9 eel_datasource            0          1      7   7     0        1          0
10 eel_dta_code              0          1      6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean    sd     p0     p25     p50
1 eel_id                0          1    601232.  1.29 601231 601232. 601232.
2 eel_typ_id            0          1         4   0         4      4       4 
3 eel_year              0          1      2024   0      2024   2024    2024 
4 eel_value             3          0.25   2000  NA      2000   2000    2000 
5 eel_qal_id            0          1         1   0         1      1       1 
      p75   p100 hist 
1 601233. 601234 ▇▇▁▇▇
2      4       4 ▁▁▇▁▁
3   2024    2024 ▁▁▇▁▁
4   2000    2000 ▁▁▇▁▁
5      1       1 ▁▁▇▁▁
```

- 366 values updated in the db

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             732   
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
 3 eel_lfs_code              0         1       1   2     0        4          0
 4 eel_hty_code              0         1       1   2     0        4          0
 5 eel_area_division       153         0.791   6   6     0        2          0
 6 eel_qal_comment         366         0.5    33  33     0      366          0
 7 eel_comment             290         0.604   1  38     0        7          0
 8 eel_missvaluequal       232         0.683   2   2     0        1          0
 9 eel_datasource            0         1       7   7     0        7          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd     p0     p25     p50
1 eel_id                0         1     515370.  91943.  380287 434622. 581418.
2 eel_typ_id            0         1          4       0        4      4       4 
3 eel_year              0         1       1997.     29.2   1908   1999    2008 
4 eel_value           500         0.317 293689. 170887.       0 162750  323500 
5 eel_qal_id            0         1         13      12.0      1      1      13 
      p75   p100 hist 
1 601673. 601856 ▂▅▁▁▇
2      4       4 ▁▁▇▁▁
3   2016    2023 ▁▁▁▁▇
4 416750  694000 ▅▃▇▅▁
5     25      25 ▇▁▁▁▇
```

## Annex 5
no data

## Annex 6
no data


## Annex 7
no data


## Annex 8
no data

## Annex 9

### samplinginfo


### group metrics


### individual metrics



