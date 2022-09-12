-----------------------------------------------------------
# LT (Lithuania)
-----------------------------------------------------------
## Annex 1
* no data

## Annex 2
### Notes
Message when "check file" (did not occur when re-integrating)
* [SPS-WARNING] 2022-09-08 10:25:07 Coercing boolean to numeric in T2 / R2C20
* [SPS-WARNING] 2022-09-08 10:25:07 Coercing boolean to numeric in T3 / R3C20
* [SPS-WARNING] 2022-09-08 10:25:07 Coercing boolean to numeric in T4 / R4C20
* [SPS-WARNING] 2022-09-08 10:25:07 Coercing boolean to numeric in T5 / R5C20
* [SPS-WARNING] 2022-09-08 10:25:07 Coercing boolean to numeric in T6 / R6C20
* [SPS-WARNING] 2022-09-08 10:25:07 Coercing boolean to numeric in T7 / R7C20
* [SPS-WARNING] 2022-09-08 10:25:07 Coercing boolean to numeric in T8 / R8C20
* [SPS-WARNING] 2022-09-08 10:25:07 Coercing boolean to numeric in T9 / R9C20

### to do
* not integrated, file needs work

### RE-INTEGRATION:
* was never integrated before
* changed DriY to sam_typ_id = 2 (it was three before, which is Silver eel)
* it said NAs introduced by coercion. Dind't find it but didn't look in detail (no time) - maybe check
* 2 new values integrated (new series) - qual_id was set to 1 (Tomas to confirm)
* 5 values updated (modified series)
* 7 new values integrated (new dataseries)
* 2 and 10 new values integrated (new group metrics)

## done
## RE-InTEGRATION
 New group metrics: 4 and 30 new values inserted in the group and metric tables
 
 In update group metrics: Error: Failed to prepare query: ERROR:  column "gr_number" is of type integer but expression is of type boolean
LINE 3: (g.gr_year,g.gr_number,g.gr_comment,g.gr_dts_datasource,g."g...
                   ^
HINT:  You will need to rewrite or cast the expression.

## Annex 3
### done
* 1 new value integrated (series)
* 8 values updated (modified series)
* 10 values integrated (new dataseries)
* 1 and 10 new values integrated (new group metrics)

### RE_INTEGRATION:
* 4 new values integrated (new dataseries)
* 

## to do
* integrate modified group metrics (there was a bug: could not find function "update_group_metrics" - at re-integration: Error: Failed to fetch row: ERROR: duplicate key value violates unique constraint "c_ck_uk_grser_gr"
DETAIL: Key (grser_ser_id, gr_year)=(350, 2021) already exists)

## Annex 4
## notes
4 rows of duplicates were detedcted but when integrating the new lines it said "0 updated, 0 kept". So when we tried to circumvent this by using "update data", shiny said these id's were not in the db. Turned out in fact the duplicates were indeed updated. What we did is we recreated the original version of the Annex, where the duplicates were in new data and not in update, so the integration shows duplicates again - but these were ignored (since they were already replaced).

## done
 * 4 new values integrated
 * 4 duplicates replaced (message said 0 updated, 0 kept but it was done in the db, issue was creatd)



## Annex 5
## to do
* Integrate. Couldn't integrate due to an error (Error: Failed to fetch row: ERROR:  new row for relation "t_eelstock_eel" violates check constraint "ck_qal_id_and_missvalue"
DETAIL:  Failing row contains (549699, 6, 2020, null, LT_total, LT, Y, F, null, 0, null, landings recorded in 2019, 2022-09-08, NC, dc_2022, Public).

## fixed  
24 new values inserted in the database

## Annex 6
* no data

## Annex 7
## done
* 2 new values integrated (new data)

## Annex 8
## to do
* Integrate. Could not integrate due to an error: Error: Failed to fetch row: ERROR:  new row for relation "t_eelstock_eel" violates check constraint "ck_qal_id_and_missvalue"
DETAIL:  Failing row contains (549730, 11, 2021, null, LT_total, LT, Y, null, null, 0, null, not reported due to commercial confidentiality reasons, 2022-09-08, NR, dc_2022, Public).



## Annex 10
* no data
