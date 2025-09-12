-----------------------------------------------------------
# NL
-----------------------------------------------------------

## Annex 1

### series
- update of comments for RhDOG and LauwG (grammar)

### dataseries
-  4 new values inserted in the database

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
1 das_comment                4             0  NA  NA     0        0          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            4             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean      sd      p0     p25
1 das_id                0             1 9728.      1.29  9726    9727.  
2 das_value             0             1    0.975   0.573    0.52    0.52
3 das_ser_id            0             1   13       1.83    11      11.8 
4 das_year              0             1 2025       0     2025    2025   
5 das_effort            0             1  154     222.      20      36.5 
6 das_qal_id            0             1    1       0        1       1   
       p50     p75    p100 hist 
1 9728.    9728.   9729    ▇▇▁▇▇
2    0.835    1.29    1.71 ▇▁▃▁▃
3   13       14.2    15    ▇▇▁▇▇
4 2025     2025    2025    ▁▁▇▁▁
5   55.5    173     485    ▇▁▁▁▂
6    1        1       1    ▁▁▇▁▁
```

### group metrics
-  1 and 1 new values inserted in the group and metric tables (only length)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             1     
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
1 gr_comment                1             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean sd     p0    p25    p50    p75
1 gr_id                 0             1 6230   NA 6230   6230   6230   6230  
2 gr_year               0             1 2024   NA 2024   2024   2024   2024  
3 gr_number             0             1  563   NA  563    563    563    563  
4 grser_ser_id          0             1   12   NA   12     12     12     12  
5 lengthmm              0             1   74.0 NA   74.0   74.0   74.0   74.0
    p100 hist 
1 6230   ▁▁▇▁▁
2 2024   ▁▁▇▁▁
3  563   ▁▁▇▁▁
4   12   ▁▁▇▁▁
5   74.0 ▁▁▇▁▁
```


### individual metrics
no data


## Annex 2

### series

### dataseries
- in the template file: 
  - values for IJsY and MarY 2021 in updated_data is the same as
  in existing data, so it ignored by shiny (missing values)
  - data in deleted_data already have das_qal_id 23, meaning they were removed 
  in 2023, so we ignore it
- 68 values updated in the db (MarY and IJsY)
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
1 das_comment                6             0  NA  NA     0        0          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            6             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean    sd       p0      p25     p50
1 das_id                0         1     10006.   1.87 10004    10005.   10006. 
2 das_value             0         1        24.9 18.4      6.81     9.17    21.2
3 das_ser_id            0         1       300.  52.7    231      257      332. 
4 das_year              0         1      2024    0     2024     2024     2024  
5 das_effort            2         0.667    25.5 12.5     14       18.5     22.5
6 das_qal_id            0         1         1    0        1        1        1  
      p75    p100 hist 
1 10008.  10009   ▇▃▃▃▃
2    41.6    46.7 ▇▁▂▁▅
3   334.    335   ▃▁▁▁▇
4  2024    2024   ▁▁▇▁▁
5    29.5    43   ▃▇▁▁▃
6     1       1   ▁▁▇▁▁
```

### group metrics
-  6 and 6 new values inserted in the group and metric tables (length)

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
1 gr_lastupdate         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean    sd   p0   p25   p50   p75 p100
1 gr_id                 0             1 6356.  1.87 6354 6355. 6356. 6358. 6359
2 gr_year               0             1 2024   0    2024 2024  2024  2024  2024
3 gr_number             6             0  NaN  NA      NA   NA    NA    NA    NA
4 grser_ser_id          0             1  300. 52.7   231  257   332.  334.  335
5 lengthmm              0             1  420. 37.7   367  398.  427   436.  474
  hist   
1 "▇▃▃▃▃"
2 "▁▁▇▁▁"
3 " "    
4 "▃▁▁▁▇"
5 "▃▃▇▃▃"
```

-  67 and 67 new values modified in the group and metric tables (length at 
digits level)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             67    
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
1 gr_comment               67             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean      sd    p0   p25   p50   p75
1 gr_id                 0             1 1231. 789.     976   992. 1009  1026.
2 gr_year               0             1 2006.  10.1   1989  1997  2005  2014 
3 gr_number            67             0  NaN   NA       NA    NA    NA    NA 
4 grser_ser_id          0             1  231.   0.504  231   231   231   232 
5 lengthmm              0             1  284.  70.4    157.  239.  264.  319.
  p100 hist   
