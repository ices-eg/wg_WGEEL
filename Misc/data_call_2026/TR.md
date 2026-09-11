-----------------------------------------------------------
# TR
-----------------------------------------------------------

## Annex 1 NR

## Annex 2 NR

## Annex 3 NR

## Annex 4

 1 new values inserted in the database

## Annex 5 NP

## Annex 6 NP

## Annex 7 NP

## Annex 8 NP

## Annex 9

### samplinginfo

 8 new values inserted in the database
 
 1 values updated in the db

### group metrics

5 and 24 new values inserted in the group and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             5     
Number of columns          14    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  10    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1  46  46     0        1          0
2 gr_dts_datasource         0             1   7   7     0        1          0
3 grsa_lfs_code             0             1   1   1     0        2          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-09 2026-09-09 2026-09-09        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate     mean       sd       p0      p25   p50   p75  p100 hist 
 1 gr_id                                      0           1   6910       1.58   6908     6909     6910  6911  6912  ▇▇▇▇▇
 2 gr_year                                    0           1   2025       0      2025     2025     2025  2025  2025  ▁▁▇▁▁
 3 gr_number                                  0           1     32.2    37.9       4       11       19    29    98  ▇▂▁▁▂
 4 grsa_sai_id                                0           1   1022       1.87   1020     1020     1023  1023  1024  ▇▁▁▇▃
 5 f_mean_lengthmm                            0           1    526.     91.1     415      465      523   585   643  ▇▇▇▇▇
 6 f_mean_weightg                             0           1    353.    189.      129.     241.     299.  522.  573. ▃▇▁▁▇
 7 method_sex_(1=visual,0=use_length)         0           1      1       0         1        1        1     1     1  ▁▁▇▁▁
 8 female_proportion                          0           1      0.991   0.0149    0.966    0.990    1     1     1  ▂▁▁▂▇
 9 m_mean_lengthmm                            3           0.4  382.     31.8     360      371.     382.  394.  405  ▇▁▁▁▇
10 m_mean_weightg                             3           0.4  101.     20.4      87       94.2    101.  109.  116. ▇▁▁▁▇

### individual metrics

Checked all locations and corrected with Sukran
Put all fish in the ASI river at the river mouth
Put all rivers at the river mouth
Corrected missing stages with YS (historical fishes in the ASI were'nt checked for stage)


[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             826   
Number of columns          20    
_______________________          
Column type frequency:           
  character                5     
  Date                     2     
  numeric                  13    
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment                0             1  46  46     0        2          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   2     0        3          0
4 fisa_geom               826             0  NA  NA     0        0          0
5 fi_id_cou                 0             1  14  18     0      798          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date             194         0.765 1997-01-26 2017-11-01 2013-05-13       73
2 fi_lastupdate         0         1     2026-09-11 2026-09-11 2026-09-11        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                      n_missing complete_rate        mean       sd        p0        p25        p50        p75      p100 hist 
 1 fi_id                                      0         1     4623986.    239.     4623574   4623780.   4623986.   4624193.   4624399   ▇▇▇▇▇
 2 fi_year                                    0         1        2010.     10.7       1997      1997       2014       2017       2025   ▇▁▂▇▅
 3 fisa_sai_id                                0         1        1005.     20.6        979       979       1019       1022       1025   ▅▁▁▁▇
 4 fisa_x_4326                                0         1          30.9     4.34        26.2      26.2       28.8       36.0       36.0 ▇▃▁▁▇
 5 fisa_y_4326                                0         1          37.5     1.75        36.0      36.0       36.7       40.0       40.8 ▇▂▁▁▃
 6 lengthmm                                   0         1         497.    125.         235       400        476        580        920   ▃▇▅▂▁
 7 weightg                                   10         0.988     377.    246.          53.4     163.       352.       517.      1400   ▇▇▂▁▁
 8 eye_diam_meanmm                          361         0.563       6.55   15.9          3         4.85       5.85       6.82     348.  ▇▁▁▁▁
 9 pectoral_lengthmm                        362         0.562      22.2     6.14        10        18.1       20.7       25.6       40.9 ▂▇▃▂▁
10 differentiated_proportion                665         0.195       0.994   0.0788       0         1          1          1          1   ▁▁▁▁▇
11 method_sex_(1=visual,0=use_length)       266         0.678       0.986   0.119        0         1          1          1          1   ▁▁▁▁▇
12 female_proportion                        266         0.678       0.866   0.341        0         1          1          1          1   ▁▁▁▁▇
13 ageyear                                  452         0.453       3.55    2.29         0         2          3          5         18   ▇▆▁▁▁