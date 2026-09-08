-----------------------------------------------------------
# GB
-----------------------------------------------------------

## Annex 1

### series

### dataseries
- remove missing values
- 22 new values inserted in the database
- 13 values updated in the db


### group metrics
- 5 and 13 new values inserted in the group and metric tables


### individual metrics
- some fishes were duplicates (detected through same fi_id_cou => ignored)
- 1039 and 1989 new values inserted in the fish and metric tables

## Annex 2

### series

### dataseries
- 46 new values inserted in the database
-5 values updated in the db


### group metrics
- removed rows with no fish 
- 37 and 71 new values inserted in the group and metric tables
- 4 and 8 new values modified in the group and metric tables


### individual metrics
- the column name fi_id_cou was removed
- SusY was fixed to SuSY
- 3777 and 6886 new values inserted in the fish and metric tables


## Annex 3

### series

### dataseries
- remove rows with empty values
- issue with an empty values in updated_data, asked to data provider => remove the row
- 5 new values inserted in the database


### group metrics
- remove NP and ND
- 1 and 10 new values inserted in the group and metric tables


### individual metrics
- remove NP and ND
- 189 and 394 new values inserted in the fish and metric tables


## Annex 4
- remove sea code in F
- put qal_id to 1
- some duplicates (exact same values) were silently removed
- 126 new values inserted in the database



## Annex 5
- remove some data reported twice
- 184 new values inserted in the database


## Annex 6
- remove sea_area
- 1 new values inserted in the database



## Annex 7
- weird updated value with no eel_id and seem to update a record where there was
an NP with a comment. Ask data provider.

## Annex 8


## Annex 9

### samplinginfo


### group metrics
- fix GB_Neag_Yellow to GB_Neag_Neagh_Yellow_HIST
- removed NP and ND in metrics
- move the record from GB_Neag_Neagh_Yellow_HIST to updated_data
- 2 and 22 new values inserted in the group and metric tables
- 1 and 10 new values modified in the group and metric tables


### individual metrics
- fix GB_Neag_Yellow to GB_Neag_Neagh_Yellow_HIST
- removed NP and ND in metrics
- 156 and 1248 new values inserted in the fish and metric tables
