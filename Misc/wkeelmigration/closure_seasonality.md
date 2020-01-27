---
title: "WKEELMIGRATION CLOSURE DATA TREATMENT"
author: "Michael Pedersen, Argyrios Sapounidis, Caroline Durif, Matthew Gollock, Derek Evans, Cédric Briand"
date: "january 2020"
output: 
  html_document:
    keep_md: true
---



# preparing the files

see readme.md in this folder for notes on source file.


# reading the files





```r
load(file=str_c(datawd1,"list_closure.Rdata"))
# list_closure is a list with all data sets (readme, data, series) as elements of the list
# below we extract the list of data and bind them all in a single data.frame
# to do so, I had to constrain the column type during file reading (see functions.R)
res <- map(list_closure,function(X){			X[["data"]]		}) %>% 
		bind_rows()
Hmisc::describe(res) %>% html()
```

```
## Warning in png(file, width = 1 + k * w, height = h): 'width=13, height=13'
## ne sont probablement pas des valeurs en pixels

## Warning in png(file, width = 1 + k * w, height = h): 'width=13, height=13'
## ne sont probablement pas des valeurs en pixels
```

```
## Warning in png(file, width = 1 + k * w, height = h): 'width=19, height=13'
## ne sont probablement pas des valeurs en pixels
```

<!--html_preserve--><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<script type="text/javascript">
<!--
    function expand_collapse(id) {
       var e = document.getElementById(id);
       var f = document.getElementById(id+"_earrows");
       if(e.style.display == 'none'){
          e.style.display = 'block';
          f.innerHTML = '&#9650';
       }
       else {
          e.style.display = 'none';
          f.innerHTML = '&#9660';
       }
    }
//-->
</script>
<style>
.earrows {color:silver;font-size:11px;}

fcap {
 font-family: Verdana;
 font-size: 12px;
 color: MidnightBlue
 }

smg {
 font-family: Verdana;
 font-size: 10px;
 color: &#808080;
}

hr.thinhr { margin-top: 0.15em; margin-bottom: 0.15em; }

