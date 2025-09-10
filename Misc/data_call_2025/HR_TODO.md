-----------------------------------------------------------
# HR
-----------------------------------------------------------

## Annex 1

No data
## Annex 2

No data
## Annex 3

No data

## Annex 4

4 rows insertedn, correction if NP then not zero

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
 3 eel_lfs_code              0          1      1   2     0        2          0
 4 eel_hty_code              0          1      1   2     0        4          0
 5 eel_area_division         3          0.25   6   6     0        1          0
 6 eel_qal_comment           4          0     NA  NA     0        0          0
 7 eel_comment               4          0     NA  NA     0        0          0
 8 eel_missvaluequal         1          0.75   2   2     0        1          0
 9 eel_datasource            0          1      7   7     0        1          0
10 eel_dta_code              0          1      6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean    sd      p0     p25     p50
1 eel_id                0          1    600164.  1.29 600163  600164. 600164.
2 eel_typ_id            0          1         4   0         4       4       4 
3 eel_year              0          1      2024   0      2024    2024    2024 
4 eel_value             3          0.25    390. NA       390.    390.    390.
5 eel_qal_id            0          1         1   0         1       1       1 
      p75    p100 hist 
1 600165. 600166  ▇▇▁▇▇
2      4       4  ▁▁▇▁▁
3   2024    2024  ▁▁▇▁▁
4    390.    390. ▁▁▇▁▁
5      1       1  ▁▁▇▁▁


## Annex 5

Recreational fishing not permitted
All NR or NP removed the zero to pass constraint (NP is not zero)

 16 new values inserted in the database
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
 1 eel_emu_nameshort         0          1      8   8     0        1          0
 2 eel_cou_code              0          1      2   2     0        1          0
 3 eel_lfs_code              0          1      1   1     0        2          0
 4 eel_hty_code              0          1      1   2     0        4          0
 5 eel_area_division        12          0.25   6   6     0        1          0
 6 eel_qal_comment          16          0     NA  NA     0        0          0
 7 eel_comment               0          1     34  34     0        1          0
 8 eel_missvaluequal         0          1      2   2     0        2          0
 9 eel_datasource            0          1      7   7     0        1          0
10 eel_dta_code              0          1      6   6     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median    
1 eel_datelastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean     sd     p0     p25     p50
1 eel_id                0             1 600180.  4.76  600172 600176. 600180.
2 eel_typ_id            0             1      6   0          6      6       6 
3 eel_year              0             1   2024.  0.516   2023   2023    2024.
4 eel_value            16             0    NaN  NA         NA     NA      NA 
5 eel_qal_id            0             1      1   0          1      1       1 
      p75   p100 hist   
1 600183. 600187 "▇▆▆▆▆"
2      6       6 "▁▁▇▁▁"
3   2024    2024 "▇▁▁▁▇"
4     NA      NA " "    
5      1       1 "▁▁▇▁▁"

## Annex 6

No data

## Annex 7

No data

## Annex 8

No data
## Annex 9

### samplinginfo


### group metrics

#### modified metrics

 2 and 23 new values modified in the group and metric tables
Cédric  I changed the AL stage to YS in two rows

#### new data

 2 and 29 new values inserted in the group and metric tables
Cédric  I changed the AL stage to YS in two rows



── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             2     
Number of columns          23    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  19    
________________________         
Group variables            None  

── Variable type: character ────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                1           0.5   1   1     0        1          0
2 gr_dts_datasource         0           1     7   7     0        1          0
3 grsa_lfs_code             0           1     2   2     0        1          0

── Variable type: Date ─────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median    
1 gr_lastupdate         0             1 2025-09-09 2025-09-09 2025-09-09
  n_unique
1        1

── Variable type: numeric ──────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate
 1 gr_id                                                         0           1  
 2 gr_year                                                       0           1  
 3 gr_number                                                     0           1  
 4 grsa_sai_id                                                   0           1  
 5 lengthmm                                                      0           1  
 6 weightg                                                       0           1  
 7 ageyear                                                       0           1  
 8 differentiated_proportion                                     0           1  
 9 m_mean_lengthmm                                               0           1  
10 m_mean_weightg                                                0           1  
11 m_mean_ageyear                                                0           1  
12 f_mean_lengthmm                                               0           1  
13 f_mean_weightg                                                0           1  
14 f_mean_age                                                    0           1  
15 method_sex_(1=visual,0=use_length)                            0           1  
16 method_anguillicola_(1=stereomicroscope,0=visual_obs)         0           1  
17 female_proportion                                             0           1  
18 anguillicola_proportion                                       0           1  
19 anguillicola_intensity                                        1           0.5
       mean        sd      p0      p25      p50      p75    p100 hist 
 1 6174.      0.707   6174    6174.    6174.    6175.    6175    ▇▁▁▁▇
 2 2024       0       2024    2024     2024     2024     2024    ▁▁▇▁▁
 3  281     375.        16     148.     281      414.     546    ▇▁▁▁▇
 4  856      33.9      832     844      856      868      880    ▇▁▁▁▇
 5  428.     13.4      418     423.     428.     432.     437    ▇▁▁▁▇
 6  186.     20.9      171     178.     186.     193.     200.   ▇▁▁▁▇
 7    4.75    0.354      4.5     4.62     4.75     4.88     5    ▇▁▁▁▇
 8    0.6     0.0566     0.56    0.58     0.6      0.62     0.64 ▇▁▁▁▇
 9  211.    243.        39.9   126.     211.     297.     383    ▇▁▁▁▇
10  114.      6.86     109     111.     114.     116.     119.   ▇▁▁▁▇
11    4       0          4       4        4        4        4    ▁▁▇▁▁
12  544      28.3      524     534      544      554      564    ▇▁▁▁▇
13  385.    142.       285.    335.     385.     435.     485    ▇▁▁▁▇
14    6.1     1.27       5.2     5.65     6.1      6.55     7    ▇▁▁▁▇
15    1       0          1       1        1        1        1    ▁▁▇▁▁
16    0.5     0.707      0       0.25     0.5      0.75     1    ▇▁▁▁▇
17    0.555   0.00707    0.55    0.552    0.555    0.558    0.56 ▇▁▁▁▇
18    0.22    0.127      0.13    0.175    0.22     0.265    0.31 ▇▁▁▁▇
19    1      NA          1       1        1        1        1    ▁▁▇▁▁

### individual metrics

Mail sent to Ivana ....
Coordinates wrong .... 



