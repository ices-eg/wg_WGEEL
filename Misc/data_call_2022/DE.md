-----------------------------------------------------------
# DE
-----------------------------------------------------------
## Annex 1 (DONE)
### to do
* DONE: NOT THIS YEAR, WILL HAVE TO CLARIFY AFTER WGEEL. need to provide ser_restocking etc. in series info

### done
* modified 2 series (ser_methods)
* integrated 11 values in dataseries (removed empty rows in templates)

## Annex 2 (DONE)

### done
* integrated 1 new value (new dataseries) - REINTEGRATED succesfully after data loss

## Annex 3 (DONE)
### done
* integrated 1 new value (new dataseries) - REINTEGRATED succesfully after data loss 

## Annex 4 (DONE)
### to do
* not integrated (no data) but there is an update to metadata since one of the data providers has changed. Not sure how to do approach this...


## Annex 5 (DONE)
### to do
* not integrated (no data) but there is an update to metadata since one of the data providers has changed. Not sure how to do approach this...

## Annex 6 (DONE)
* not provided by DE / empty sheet. Nothing to report from Germany, so this should be fine.

## Annex 7 (DONE)
### to do
* not integrated (no data) but there is an update to metadata since one of the data providers has changed. Not sure how to do approach this...

## Annex 8 (DONE)
### to do
* DONE: INTEGRATED. not integrated due to a bug being stuck in the loading screen (added to issues); but needs to be integrated, DE provided an update to data!


## Annex 10 (DONE)
### notes
* DONE In the database there was a wron name for a series in sai_info (DE_Elbe_Eider should have been DE_Eide_Eider). This was changed in the database and also for the related group metrics the series was changed to DE_Eide_Eider. Accordingly, the spreadsheet, as provided by DE, was edited (i.e. the existing series info was changed accordingly and the existing group metrics was changed accordingly).

### to do
* pre-filled series ending with "HIST" and related group metrics should be deleted. It's not clear to the data provider how these are generated and if they are reliable.
* DONE - integrate individual metrics, there was a bug...

### done
* 5738 and 46090 new values inserted (new individual metrics)
* group metrics: 137 and 1509 new values inserted in the group and metric tables
* deleted groups metrics: done using an sql query (see database_edition_2022.sql): 34 groups metrics with qal_id 22 and 10 gr_comment updated for gr_id in (2323,2334,2167,2222,2189,2200,2211,2178,2233,2244);