span.xscript {
position: relative;
}
span.xscript sub {
position: absolute;
left: 0.1em;
bottom: -1ex;
}
</style>
 <font color="MidnightBlue"><div align=center><span style="font-weight:bold">res <br><br> 15  Variables   15073  Observations</span></div></font> <hr class="thinhr"> <span style="font-weight:bold">eel_typ_name</span> <style>
 .hmisctable430795 {
 border: none;
 font-size: 85%;
 }
 .hmisctable430795 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable430795 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable430795">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>14191</td><td>882</td><td>2</td></tr>
 </table>
 <pre style="font-size:85%;">
 Value      com_closure rec_closure
 Frequency         8729        5462
 Proportion       0.615       0.385
 </pre>
 <hr class="thinhr"> <span style="font-weight:bold">eel_year</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAAEAAAAANCAMAAAAucZheAAAACVBMVEUAAADMzMz////1iUV5AAAAPklEQVQokWNgJAgYGHAikCwTQcDAgBOBZKlhAAMDimo0zYQMwCMNVUR7A/AFMyikCcTCYPDCMDCAklhgYAQAHPMCtnsDl1QAAAAASUVORK5CYII=" alt="image" /></div> <style>
 .hmisctable408157 {
 border: none;
 font-size: 85%;
 }
 .hmisctable408157 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable408157 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable408157">
 <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th><th>.05</th><th>.10</th><th>.25</th><th>.50</th><th>.75</th><th>.90</th><th>.95</th></tr>
 <tr><td>14191</td><td>882</td><td>21</td><td>0.997</td><td>2010</td><td>6.606</td><td>2001</td><td>2002</td><td>2005</td><td>2011</td><td>2015</td><td>2018</td><td>2019</td></tr>
 </table>
 <span style="font-size: 85%;"><font color="MidnightBlue">lowest</font> : 2000 2001 2002 2003 2004 ,  <font color="MidnightBlue">highest</font>: 2016 2017 2018 2019 2020</span> <hr class="thinhr"> <span style="font-weight:bold">eel_month</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAAEYAAAANCAMAAAAjb+gZAAAACVBMVEUAAADMzMz////1iUV5AAAAWklEQVQokWNgxAAMDAgSC0CWhitiYEICDAxQEoLgIigsZAmEIBWMAakmyhg4n4Ax6KJYjcFqAHWNwRr8EISICkwhdA2Dy1PDyxgoYgQGNiQSkEgGVBEsQmhKAchfBBpr4zDHAAAAAElFTkSuQmCC" alt="image" /></div> <style>
 .hmisctable783583 {
 border: none;
 font-size: 85%;
 }
 .hmisctable783583 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable783583 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable783583">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>13923</td><td>1150</td><td>23</td></tr>
 </table>
 <style>
 .hmisctable809483 {
 border: none;
 font-size: 85%;
 }
 .hmisctable809483 td {
 text-align: right;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable809483 th {
 color: Black;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: bold;
 }
 </style>
 <table class="hmisctable809483">
 <tr><td><font color="MidnightBlue">lowest</font> :</td><td>ABR       </td><td>AGO       </td><td>APR       </td><td>Aug       </td><td>AUG       </td></tr>
 <tr><td><font color="MidnightBlue">highest</font>:</td><td>OCT       </td><td>sep       </td><td>SEP       </td><td>whole year</td><td>WHOLE YEAR</td></tr>
 </table>
 <hr class="thinhr"> <span style="font-weight:bold">fishery_closure_type</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAACVBMVEUAAADMzMz////1iUV5AAAAHUlEQVQImWNgRAAGBgYmBKCAR66ZDOg8BAYZisAAWkMA7ZYDxOwAAAAASUVORK5CYII=" alt="image" /></div> <style>
 .hmisctable569353 {
 border: none;
 font-size: 85%;
 }
 .hmisctable569353 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable569353 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable569353">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>12132</td><td>2941</td><td>4</td></tr>
 </table>
 <pre style="font-size:85%;">
 Value         PS    PT   PTS     T
 Frequency   1550   975  1237  8370
 Proportion 0.128 0.080 0.102 0.690
 </pre>
 <hr class="thinhr"> <span style="font-weight:bold">fishery_closure_percent</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAAJcAAAANCAMAAACTvAxuAAAACVBMVEUAAADMzMz////1iUV5AAAAZUlEQVQ4je1T0QoAEAw8/v+jZbsJeaD2MHJl6uJ2sUMKB6CWHA6onr6vbXxfZ1BfnP9AsDwi2JvZP77uy1XnHl9L+Z2evr5k/iWRtjGfpHUNZ6AEaSpALjLeHTfTyXo04UaytZQCXGMM+v08ajcAAAAASUVORK5CYII=" alt="image" /></div> <style>
 .hmisctable942439 {
 border: none;
 font-size: 85%;
 }
 .hmisctable942439 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable942439 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable942439">
 <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th><th>.05</th><th>.10</th><th>.25</th><th>.50</th><th>.75</th><th>.90</th><th>.95</th></tr>
 <tr><td>9757</td><td>5316</td><td>61</td><td>0.916</td><td>57.8</td><td>46.1</td><td>  0</td><td>  0</td><td> 10</td><td> 55</td><td>100</td><td>100</td><td>100</td></tr>
 </table>
 <span style="font-size: 85%;"><font color="MidnightBlue">lowest</font> :   0   1   5   6  10 ,  <font color="MidnightBlue">highest</font>:  94  95  96  97 100</span> <hr class="thinhr"> <span style="font-weight:bold">reason_for_closure</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAACVBMVEUAAADMzMz////1iUV5AAAAIUlEQVQImWNgYEQCDAxMSAA3j4EBPw/ZRFL0ETATihkYAFjUAO8vS3RRAAAAAElFTkSuQmCC" alt="image" /></div> <style>
 .hmisctable539890 {
 border: none;
 font-size: 85%;
 }
 .hmisctable539890 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable539890 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable539890">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>12085</td><td>2988</td><td>4</td></tr>
 </table>
 <pre style="font-size:85%;">
 Value             EMP EU Closure      other      Other
 Frequency        6848        125          2       5110
 Proportion      0.567      0.010      0.000      0.423
 </pre>
 <hr class="thinhr"> <span style="font-weight:bold">eel_emu_nameshort</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAAJcAAAANCAMAAACTvAxuAAAACVBMVEUAAADMzMz////1iUV5AAAAoElEQVQ4jc2UgQ6AIAhEj/7/o4sUkGGb0FpSU0NOXmwIKhhQUeVSHAVDSZVLURJtxiU8+3GxOa6vELflSjXJbW1W1wfNSMl+tHr1MumiUBDYONvOcwndr1wu82uuodgJrhB0OQaIwOX2FpCcfJHL2qxrVC6548GucO7vhqTDnffENbsWuZ3AD79tIR+Azuo3I1t0OSGeRBYQ5GSBFtJoiE5x4gtsoQH+FAAAAABJRU5ErkJggg==" alt="image" /></div> <style>
 .hmisctable120904 {
 border: none;
 font-size: 85%;
 }
 .hmisctable120904 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable120904 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable120904">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>14193</td><td>880</td><td>67</td></tr>
 </table>
 <span style="font-size: 85%;"><font color="MidnightBlue">lowest</font> : BE_Sche  DE_Eide  DE_Elbe  DE_Ems   DE_Rhei  ,  <font color="MidnightBlue">highest</font>: PT_Port  PT_total SE_East  SE_West  VA_total</span> <hr class="thinhr"> <span style="font-weight:bold">eel_cou_code</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAADcAAAANCAMAAAA65Aa/AAAACVBMVEUAAADMzMz////1iUV5AAAAPklEQVQokWNgRAUMDIxEAQYmVMCALoADDHt9QzE8gZpQ9OExBIs+hGp8+iBycJIEfcDAYYSTDDA2GCFY6AgAruUEho5clgIAAAAASUVORK5CYII=" alt="image" /></div> <style>
 .hmisctable208663 {
 border: none;
 font-size: 85%;
 }
 .hmisctable208663 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable208663 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable208663">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>15070</td><td>3</td><td>18</td></tr>
 </table>
 <pre style="font-size:85%;">
 Value          0    BE    DE    DK    ES    FR    GB    GR    IE    IT    LT    LV
 Frequency    877    41   710   208  1558  6608  1229    67   100  2014   480    79
 Proportion 0.058 0.003 0.047 0.014 0.103 0.438 0.082 0.004 0.007 0.134 0.032 0.005
                                               
 Value         NL    NO    PL    PT    SE    VA
 Frequency     61   480   141   388    24     5
 Proportion 0.004 0.032 0.009 0.026 0.002 0.000
 </pre>
 <hr class="thinhr"> <span style="font-weight:bold">eel_lfs_code</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAABMAAAANCAMAAAB8UqUVAAAACVBMVEUAAADMzMz////1iUV5AAAALklEQVQYlWNgYEQCDAwQkgkJQHiYYgwMJIohUSAxJAvBFC51SByqiIGsg1oIpQCecgEaIuWOOAAAAABJRU5ErkJggg==" alt="image" /></div> <style>
 .hmisctable659400 {
 border: none;
 font-size: 85%;
 }
 .hmisctable659400 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable659400 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable659400">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>13773</td><td>1300</td><td>6</td></tr>
 </table>
 <pre style="font-size:85%;">
 Value          G    GS   GYS     S     Y    YS
 Frequency   3626     1  2127  1412  3676  2931
 Proportion 0.263 0.000 0.154 0.103 0.267 0.213
 </pre>
 <hr class="thinhr"> <span style="font-weight:bold">eel_hty_code</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAABkAAAANCAMAAABrcDXcAAAACVBMVEUAAADMzMz////1iUV5AAAAOklEQVQYlWNgZGRkYGBEARA+AxMTEwOIQAIQPq1kEPJQPsItDLjchqGHYhlkNXhkGCBuYWBEZTEyAAAyVQG6zqR4oAAAAABJRU5ErkJggg==" alt="image" /></div> <style>
 .hmisctable902245 {
 border: none;
 font-size: 85%;
 }
 .hmisctable902245 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable902245 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable902245">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>14193</td><td>880</td><td>8</td></tr>
 </table>
 <pre style="font-size:85%;">
 Value          C     F    FC    FT   FTC    MO     T    TC
 Frequency    240  4954    28  3016  1042    56  4767    90
 Proportion 0.017 0.349 0.002 0.212 0.073 0.004 0.336 0.006
 </pre>
 <hr class="thinhr"> <span style="font-weight:bold">eel_area_division</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAAEMAAAANCAMAAADFRiNdAAAACVBMVEUAAADMzMz////1iUV5AAAAVElEQVQokWNgxAYYGLAKo8ohGEzYAAN2YVQ5BINMM4Dk8DADjqAi5MQLHGGPF2SXYncNFnfQ3gyoOmTTiDIDDVHRDDgHW7wAQxcJMWAgFFE0FRA9ANUmBLt19eRyAAAAAElFTkSuQmCC" alt="image" /></div> <style>
 .hmisctable428803 {
 border: none;
 font-size: 85%;
 }
 .hmisctable428803 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable428803 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable428803">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>3938</td><td>11135</td><td>22</td></tr>
 </table>
 <style>
 .hmisctable633770 {
 border: none;
 font-size: 85%;
 }
 .hmisctable633770 td {
 text-align: right;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable633770 th {
 color: Black;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: bold;
 }
 </style>
 <table class="hmisctable633770">
 <tr><td><font color="MidnightBlue">lowest</font> :</td><td>08/03 et 15/02 </td><td>09/03 et 15/02 </td><td>12/03 et 15/02 </td><td>14/03 et 15/02 </td><td>21.1.A         </td></tr>
 <tr><td><font color="MidnightBlue">highest</font>:</td><td>27.8.c y 27.9.a</td><td>27.9.a         </td><td>37.1.1         </td><td>37.2.2         </td><td>37.3.1         </td></tr>
 </table>
 <hr class="thinhr"> <span style="font-weight:bold">eel_comment</span> <style>
 .hmisctable806092 {
 border: none;
 font-size: 85%;
 }
 .hmisctable806092 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable806092 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable806092">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>2292</td><td>12781</td><td>166</td></tr>
 </table>
 <style>
 .hmisctable982806 {
 border: none;
 font-size: 85%;
 }
 .hmisctable982806 td {
 text-align: right;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable982806 th {
 color: Black;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: bold;
 }
 </style>
 <table class="hmisctable982806">
 <tr><td><font color="MidnightBlue">lowest</font> :</td><td>1 nm seeward from baseline (Annex 1 AalVO SH)    </td><td>1er: 08-03 et 2ieme 15-02                        </td><td>1er: 09-03 et 2ieme 15-02                        </td><td>1er: 10-03 et 2ieme 15-02                        </td><td>1er: 11-03 et 2ieme 15-02                        </td></tr>
 <tr><td><font color="MidnightBlue">highest</font>:</td><td>Veda: Vigo, Pontevedra, Ferrol                   </td><td>Veda:Tambre, Ulla,Vigo,Arousa, Ferrol, Muros     </td><td>Veda:Ulla,Tambre                                 </td><td>Veda:Vigo, Ferrol, no dist entre anguila y angula</td><td>Veda:Vigo, Ferrol, no dsit entre anguila y angula</td></tr>
 </table>
 <hr class="thinhr"> <span style="font-weight:bold">source</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAADEAAAANCAMAAAA3+nb4AAAACVBMVEUAAADMzMz////1iUV5AAAAPUlEQVQokWNgRAIMDIyEAQMTEmBA4eEAw0bHIA8roHIUHbi0o+tAqMOnAyJHtA5GBnAQgUkGGBuMECwUBABJ7wQDBRyHrgAAAABJRU5ErkJggg==" alt="image" /></div> <style>
 .hmisctable491650 {
 border: none;
 font-size: 85%;
 }
 .hmisctable491650 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable491650 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable491650">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>15073</td><td>0</td><td>16</td></tr>
 </table>
 <style>
 .hmisctable457241 {
 border: none;
 font-size: 85%;
 }
 .hmisctable457241 td {
 text-align: right;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable457241 th {
 color: Black;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: bold;
 }
 </style>
 <table class="hmisctable457241">
 <tr><td><font color="MidnightBlue">lowest</font> :</td><td>BE_Pivot Table        </td><td>DE_fishery_closure.mip</td><td>DK_fishery_closure.mip</td><td>ES_Pivot Table        </td><td>FR_fishery_closure_raw</td></tr>
 <tr><td><font color="MidnightBlue">highest</font>:</td><td>NL_fishery_closure_raw</td><td>NO_fishery_closure_raw</td><td>PL_fishery_closure.mip</td><td>PT_Pivot Tables       </td><td>SE_fishery_closure_raw</td></tr>
 </table>
 <hr class="thinhr"> <span style="font-weight:bold">country</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAADEAAAANCAMAAAA3+nb4AAAACVBMVEUAAADMzMz////1iUV5AAAAPUlEQVQokWNgRAIMDIyEAQMTEmBA4eEAw0bHIA8roHIUHbi0o+tAqMOnAyJHtA5GBnAQgUkGGBuMECwUBABJ7wQDBRyHrgAAAABJRU5ErkJggg==" alt="image" /></div> <style>
 .hmisctable506054 {
 border: none;
 font-size: 85%;
 }
 .hmisctable506054 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable506054 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable506054">
 <tr><th>n</th><th>missing</th><th>distinct</th></tr>
 <tr><td>15073</td><td>0</td><td>16</td></tr>
 </table>
 <pre style="font-size:85%;">
 Value         BE    DE    DK    ES    FR    GB    GR    IE    IT    LT    LV    NL
 Frequency    241   710   264  1558  6608  1250   247   244  2014   483   262    61
 Proportion 0.016 0.047 0.018 0.103 0.438 0.083 0.016 0.016 0.134 0.032 0.017 0.004
                                   
 Value         NO    PL    PT    SE
 Frequency    480   239   388    24
 Proportion 0.032 0.016 0.026 0.002
 </pre>
 <hr class="thinhr"> <span style="font-weight:bold">datasource</span> <style>
 .hmisctable464471 {
 border: none;
 font-size: 85%;
 }
 .hmisctable464471 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable464471 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable464471">
 <tr><th>n</th><th>missing</th><th>distinct</th><th>value</th></tr>
 <tr><td>15073</td><td>0</td><td>1</td><td>wkeelmigration</td></tr>
 </table>
 <pre style="font-size:85%;">
 Value      wkeelmigration
 Frequency           15073
 Proportion              1
 </pre>
 <hr class="thinhr"><!--/html_preserve-->

```r
# these are all empty lines ....
# print(res[is.na(res$eel_emu_nameshort),],n=2)
# all NA print(res[is.na(res$eel_emu_nameshort),],n=1000)
res <- res[!is.na(res$eel_emu_nameshort),]
# describe file again

# treating month

unique(res$eel_month)
```

```
##  [1] "WHOLE YEAR" "NOV"        "DEC"        "JAN"        "SEP"       
##  [6] "OCT"        "FEB"        "MAR"        "APR"        "MAY"       
## [11] "JUN"        "JUL"        "AUG"        NA           "whole year"
## [16] "ABR"        "AGO"        "sep"        "oct"        "nov"       
## [21] "dec"        "Jun"        "Jul"        "Aug"
```

```r
res$eel_month <- tolower(res$eel_month)
# resm<-res[is.na(res$eel_month),]
res$eel_month[is.na(res$eel_month)]<-"whole year"
# removing whole year and missing year
res$eel_month[res$eel_month=="abr"] <- "apr"
res$eel_month[res$eel_month=="ago"] <- "aug"




# recode the month
res$eel_month <- recode(res$eel_month, 
		"mar"=3, 
		"apr"=4, 
		"may"=5, 
		"jun"=6,
		"jul"=7,
		"aug"=8,
		"sep"=9,
		"oct"=10,
		"nov"=11,
		"dec"=12, 
		"jan"=1, 
		"feb"=2,
        "whole year"=13
)
Hmisc::describe(res$eel_month) %>% html
```

<!--html_preserve--><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<script type="text/javascript">
<!--
    function expand_collapse(id) {
       var e = document.getElementById(id);
       var f = document.getElementById(id+"_earrows");
       if(e.style.display == 'none'){
          e.style.display = 'block';
          f.innerHTML = '&#9650';
       }
       else {
          e.style.display = 'none';
          f.innerHTML = '&#9660';
       }
    }
//-->
</script>
<style>
.earrows {color:silver;font-size:11px;}

fcap {
 font-family: Verdana;
 font-size: 12px;
 color: MidnightBlue
 }

smg {
 font-family: Verdana;
 font-size: 10px;
 color: &#808080;
}

hr.thinhr { margin-top: 0.15em; margin-bottom: 0.15em; }

span.xscript {
position: relative;
}
span.xscript sub {
position: absolute;
left: 0.1em;
bottom: -1ex;
}
</style>
 <span style="font-weight:bold">res$eel_month</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAACgAAAANCAMAAADsQdzaAAAACVBMVEUAAADMzMz////1iUV5AAAAPElEQVQokWNgJAYwMDAyMOECDAwgBGeA2AwM6CoQksgIoZc4hcj2EFKITwjoH7CfUBEWIRJMHAoKifQ1AArWAbM+h691AAAAAElFTkSuQmCC" alt="image" /></div> <style>
 .hmisctable547245 {
 border: none;
 font-size: 85%;
 }
 .hmisctable547245 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable547245 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable547245">
 <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th><th>.05</th><th>.10</th><th>.25</th><th>.50</th><th>.75</th><th>.90</th><th>.95</th></tr>
 <tr><td>14193</td><td>0</td><td>13</td><td>0.994</td><td>7.306</td><td>4.429</td><td> 1</td><td> 2</td><td> 4</td><td> 8</td><td>11</td><td>12</td><td>13</td></tr>
 </table>
 <pre style="font-size:85%;">
 Value          1     2     3     4     5     6     7     8     9    10    11    12
 Frequency   1143  1104  1057   849   822   871  1086  1112  1203  1232  1150  1185
 Proportion 0.081 0.078 0.074 0.060 0.058 0.061 0.077 0.078 0.085 0.087 0.081 0.083
                 
 Value         13
 Frequency   1379
 Proportion 0.097
 </pre>
<!--/html_preserve-->

```r
# number of data per emu
#res %>% mutate("freq"=1) %>% filter(eel_year>2000 & eel_year<2019) %>%
#xtabs ( formula=freq ~ eel_year + eel_month +eel_emu_nameshort)


res <- res[order(res$eel_typ_name,res$eel_emu_nameshort, res$eel_year, res$eel_month,res$eel_lfs_code,res$eel_hty_code),]
res$id <- 1:nrow(res)

# checking for duplicates; These have sereral values for one stage (means that they have more than 2 habitats types

res %>% mutate("freq"=1) %>% filter(eel_year>2000 & eel_year<2019) %>%
		xtabs ( formula=freq ~ eel_typ_name + eel_year + eel_month +eel_emu_nameshort +eel_lfs_code)%>%
		as.data.frame() %>% filter(Freq>2)%>% kable()%>% kable_styling() %>%
		scroll_box(width = "500px", height = "200px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:200px; overflow-x: scroll; width:500px; "><table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_typ_name </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_year </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_month </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_emu_nameshort </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_lfs_code </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Freq </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Elbe </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> DE_Wese </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> DE_Wese </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
</tbody>
</table></div>

```r
# temporarily dropping those files
# res <-res%>%filter(!eel_emu_nameshort%in% c('PL_Oder','PL_Vist'))

# SEARCHING FOR DUPLICATES-----------------------------------------------------------

duplicates <- res %>% mutate("freq"=1) %>% filter(eel_year>2000 & eel_year<2019) %>%
		xtabs ( formula=freq ~ eel_year + eel_month +eel_emu_nameshort +eel_lfs_code+eel_hty_code+eel_typ_name)%>%
		as.data.frame() %>% filter(Freq>1)

kable(duplicates)%>% kable_styling() %>%
		scroll_box(width = "500px", height = "200px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:200px; overflow-x: scroll; width:500px; "><table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_year </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_month </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_emu_nameshort </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_lfs_code </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_hty_code </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> eel_typ_name </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Freq </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 13 </td>
   <td style="text-align:left;"> FR_Cors </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> FT </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 13 </td>
   <td style="text-align:left;"> FR_Cors </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> FT </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 13 </td>
   <td style="text-align:left;"> FR_Cors </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> FT </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 13 </td>
   <td style="text-align:left;"> FR_Cors </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> FT </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 13 </td>
   <td style="text-align:left;"> FR_Cors </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> FT </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 13 </td>
   <td style="text-align:left;"> FR_Cors </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> FT </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 13 </td>
   <td style="text-align:left;"> FR_Cors </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> FT </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 13 </td>
   <td style="text-align:left;"> FR_Cors </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> FT </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Gali </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> FTC </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> ES_Astu </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> com_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> ES_Basq </td>
   <td style="text-align:left;"> G </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> NO_total </td>
   <td style="text-align:left;"> YS </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> rec_closure </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
</tbody>
</table></div>

```r
colnames(res) <-gsub("eel_","",colnames(res))



# mycolumn="hty_code";mydata=res
nicetable <- function(mydata, mycolumn){
  ta <- table(mydata[,mycolumn]) %>% t()
  kable(ta)
}
nicetable(res,"fishery_closure_type")
```

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> PS </th>
   <th style="text-align:right;"> PT </th>
   <th style="text-align:right;"> PTS </th>
   <th style="text-align:right;"> T </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1550 </td>
   <td style="text-align:right;"> 975 </td>
   <td style="text-align:right;"> 1237 </td>
   <td style="text-align:right;"> 8370 </td>
  </tr>
</tbody>
</table>

```r
nicetable(res,"emu_nameshort")
```

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> BE_Sche </th>
   <th style="text-align:right;"> DE_Eide </th>
   <th style="text-align:right;"> DE_Elbe </th>
   <th style="text-align:right;"> DE_Ems </th>
   <th style="text-align:right;"> DE_Rhei </th>
   <th style="text-align:right;"> DE_Schl </th>
   <th style="text-align:right;"> DE_Warn </th>
   <th style="text-align:right;"> DE_Wese </th>
   <th style="text-align:right;"> DK_Inla </th>
   <th style="text-align:right;"> DK_total </th>
   <th style="text-align:right;"> ES_Astu </th>
   <th style="text-align:right;"> ES_Basq </th>
   <th style="text-align:right;"> ES_Cant </th>
   <th style="text-align:right;"> ES_Cata </th>
   <th style="text-align:right;"> ES_Gali </th>
   <th style="text-align:right;"> ES_Minh </th>
   <th style="text-align:right;"> ES_Mino </th>
   <th style="text-align:right;"> ES_Murc </th>
   <th style="text-align:right;"> ES_Vale </th>
   <th style="text-align:right;"> FR_Adou </th>
   <th style="text-align:right;"> FR_Arto </th>
   <th style="text-align:right;"> FR_Bret </th>
   <th style="text-align:right;"> FR_Cors </th>
   <th style="text-align:right;"> FR_Garo </th>
   <th style="text-align:right;"> FR_Loir </th>
   <th style="text-align:right;"> FR_Meus </th>
   <th style="text-align:right;"> FR_Rhin </th>
   <th style="text-align:right;"> FR_Rhon </th>
   <th style="text-align:right;"> FR_Sein </th>
   <th style="text-align:right;"> FR_total </th>
   <th style="text-align:right;"> GB_Angl </th>
   <th style="text-align:right;"> GB_Dee </th>
   <th style="text-align:right;"> GB_Humb </th>
   <th style="text-align:right;"> GB_Neag </th>
   <th style="text-align:right;"> GB_NorE </th>
   <th style="text-align:right;"> GB_Nort </th>
   <th style="text-align:right;"> GB_NorW </th>
   <th style="text-align:right;"> GB_Scot </th>
   <th style="text-align:right;"> GB_Seve </th>
   <th style="text-align:right;"> GB_Solw </th>
   <th style="text-align:right;"> GB_SouE </th>
   <th style="text-align:right;"> GB_SouW </th>
   <th style="text-align:right;"> GB_Tham </th>
   <th style="text-align:right;"> GB_Wale </th>
   <th style="text-align:right;"> GR_total </th>
   <th style="text-align:right;"> IE_NorW </th>
   <th style="text-align:right;"> IE_total </th>
   <th style="text-align:right;"> IT_Emil </th>
   <th style="text-align:right;"> IT_Frio </th>
   <th style="text-align:right;"> IT_Lazi </th>
   <th style="text-align:right;"> IT_Lomb </th>
   <th style="text-align:right;"> IT_Sard </th>
   <th style="text-align:right;"> IT_Umbr </th>
   <th style="text-align:right;"> IT_Vene </th>
   <th style="text-align:right;"> LT_total </th>
   <th style="text-align:right;"> LV_Latv </th>
   <th style="text-align:right;"> NL_Neth </th>
   <th style="text-align:right;"> NO_total </th>
   <th style="text-align:right;"> PL_Oder </th>
   <th style="text-align:right;"> PL_total </th>
   <th style="text-align:right;"> PL_Vist </th>
   <th style="text-align:right;"> PT_port </th>
   <th style="text-align:right;"> PT_Port </th>
   <th style="text-align:right;"> PT_total </th>
   <th style="text-align:right;"> SE_East </th>
   <th style="text-align:right;"> SE_West </th>
   <th style="text-align:right;"> VA_total </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 75 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:right;"> 240 </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 78 </td>
   <td style="text-align:right;"> 148 </td>
   <td style="text-align:right;"> 152 </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 147 </td>
   <td style="text-align:right;"> 162 </td>
   <td style="text-align:right;"> 247 </td>
   <td style="text-align:right;"> 320 </td>
   <td style="text-align:right;"> 358 </td>
   <td style="text-align:right;"> 209 </td>
   <td style="text-align:right;"> 75 </td>
   <td style="text-align:right;"> 85 </td>
   <td style="text-align:right;"> 164 </td>
   <td style="text-align:right;"> 889 </td>
   <td style="text-align:right;"> 860 </td>
   <td style="text-align:right;"> 839 </td>
   <td style="text-align:right;"> 384 </td>
   <td style="text-align:right;"> 1245 </td>
   <td style="text-align:right;"> 623 </td>
   <td style="text-align:right;"> 162 </td>
   <td style="text-align:right;"> 252 </td>
   <td style="text-align:right;"> 481 </td>
   <td style="text-align:right;"> 855 </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 66 </td>
   <td style="text-align:right;"> 156 </td>
   <td style="text-align:right;"> 66 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 36 </td>
   <td style="text-align:right;"> 186 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 126 </td>
   <td style="text-align:right;"> 36 </td>
   <td style="text-align:right;"> 66 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 86 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 67 </td>
   <td style="text-align:right;"> 21 </td>
   <td style="text-align:right;"> 79 </td>
   <td style="text-align:right;"> 242 </td>
   <td style="text-align:right;"> 257 </td>
   <td style="text-align:right;"> 317 </td>
   <td style="text-align:right;"> 246 </td>
   <td style="text-align:right;"> 366 </td>
   <td style="text-align:right;"> 304 </td>
   <td style="text-align:right;"> 282 </td>
   <td style="text-align:right;"> 480 </td>
   <td style="text-align:right;"> 79 </td>
   <td style="text-align:right;"> 61 </td>
   <td style="text-align:right;"> 480 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 132 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 105 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
</tbody>
</table>

```r
nicetable(res,"month")
```

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> 1 </th>
   <th style="text-align:right;"> 2 </th>
   <th style="text-align:right;"> 3 </th>
   <th style="text-align:right;"> 4 </th>
   <th style="text-align:right;"> 5 </th>
   <th style="text-align:right;"> 6 </th>
   <th style="text-align:right;"> 7 </th>
   <th style="text-align:right;"> 8 </th>
   <th style="text-align:right;"> 9 </th>
   <th style="text-align:right;"> 10 </th>
   <th style="text-align:right;"> 11 </th>
   <th style="text-align:right;"> 12 </th>
   <th style="text-align:right;"> 13 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1143 </td>
   <td style="text-align:right;"> 1104 </td>
   <td style="text-align:right;"> 1057 </td>
   <td style="text-align:right;"> 849 </td>
   <td style="text-align:right;"> 822 </td>
   <td style="text-align:right;"> 871 </td>
   <td style="text-align:right;"> 1086 </td>
   <td style="text-align:right;"> 1112 </td>
   <td style="text-align:right;"> 1203 </td>
   <td style="text-align:right;"> 1232 </td>
   <td style="text-align:right;"> 1150 </td>
   <td style="text-align:right;"> 1185 </td>
   <td style="text-align:right;"> 1379 </td>
  </tr>
</tbody>
</table>

```r
nicetable(res,"hty_code")
```

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> C </th>
   <th style="text-align:right;"> F </th>
   <th style="text-align:right;"> FC </th>
   <th style="text-align:right;"> FT </th>
   <th style="text-align:right;"> FTC </th>
   <th style="text-align:right;"> MO </th>
   <th style="text-align:right;"> T </th>
   <th style="text-align:right;"> TC </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 240 </td>
   <td style="text-align:right;"> 4954 </td>
   <td style="text-align:right;"> 28 </td>
   <td style="text-align:right;"> 3016 </td>
   <td style="text-align:right;"> 1042 </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 4767 </td>
   <td style="text-align:right;"> 90 </td>
  </tr>
</tbody>
</table>

```r
describe(res$fishery_closure_percent)%>%html()
```

<!--html_preserve--><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<script type="text/javascript">
<!--
    function expand_collapse(id) {
       var e = document.getElementById(id);
       var f = document.getElementById(id+"_earrows");
       if(e.style.display == 'none'){
          e.style.display = 'block';
          f.innerHTML = '&#9650';
       }
       else {
          e.style.display = 'none';
          f.innerHTML = '&#9660';
       }
    }
//-->
</script>
<style>
.earrows {color:silver;font-size:11px;}

fcap {
 font-family: Verdana;
 font-size: 12px;
 color: MidnightBlue
 }

smg {
 font-family: Verdana;
 font-size: 10px;
 color: &#808080;
}

hr.thinhr { margin-top: 0.15em; margin-bottom: 0.15em; }

span.xscript {
position: relative;
}
span.xscript sub {
position: absolute;
left: 0.1em;
bottom: -1ex;
}
</style>
 <span style="font-weight:bold">res$fishery_closure_percent</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
iVBORw0KGgoAAAANSUhEUgAAAJcAAAANCAMAAACTvAxuAAAACVBMVEUAAADMzMz////1iUV5AAAAZUlEQVQ4je1T0QoAEAw8/v+jZbsJeaD2MHJl6uJ2sUMKB6CWHA6onr6vbXxfZ1BfnP9AsDwi2JvZP77uy1XnHl9L+Z2evr5k/iWRtjGfpHUNZ6AEaSpALjLeHTfTyXo04UaytZQCXGMM+v08ajcAAAAASUVORK5CYII=" alt="image" /></div> <style>
 .hmisctable541339 {
 border: none;
 font-size: 85%;
 }
 .hmisctable541339 td {
 text-align: center;
 padding: 0 1ex 0 1ex;
 }
 .hmisctable541339 th {
 color: MidnightBlue;
 text-align: center;
 padding: 0 1ex 0 1ex;
 font-weight: normal;
 }
 </style>
 <table class="hmisctable541339">
 <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th><th>.05</th><th>.10</th><th>.25</th><th>.50</th><th>.75</th><th>.90</th><th>.95</th></tr>
 <tr><td>9757</td><td>4436</td><td>61</td><td>0.916</td><td>57.8</td><td>46.1</td><td>  0</td><td>  0</td><td> 10</td><td> 55</td><td>100</td><td>100</td><td>100</td></tr>
 </table>
 <span style="font-size: 85%;"><font color="MidnightBlue">lowest</font> :   0   1   5   6  10 ,  <font color="MidnightBlue">highest</font>:  94  95  96  97 100</span><!--/html_preserve-->

```r
save(res,file=str_c(datawd,"res_closure.Rdata"))
```



```r
load(file=str_c(datawd,"res_landings.Rdata"))

#  before correction this table had a lot of values in red (duplicates)
res %>%	group_by(emu_nameshort,lfs_code,hty_code,year,month) %>%
		summarize(N=n()) %>% 
		mutate(N = cell_spec(N, "html", color = ifelse(N > 1, "red", "black"),bold=ifelse(N > 1, T, F)))%>%
		pivot_wider(names_from="month",values_from="N")%>%
		kable(escape = F, align = "c") %>%
		kable_styling(c("striped", "condensed"), full_width = F)%>%
		scroll_box(width = "600px", height = "400px")

# groups with all zero for one year 
# for later reuse (remove those series)
all_zero <- res %>%	group_by(emu_nameshort,lfs_code,hty_code,year) %>%
		summarize(S=sum(value)) %>% 
    filter(S==0)
# table
all_zero %>%
		kable(escape = F, align = "c") %>%
		kable_styling(c("striped", "condensed"), full_width = F)%>%
		scroll_box(width = "600px", height = "400px")
```



Empty graphs correspond to all zero values reported for one year, those values are now removed

# Silver eels


<!--  -->
<!-- # Glass eel -->
<!--  -->
<!-- ```{r g, echo=TRUE, include=TRUE} -->
<!-- res %>% filter(lfs_code=="G") %>% select(hty_code) %>% distinct() -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'G', -->
<!-- 			hty = c("T"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "tomato1")	 -->
<!-- } -->
<!--  -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'G', -->
<!-- 			hty = c("F"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "violetred")	 -->
<!-- } -->
<!--  -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'G', -->
<!-- 			hty = c("FTC"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "firebrick")	 -->
<!-- } -->
<!--  -->
<!-- ``` -->
<!--  -->
<!--  -->
<!-- # Yellow -->
<!--  -->
<!-- ```{r y, echo=TRUE, include=TRUE} -->
<!-- res %>% filter(lfs_code=="Y") %>% select(hty_code) %>% distinct() -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'Y', -->
<!-- 			hty = c("C"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "green")	 -->
<!-- } -->
<!--  -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'Y', -->
<!-- 			hty = c("F"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "greenyellow")	 -->
<!-- } -->
<!--  -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'Y', -->
<!-- 			hty = c("T"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "limegreen")	 -->
<!-- } -->
<!--  -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'Y', -->
<!-- 			hty = c("MO"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "olivedrab")	 -->
<!-- } -->
<!--  -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'Y', -->
<!-- 			hty = c("FTC"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "springgreen")	 -->
<!-- } -->
<!--  -->
<!-- ``` -->
<!--  -->
<!-- # Yellow silver -->
<!--  -->
<!-- ```{r ys, echo=TRUE, include=TRUE} -->
<!-- res %>% filter(lfs_code=="YS") %>% select(hty_code) %>% distinct() -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'YS', -->
<!-- 			hty = c("C"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "plum")	 -->
<!-- } -->
<!--  -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'YS', -->
<!-- 			hty = c("F"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "purple")	 -->
<!-- } -->
<!--  -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'YS', -->
<!-- 			hty = c("T"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "magenta")	 -->
<!-- } -->
<!--  -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'YS', -->
<!-- 			hty = c("FTC"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "violet")	 -->
<!-- } -->
<!--  -->
<!-- for (the_emu in unique(res$emu_nameshort)){ -->
<!-- 	fnplot(lfs = 'YS', -->
<!-- 			hty = c("TC"), -->
<!-- 			emu=the_emu,  -->
<!-- 			colfill= "hotpink")	 -->
<!-- } -->
<!-- ``` -->
