-----------------------------------------------------------
# FR
-----------------------------------------------------------
## Annex 1

### series

1 new
4 values updated in the db

### dataseries

18 new values inserted in the database
296 values updated in the db

### group metrics

0

### individuals metrics

 234355 and 486270 new values inserted in the group and metric tables

## Annex 2

### series

0 new, 0 modified

### dataseries

17 new ; 140 values updated in the db

### group metrics

0

### individual metrics

 78542 and 141559 new values inserted in the group and metric tables

## Annex 3

### series

0 new, 0 modified

### dataseries

 7 new values inserted in the database
 
 fail to update --> Error: Failed to fetch row: ERROR:  duplicate key value violates unique constraint "c_uk_year_ser_id"
DETAIL:  Key (das_year, das_ser_id)=(1982, 220) already exists.
https://github.com/ices-eg/wg_WGEEL/issues/255
 
 ### group metrics
 
 9 and 9 new values inserted in the group and metric tables
 
 ### individual metrics
 
 53188 and 194914 new values inserted in the fish and metric tables

## Annex 4

 121 new values inserted in the database
28 values updated in the db

## Annex 5

 115 new values inserted in the database
9 values updated in the db

## Annex 6

No data

## Annex 7

error 'there is an error' https://github.com/ices-eg/wg_WGEEL/issues/256

## Annex 8

No data

## Annex 10
 
13 series
 
group: 
Error: Failed to fetch row: ERROR:  duplicate key value violates unique constraint "c_ck_uk_grsa_gr"
DETAIL:  Key (grsa_sai_id, gr_year)=(306, 2014) already exists. ==> problem is we have two different life stage for the same year & sampling
https://github.com/ices-eg/wg_WGEEL/issues/253

individual
https://github.com/ices-eg/wg_WGEEL/issues/254