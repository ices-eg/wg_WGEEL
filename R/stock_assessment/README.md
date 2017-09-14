# how to use the script to check files

The fields must be named like 

````r
datacallfiles<-c("Eel_Data_Call_Annex2_Catch_and_Landings.xlsx",
    "Eel_Data_Call_Annex3_Stocking.xlsx",
    "Eel_Data_Call_Annex4_Aquaculture_Production.xlsx")
````
Note that I have removed the name of the country at the end when there was one at the submission.

Each country or EMU will be stored in it's own folder e.g.

````
France>Eel_Data_Call_Annex2_Catch_and_Landings.xlsx
France>Eel_Data_Call_Annex3_Stocking.xlsx
France>Eel_Data_Call_Annex4_Aquaculture_Production.xlsx

Italy>Eel_Data_Call_Annex2_Catch_and_Landings.xlsx
Italy>Eel_Data_Call_Annex3_Stocking.xlsx
Italy>Eel_Data_Call_Annex4_Aquaculture_Production.xlsx
````
Normally I will have everything arranged on the sharepoint, so you just have to sync the file to get the right data and folders
#### sync with the sharepoint to get a copy of the files.
I have managed to run the sync component of the sharepoint, by downloading onedrive buisness following a procedure
described [here](https://support.microsoft.com/en-us/help/2903984/how-to-install-onedrive-for-business-for-sharepoint-and-sharepoint-onl).
It looks as if it depends a lot on your computer configuration but some of us might have the office365 installed from their company
and some others might manage to synchronize from the sharepoint. If you have office 2016 you don't need to do that. Once you click on the sync button,
you can synchronize the datacall folder on your computer. I have used the * C:/temp * folder as the destination.

The [script](https://github.com/ices-eg/WGEEL/tree/master/R/stock_assessment)  for initial check of the datacall files, 
 needs to be adapted for the path on your computer.


So I have access to the sharepoint, apparently the whole WGEEL2017 Meeting docs have been synchronized in 
* C:\temp\SharePoint\WGEEL - 2017 Meeting Docs\* 

According to your local settings you must adjust the first line of the script (currently line 23), beware use slash and not antislash for path in R.
````r
# this is the folder where you will store the files prior to upload
# don't forget to put an / at the end of the string
mylocalfolder <- "C:/temp/SharePoint/WGEEL - 2017 Meeting Docs/06. Data/datacall"
# you will need to put the following files there
````
