-----------------------------------------------------------
# AL
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10


-----------------------------------------------------------
# BE
-----------------------------------------------------------

## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

-----------------------------------------------------------
# CZ
-----------------------------------------------------------

## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10


-----------------------------------------------------------
# DE
-----------------------------------------------------------
## Annex 1
### to do
* need to provide ser_restocking etc. in series info

### done
* modified 2 series (ser_methods)
* integrated 11 values in dataseries (removed empty rows in templates)

## Annex 2

### done
* integrated 1 new value (new dataseries)

## Annex 3
### done
* integrated 1 new value (new dataseries)

## Annex 4
### to do
* not integrated (no data) but there is an update to metadata since one of the data providers has changed. Not sure how to do approach this...


## Annex 5
### to do
* not integrated (no data) but there is an update to metadata since one of the data providers has changed. Not sure how to do approach this...

## Annex 6
* not provided by DE / empty sheet. Nothing to report from Germany, so this should be fine.

## Annex 7
### to do
* not integrated (no data) but there is an update to metadata since one of the data providers has changed. Not sure how to do approach this...

## Annex 8
### to do
* not integrated due to a bug being stuck in the loading screen (added to issues); but needs to be integrated, DE provided an update to data!


## Annex 10
### notes
* In the database there was a wron name for a series in sai_info (DE_Elbe_Eider should have been DE_Eide_Eider). This was changed in the database and also for the related group metrics the series was changed to DE_Eide_Eider. Accordingly, the spreadsheet, as provided by DE, was edited (i.e. the existing series info was changed accordingly and the existing group metrics was changed accordingly).

### to do
* pre-filled series ending with "HIST" and related group metrics should be deleted. It's not clear to the data provider how these are generated and if they are reliable.
* integrate individual metrics, there was a bug...

### done
* group metrics: 137 and 1509 new values inserted in the group and metric tables
* deleted groups metrics: done using an sql query (see database_edition_2022.sql): 34 groups metrics with qal_id 22 and 10 gr_comment updated for gr_id in (2323,2334,2167,2222,2189,2200,2211,2178,2233,2244);
-----------------------------------------------------------
# DK
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

-----------------------------------------------------------
# DZ
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

-----------------------------------------------------------
# EE
-----------------------------------------------------------

## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10




-----------------------------------------------------------
# EG
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

-----------------------------------------------------------
# ES
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

-----------------------------------------------------------
# FI
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

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

to be checked by LB (issue with season)

## Annex 4

 121 new values inserted in the database
28 values updated in the db

## Annex 5

 115 new values inserted in the database
9 values updated in the db

## Annex 6

No data

## Annex 7

error 'there is an error'

## Annex 8

No data

## Annex 10

on error

-----------------------------------------------------------
# GR
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

-----------------------------------------------------------
# HR
-----------------------------------------------------------

Croatia do we have anything ? 

# GB
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4
305 new values inserted in the database

103 values updated in the db

## Annex 5
168 new values inserted in the database

108 values updated in the db

## Annex 6
5 new values inserted in the database

1 values updated in the db


## Annex 7
72 new values inserted in the database

## Annex 8
Not relevant to GB.


## Annex 10
* 3 new rows added under sampling info

* 23 and 283 new values inserted in the group and metric tables
* deleted groups metrics: done using an sql query (see database_edition_2022.sql): 34 groups metrics with qal_id 22 and 24 gr_comment updated for gr_id in (2176,2177,2179,2180,2181,2182,2183,2169,2170,2171,2172,2173,2174,2175,2184,2185,2186,2187,2188,2190,2191,2192,2193,2194);

Issue with integrating individual data

-----------------------------------------------------------
# IE
-----------------------------------------------------------

## Annex 1


## Annex 2

## Annex 3


## Annex 4
72 new rows added

## Annex 5
72 new rows added
540 rows updated

## Annex 6
14 new rows added
3 rows updated

## Annex 7
14 new rows
2 updated rows
## Annex 8



## Annex 10
* 2 new rows added sampling info
* 6 and 31 new group metrics
* deleted groups metrics: done using an sql query (see database_edition_2022.sql): 72 groups metrics with qal_id 22 and 27 gr_comment updated for gr_id in (2195,2196,2197,2198,2199,2201,2202,2203,2204,2205,2206,2207,2208,2209,2210,2212,2213,2214,2215,2216,2217,2218,2219,2220,2221,2260,2261);



-----------------------------------------------------------
# IT
-----------------------------------------------------------

## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10



-----------------------------------------------------------
# LT (Lithuania)
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

-----------------------------------------------------------
# LV (Latvia)
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

-----------------------------------------------------------
# MA
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10


-----------------------------------------------------------
# NL 
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

-----------------------------------------------------------
# NO (Norway) 
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

----------------------------------------------------------- 
# PL 
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

----------------------------------------------------------- 
# PT
-----------------------------------------------------------
 ## Annex 1
### done
* 1 updated series (modified series)
* 3 new values inserted in the database (new dataseries)
* updated two values (new dataseries)
* 5826 and 11652 new values inserted in the fish and metric tables (new individual metrics)

### to do
* integrate new grouped metrics (there was an error that is to be fixed)


## Annex 2
* 

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10

-----------------------------------------------------------
# SE
-----------------------------------------------------------
## Annex 1


## Annex 2
New dataseries: 2 new values inserted in the database (new years)

Modified dataseries: 75 values updated in the db (effort data added and corrected CPUE data)

New group metrics: 83 and 83 new values inserted in the group and metric tables.

New individual metrics: 1253 and 7416 new values inserted in the group and metric tables

## Annex 3


## Annex 4
Integrate new rows: Uploaded 36 new rows

## Annex 5


## Annex 6


## Annex 7

## Annex 8
New rows: 1 new values inserted in the database


## Annex 10

----------------------------------------------------------- 
# Sl
----------------------------------------------------------- 
 
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8



## Annex 10


----------------------------------------------------------- 
# TN
-----------------------------------------------------------
## Annex 1


## Annex 2

## Annex 3


## Annex 4



## Annex 5


## Annex 6


## Annex 7

## Annex 8

## Annex 10

-----------------------------------------------------------
# TR
-----------------------------------------------------------
 
## Annex 1
No data
## Annex 2
No data
## Annex 3
No data
## Annex 4
Two new data integrated for commercial landings
One new data integrated for recreational landings
## Annex 5
No data
## Annex 6
No data
## Annex 7
No data
## Annex 8
No data
## Annex 10
No data
 

