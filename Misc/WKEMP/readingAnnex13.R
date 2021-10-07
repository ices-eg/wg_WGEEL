
##Annex 13 data sheets

#

#Aim: to pull out relevent data from Overview EMU sheet into a row/column of data per EMU

#ignore sheets 'readme' metadata [we can come back and get this info if needed]
#'tr_emu_em'.
#sheet given is 'Overview_EMUX1' if only one emu this will be filled out, if more emus this could be blank with multiple sheets available


#questions/headers are mostly in column A and respective row number

#1. EMU Identification
library(XLConnect)

readWorksheetWithNull=function(wb, s, startRow, startCol, endRow, endCol,header=FALSE){
  val=XLConnect::readWorksheet(wb, s, startRow=startRow, startCol=startCol,
                    endRow=endRow, endCol=endCol,header=FALSE)[1,1]
  
  ifelse(is.null(val), NA, val)
}


read_annex13=function(filename){

wb = loadWorkbook(filename)
sheet=getSheets(wb)
sheet = sheet[grep("Overview",sheet)]
do.call(rbind.data.frame,lapply(sheet,function(s){
  cou_code=readWorksheetWithNull(wb, s, startRow=5, startCol=2, endRow=5, endCol=2,header=FALSE)
  emu_nameshort=readWorksheetWithNull(wb, s, startRow=6, startCol=2, endRow=6, endCol=2,header=FALSE)
  transboundary=readWorksheetWithNull(wb, s, startRow=7, startCol=2, endRow=7, endCol=2,header=FALSE)
  connected=readWorksheetWithNull(wb, s, startRow=8, startCol=2, endRow=8, endCol=2,header=FALSE)
  comment_emu=readWorksheetWithNull(wb, s, startRow=8, startCol=3, endRow=8, endCol=3,header=FALSE)
  date=readWorksheetWithNull(wb, s, startRow=10, startCol=2, endRow=10, endCol=2,header=FALSE)
  b0_change=readWorksheetWithNull(wb, s, startRow=14, startCol=2, endRow=14, endCol=2,header=FALSE)
  b0_explaination=readWorksheetWithNull(wb, s, startRow=14, startCol=3, endRow=14, endCol=3,header=FALSE)
  bbest_change=readWorksheetWithNull(wb, s, startRow=15, startCol=2, endRow=15, endCol=2,header=FALSE)
  bbest_explaination=readWorksheetWithNull(wb, s, startRow=15, startCol=3, endRow=15, endCol=3,header=FALSE)
  bcurrent_change=readWorksheetWithNull(wb, s, startRow=16, startCol=2, endRow=16, endCol=2,header=FALSE)
  bcurrent_explaination=readWorksheetWithNull(wb, s, startRow=16, startCol=3, endRow=16, endCol=3,header=FALSE)
  
  habitat_considered_change=readWorksheetWithNull(wb, s, startRow=19, startCol=2, endRow=19, endCol=2,header=FALSE)
  habitat_considered_explaination=readWorksheetWithNull(wb, s, startRow=19, startCol=3, endRow=19, endCol=3,header=FALSE)
  data_source_change=readWorksheetWithNull(wb, s, startRow=20, startCol=2, endRow=20, endCol=2,header=FALSE)
  data_source_explaination=readWorksheetWithNull(wb, s, startRow=20, startCol=3, endRow=20, endCol=3,header=FALSE)
  method_assessment_change=readWorksheetWithNull(wb, s, startRow=21, startCol=2, endRow=21, endCol=2,header=FALSE)
  method_assessment_explaination=readWorksheetWithNull(wb, s, startRow=21, startCol=3, endRow=21, endCol=3,header=FALSE)
  
  restocking_b0=readWorksheetWithNull(wb, s, startRow=29, startCol=2, endRow=29, endCol=2,header=FALSE)
  restocking_bbest_bcurrent=readWorksheetWithNull(wb, s, startRow=29, startCol=3, endRow=29, endCol=3,header=FALSE)
  restocking_bbest_sumf=readWorksheetWithNull(wb, s, startRow=29, startCol=4, endRow=29, endCol=4,header=FALSE)
  restocking_bbest_sumh=readWorksheetWithNull(wb, s, startRow=29, startCol=5, endRow=29, endCol=5,header=FALSE)
  restocking_explaination=readWorksheetWithNull(wb, s, startRow=46, startCol=2, endRow=46, endCol=2,header=FALSE)
  
  b0_mk=readWorksheetWithNull(wb, s, startRow=50, startCol=2, endRow=50, endCol=2,header=FALSE)
  bbest_bcurrent_mk=readWorksheetWithNull(wb, s, startRow=50, startCol=3, endRow=50, endCol=3,header=FALSE)
  b0_counter=readWorksheetWithNull(wb, s, startRow=51, startCol=2, endRow=51, endCol=2,header=FALSE)
  bbest_bcurrent_counter=readWorksheetWithNull(wb, s, startRow=51, startCol=3, endRow=51, endCol=3,header=FALSE)
  b0_trap=readWorksheetWithNull(wb, s, startRow=52, startCol=2, endRow=52, endCol=2,header=FALSE)
  bbest_bcurrent_trap=readWorksheetWithNull(wb, s, startRow=52, startCol=3, endRow=52, endCol=3,header=FALSE)  
  b0_other=readWorksheetWithNull(wb, s, startRow=53, startCol=2, endRow=53, endCol=2,header=FALSE)
  bbest_bcurrent_other=readWorksheetWithNull(wb, s, startRow=53, startCol=3, endRow=53, endCol=3,header=FALSE) 
  assessment_explaination=readWorksheetWithNull(wb, s, startRow=53, startCol=4, endRow=53, endCol=4,header=FALSE) 
  indirect_assessment=readWorksheetWithNull(wb, s, startRow=57, startCol=1, endRow=57, endCol=1,header=FALSE) 
  
  mortality_wise=readWorksheetWithNull(wb, s, startRow=58, startCol=2, endRow=58, endCol=2,header=FALSE) 
  data.frame(cou_code=cou_code,
             emu_nameshort=emu_nameshort,
             transboundary=transboundary,
             connected=connected,
             comment_emu=comment_emu,
             date=date,
             b0_change=b0_change,
             b0_explaination=b0_explaination,
             bbest_change=bbest_change,
             bbest_explaination=bbest_explaination,
             bcurrent_change=bcurrent_change,
             bcurrent_explaination=bcurrent_explaination,
             habitat_considered_change=habitat_considered_change,
             habitat_considered_explaination=habitat_considered_explaination,
             data_source_change=data_source_change,
             data_source_explaination=data_source_explaination,
             method_assessment_change=method_assessment_change,
             method_assessment_explaination=method_assessment_explaination,
             restocking_b0=restocking_b0,
             restocking_bbest_bcurrent=restocking_bbest_bcurrent,
             restocking_bbest_sumf=restocking_bbest_sumf,
             restocking_bbest_sumh=restocking_bbest_sumh,
             restocking_explaination=restocking_explaination,
             b0_mk=b0_mk,
             bbest_bcurrent_mk=bbest_bcurrent_mk,
             b0_counter=b0_counter,
             bbest_bcurrent_counter=bbest_bcurrent_counter,
             b0_trap=b0_trap,
             bbest_bcurrent_trap=bbest_bcurrent_trap,
             b0_other=b0_other,
             bbest_bcurrent_other=bbest_bcurrent_other,
             assessment_explaination=assessment_explaination,
             indirect_assessment=indirect_assessment,
             mortality_wise=mortality_wise)
  }))

}



#####to build the table: put all the filenames below and then run the line starting with annexes13_table
setwd("/tmp/Annex13/")
filenames=list.files("/tmp/Annex13/")
annexes13_table = do.call(rbind.data.frame,lapply(filenames, function(f) read_annex13(f)))
