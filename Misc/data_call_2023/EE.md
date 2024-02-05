-----------------------------------------------------------
# EE 
-----------------------------------------------------------

## Annex 1
* Error: list_comp_series  - could not integrate

### series

### dataseries


### group metrics


### individual metrics

## Annex 2

### series

### dataseries


### group metrics


### individual metrics



## Annex 3

### series

### dataseries


### group metrics


### individual metrics



## Annex 4
* new rows: 2 new rows integrated
* updated rows: 1 values updated in the db

## Annex 5
* duplicated rows: For duplicates 156 values replaced in the t_eelstock_ eel table (values from current datacall stored with code eel_qal_id 23), 0 values not replaced (values from current datacall stored with code eel_qal_id 0),
* new rows: In "new data" there were 600 rows, existing in the db were 540 rows. Only 156 were identified as duplicates but when trying to integrate new ones it gives an error that says key values already exist (I assume they are not detected as duplicates but are indeed, whereas the 156 actually were duplicates in key values but with a change). We updated the 156 duplicates and did not integrate new rows (since 2023 data was not available).


## Annex 6



## Annex 7
* new rows: 4 new values added (the shiny has an issue though since for the rows with kg there is no entry for n and it doesn't like it (wants a missvsalue). When the file for integration is created it therefore also generates a duplicate row with no entry - e.g. one with the actual value from the row with typ_id kg, and then one wioth no value for kg from the row that way for n).


## Annex 8



## Annex 10
* could not integrate: Shiny says sai_name is wrong but we cannot integrate as new series (says already exists). If we want to enter the data though, it says series does not exist... 

### samplinginfo


### group metrics


### individual metrics

