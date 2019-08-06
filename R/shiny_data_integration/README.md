# Shiny data integration


This is the interface to run the shiny data integration. The basic idea is (1) to let wgeel experts do the checks on the files, (2) help them to qualify the data (3) compare data with those existing in the database and check for duplicates. There are two tabs, one to edit data straight into the database, the other to display graph to check for duplicates once data are submitted.

*last update 2018*

## Recipe

--------------------------------------------

### First things to do before new wgeel (section for database and app. maintainer.... skip to next....)

At the end of global.R set the code for `qal_id` and a variable `the_eel_datasource`

```r
# VERY IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -------------------------------------------------
##########################
# CHANGE THIS LINE AT THE NEXT DATACALL AND WHEN TEST IS FINISHED
# BEFORE WGEEL sqldf('delete from datawg.t_eelstock_eel where eel_datasource='datacall_2018_test')
########################
qualify_code<-18 # change this code here and in tr_quality_qal for next wgeel
the_eel_datasource <- "test"
# the_eel_datasource <- "dc_2018"
```

code in `database_edition_2019`

```sql
select * from ref.tr_quality_qal;
BEGIN;
INSERT INTO ref.tr_quality_qal (qal_id ,
  qal_level,
  qal_text,
  qal_kept) VALUES
(
19,
'discarded_wgeel_2019',
'This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2019',
FALSE);--1
COMMIT;
```

Create also this code in the reference table `ref.tr_datasource_dts`

```sql
select * from ref.tr_datasource_dts;
BEGIN;
INSERT INTO ref.tr_datasource_dts  VALUES
(
'dc_2019',
'Joint EIFAAC/GFCM/ICES Eel Data Call 2019');--1
COMMIT;
```

The table of current users of the app is created in `datawg.participants`, update this with the wgeel participant list before wgeel.

Change can also be done in 

