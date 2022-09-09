----------------------------------------------------------- 
# PT
-----------------------------------------------------------
 ## Annex 1
### done
* 1 updated series (modified series) - RE-INTEGRATED after data loss
* 3 new values inserted in the database (new dataseries) - RE-INTEGRATED after data loss
* 2 updated values (new dataseries) - RE-INTEGRATED after data loss
* 5826 and 11652 new values inserted in the fish and metric tables (new individual metrics) - nothing shows in integration tool during re-integration; already inegrated? YES
* 2 and 6 values inserted (new group metrics) - (was already integrated when trying to re-integrate... Maybe I did that and forgot)

### to do
* DONE/REDUNDANT (no update required in the first place - it was a falty detection of new as update): update group meterics (caused an error: Error: Failed to prepare query: ERROR:  column "gr_number" is of type integer but expression is of type boolean
LINE 2: (SELECT g.gr_year,g.gr_number,g.gr_comment,g.gr_dts_datasour...
                        HINT:  You will need to rewrite or cast the expression.
* DONE/REDUNDANT (see above): update group metrics: during RE-INTEGRATION the error message changed to: could not find function "update_group_metrics"

* DONE: CHECK if new group metrics / new individual metrics are integrated YES

 ## Annex 2
 ### to do
 * integrate, we had an issue

## Annex 3
### done
* 2 values updated (modified series)
* 2 values deleted (from dataseries)
* 2 values integrated (new dataseries)
* 2 and 10 new values integrated (group metrics)
* 147 and 902 new values integrated (individual metrics)

### RE-INTEGRATION
* 2 values integrated (new dataseries)
* individual values dont show (already in database, checked for glass eel but assuming it holds here too?)

### to do
* DONE/REDUNDANT (since the delete were the previously updated lines): Integrate delete group metrics. Couldn't delete, there was an error (Failed to prepare query: ERROR:  invalid input syntax for type integer: ""
LINE 1: ...ELECT ser_cou_code FROM datawg.t_series_ser WHERE ser_id='';)
* Integrate update group metrics. There was a bug (could not find function "update_group_metrics") - gr_number is updated, hence it couldn't find a matching row (comparison with db based on gr_id and gr_number at this point).

## Annex 4
### notes
info lost when converting/saving readme, DOUBLE CHECK IF EVERYTHING IS INTEGRATED

## Annex 5
### done
* 24 new values integrated (new data)

## Annex 6
### notes
info lost when converting/saving readme, DOUBLE CHECK IF EVERYTHING IS INTEGRATED - I think there was no data

## Annex 7
### to do
* DONE: turns out there was no data - nothing integrated, an error occured when uploading file: error with col_number. fix table (eel_value_number etc.)

## Annex 8
### done
* 1 new value integrated (new data)
* 10 values updated (updated values)

## Annex 10
no data



