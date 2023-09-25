-----------------------------------------------------------
# PT
-----------------------------------------------------------

## General Notes
* New dc files provided since original submission was erroneous

## Annex 1

### series
* modified series: 1 series was updated and integration was done (MiScG); NOTE: It existed before and nothing was actually changed except for data_source, does this cause issues (is the series in the db twice now?) 

### dataseries
* new dataseries:  7 new values inserted in the database
* modified dataseries: 46 values updated in the db (qual_id was added)
### group metrics
* new group metrics:  2 and 5 new values inserted in the group and metric tables
* modified group metrics:   3 and 6 new values modified in the group and metric tables

### individual metrics
* new individual metrics: 821 and 1642 new values inserted in the fish and metric tables
  
## Annex 2

### series

### dataseries
* new dataseries: 6 new values inserted in the database
* modified dataseries: 1 values updated in the db (for gr_id 1684 & 1707 the gr_number was in comments in the db, this was corrected manually in the db; in addition to the 1 updated value)
  
### group metrics
* new group metrics: 2 and 4 new values inserted in the group and metric tables
* modified group metrics: 1 and 2 new values modified in the group and metric tables

### individual metrics
* new individual metrics: 111 and 710 new values inserted in the fish and metric tables

## Annex 3

* manually edited gr_number for gr_IDs 168, 1114 (gr_numbers are 9 and 17 respectively)
* In "updated group" there were gr_id 169 (MonS 2018) and 1068 (MonS 2020) WITH biometric values that caused an issue for integration (the gr_number was changed, but even after manually editing this in the db, it could not find them. Issue is seemingly an inner join that could not be done since the rows in the db had no biometric values). These gr_ids were deleted from the db. In "new data group", there were rows for both MonS 2018 & MonS 2020 but WITHOUT biometric values. These rows were therefore replaced with the ones from "updated", essentially re-integrating the previously deleted rows with a new gr_id (old one in comment), updated gr_number and the biometric data.

### series
* modified series: 1 values updated in the db
  
### dataseries
* new dataseries: 6 new values inserted in the database 
* modified dataseries: 6 values updated in the db

### group metrics
* new group metrics: 4 and 26 new values inserted in the group and metric tables
* modified group metrics: 3 and 25 new values modified in the group and metric tables

### individual metrics
* new individual metrics: 17 and 122 new values inserted in the fish and metric tables


## Annex 4
*  new rows: 2 new values inserted in the database


## Annex 5
* new rows: 24 new values inserted in the database


## Annex 6



## Annex 7
* nothing integrated, no new or updated data


## Annex 8
* new rows: 1 new values inserted in the database


## Annex 10
* nothing integrated, no new or updated data

### samplinginfo


### group metrics


### individual metrics

