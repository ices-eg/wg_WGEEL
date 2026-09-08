-----------------------------------------------------------
# FR
-----------------------------------------------------------

## Annex 1

### series

No change

### dataseries

 new : 7 new values inserted in the database
 
 modified : 45 values updated in the db
 
### group metrics

new : 1 and 1 new values inserted in the group and metric tables

modified :  1 and 1 new values modified in the group and metric tables

### individual metrics

 deleted : 199584 values deleted from fish table, cascade delete on metrics
 
 new :  217008 and 223320 new values inserted in the fish and metric tables
 
 [1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             217008
Number of columns          13    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  7     
________________________         
Group variables            None  

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment           216751       0.00118  27  38     0        3          0
2 fi_dts_datasource         0       1         7   7     0        1          0
3 fi_lfs_code           12132       0.944     1   1     0        2          0
4 fi_id_cou                 0       1        10  15     0   217008          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 1994-04-30 2026-06-20 2008-06-06     2511
2 fi_lastupdate         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate       mean        sd          p0       p25        p50        p75      p100 hist 
1 fi_id                     0      1        4046032.   62645.    3937528     3991780.  4046032.   4100283.   4154535   ▇▇▇▇▇
2 fi_year                   0      1           2010.       9.11     1994        2001      2008       2018       2026   ▇▇▇▅▇
3 fiser_ser_id              0      1             84.9     87.0        50          61        61         61        485   ▇▁▁▁▁
4 lengthmm                  0      1            123.      32.8        38         102       120        137        665   ▇▁▁▁▁
5 weightg              210868      0.0283        10.7     21.9         0.107       4         6          9        759   ▇▁▁▁▁
6 eye_diam_meanmm      216923      0.000392       3.74     0.844       2.4         3.1       3.65       4.35       6   ▆▇▆▃▁
7 pectoral_lengthmm    216921      0.000401      14.7      3.44        9          12.0      14.1       16.5       24.2 ▆▇▅▂▁

## Annex 2

### series

no new series

### dataseries

 17 new values inserted in the database
 
 Modified : 198 values updated in the db
 
 
 [1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             198   
Number of columns          10    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment                0         1      22 174     0        2          0
2 das_dts_datasource       123         0.379   7   7     0        5          0
3 das_qal_comment          198         0      NA  NA     0        0          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean       sd       p0      p25      p50      p75    p100 hist 
1 das_id                0             1 6387.    1626.    4067     5478.    6542.    7872.    9405    ▆▇▇▂▆
2 das_value             0             1    0.600    0.503    0.043    0.191    0.456    0.893    2.40 ▇▃▂▁▁
3 das_ser_id            0             1  297.      61.4    213      217.     304.     371      376    ▆▁▇▁▆
4 das_year              0             1 2017.       4.84  2002     2013     2018.    2021     2024    ▁▂▆▆▇
5 das_effort            0             1   10.2      8.93     1        4        9       11       52    ▇▂▁▁▁
6 das_qal_id            0             1    1        0        1        1        1        1        1    ▁▁▇▁▁

### group metrics


New group metrics :  13 and 26 new values inserted in the group and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             13    
Number of columns          9     
_______________________          
Column type frequency:           
  character                2     
  Date                     1     
  numeric                  6     
________________________         
Group variables            None  

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment                0             1   2  38     0       12          0
2 gr_dts_datasource         0             1   7   7     0        1          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean     sd     p0    p25    p50   p75 p100 hist 
1 gr_id                 0             1 6439     3.89 6433   6436   6439   6442  6445 ▇▅▇▅▇
2 gr_year               0             1 2025     0    2025   2025   2025   2025  2025 ▁▁▇▁▁
3 gr_number             0             1  317.  187.    196    227    246    301   897 ▇▂▁▁▁
4 grser_ser_id          0             1  279.   66.1   213    217    302    306   374 ▇▁▅▁▃
5 lengthmm              0             1   95.4  63.2    28.9   41.4   57.9  167.  186 ▇▁▂▁▅
6 weightg               0             1  294.  341.     14     59    164    336  1167 ▇▃▁▁▁

### individual metrics


#### modified individual metrics  

has probably never been integrated 
see [#383](https://github.com/ices-eg/wg_WGEEL/issues/383)
see [#384](https://github.com/ices-eg/wg_WGEEL/issues/384)

16288 and 25151 new values updated in the fish and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             16288 
Number of columns          13    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  7     
________________________         
Group variables            None  

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment            16275      0.000798  23  28     0        2          0
2 fi_dts_datasource         0      1          7   7     0        1          0
3 fi_lfs_code           13847      0.150      1   1     0        2          0
4 fi_id_cou             16288      0         NA  NA     0        0          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 1998-09-01 2024-09-19 2013-09-17      175
2 fi_lastupdate         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate      mean         sd        p0      p25       p50       p75      p100 hist 
1 fi_id                     0        1      719199.   1004950.   299051    303123.  307194.   311266.   3580786   ▇▁▁▁▁
2 fi_year                   0        1        2011.         9.31   1998      2001     2013      2019       2024   ▇▁▂▅▆
3 fiser_ser_id              0        1         219          0       219       219      219       219        219   ▁▁▇▁▁
4 lengthmm                  0        1         194.        93.2      56       129      166       231        852   ▇▃▁▁▁
5 weightg                9073        0.443      42.2       78.4       0.47      9.3     19.9      42       1308.  ▇▁▁▁▁
6 eye_diam_meanmm       15463        0.0507      5.08       1.20      1.75      4.2      4.85      5.75      10.4 ▁▇▅▁▁
7 pectoral_lengthmm     15465        0.0505     17.7        5.34      9.5      14.2     16.2      20.0       43.3 ▇▆▂▁▁
fi_id 3511848,3511849,3511850,3511851,3511852,3511853,3511854,3511855,3511856,3511857...(>10 values) currently not in db from deleted_individual_metrics

#### deleted individual metrics

8796 values deleted from fish table, cascade delete on metrics

#### new individual metrics


 16060 and 31180 new values inserted in the fish and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             16060 
Number of columns          13    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  7     
________________________         
Group variables            None  

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment            16060         0      NA  NA     0        0          0
2 fi_dts_datasource         0         1       7   7     0        1          0
3 fi_lfs_code            6432         0.600   1   1     0        2          0
4 fi_id_cou                 0         1       7  13     0    16060          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 1995-09-13 2025-10-07 2006-09-12      189
2 fi_lastupdate         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate       mean     sd          p0       p25       p50        p75     p100 hist 
1 fi_id                     0         1     4388240.   4636.  4380211     4384226.  4388240.  4392255.   4396270  ▇▇▇▇▇
2 fi_year                   0         1        2011.     12.0    1995        2000      2006      2025       2025  ▆▅▁▁▇
3 fiser_ser_id              0         1         237.     49.1     213         214       214       218        376  ▇▁▁▁▁
4 lengthmm                  0         1         242.    113.       50         157       213       310        817  ▇▇▂▁▁
5 weightg                6211         0.613      55.4    88.8       1          10        24        65       1192  ▇▁▁▁▁
6 eye_diam_meanmm       13243         0.175       4.75   10.2       0.275       3.4       4.3       5.45     538. ▇▁▁▁▁
7 pectoral_lengthmm     13606         0.153      16.7    13.7       1          12.2      15.5      19.2      323  ▇▁▁▁▁

## Annex 3

### series

No change

### dataseries

#### new

 4 new values inserted in the database
 
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

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment                2           0.5  27  83     0        2          0
2 das_dts_datasource         0           1     7   7     0        1          0
3 das_qal_comment            4           0    NA  NA     0        0          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean      sd    p0     p25     p50    p75  p100 hist 
1 das_id                0             1 10288.     1.29 10286 10287.  10288.  10288. 10289 ▇▇▁▇▇
2 das_value             0             1  2016.  2234.      87   201    1664.   3480   4650 ▇▁▁▃▃
3 das_ser_id            0             1   215     13.4    195   214.    221     222.   223 ▂▁▁▁▇
4 das_year              0             1  2025      0     2025  2025    2025    2025   2025 ▁▁▇▁▁
5 das_effort            0             1   147    147.      43    71.5    90     166.   365 ▇▁▁▁▂
6 das_qal_id            0             1     2.5    1.73     1     1       2.5     4      4 ▇▁▁▁▇


#### modified

2 values updated in the db

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

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min max empty n_unique whitespace
1 das_comment                0             1  12  65     0        2          0
2 das_dts_datasource         0             1   7  10     0        2          0
3 das_qal_comment            2             0  NA  NA     0        0          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable   n_missing complete_rate min        max        median     n_unique
1 das_last_update         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean       sd   p0   p25   p50   p75 p100 hist 
1 das_id                0             1 9004   593.    8585 8794. 9004  9214. 9423 ▇▁▁▁▇
2 das_value             0             1 3720. 4823.     309 2014. 3720. 5425. 7130 ▇▁▁▁▇
3 das_ser_id            0             1  209    19.8    195  202   209   216   223 ▇▁▁▁▇
4 das_year              0             1 2024.    0.707 2023 2023. 2024. 2024. 2024 ▇▁▁▁▇
5 das_effort            0             1  223   201.      81  152   223   294   365 ▇▁▁▁▇
6 das_qal_id            0             1    1     0        1    1     1     1     1 ▁▁▇▁▁

### group metrics

 2 and 11 new values inserted in the group and metric tables
 
 

### individual metrics

#### new

57994 and 149995 new values inserted in the fish and metric tables

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             57994 
Number of columns          13    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  7     
________________________         
Group variables            None  

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment            57994             0  NA  NA     0        0          0
2 fi_dts_datasource         0             1   7   7     0        1          0
3 fi_lfs_code               0             1   1   1     0        1          0
4 fi_id_cou                 0             1  11  14     0    57994          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 1993-03-10 2026-05-16 2017-12-11     2134
2 fi_lastupdate         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate       mean       sd         p0        p25        p50        p75      p100 hist 
1 fi_id                     0         1     4441328.   16742.   4412331    4426829.   4441328.   4455826.   4470324   ▇▇▇▇▇
2 fi_year                   0         1        2016.       5.23    1992       2014       2017       2020       2025   ▁▁▁▇▅
3 fiser_ser_id              0         1         223.       1.98     195        223        223        223        223   ▁▁▁▁▇
4 lengthmm                  0         1         454.     122.       226        372        408        495       1285   ▇▅▁▁▁
5 weightg                2416         0.958     197.     236.        15         88        114        197       3412   ▇▁▁▁▁
6 eye_diam_meanmm       39188         0.324       7.04     1.21       2.98       6.33       6.93       7.54      44.3 ▇▁▁▁▁
7 pectoral_lengthmm     40377         0.304      24.5      5.51       7.52      21.0       23.3       26.8       60.9 ▁▇▁▁▁

#### modified

 33493 and 80842 new values updated in the fish and metric tables
 
[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             33493 
Number of columns          13    
_______________________          
Column type frequency:           
  character                4     
  Date                     2     
  numeric                  7     
________________________         
Group variables            None  

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 fi_comment            33489      0.000119  26  37     0        3          0
2 fi_dts_datasource         0      1          7   7     0        1          0
3 fi_lfs_code               0      1          1   1     0        1          0
4 fi_id_cou             33493      0         NA  NA     0        0          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 fi_date               0             1 1996-09-25 2025-02-24 2016-01-09     1303
2 fi_lastupdate         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate       mean        sd         p0        p25       p50        p75      p100 hist 
1 fi_id                     0         1     2862931.   125090.   2821170    2839155    2848056   2856430    3936495   ▇▁▁▁▁
2 fi_year                   0         1        2014.        7.47    1996       2013       2015      2020       2024   ▂▁▁▇▅
3 fiser_ser_id              0         1         213.       12.9      195        195        222       222        223   ▅▁▁▁▇
4 weightg                1592         0.952     335.      247.        12        116        318       458       3590   ▇▁▁▁▁
5 eye_diam_meanmm       24929         0.256       7.50      1.38       0.6        6.55       7.3       8.25      32.2 ▅▇▁▁▁
6 pectoral_lengthmm     26597         0.206      26.1       7.45       3.18      20.2       24.2      30.7       78.3 ▁▇▂▁▁
7 lengthmm12         1.000     535.      131.       257        399        559       630       1166   ▆▇▅▁▁

#### deleted

 58919 values deleted from fish table, cascade delete on metrics

## Annex 4

### new

 120 new values inserted in the database

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             120   
Number of columns          16    
_______________________          
Column type frequency:           
  character                10    
  Date                     1     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0         1       7   7     0       10          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       1   1     0        3          0
 4 eel_hty_code              0         1       1   2     0        4          0
 5 eel_area_division       120         0      NA  NA     0        0          0
 6 eel_qal_comment         120         0      NA  NA     0        0          0
 7 eel_comment              53         0.558  16  34     0        4          0
 8 eel_missvaluequal        21         0.825   2   2     0        2          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean        sd     p0     p25     p50     p75    p100 hist 
1 eel_id                0         1     612296.    34.8   612237 612267. 612296. 612326. 612356  ▇▇▇▇▇
2 eel_typ_id            0         1          4      0          4      4       4       4       4  ▁▁▇▁▁
3 eel_year              0         1       2024.     0.635   2022   2024    2024    2025    2026  ▁▁▇▆▁
4 eel_value            99         0.175  19473. 45283.         0    642.   3615   13142. 192336. ▇▁▁▁▁
5 eel_qal_id            0         1          1      0          1      1       1       1       1  ▁▁▇▁▁
Show 
10
 entriesSearch:
eel_id	eel_typ_id	eel_year	eel_value	eel_emu_nameshort	eel_cou_code	eel_lfs_code	eel_hty_code	eel_area_division	eel_qal_id	eel_qal_comment	eel_comment	eel_datelastupdate	eel_missvaluequal	eel_datasource	eel_dta_code
612237	4	2025	0	FR_Bret	FR	Y	F		1			2026-09-07		dc_2026	Public
612238	4	2025	0	FR_Rhon	FR	S	F		1			2026-09-07		dc_2026	Public
612239	4	2025	7.45	FR_Adou	FR	Y	F		1			2026-09-07		dc_2026	Public
612240	4	2025	42.6	FR_Bret	FR	Y	T		1			2026-09-07		dc_2026	Public
612241	4	2025	313	FR_Rhin	FR	Y	F		1			2026-09-07		dc_2026	Public
612242	4	2026	642.13	FR_Arto	FR	G	T		1			2026-09-07		dc_2026	Public
612243	4	2026	706.5	FR_Sein	FR	G	T		1			2026-09-07		dc_2026	Public
612244	4	2025	1117	FR_Cors	FR	Y	T		1			2026-09-07		dc_2026	Public
612245	4	2026	2776.939	FR_Adou	FR	G	T		1			2026-09-07		dc_2026	Public
612246	4	2025	2885.8	FR_Garo	FR

#### Modified landings

For duplicates 57 values replaced in the t_eelstock_ eel table (values from current datacall stored with code eel_qal_id 26)
,	0 values not replaced (values from current datacall stored with code eel_qal_id 26),


#### deleted landings

removed columns at the table end to pass format test : OK
57 values deleted in the db


#### updated

no updated data


## Annex 5

#### new

 120 new values inserted in the database

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             120   
Number of columns          16    
_______________________          
Column type frequency:           
  character                10    
  Date                     1     
  numeric                  5     
________________________         
Group variables            None  

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable     n_missing complete_rate min max empty n_unique whitespace
 1 eel_emu_nameshort         0         1       7   7     0       10          0
 2 eel_cou_code              0         1       2   2     0        1          0
 3 eel_lfs_code              0         1       1   1     0        3          0
 4 eel_hty_code              0         1       1   2     0        4          0
 5 eel_area_division       120         0      NA  NA     0        0          0
 6 eel_qal_comment         120         0      NA  NA     0        0          0
 7 eel_comment              46         0.617  22  34     0        2          0
 8 eel_missvaluequal         6         0.95    2   2     0        1          0
 9 eel_datasource            0         1       7   7     0        1          0
10 eel_dta_code              0         1       6   6     0        1          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean      sd     p0       p25     p50     p75    p100 hist 
1 eel_id                0        1      612650.  34.8   612591 612621.   612650. 612680. 612710  ▇▇▇▇▇
2 eel_typ_id            0        1           6    0          6      6         6       6       6  ▁▁▇▁▁
3 eel_year              0        1        2024.   0.488   2024   2024      2024    2025    2025  ▇▁▁▁▅
4 eel_value           114        0.0500    334. 456.         0      2.17    177.    452.   1162. ▇▂▂▁▂
5 eel_qal_id            0        1           1    0          1      1         1       1       1  ▁▁▇▁▁

#### modified

nothing

#### deleted

nothing

## Annex 6

No Annex, no other landings.

## Annex 7

release 
new_data 
column <eel_missvaluequal>, lines <14>, there should be a code, as the eel_values are both missing 
Country <FR>,  dataset <new_data>, column <eel_area_division>, line <14>,  should be empty 
updated_data 
deleted_data 

There is a missing value in numbers in 2025 sent a message to check, trend in average weight not constant over time 
(from 0.13 to 0.225 kg per individual)
Added N = 49144  after exchanges with Guirec

28 new values inserted in the database

[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             28    
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
 1 eel_emu_nameshort         0        1        7   7     0       10          0
 2 eel_cou_code              0        1        2   2     0        1          0
 3 eel_lfs_code              0        1        1   1     0        2          0
 4 eel_hty_code              0        1        1   1     0        2          0
 5 eel_area_division        26        0.0714   6   6     0        1          0
 6 eel_qal_comment          28        0       NA  NA     0        0          0
 7 eel_comment              28        0       NA  NA     0        0          0
 8 eel_missvaluequal        28        0       NA  NA     0        0          0
 9 eel_datasource            0        1        7   7     0        1          0
10 eel_dta_code              0        1        6   6     0        1          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable      n_missing complete_rate min        max        median     n_unique
1 eel_datelastupdate         0             1 2026-09-08 2026-09-08 2026-09-08        1

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate     mean          sd     p0     p25      p50     p75    p100 hist 
1 eel_id                0             1 612888.        8.23  612875 612882. 612888.  612895.  612902 ▇▇▇▇▇
2 eel_typ_id            0             1      8.5       0.509      8      8       8.5      9        9 ▇▁▁▁▇
3 eel_year              0             1   2026.        0.923   2023   2025    2026     2026     2026 ▁▁▁▂▇
4 eel_value             0             1 289164.  1025426.         0      0       0      435. 5005154 ▇▁▁▁▁
5 eel_qal_id            0             1      1         0          1      1       1        1        1 ▁▁▇▁▁

## Annex 8

 1 new values inserted in the database
 NR ...

## Annex 9

### samplinginfo

```
loading sampling info 
dataset <sampling_info>, column <sai_hty_code>, missing values line 1 
 dataset <sampling_info>, column <sai_hty_code>, missing values line 2 
 dataset <sampling_info>, column <sai_hty_code>, missing values line 3 
dataset <sampling_info>, column <sai_hty_code>, missing values line 1 
 dataset <sampling_info>, column <sai_hty_code>, missing values line 2 
 dataset <sampling_info>, column <sai_hty_code>, missing values line 3 
dataset <sampling_info>, column <sai_samplingobjective>, missing values line 1 
 dataset <sampling_info>, column <sai_samplingobjective>, missing values line 2 
 dataset <sampling_info>, column <sai_samplingobjective>, missing values line 3 
dataset <sampling_info>, column <sai_samplingstrategy>, missing values line 1 
 dataset <sampling_info>, column <sai_samplingstrategy>, missing values line 2 
 dataset <sampling_info>, column <sai_samplingstrategy>, missing values line 3 
dataset <sampling_info>, column <sai_protocol>, missing values line 1 
 dataset <sampling_info>, column <sai_protocol>, missing values line 2 
 dataset <sampling_info>, column <sai_protocol>, missing values line 3 
 ```
 I have udated the habiat , T for Certes and F for Loire and Nive, we'll get rid of the other columns in the new DB anyways.
 
#### modified sampling
 
 3 lines updated....
 
### group metrics

#### new

11 and 56 new values inserted in the group and metric tables


[1] "this is what will be in the db"
── Data Summary ────────────────────────
                           Values
Name                       datadb
Number of rows             11    
Number of columns          22    
_______________________          
Column type frequency:           
  character                3     
  Date                     1     
  numeric                  18    
________________________         
Group variables            None  

── Variable type: character ───────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 gr_comment               11             0  NA  NA     0        0          0
2 gr_dts_datasource         0             1   7   7     0        1          0
3 grsa_lfs_code             0             1   1   2     0        4          0

── Variable type: Date ────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 gr_lastupdate         0             1 2026-09-07 2026-09-07 2026-09-07        1

── Variable type: numeric ─────────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable                                         n_missing complete_rate     mean      sd       p0      p25      p50
 1 gr_id                                                         0         1     6481       3.32  6476     6478.    6481    
 2 gr_year                                                       0         1     2026.      0.522 2025     2025     2026    
 3 gr_number                                                     0         1      341.    386.      50      150      229    
 4 grsa_sai_id                                                   0         1      310.      3.82   305      306.     309    
 5 lengthmm                                                      2         0.818  195.    188.      70.7     72       72.2  
 6 weightg                                                       0         1       94.2   118.       0.3      0.33     0.37 
 7 ageyear                                                       8         0.273    6.27    1.46     4.7      5.6      6.5  
 8 differentiated_proportion                                     8         0.273    0.831   0.286    0.5      0.746    0.992
 9 m_mean_lengthmm                                               8         0.273  359.     12.4    350      352.     354.   
10 m_mean_weightg                                                8         0.273   75.3     7.76    67.6     71.4     75.1  
11 m_mean_ageyear                                                8         0.273    5.1     1.55     3.6      4.3      5    
12 f_mean_lengthmm                                               8         0.273  540.     91.5    451.     494.     537.   
13 f_mean_weightg                                                8         0.273  301.    145.     163.     226.     288.   
14 f_mean_age                                                    8         0.273    7.6     1.37     6.4      6.85     7.3  
15 method_sex_(1=visual,0=use_length)                            8         0.273    1       0        1        1        1    
16 method_anguillicola_(1=stereomicroscope,0=visual_obs)         8         0.273    0       0        0        0        0    
17 female_proportion                                             8         0.273    0.516   0.242    0.373    0.376    0.38 
18 anguillicola_proportion                                       8         0.273    0.443   0.143    0.284    0.385    0.486
        p75     p100 hist 
 1 6484.    6486     ▇▅▅▅▅
 2 2026     2026     ▇▁▁▁▇
 3  326.    1410     ▇▁▁▁▁
 4  312.     316     ▇▃▂▃▃
 5  351.     497.    ▇▁▁▁▂
 6  224.     270.    ▇▁▁▁▅
 7    7.05     7.6   ▇▁▁▇▇
 8    0.996    1     ▃▁▁▁▇
 9  364.     373.    ▇▁▁▁▃
10   79.1     83.2   ▇▁▇▁▇
11    5.85     6.7   ▇▁▇▁▇
12  585.     634.    ▇▁▇▁▇
13  370.     452.    ▇▁▇▁▇
14    8.2      9.1   ▇▇▁▁▇
15    1        1     ▁▁▇▁▁
16    0        0     ▁▁▇▁▁
17    0.588    0.796 ▇▁▁▁▃
18    0.523    0.56  ▇▁▁▇▇



### individual metrics

9635

=> 3750 and 9635 new values inserted in the fish and metric tables