1 4422 "▇▁▁▁▁"
2 2023 "▇▇▇▇▇"
3   NA " "    
4  232 "▇▁▁▁▇"
5  550 "▃▇▃▁▁"
```

### individual metrics
no data


## Annex 3

### series
- some changes in series_info, mostly changes in description and location
- the series in Zandmass is now said to be affected by restocking
- 7 values updated in the db

### dataseries
-  8 new values inserted in the database

```
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

── Variable type: character ────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment                8             0  NA  NA     0        0          0
2 das_dts_datasource         0             1   7   7     0        1          0
3 das_qal_comment            8             0  NA  NA     0        0          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median    
1 das_last_update         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean     sd        p0      p25
1 das_id                0         1     9804.     2.45  9800      9802.   
2 das_value             1         0.875    8.65  15.0      0.0557    0.203
3 das_ser_id            0         1      256.    58.9    233       235.   
4 das_year              0         1     2024.     0.354 2023      2024    
5 das_effort            1         0.875  218.    61.8    140       165    
6 das_qal_id            0         1        0.875  0.354    0         1    
      p50     p75   p100 hist 
1 9804.   9805.   9807   ▇▃▇▃▇
2    1.21    9.79   39.3 ▇▁▂▁▂
3  236.    237.    402   ▇▁▁▁▁
4 2024    2024    2024   ▁▁▁▁▇
5  233     269     284   ▅▂▁▂▇
6    1       1       1   ▁▁▁▁▇
```


### group metrics
- the group value for NZKS 2023 was already in the db, exactly the same, so
the this new value is not integrated
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
1 gr_lastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean    sd   p0   p25   p50   p75 p100
1 gr_id                 0             1 6234.  1.87 6232 6233. 6234. 6236. 6237
2 gr_year               0             1 2024   0    2024 2024  2024  2024  2024
3 gr_number             6             0  NaN  NA      NA   NA    NA    NA    NA
4 grser_ser_id          0             1  263. 68.0   233  234.  236   238.  402
5 lengthmm              0             1  767. 36.8   714  742.  783   790.  803
  hist   
1 "▇▃▃▃▃"
2 "▁▁▇▁▁"
3 " "    
4 "▇▁▁▁▂"
5 "▇▁▁▇▇"
```

### individual metrics
no data


## Annex 4
- in the template file, extra columns were removed in updated data

- 7 values deleted in the db

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
 1 eel_emu_nameshort         0        1        7   7     0        1          0
 2 eel_cou_code              0        1        2   2     0        1          0
 3 eel_lfs_code              0        1        1   2     0        4          0
 4 eel_hty_code              0        1        1   2     0        4          0
 5 eel_area_division        13        0.0714   6   6     0        1          0
 6 eel_qal_comment          14        0       NA  NA     0        0          0
 7 eel_comment               4        0.714   36  36     0        1          0
 8 eel_missvaluequal         2        0.857    2   2     0        2          0
 9 eel_datasource            0        1        7   7     0        1          0
10 eel_dta_code              0        1        6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean        sd     p0     p25     p50
1 eel_id                0         1     600958.      4.18 600951 600954. 600958.
2 eel_typ_id            0         1          4       0         4      4       4 
3 eel_year              0         1       2024       0      2024   2024    2024 
4 eel_value            12         0.143 239510  336434.     1615 120562. 239510 
5 eel_qal_id            0         1          1       0         1      1       1 
      p75   p100 hist 
1 600961. 600964 ▇▇▅▇▇
2      4       4 ▁▁▇▁▁
3   2024    2024 ▁▁▇▁▁
4 358458. 477405 ▇▁▁▁▇
5      1       1 ▁▁▇▁▁
```

- 76 values updated in the db (change of qal_id from 1 to 3 for some incomplete
historical data)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             152   
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
 3 eel_lfs_code              0         1       2   2     0        1          0
 4 eel_hty_code              0         1       1   1     0        2          0
 5 eel_area_division       130         0.145   6   6     0        1          0
 6 eel_qal_comment          76         0.5    33  33     0       76          0
 7 eel_comment               0         1      38  82     0        3          0
 8 eel_missvaluequal       152         0      NA  NA     0        0          0
 9 eel_datasource            0         1       7   7     0        2          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean        sd     p0     p25
1 eel_id                0             1  577421.   23693.  553768 553806.
2 eel_typ_id            0             1       4        0        4      4 
3 eel_year              0             1    1981.      19.9   1945   1964.
4 eel_value             0             1 1220443. 1275274.    3493 292962 
5 eel_qal_id            0             1      13       12.0      1      1 
      p50      p75    p100 hist 
1 577424.  601036.  601074 ▇▁▁▁▇
2      4        4        4 ▁▁▇▁▁
3   1982.    2000     2009 ▅▅▅▅▇
4 705000  2116000  4799000 ▇▁▂▁▁
5     13       25       25 ▇▁▁▁▇
```