https://github.com/ices-eg/wg_WGEEL/blob/a353ad8ccccffb66f46b001654b30a897398bb7c/R/database_interaction/database_connection.R#L14
to use an interactive data entry for database name and user using [getPass](https://www.rdocumentation.org/packages/getPass/versions/0.2-2/topics/getPass)

To save the database
```sh
pg_dump -U postgres --table datawg.t_eelstock_eel -f "t_eelstock_eel.sql" wgeel
```
To save lines for one country only before updating
```sql
COPY (SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code='FR') TO 'F:/base/eel_stock_france.tsv'
--delete data in the table
BEGIN;
DELETE FROM datawg.t_eelstock_eel WHERE eel_cou_code='FR'; at this stage verify the number of lines
COMMIT;
COPY datawg.t_eelstock_eel FROM 'eel_stock_france.tsv'
```
------------------

### Application details : data integration

You must set the working directory at the root of the git
```r
setwd("C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL")
```
to test the app you need to put the files from wgeel 2018 datacall in a folder
launch by running run.R. In R studio, open the [ui.R](https://github.com/ices-eg/wg_WGEEL/blob/master/R/shiny_data_integration/shiny/ui.R) or [server.r](https://github.com/ices-eg/wg_WGEEL/blob/master/R/shiny_data_integration/shiny/server.R) and click on the RunApp button appearing at the top of the file.

Data entry should be done with someone familiar with the app (someone from the data subgroup ... enter name in the secondary assessor box) and one country leader (Main assessor national). Only the national assessor can truly say what to do in case of duplicates. 

![alt text][data_check]
 * click button **1**, browse to select file, _from this step the road to the next steps will be explained by rows of text_. 
 * click on the button **2**, the functions running the check on your data will return a list of error, and an excel file with those errors, check them, re-run untill you have solved all errors
 * click on the button **3**, this will load existing data from the database and run comparison checks with your current data. You will get two datasets one excel file with duplicated values and one excel file with new lines to be integrated. *to download the file select "all" values in the choice box on top of values. There is an empty line at the head of the dataset, remove it if you need to filter data but don't forget to put it again otherwise you'll get a changed_colnames error*
 	* In the dataset with duplicates you will need to select which value is to be kept from the database or the new dataset: in the column keep new value choose true to replace data using the new datacall data. Duplicated lines (old or new) will be kept in the database with an eel\_qual\_id of 18 if the year of integration is 2018. Don't forget to set a value for **eel_qal_id.xls** when keep_new_value=true. IF necessary for values to be replaced also put a comment in **eel_qal_comment.xls**. Possible values for qal_id are as following :
  
| qal_id | qal_level | qal_text |
| --- | --- | -------------------------------|
| 0 | missing | missing data |
| 1 | good quality | the data passed the quality checks of the wgeel |
| 2 | modified | The wgeel has modified that data |
| 3 | bad quality | The data has been judged of too poor quality to be used by the wgeel, it is not used |
| 4 | warnings | The data is used by the wgeel, but there are warnings on its quality (see comments) |
| 18 | discarded_wgeel_2018 | This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2018 |

  
  You will also need to give a qal comment if you select to replace the value currently in the database. *don't change the structure of the file, if you insert some to run checks or calculations, remove them before integration*
 	* In the dataset with new lines, you will still need to give a qal_id statement to all lines
 * click on the button **4** to select the dataset just processed and try integration in the database **5**. If it fails, try to understand with the message why the database refused your data and reprocess it.
 
 This is how it looks like when files are loaded
 
  * do the same for new data.
 
 ![alt text][data_check_step0]

 ![alt text][data_check_step1]



### Application details : data correction

Click on button edit in the tab panel on the left
Select a country, a type of data and choose a year range.

#### Choice of county and type :

 ![alt text][data_correction_step0]
 
To *edit* a cell, simply click inside modify the value, you can edit several cell,
Then click on the save button, a message will be displayed. Once changes are made, you can click on the clear button if you want to go back to the previous values. 

#### Data edition straight into the database :
 ![alt text][data_correction_step1]


### Data exploration tab to check for duplicates 

You can select a type (e.g. aquaculture or com_landings kg)  and a country (this is intented to country report leaders). This graph will diplay selected values on the left and discarded values on the right  (note : here the graph does not contain any discarded value.)

This creates a graph where total values are displayed and color according to the number of observation in the database for that year. There can be many as there are observations per emu, per lifestage and per habitat type.  

When you click on a bar, all corresponding lines are displayed, you can also explore details on plotly graph displayed by emu_code and stage on the right, hovering on this graph produces information.

![image](https://user-images.githubusercontent.com/26055877/44299808-ee673680-a2fc-11e8-8810-42160141eda6.png)



# Programming details

## global.R

This file is processed at launching, you can load it if you plan to debug the app,
set your working directory to your local copy of the *shiny\_data\_integration tab\\shiny*. Important : in this file you need to set up 
```r
setwd("C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\R\\shiny_data_integration\\shiny")
```

## ui.R

the ui uses shinydashboard for appearance, it also uses Shinyjs to create a stop button [closewindow](https://github.com/daattali/advanced-shiny/blob/master/close-window/app.R) usefull when developping the app.
several html tabs are generated dynamically in server.R according to checks on the user input (for instance in some cases there are no duplicates, then the user is returned the information no duplicates). Small pieces of text will inform the user on the way forward.
## Server.R

### data load

The excel files are processed. Upon reading the input the interface switches automatically to the right type of data. 
```r
      step0_filepath <- reactive({
            inFile <- input$xlfile      
            if (is.null(inFile)){        return(NULL)
            } else {
              data$path_step0<-inFile$datapath #path to a temp file
              if (grepl(c("catch"),tolower(inFile$name))) 
                updateRadioButtons(session, "file_type", selected = "catch_landings")
              if (grepl(c("release"),tolower(inFile$name)))
                updateRadioButtons(session, "file_type", selected = "release")
              if (grepl(c("aquaculture"),tolower(inFile$name)))
                updateRadioButtons(session, "file_type", selected = "aquaculture")
              if (grepl(c("biomass_indicator"),tolower(inFile$name))) 
                updateRadioButtons(session, "file_type", selected = "biomass")             
              if (grepl(c("habitat"),tolower(inFile$name)))
                updateRadioButtons(session, "file_type", selected = "potential_available_habitat")
              if (grepl(c("silver"),tolower(inFile$name))) 
                updateRadioButtons(session, "file_type", selected = "mortality_silver_equiv")      
              if (grepl(c("rate"),tolower(inFile$name)))
                updateRadioButtons(session, "file_type", selected = "mortality_rates")
            }
          }) 
```

Pressing the button will trigger the insertion of a data in the log file via 

```r
log_datacall( "check data",cou_code = cou_code, message = paste(rls$message,collapse="\n"), the_metadata = rls$res$the_metadata, file_type = file_type, main_assessor = main_assessor, secondary_assessor = secondary_assessor )
```
When the button is pressed, the files are processed using the [check_utilities](https://github.com/ices-eg/wg_WGEEL/blob/master/R/utilities/check_utilities.R) functions which are built to assess the integrity of a column, for instance for 
countries we have 
```r
###### eel_cou_code ##############
   
# must be a character
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_cou_code",
            country=country,
            type="character"))
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
# must only have one value
    data_error= rbind(data_error, check_unique(dataset=data_xls,
            column="eel_cou_code",
            country=country))
```

Those functions are then applied differently according to the dataset, in [loading functions.R](https://github.com/ices-eg/wg_WGEEL/blob/master/R/utilities/loading_functions.R)

### check for duplicates
Data are retrieved from the database using the extract data function which is built on postgreSQL [views](https://github.com/ices-eg/wg_WGEEL/blob/master/SQL/views.sql) per data type
```r
 switch (input$file_type, "catch_landings"={                                     
                  data_from_base<-extract_data("Landings")                  
                },
                "release"={
                  data_from_base<-extract_data("Release")
                },
                "aquaculture"={             
                  data_from_base<-extract_data("Aquaculture")},
                "biomass"={
                  # bug in excel file
                  colnames(data_from_excel)[colnames(data_from_excel)=="typ_name"]<-"eel_typ_name"
                  data_from_base<-rbind(
                      extract_data("B0"),
                      extract_data("Bbest"),
                      extract_data("Bcurrent"))
                },
                "potential_available_habitat"={
                  data_from_base<-extract_data("Potential available habitat")                  
                },
                "silver_eel_equivalents"={
                  data_from_base<-extract_data("Mortality in Silver Equivalents")      
                  
                },
                "mortality_rates"={
                  data_from_base<-rbind(
                      extract_data("Sigma A"),
                      extract_data("Sigma F"),
                      extract_data("Sigma H"))
                }    

```

They are compared to the current data type via [database_tools.R](https://github.com/ices-eg/wg_WGEEL/blob/master/R/shiny_data_integration/shiny/database_tools.R) using inner join on columns
`"eel_typ_id", "eel_year", "eel_lfs_code","eel_emu_nameshort", "eel_cou_code", "eel_hty_code", "eel_area_division"`
```r
duplicates <- data_from_base %>% dplyr::filter(eel_typ_id %in% current_typ_id & 
              eel_cou_code == current_cou_code) %>% dplyr::select(eel_colnames) %>% # dplyr::select(-eel_cou_code)%>%
      dplyr::inner_join(data_from_excel, by = c("eel_typ_id", "eel_year", "eel_lfs_code", 
              "eel_emu_nameshort", "eel_cou_code", "eel_hty_code", "eel_area_division"), 
          suffix = c(".base", ".xls"))

```
New data correspond to an anti-join
```r
  new <- dplyr::anti_join(data_from_excel, data_from_base, by = c("eel_typ_id", 
          "eel_year", "eel_lfs_code", "eel_emu_nameshort", "eel_hty_code", "eel_area_division", 
          "eel_cou_code"), suffix = c(".base", ".xls"))
```
### Treating the case of duplicates

We should not loose any data. This is a problem discussed (here)[
https://github.com/orgs/ices-eg/teams/wgeel/discussions/1]
and the final choice 
(here)[
https://github.com/orgs/ices-eg/teams/wgeel/discussions/4]

This is done in the functions `write_duplicates.R`. Values kept from the datacall will be inserted, old values from the database will be qualified with a number corresponding to the wgeel datacall (e.g. eel_qal_id=18 for 2018).
Values not selected from the datacall will be also be inserted with eel_qal_id=qualify_code (again 18).
The user is returned an excel file with a column keep_new_value in which he will select whether or not keep the new data. This excel file corresponds to the previous joining of two files. There are various test run to check for possible format

```r
  # with logical R value here I'm testing various mispelling
  duplicates2$keep_new_value[duplicates2$keep_new_value == "1"] <- "true"
  duplicates2$keep_new_value[duplicates2$keep_new_value == "0"] <- "false"
  duplicates2$keep_new_value <- toupper(duplicates2$keep_new_value)
  duplicates2$keep_new_value[duplicates2$keep_new_value == "YES"] <- "true"
  duplicates2$keep_new_value[duplicates2$keep_new_value == "NO"] <- "false"
```

The user must qualify the new data (as when inserting `eel_qal_id` cannot be NULL

There are two programming tricks to be aware of :
 * Note the use of poolCheckout to catch the error. I've tried many ways with sqldf but trycatch failed to catch the error (it's an internal problem to dbi). Hence the use of DBI.  Two queries are run at once to catch error on failure and not be stuck with only half the modification done. See https:/stackoverflow.com/questions/34332769/how-to-use-dbgetquery-in-trycatch-with-postgresql
 
 * sqldf is handy because you can run queries with objet from R as if they were table inside the database. As you cannot do that with DBI, I've had to first create the temporary table using sqldf and only then run the DBI query
 
 * At the beginning the script was as following : 
 
```r
query <- paste(query1, query2)
    conn <- poolCheckout(pool)
    tryCatch({
          dbExecute(conn, query)
        }, error = function(e) {
          message <<- e
        }, finally = {
          poolReturn(conn)
          sqldf("drop table if exists not_replaced_temp")
          sqldf("drop table if exists replaced_temp")
        })
```
 *  However this just launches the `query1` never `query2`, as `dbExecute` only executes one line. So the modified script handles integration error and performs some "manual rollback" in case of failure, to do so query1_reverse uses the day, hopefully there won't be a failure of data integration arround midnight at the wgeel.
 
 ```r
  
  conn <- poolCheckout(pool)
  message <- NULL
  
  # First step, replace values in the database --------------------------------------------------
  
  sqldf(query0)
  
  # Second step insert replaced ------------------------------------------------------------------
  
  nr1 <- tryCatch({     
        dbExecute(conn, query1)
      }, error = function(e) {
        message <- e  
        sqldf (query0_reverse)      # perform reverse operation
      }, finally = {
        poolReturn(conn)
        sqldf( str_c( "drop table if exists not_replaced_temp_", cou_code))
        sqldf( str_c( "drop table if exists replaced_temp_", cou_code))        
      })
  
  # Third step insert not replaced values into the database -----------------------------------------

  
  if (is.null(message)){ # the previous operation had no error
     conn <- poolCheckout(pool)  
    tryCatch({     
                dbExecute(conn, query2)
            }, error = function(e) {
                message <- e                   
                dbExecute(conn, query1_reverse) # this is not surrounded by trycatch, pray it does not fail ....
                 sqldf (query0_reverse)      # perform reverse operation    
               }, finally = {
                poolReturn(conn)
                sqldf( str_c( "drop table if exists not_replaced_temp_", cou_code))
                sqldf( str_c( "drop table if exists replaced_temp_", cou_code))        
            })
    
  }  
  
message <- sprintf("For duplicates %s values replaced in the database (old values kept with code eel_qal_id=%s)\n, %s values not replaced (values from current datacall stored with code eel_qal_id %s)", 
      nrow(replaced), qualify_code, nrow(not_replaced), qualify_code)
 
 
```

The `not_replaced` data are kept but with code **18** and with a new comment

```r
 not_replaced$eel_comment.xls[is.na(not_replaced$eel_comment.xls)] <- ""
    not_replaced$eel_comment.xls <- paste0(not_replaced$eel_comment.xls, " Value ", 
        not_replaced$eel_value.xls, " not used, value from the database ", not_replaced$eel_value.base, 
        " kept instead for datacall ", format(Sys.time(), "%Y"))
    not_replaced$eel_qal_id <- qualify_code

```
The `replaced` data are inserted in the database, there is a check at the beginning of the function to ensure all data have been qualified. This check uses validate which returns a user readable text instead of an error

```r
  validate(need(all(!is.na(replaced$eel_qal_id.xls)), "All values with true in keep_new_value column should have a value in eel_qal_id \n"))
```
### Inserting new rows 

Same trick, use of a temp table with sqldf, and DBI to catch errors.

## Data corrections tab

Everything is detailed here https://yihui.shinyapps.io/DT-edit/ however again there was the problem of catching the error and displaying it to the user. Note also the use of glue to protect from SQL insertions...


```r
update_t_eelstock_eel <- function(editedValue, pool, data) {
  # Keep only the last modification for a cell edited Value is a data frame with
  # columns row, col, value this part ensures that only the last value changed in a
  # cell is replaced.  Previous edits are ignored
  editedValue <- editedValue %>% group_by(row, col) %>% filter(value == dplyr::last(value) | 
          is.na(value)) %>% ungroup()
  # opens the connection, this must be followed by poolReturn
  conn <- poolCheckout(pool)
  # Apply to all rows of editedValue dataframe
  t_eelstock_eel_ids <- data$eel_id
  error = list()
  lapply(seq_len(nrow(editedValue)), function(i) {
        row = editedValue$row[i]
        id = t_eelstock_eel_ids[row]
        col = t_eelstock_eel_fields[editedValue$col[i]]
        value = editedValue$value[i]
        # glue sql will use arguments tbl, col, value and id
        query <- glue::glue_sql("UPDATE datawg.t_eelstock_eel SET
                {`col`} = {value}
                WHERE eel_id = {id}
                ", 
            .con = conn)
        tryCatch({
              dbExecute(conn, sqlInterpolate(ANSI(), query))
            }, error = function(e) {
              error[i] <<- e
            })
      })
  poolReturn(conn)
  # print(editedValue)
  return(error)
}
```

[data_check]: https://github.com/ices-eg/wg_WGEEL/blob/master/R/shiny_data_integration/shiny/common/images/data_check.png "Shiny app for data integration"
[data_check_step0]: 
https://user-images.githubusercontent.com/26055877/42418061-9b6dcf0e-8298-11e8-9fd1-89fed97f832a.png
[data_check_step1]: 
https://user-images.githubusercontent.com/26055877/42418064-ae3a6976-8298-11e8-8874-765c0218422e.png
[data_correction_step0]:
https://user-images.githubusercontent.com/26055877/44337425-fa790280-a47a-11e8-9f04-916f3fa5887e.png
[data_correction_step1]:
https://user-images.githubusercontent.com/26055877/44337741-f4375600-a47b-11e8-9515-11b572923586.png
