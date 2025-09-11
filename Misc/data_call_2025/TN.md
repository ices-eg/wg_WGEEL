-----------------------------------------------------------
# TN
-----------------------------------------------------------

## Annex 1
no data

## Annex 2
no data



## Annex 3
no data



## Annex 4
- in the template file:
  - there was an error in reporting data: data that had been reported as 2023 
  were in fact data from 2022 that had already been inserted as 2022
  - data that had been reported as 2024 were in fact data from 2023
  - put data 2023 in deleted data (since there are from 2022 and had already been
  reported)
  - put data 2024 in updated data and change year to 2023
  
- 32 values deleted in the db (data that had been reported as 2023 but were 2022)
- 16 values updated in the db (data from 2024 reassigned to 2023)

```
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             32    
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
 1 eel_emu_nameshort         0          1      5   6     0        4          0
 2 eel_cou_code              0          1      2   2     0        1          0
 3 eel_lfs_code              0          1      2   2     0        1          0
 4 eel_hty_code              0          1      1   2     0        4          0
 5 eel_area_division         8          0.75   6   6     0        2          0
 6 eel_qal_comment          16          0.5   33  33     0       16          0
 7 eel_comment              32          0     NA  NA     0        0          0
 8 eel_missvaluequal         8          0.75   2   2     0        1          0
 9 eel_datasource            0          1      7   7     0        2          0
10 eel_dta_code              0          1      6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean        sd     p0     p25     p50
1 eel_id                0          1    596698  12159.    584723 584731. 596698 
2 eel_typ_id            0          1         4      0          4      4       4 
3 eel_year              0          1      2024.     0.508   2023   2023    2024.
4 eel_value            24          0.25  26363. 43214.      1929   2276.   3584.
5 eel_qal_id            0          1        13     12.2        1      1      13 
      p75   p100 hist 
1 608665. 608673 ▇▁▁▁▇
2      4       4 ▁▁▇▁▁
3   2024    2024 ▇▁▁▁▇
4  27671   96353 ▇▁▁▁▂
5     25      25 ▇▁▁▁▇
```
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
 1 eel_emu_nameshort         0         1       5   6     0        4          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       2   2     0        1          0
 4 eel_hty_code              0         1       1   2     0        4          0
 5 eel_area_division         4         0.75    6   6     0        2          0
 6 eel_qal_comment          16         0      NA  NA     0        0          0
 7 eel_comment              16         0      NA  NA     0        0          0
 8 eel_missvaluequal         5         0.688   2   2     0        1          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-11 2025-09-11 2025-09-11
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd     p0     p25     p50
1 eel_id                0         1     608698.     4.76 608690 608694. 608698.
2 eel_typ_id            0         1          4      0         4      4       4 
3 eel_year              0         1       2024      0      2024   2024    2024 
4 eel_value            11         0.312  12487. 23271.      150   1846    2015 
5 eel_qal_id            0         1          1      0         1      1       1 
      p75   p100 hist 
1 608701. 608705 ▇▆▆▆▆
2      4       4 ▁▁▇▁▁
3   2024    2024 ▁▁▇▁▁
4   4398   54027 ▇▁▁▁▂
5      1       1 ▁▁▇▁▁
```

## Annex 5
no data

## Annex 6
no data


## Annex 7
no data


## Annex 8


## Annex 9
no data