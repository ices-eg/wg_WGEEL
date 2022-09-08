


























-----------------------------------------------------------
# GR
-----------------------------------------------------------
## Annex 1
--
## Annex 2
1 update modified series (Step 2.1.2) and 11 new dataseries (Step 2.2.2)
## Annex 3
31 new values in new data series
3 values in uptaded modified series
1 and 10 values integrate new group metrics
## Annex 4

32 new values was added.

Error: Failed to prepare query: ERROR:  column "eel_value" does not exist
LINE 17:       eel_value,
               ^
HINT:  There is a column named "eel_value" in table "t_eelstock_eel", but it cannot be referenced from this part of the query.

## Annex 5
--

## Annex 6
--

## Annex 7
8 new values was added
## Annex 8
1new value was added

## Annex 10
--
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
No new data

## Annex 2
No new data

## Annex 3
No new data

## Annex 4
### done
* new data inserted 28 rows
### TODO
* duplicates error, needs to be reprogrammed

## Annex 5
### done
* new data inserted 2 rows
* * some of the new rows are recognized as duplicates (probably NR yet)
### TODO
* duplicates error, needs to be reprogrammed
## Annex 6
No data
## Annex 7
### TODO
2 rows
## Annex 8
### Done
2 rows
## Annex 10
### TODO
Shiny delete the old data


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
It is done

## Annex 2
It is done
## Annex 3

It is done
## Annex 4

It is done

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
* 2 and 6 values inserted (new group metrics)


## Annex 2

### done
* 2 values integrated (new dataseries)
* 2 and 4 new values integrated (new group metrics)
* 437 and 2413 values integrated (new individual metrics)

### to do
* integrate modified group metrics (update group metrics): Error: Anenex 2could not find function "update_group_metrics"
* integrate deleted group metrics. It caused an error: Anex 2 -Failed to prepare query: ERROR:  invalid input syntax for type integer: ""
LINE 1: ...ELECT ser_cou_code FROM datawg.t_series_ser WHERE ser_id='';


## Annex 3
### notes
pressed proceed for "delete dataseries" but no file was browsed, still said 2 values deleted...

### done
* 2 values updated (modified series)
* 2 new values (new dataseries)
* 2 and 10 new values (new group metrics) - pressed proceed twice, second caused error
* 147 and 902 new values integrated (new individual metrics)

### to do
* integrate "delete group metrics": delete group metrics caused an error when proceeding: Failed to prepare query: ERROR:  invalid input syntax for type integer: ""
LINE 1: ...ELECT ser_cou_code FROM datawg.t_series_ser WHERE ser_id='';

* integrate modified group metrics: integration caused an errror: Failed to prepare query: ERROR:  invalid input syntax for type integer: ""
LINE 1: ...ELECT ser_cou_code FROM datawg.t_series_ser WHERE ser_id='';

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
Modified series: 1 value updated in the db

New dataseries: 9 values inserted in the db

Modified dataseries: 620 values updated in the db (added a quality id)

New group metrics: 4 and 4 new values inserted in the group and metric tables

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
New rows: 4 new values inserted in the database

## Annex 7
New rows: 8 new values in the database

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
 