## Annex 5
- 22 new values inserted in the database

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             22    
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
 1 eel_emu_nameshort         0        1        7   7     0        1          0
 2 eel_cou_code              0        1        2   2     0        1          0
 3 eel_lfs_code              0        1        1   1     0        3          0
 4 eel_hty_code              0        1        1   2     0        4          0
 5 eel_area_division        21        0.0455   6   6     0        1          0
 6 eel_qal_comment          22        0       NA  NA     0        0          0
 7 eel_comment              10        0.545   25  34     0        2          0
 8 eel_missvaluequal         0        1        2   2     0        2          0
 9 eel_datasource            0        1        7   7     0        1          0
10 eel_dta_code              0        1        6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean     sd     p0     p25     p50
1 eel_id                0             1 601182.  6.49  601171 601176. 601182.
2 eel_typ_id            0             1      6   0          6      6       6 
3 eel_year              0             1   2023.  0.510   2023   2023    2023 
4 eel_value            22             0    NaN  NA         NA     NA      NA 
5 eel_qal_id            0             1      1   0          1      1       1 
      p75   p100 hist   
1 601187. 601192 "▇▆▆▆▇"
2      6       6 "▁▁▇▁▁"
3   2024    2024 "▇▁▁▁▇"
4     NA      NA " "    
5      1       1 "▁▁▇▁▁"
```

## Annex 6
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
 1 eel_emu_nameshort         0             1   7   7     0        1          0
 2 eel_cou_code              0             1   2   2     0        1          0
 3 eel_lfs_code              0             1   1   1     0        1          0
 4 eel_hty_code              0             1   1   1     0        1          0
 5 eel_area_division         1             0  NA  NA     0        0          0
 6 eel_qal_comment           1             0  NA  NA     0        0          0
 7 eel_comment               0             1  17  17     0        1          0
 8 eel_missvaluequal         1             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean sd     p0    p25    p50    p75
1 eel_id                0             1 601215 NA 601215 601215 601215 601215
2 eel_typ_id            0             1     32 NA     32     32     32     32
3 eel_year              0             1   2024 NA   2024   2024   2024   2024
4 eel_value             0             1   7743 NA   7743   7743   7743   7743
5 eel_qal_id            0             1      1 NA      1      1      1      1
    p100 hist 
1 601215 ▁▁▇▁▁
2     32 ▁▁▇▁▁
3   2024 ▁▁▇▁▁
4   7743 ▁▁▇▁▁
5      1 ▁▁▇▁▁
```

## Annex 7
- in the template file
  - shifted the content of a few columns to get them in 
correct place
  - fix typ name from q_release_n to release_n

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
 1 eel_emu_nameshort         0             1   7   7     0        1          0
 2 eel_cou_code              0             1   2   2     0        1          0
 3 eel_lfs_code              0             1   1   2     0        2          0
 4 eel_hty_code              0             1   1   1     0        1          0
 5 eel_area_division         4             0  NA  NA     0        0          0
 6 eel_qal_comment           4             0  NA  NA     0        0          0
 7 eel_comment               4             0  NA  NA     0        0          0
 8 eel_missvaluequal         4             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean          sd     p0     p25
1 eel_id                0             1 601220.        1.29  601219 601220.
2 eel_typ_id            0             1      8.5       0.577      8      8 
3 eel_year              0             1   2025         0       2025   2025 
4 eel_value             0             1 854108.  1199177.      1078   1109.
5 eel_qal_id            0             1      1         0          1      1 
       p50      p75    p100 hist 
1 601220.   601221.  601222 ▇▇▁▇▇
2      8.5       9        9 ▇▁▁▁▇
3   2025      2025     2025 ▁▁▇▁▁
4 435253   1288252. 2544846 ▇▃▁▁▃
5      1         1        1 ▁▁▇▁▁
```

## Annex 8
-  2 new values inserted in the database

```
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

── Variable type: character ────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0             1   7   7     0        1          0
 2 eel_cou_code              0             1   2   2     0        1          0
 3 eel_lfs_code              0             1   1   1     0        1          0
 4 eel_hty_code              2             0  NA  NA     0        0          0
 5 eel_area_division         2             0  NA  NA     0        0          0
 6 eel_qal_comment           2             0  NA  NA     0        0          0
 7 eel_comment               2             0  NA  NA     0        0          0
 8 eel_missvaluequal         2             0  NA  NA     0        0          0
 9 eel_datasource            0             1   7   7     0        1          0
10 eel_dta_code              0             1   6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-10 2025-09-10 2025-09-10
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean         sd      p0      p25
1 eel_id                0             1  601228.      0.707  601227  601227.
2 eel_typ_id            0             1      11       0          11      11 
3 eel_year              0             1    2024.      0.707    2024    2024.
4 eel_value             0             1 2075000  106066.    2000000 2037500 
5 eel_qal_id            0             1       1       0           1       1 
       p50      p75    p100 hist 
1  601228.  601228.  601228 ▇▁▁▁▇
2      11       11       11 ▁▁▇▁▁
3    2024.    2025.    2025 ▇▁▁▁▇
4 2075000  2112500  2150000 ▇▁▁▁▇
5       1        1        1 ▁▁▇▁▁
```


## Annex 9

### samplinginfo
- there are two new sampling in which I edited the name to be consistent with
the standard naming convention (NL_Neth_FYMA, NL_Neth_DAK)
-  2 new values inserted in the database

### group metrics
-  37 values deleted from group table, cascade delete on metrics

### individual metrics
- in template
  - change "NA" to "" in new individual metrics
  - fix sai_name to NL_Neth_FYMA, NL_Neth_DAK
  - sai_name 'NL_Neth_market_IJSMM' were fixed to 'NL_Neth_market'
  - fix longitude -5.11667 to 5.11667
  - fix longitude 51.16667 to 5.116667
  - fix longitude 4.11867 to 5.11867 (check with existing data)
  - fixed latitude 53.89453 to 52.89453
  - fixed lattitude 532.53333 to 52.53333



-  11422 values deleted from fish table, cascade delete on metrics (all data)
- 18141 and 114392 new values inserted in the fish and metric tables

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             18141 
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
1 fi_comment              120         0.993  65  65     0        1          0
2 fi_dts_datasource         0         1       7   7     0        1          0
3 fi_lfs_code               0         1       1   2     0        3          0
4 fisa_geom             18141         0      NA  NA     0        0          0
5 fi_id_cou                 0         1       8   8     0    18141          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 fi_date               0             1 1988-09-26 2024-10-03 2012-08-08
2 fi_lastupdate         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1      547
2        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 fi_id                                                         0        1     
 2 fi_year                                                       0        1     
 3 fisa_sai_id                                                   0        1     
 4 fisa_x_4326                                                 109        0.994 
 5 fisa_y_4326                                                  75        0.996 
 6 lengthmm                                                      2        1.00  
 7 weightg                                                       6        1.00  
 8 ageyear                                                   16841        0.0717
 9 differentiated_proportion                                  3595        0.802 
10 method_sex_(1=visual,0=use_length)                         3595        0.802 
11 female_proportion                                          3595        0.802 
12 method_anguillicola_(1=stereomicroscope,0=visual_obs)      6055        0.666 
13 anguillicola_proportion                                    6175        0.660 
14 anguillicola_intensity                                    17836        0.0168
15 eye_diam_meanmm                                           13726        0.243 
16 pectoral_lengthmm                                         13733        0.243 
          mean       sd          p0        p25        p50        p75       p100
 1 3907938     5237.    3898868     3903403    3907938    3912473    3917008   
 2    2014.       5.38     1988        2010       2012       2019       2024   
 3     358.      52.8       353         353        353        353        972   
 4       5.31     0.486       3.73        5.11       5.28       5.51       6.93
 5      52.6      2.10        5.04       52.5       52.8       52.9       53.4 
 6     474.     163.         98         353        424        568       1120   
 7     303.     377.          1.7        77        139        357       3471   
 8       8.02     4.31        1           5          7         10         32   
 9       1        0           1           1          1          1          1   
10       1        0           1           1          1          1          1   
11       0.851    0.356       0           1          1          1          1   
12       0        0           0           0          0          0          0   
13       0.331    0.471       0           0          0          1          1   
14       6.15     7.52        1           2          4          7         62   
15       1.15     0.154       0.103       1.05       1.13       1.23       3.88
16      22.4      9.93        2.23       14.6       19.8       29.0       67.6 
   hist 
 1 ▇▇▇▇▇
 2 ▁▁▃▇▆
 3 ▇▁▁▁▁
 4 ▁▂▇▂▁
 5 ▁▁▁▁▇
 6 ▂▇▃▂▁
 7 ▇▁▁▁▁
 8 ▇▅▁▁▁
 9 ▁▁▇▁▁
10 ▁▁▇▁▁
11 ▂▁▁▁▇
12 ▁▁▇▁▁
13 ▇▁▁▁▃
14 ▇▁▁▁▁
15 ▁▇▁▁▁
16 ▅▇▃▁▁
```


