---
title: "WKEELMIGRATION scientific litterature review"
date: "february 2020"
output: 
  html_document:
    keep_md: true
---


 
 



 
 
 ```r
 load(file=str_c(datawd,'sea.Rdata'))
 describe(sea)%>%html
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
  <font color="MidnightBlue"><div align=center><span style="font-weight:bold">sea <br><br> 38  Variables   65  Observations</span></div></font> <hr class="thinhr"> <span style="font-weight:bold">Year of publication</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAADEAAAANCAMAAAA3+nb4AAAACVBMVEUAAADMzMz////1iUV5AAAANklEQVQokWNgJAUwMDAwMjCRAoA6mIaNDqDvSQwrBlJsgdpBvHKa62CAAPJ0EAodYPBAGWAOACobA+nhC6sWAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable493106 {
  border: none;
  font-size: 85%;
  }
  .hmisctable493106 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable493106 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable493106">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th><th>.05</th><th>.10</th><th>.25</th><th>.50</th><th>.75</th><th>.90</th><th>.95</th></tr>
  <tr><td>65</td><td>0</td><td>16</td><td>0.97</td><td>2001</td><td>26.18</td><td>1920</td><td>1920</td><td>2008</td><td>2016</td><td>2018</td><td>2018</td><td>2018</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value       1920  1984  1986  1988  1990  1995  2003  2005  2008  2009  2012  2014
  Frequency      8     1     1     1     1     1     1     1     3     5     3     1
  Proportion 0.123 0.015 0.015 0.015 0.015 0.015 0.015 0.015 0.046 0.077 0.046 0.015
                                    
  Value       2016  2017  2018  2019
  Frequency     16     5    15     2
  Proportion 0.246 0.077 0.231 0.031
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Type</span> <style>
  .hmisctable583455 {
  border: none;
  font-size: 85%;
  }
  .hmisctable583455 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable583455 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable583455">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>65</td><td>0</td><td>2</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value      Master Degree thesis                paper
  Frequency                     1                   64
  Proportion                0.015                0.985
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Reference</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAGEAAAANCAMAAACO7vCwAAAACVBMVEUAAADMzMz////1iUV5AAAASElEQVQ4jWNghAAGBkYaAQYmCGCAMagOBpcN5LliWNhAQloiL70Ni1Ai2wZi7WOAqqSBDQwQsxmgDKIRicpBaYmBNESickZGAJB+B543hbroAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable436297 {
  border: none;
  font-size: 85%;
  }
  .hmisctable436297 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable436297 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable436297">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>56</td><td>9</td><td>32</td></tr>
  </table>
  <style>
  .hmisctable939802 {
  border: none;
  font-size: 85%;
  }
  .hmisctable939802 td {
  text-align: right;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable939802 th {
  color: Black;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: bold;
  }
  </style>
  <table class="hmisctable939802">
  <tr><td><font color="MidnightBlue">lowest</font> :</td><td>ABDALHAMID, A. H., RAMADAN, A. A., Mohamed, E., SAYED, M. A., & ELAWAD, A. N. (2018). Study of some ecological and biological parameters on European eel Anguilla anguilla in Umm Hufayan brackish lagoon, Eastern Libya Mediterranean Sea. Bulletin de l’Institut Scientifique, Rabat, (40), 23-30.   </td><td>Amilhat, E., Farrugio, H., Lecomte-Finiger, R., Simon, G., & Sasal, P. (2009). Silver eel population size and escapement in a Mediterranean lagoon: Bages-Sigean, France. Knowledge and Management of Aquatic Ecosystems, (390-391), 05.                                                               </td><td>Aranburu, A., Díaz, E., & Briand, C. (2016). Glass eel recruitment and exploitation in a South European estuary (Oria, Bay of Biscay). ICES Journal of Marine Science, 73(1), 111-121.                                                                                                                 </td><td>Arribas, C., Fernández-Delgado, C., Oliva-Paterna, F. J., & Drake, P. (2012). Oceanic and local environmental conditions as forcing mechanisms of the glass eel recruitment to the southernmost European estuary. Estuarine, Coastal and Shelf Science, 107, 46-57.                                    </td><td>Aschonitis, V. G., Castaldelli, G., Lanzoni, M., Merighi, M., Gelli, F., Giari, L., ... & Fano, E. A. (2017). A size-age model based on bootstrapping and Bayesian approaches to assess population dynamics of Anguilla anguilla L. in semi-closed lagoons. Ecology of Freshwater Fish, 26(2), 217-232.</td></tr>
  <tr><td><font color="MidnightBlue">highest</font>:</td><td>Tosunoglu, Z., Kaykac, M. H., & Ünal, V. (2017). Temporal alterations of fishery landings in coastal lagoons along the Aegean coast of Turkey. Turkish Journal of Fisheries and Aquatic Sciences, 17(7), 1441-1448.                                                                                    </td><td>Verbiest, H., Breukelaar, A., Ovidio, M., Philippart, J. C., & Belpaire, C. (2012). Escapement success and patterns of downstream migration of female silver eel Anguilla anguilla in the River Meuse. Ecology of Freshwater Fish, 21(3), 395-403.                                                     </td><td>Vøllestad, L. A., Jonsson, B., Hvidsten, N. A., Næsje, T. F., Haraldstad, Ø., & Ruud-Hansen, J. (1986). Environmental factors regulating the seaward migration of European silver eels (Anguilla anguilla). Canadian Journal of Fisheries and Aquatic Sciences, 43(10), 1909-1916.                     </td><td>Walmsley, S., Bremner, J., Walker, A., Barry, J., & Maxwell, D. (2018). Challenges to quantifying glass eel abundance from large and dynamic estuaries. ICES Journal of Marine Science, 75(2), 727-737.                                                                                                </td><td>Zompola, S., Katselis, G., Koutsikopoulos, C., & Cladas, Y. (2008). Temporal patterns of glass eel migration (Anguilla anguilla L. 1758) in relation to environmental factors in the Western Greek inland waters. Estuarine, Coastal and Shelf Science, 80(3), 330-338.                                </td></tr>
  </table>
  <hr class="thinhr"> <span style="font-weight:bold">Area FAO</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAACsAAAANCAMAAAAHdmfZAAAACVBMVEUAAADMzMz////1iUV5AAAATklEQVQokb2Q0Q4AIARFr/7/o2Mlxli9ZGY3TgVQb4DTozc4oGYXVbK+8JOtht6Hcg/2CKvrHjIrmXc2frjYc0MziKzEwKrmQUEpwpxUTLy8AxIO+sloAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable815676 {
  border: none;
  font-size: 85%;
  }
  .hmisctable815676 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable815676 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable815676">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>65</td><td>0</td><td>14</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value       27.3.d 27.3.d.  27.4.a  27.4.b  27.4.c  27.7.b  27.7.j  27.8.b  27.8.c
  Frequency        2       1       3       1      11       1       2       6      12
  Proportion   0.031   0.015   0.046   0.015   0.169   0.015   0.031   0.092   0.185
                                                    
  Value       27.9.a  37.1.3  37.2.1  37.2.2  37.3.1
  Frequency        3      15       1       2       5
  Proportion   0.046   0.231   0.015   0.031   0.077
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Country</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAADQAAAANCAMAAADR0728AAAACVBMVEUAAADMzMz////1iUV5AAAAS0lEQVQokWNgxAAMDJhiqKIMTBiAAYsYqiglmlCEBpMmLGFDVOgBDSHdeZRpQiYp0QTnoLqFgQkZobsWixBYEyMyYkRiQDkoQmAEAIbdA+AUf5yJAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable511775 {
  border: none;
  font-size: 85%;
  }
  .hmisctable511775 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable511775 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable511775">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>65</td><td>0</td><td>17</td></tr>
  </table>
   Belgium (2, 0.031), France (6, 0.092), Germany (10, 0.154), Great Britain (2, 0.031), Greece (4, 0.062), Ireland (1, 0.015), Italy (14, 0.215), Libya (2, 0.031), Lithuania (1, 0.015), Montenegro (1, 0.015), Norway (3, 0.046), Poland (1, 0.015), Portugal (2, 0.031), Spain (13, 0.200), Sweden (1, 0.015), Tunisia (1, 0.015), Turchia (1, 0.015) <hr class="thinhr"> <span style="font-weight:bold">EMU</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAEwAAAANCAMAAAA0TXjQAAAACVBMVEUAAADMzMz////1iUV5AAAAUklEQVQokWNgRAUMDIw4AT45iAImVMCALkCkHEQBDQyDqxuuhqFFFDViczB6E5dhWHSiCWGqwGIYhA1hwLlYLEImYeIMTMQgohQBDWMkBhGlCAAdUQWpGMTHQgAAAABJRU5ErkJggg==" alt="image" /></div> <style>
  .hmisctable505269 {
  border: none;
  font-size: 85%;
  }
  .hmisctable505269 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable505269 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable505269">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>65</td><td>0</td><td>25</td></tr>
  </table>
  <span style="font-size: 85%;"><font color="MidnightBlue">lowest</font> : BE_Meus  BE_Sche  DE_Ems   DE_Warn  ES_Anda  ,  <font color="MidnightBlue">highest</font>: PL_Vist  PT_Port  SE_East  TN_Total TR_total</span> <hr class="thinhr"> <span style="font-weight:bold">Site</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAGEAAAANCAMAAACO7vCwAAAACVBMVEUAAADMzMz////1iUV5AAAATklEQVQ4jWNgpAAwMBCjiIkCwECM7oGxgSiN2BVi0TosbCA3iWBXiEXrsAglnBqJsIdyGwhZgiYP0YGuiQEhThwiUTkoLTGQhkhUzsgIAFQDB4DQ+CzNAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable962618 {
  border: none;
  font-size: 85%;
  }
  .hmisctable962618 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable962618 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable962618">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>64</td><td>1</td><td>32</td></tr>
  </table>
  <style>
  .hmisctable435525 {
  border: none;
  font-size: 85%;
  }
  .hmisctable435525 td {
  text-align: right;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable435525 th {
  color: Black;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: bold;
  }
  </style>
  <table class="hmisctable435525">
  <tr><td><font color="MidnightBlue">lowest</font> :</td><td>Adour                              </td><td>Alfios                             </td><td>Bages-Sigean                       </td><td>Bojana                             </td><td>Burrishoole                        </td></tr>
  <tr><td><font color="MidnightBlue">highest</font>:</td><td>Umm Hufayan                        </td><td>Vaccares/Grau de la Forcade channel</td><td>Vistonis-Porto Lagos               </td><td>Vistula                            </td><td>Warnow                             </td></tr>
  </table>
  <hr class="thinhr"> <span style="font-weight:bold">Lat</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAB8AAAANCAMAAABmbkWbAAAACVBMVEUAAADMzMz////1iUV5AAAALElEQVQYlWNgxAQMDEhsJkzAgCQ44PJ0cz9ClAh5CAJiCIkihCYPdi8coXMAEpoCVUlB2UYAAAAASUVORK5CYII=" alt="image" /></div> <style>
  .hmisctable820814 {
  border: none;
  font-size: 85%;
  }
  .hmisctable820814 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable820814 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable820814">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>26</td><td>39</td><td>10</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value         36°47'N    37°36'N    39°37'N     41°24’    41°50'N    43.0878
  Frequency           1          1          1          3          1          1
  Proportion      0.038      0.038      0.038      0.115      0.038      0.038
                                                        
  Value         43°29'N    48°32'N    51°40'N 58.903324N
  Frequency          12          2          2          2
  Proportion      0.462      0.077      0.077      0.077
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Lon</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAB8AAAANCAMAAABmbkWbAAAACVBMVEUAAADMzMz////1iUV5AAAAN0lEQVQYlWNgRAIMDIzogIEJCTCg8CBCAy1PB/fDhbHJM8CEgSSKPFwUKgOVR+OAnAzEcITOAQARZgJXawfnDQAAAABJRU5ErkJggg==" alt="image" /></div> <style>
  .hmisctable676835 {
  border: none;
  font-size: 85%;
  }
  .hmisctable676835 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable676835 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable676835">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>26</td><td>39</td><td>10</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value      , 5.963514E      12°54’     19°22'E      2°04'W      2°14'W     20°11'E
  Frequency            2           3           1           2          12           1
  Proportion       0.077       0.115       0.038       0.077       0.462       0.038
                                                            
  Value          21°26'E     3.00487      3°15'W      4°58'W
  Frequency            1           1           2           1
  Proportion       0.038       0.038       0.077       0.038
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">River, lagoon, estuary</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABkAAAANCAMAAABrcDXcAAAACVBMVEUAAADMzMz////1iUV5AAAAKklEQVQYlWNgRAMMDDAGExpggInQTQbNRUhuY0BViaSHbjIgZ4BdhMYCAFIJAepphTZbAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable657984 {
  border: none;
  font-size: 85%;
  }
  .hmisctable657984 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable657984 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable657984">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>65</td><td>0</td><td>8</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value            estuary         fjord        lagoon    lake + sea         marsh
  Frequency             13             1            16             1             1
  Proportion         0.200         0.015         0.246         0.015         0.015
                                                      
  Value              river river estuary rivers-lagoon
  Frequency             31             1             1
  Proportion         0.477         0.015         0.015
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Surface/Catchment area</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAB8AAAANCAMAAABmbkWbAAAACVBMVEUAAADMzMz////1iUV5AAAAOElEQVQYlWNgRAMMDCCE4DKhAQYGEEJwB1qeZu6HknjlGZCMgjLR5RlgQlAJNA7IrRAnQx2OxgEA7A0CKQtEajIAAAAASUVORK5CYII=" alt="image" /></div> <style>
  .hmisctable664555 {
  border: none;
  font-size: 85%;
  }
  .hmisctable664555 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable664555 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable664555">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>39</td><td>26</td><td>10</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value      <U+200E>19582     1,140 km2         57400            60           850
  Frequency              1             1             1             2             1
  Proportion         0.026         0.026         0.026         0.051         0.026
                                                                                  
  Value                888         large  medium large         small    very large
  Frequency             12            13             1             4             3
  Proportion         0.308         0.333         0.026         0.103         0.077
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Distance from sea/length of the channel</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAADcAAAANCAMAAAA65Aa/AAAACVBMVEUAAADMzMz////1iUV5AAAAN0lEQVQokWNgRAUMDIxEAQYmVMCALoADDHt9QyU8kRUC2bTTB1HBAFGLFeGUACMGRlwIpwQQAQCezgRKmnMUngAAAABJRU5ErkJggg==" alt="image" /></div> <style>
  .hmisctable528826 {
  border: none;
  font-size: 85%;
  }
  .hmisctable528826 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable528826 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable528826">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>34</td><td>31</td><td>18</td></tr>
  </table>
   ? (3, 0.088), < 10 km (1, 0.029), < 10 km (1, 0.029), > 20 km (1, 0.029), 0 (3, 0.088), 0-10 km (12, 0.353), 1050 m (1, 0.029), 179 km (1, 0.029), 200 m (1, 0.029), 4.5 (1, 0.029), 500 m (1, 0.029), 6 (1, 0.029), 8-32 km (1, 0.029), 80 km (1, 0.029), 925 km (1, 0.029), all Severn 11.419 km2 (estuary 4.800 km2) (1, 0.029), na (2, 0.059), Severn 11.419 km2, estuary 4.800 km2 (1, 0.029) <hr class="thinhr"> <span style="font-weight:bold">Barrier/sluice/gate</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAB8AAAANCAMAAABmbkWbAAAACVBMVEUAAADMzMz////1iUV5AAAANElEQVQYlWNgRAIMDBCMLMSEBBgYIBhZaKDlaeZ+CIMBWRK3PEQSmzwDkiQWDtTJcITOAQDqSQIpIleEKAAAAABJRU5ErkJggg==" alt="image" /></div> <style>
  .hmisctable186190 {
  border: none;
  font-size: 85%;
  }
  .hmisctable186190 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable186190 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable186190">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>40</td><td>25</td><td>10</td></tr>
  </table>
   barrier (1, 0.025), barrier and fence (1, 0.025), dams (2, 0.050), gate (3, 0.075), n (13, 0.325), N (13, 0.325), na (1, 0.025), sluice/pumps and lavoriero (1, 0.025), Y (4, 0.100), Y (13 sluices) (1, 0.025) <hr class="thinhr"> <span style="font-weight:bold">Other</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABMAAAANCAMAAAB8UqUVAAAACVBMVEUAAADMzMz////1iUV5AAAAMElEQVQYlWNgZGRkYGBEAQxMTEwMIAIJUF2McntRhFHFIBSmGAMDyE4gBlsNoRgYAMJrAWj7Hji4AAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable430601 {
  border: none;
  font-size: 85%;
  }
  .hmisctable430601 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable430601 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable430601">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>26</td><td>39</td><td>6</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value           large     medium      small tidal weir very large very small
  Frequency           1         15          4          1          3          2
  Proportion      0.038      0.577      0.154      0.038      0.115      0.077
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Y/N</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAACVBMVEUAAADMzMz////1iUV5AAAAJElEQVQImWNgRAAGBgYmBCCOB2Jg8MBmwTADXBymkiweA7KZAE7ZAMXkubjzAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable791886 {
  border: none;
  font-size: 85%;
  }
  .hmisctable791886 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable791886 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable791886">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>48</td><td>17</td><td>4</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value          n     N     y     Y
  Frequency      1    11    14    22
  Proportion 0.021 0.229 0.292 0.458
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Management period</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABYAAAANCAMAAACae25RAAAACVBMVEUAAADMzMz////1iUV5AAAAL0lEQVQYlWNgBAMGBkYUwMAEBgxQGgZwCTNQRRjsDAyXMICVYjOEdsJwl4AcA6MA+68Bn7kzgqkAAAAASUVORK5CYII=" alt="image" /></div> <style>
  .hmisctable257319 {
  border: none;
  font-size: 85%;
  }
  .hmisctable257319 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable257319 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable257319">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>65</td><td>0</td><td>7</td></tr>
  </table>
   1990-2007 (20, 0.308), 1990-2007 + post 2007 (13, 0.200), post 2007 (28, 0.431), pre 1990 (1, 0.015), pre 1998 (1, 0.015), pre 1999 (1, 0.015), pre 2000 (1, 0.015) <hr class="thinhr"> <span style="font-weight:bold">Migration type</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAACVBMVEUAAADMzMz////1iUV5AAAAIklEQVQImWNgRAAGBgYmBKCAR7yZDOg8mAgmD2QWyEAQDQBZkwDsERRjJAAAAABJRU5ErkJggg==" alt="image" /></div> <style>
  .hmisctable267755 {
  border: none;
  font-size: 85%;
  }
  .hmisctable267755 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable267755 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable267755">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>65</td><td>0</td><td>4</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value       escapement  Escapement   Migration Recruitment
  Frequency           13           7           1          44
  Proportion       0.200       0.108       0.015       0.677
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Stage</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABwAAAANCAMAAACNWf6YAAAACVBMVEUAAADMzMz////1iUV5AAAAMElEQVQYlWNgRAIMDIwogIEJCTCg8ID8gZAk1bVwA2grCeFjSIIcyAB2J4SEc4AYALDaAjXCHhY3AAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable300819 {
  border: none;
  font-size: 85%;
  }
  .hmisctable300819 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable300819 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable300819">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>62</td><td>3</td><td>9</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value          BL      E   E/BT      G     GE GE/E/Y      S     SY     YS
  Frequency       1      1      5      1     35      2     14      2      1
  Proportion  0.016  0.016  0.081  0.016  0.565  0.032  0.226  0.032  0.016
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Data type</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAB8AAAANCAMAAABmbkWbAAAACVBMVEUAAADMzMz////1iUV5AAAAQklEQVQYlWNgBAMGBgSJAhiYwICBAUGiAHLkgRRcJYY8RJJ4eXT3AzEE4XA/FvPhfIrkoaIo8gwMKEJYOChOxsIBAK0SAdetQ7xDAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable583388 {
  border: none;
  font-size: 85%;
  }
  .hmisctable583388 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable583388 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable583388">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>60</td><td>5</td><td>10</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value            catch        cpue cpue (kg/h)       g/day          kg           n
  Frequency            1           4          12           2          12           8
  Proportion       0.017       0.067       0.200       0.033       0.200       0.133
                                                            
  Value                N      N/hour    N/volume      number
  Frequency            9           9           1           2
  Proportion       0.150       0.150       0.017       0.033
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Data frequency</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAB8AAAANCAMAAABmbkWbAAAACVBMVEUAAADMzMz////1iUV5AAAAPElEQVQYlWNgBAMGBhDCAhiYwICBAYSwgAGXp6b7sShhQJaEyiOUMTCA2NjlITIY8mgckKshjod6AY0DAOGbAhdUznRtAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable260785 {
  border: none;
  font-size: 85%;
  }
  .hmisctable260785 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable260785 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable260785">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>44</td><td>21</td><td>10</td></tr>
  </table>
   3 days (average) (2, 0.045), annually (3, 0.068), daily (13, 0.295), daily (new and full moon) (12, 0.273), daily/weekly (4, 0.091), monthly (new moon) (1, 0.023), montly (3, 0.068), occasional (1, 0.023), occasional sampling (chosen based on info on recruitment start) (2, 0.045), seasonal (3, 0.068) <hr class="thinhr"> <span style="font-weight:bold">Monitoring typology</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAACUAAAANCAMAAAAZv1dqAAAACVBMVEUAAADMzMz////1iUV5AAAASElEQVQYlbWPQQoAMAjDWv//6CEd6jzMkyKjslAISAIcBmYGf76zQHWw3ROlADlKM2Uj3Y/alY29a4WKfWwmKusBd5BjbE33PrVKAoYplSmHAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable535086 {
  border: none;
  font-size: 85%;
  }
  .hmisctable535086 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable535086 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable535086">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>62</td><td>3</td><td>12</td></tr>
  </table>
   Collaboration with fisheries (1, 0.016), Experimental fishing (14, 0.226), fishery (9, 0.145), fishery dependend (3, 0.048), fishery dependent (7, 0.113), Scientific (3, 0.048), scientific (device) (3, 0.048), Scientific (hauling) (9, 0.145), Scientific (tows) (2, 0.032), scientific fishing (1, 0.016), scientific monitoring (8, 0.129), Trap (2, 0.032) <hr class="thinhr"> <span style="font-weight:bold">Gear</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAADQAAAANCAMAAADR0728AAAACVBMVEUAAADMzMz////1iUV5AAAAOklEQVQokWNgxAAMDJhiqBIMTBiAAYsYqsSw1DQUQw+7PrgEAwqHAUMTVgkGCAsrwikB1MSIC+GUAACoFwPTPq4i5QAAAABJRU5ErkJggg==" alt="image" /></div> <style>
  .hmisctable506216 {
  border: none;
  font-size: 85%;
  }
  .hmisctable506216 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable506216 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable506216">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>48</td><td>17</td><td>17</td></tr>
  </table>
  <style>
  .hmisctable151129 {
  border: none;
  font-size: 85%;
  }
  .hmisctable151129 td {
  text-align: right;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable151129 th {
  color: Black;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: bold;
  }
  </style>
  <table class="hmisctable151129">
  <tr><td><font color="MidnightBlue">lowest</font> :</td><td>?                    </td><td>1.4 m2 midwater trawl</td><td>barrier + fyke net   </td><td>entrapment device    </td><td>Fike-net             </td></tr>
  <tr><td><font color="MidnightBlue">highest</font>:</td><td>pound nets           </td><td>stow net system      </td><td>trawl 1.4 m diameter </td><td>Tubes                </td><td>wolf trap            </td></tr>
  </table>
  <hr class="thinhr"> <span style="font-weight:bold">Year/s of observation</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAIIAAAANCAMAAABSO0bCAAAACVBMVEUAAADMzMz////1iUV5AAAAaElEQVQ4jWNgpAtgYMAjx0QXwIDHnmHpBLhtQAYEjTqBGCeQlqDRGDAucoKHy8ARmiB5OQLZZ8gMGBfZk3AZzFCAc1ENHxROQFbNwIDKI4hIVI6pY9QJUCegJl6QCkZSEInKMXUwMgIAp0AIjQajoYAAAAAASUVORK5CYII=" alt="image" /></div> <style>
  .hmisctable186682 {
  border: none;
  font-size: 85%;
  }
  .hmisctable186682 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable186682 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable186682">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>62</td><td>3</td><td>43</td></tr>
  </table>
  <style>
  .hmisctable755453 {
  border: none;
  font-size: 85%;
  }
  .hmisctable755453 td {
  text-align: right;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable755453 th {
  color: Black;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: bold;
  }
  </style>
  <table class="hmisctable755453">
  <tr><td><font color="MidnightBlue">lowest</font> :</td><td>1922                       </td><td>1923                       </td><td>1924                       </td><td>1925                       </td><td>1926                       </td></tr>
  <tr><td><font color="MidnightBlue">highest</font>:</td><td>dic 2013-feb 2014          </td><td>gen 2013 (season 2012-2013)</td><td>may 2014-oct 2014          </td><td>nov 1979-feb 1981          </td><td>oct 2009-jan 2010          </td></tr>
  </table>
  <hr class="thinhr"> <span style="font-weight:bold">Jan</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABwAAAANCAMAAACNWf6YAAAACVBMVEUAAADMzMz////1iUV5AAAAM0lEQVQYlWNgxAQMDDAGEyZggAnikWRgoJUkbtcyoGqFa4HppJUkWAGEj10S6kC4M6EUAJNZAfwCLoJ6AAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable882597 {
  border: none;
  font-size: 85%;
  }
  .hmisctable882597 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable882597 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable882597">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th></tr>
  <tr><td>31</td><td>34</td><td>9</td><td>0.946</td><td>2.325</td><td>1.68</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value      0.00000000 0.02631579 0.06620393 0.36364061 0.63387755 1.00000000
  Frequency           4          1          1          1          1          1
  Proportion      0.129      0.032      0.032      0.032      0.032      0.032
                                             
  Value      2.00000000 3.00000000 4.00000000
  Frequency           4         10          8
  Proportion      0.129      0.323      0.258
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Feb</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABkAAAANCAMAAABrcDXcAAAACVBMVEUAAADMzMz////1iUV5AAAAOUlEQVQYlWNgBAMGBkZGNBYDExgwQGkkFmkyEA5ZMljcBuGg6oFowGYaigwDeTIIPjIL5A6Ic9BZACMdAZF6pmF2AAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable953875 {
  border: none;
  font-size: 85%;
  }
  .hmisctable953875 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable953875 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable953875">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>27</td><td>38</td><td>8</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value                        0 0.12625955862885266                   1
  Frequency                    2                   1                   7
  Proportion               0.074               0.037               0.259
                                                                        
  Value                 1 (n493)                   2                   3
  Frequency                    1                   3                   7
  Proportion               0.037               0.111               0.259
                                                    
  Value                        4          4 (n 1717)
  Frequency                    5                   1
  Proportion               0.185               0.037
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Mar</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABMAAAANCAMAAAB8UqUVAAAACVBMVEUAAADMzMz////1iUV5AAAAJklEQVQYlWNgYMQADAxMGID6YgwYNoPEsKlDN4IBBkgWY0AAJFsBwsgBWsFOKBQAAAAASUVORK5CYII=" alt="image" /></div> <style>
  .hmisctable672321 {
  border: none;
  font-size: 85%;
  }
  .hmisctable672321 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable672321 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable672321">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th></tr>
  <tr><td>20</td><td>45</td><td>6</td><td>0.925</td><td>1.8</td><td>2.389</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value         0    1    2    3    4   10
  Frequency     8    4    2    2    3    1
  Proportion 0.40 0.20 0.10 0.10 0.15 0.05
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Apr</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABkAAAANCAMAAABrcDXcAAAACVBMVEUAAADMzMz////1iUV5AAAAJ0lEQVQYlWNgYMQBGBiYcAD6yeBzGzZ9DAw0kYEgFBbIbUAMQSgsAFseAd+mUdMjAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable808234 {
  border: none;
  font-size: 85%;
  }
  .hmisctable808234 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable808234 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable808234">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>28</td><td>37</td><td>8</td></tr>
  </table>
   0 (13, 0.464), 1 (5, 0.179), 2 (1, 0.036), 2 (n 334) (1, 0.036), 2.6315789473684209E-2 (1, 0.036), 20 (1, 0.036), 3 (1, 0.036), 4 (5, 0.179) <hr class="thinhr"> <span style="font-weight:bold">May</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABYAAAANCAMAAACae25RAAAACVBMVEUAAADMzMz////1iUV5AAAAJElEQVQYlWNgYGDEAhgYGJiwABoL09IlDDAWiiBOYZjlSO4AAAhuAbQt1UsjAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable472880 {
  border: none;
  font-size: 85%;
  }
  .hmisctable472880 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable472880 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable472880">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th></tr>
  <tr><td>15</td><td>50</td><td>7</td><td>0.929</td><td>6.467</td><td>10.02</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value          0     1     2     3     4    25    50
  Frequency      2     3     6     1     1     1     1
  Proportion 0.133 0.200 0.400 0.067 0.067 0.067 0.067
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">June</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABAAAAANCAMAAACXZR4WAAAACVBMVEUAAADMzMz////1iUV5AAAAIklEQVQImWNgYEQFDAxMqIA6AgzotjBgqKBIgAECUGxgAACRXQFCH6aO0QAAAABJRU5ErkJggg==" alt="image" /></div> <style>
  .hmisctable338939 {
  border: none;
  font-size: 85%;
  }
  .hmisctable338939 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable338939 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable338939">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th></tr>
  <tr><td>15</td><td>50</td><td>5</td><td>0.832</td><td>10.27</td><td>16.88</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value          0     1     4    60    70
  Frequency      1     8     4     1     1
  Proportion 0.067 0.533 0.267 0.067 0.067
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">July</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABMAAAANCAMAAAB8UqUVAAAACVBMVEUAAADMzMz////1iUV5AAAAHklEQVQYlWNgYMQADAxMGID6YtjsRVfIwEADMQxbAcqCAX5yK0xwAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable775146 {
  border: none;
  font-size: 85%;
  }
  .hmisctable775146 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable775146 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable775146">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th></tr>
  <tr><td>15</td><td>50</td><td>6</td><td>0.952</td><td>11.87</td><td>20.72</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value          0     1     2     3     4    80
  Frequency      5     3     2     1     2     2
  Proportion 0.333 0.200 0.133 0.067 0.133 0.133
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Aug</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABYAAAANCAMAAACae25RAAAACVBMVEUAAADMzMz////1iUV5AAAAJElEQVQYlWNgYGDEAhgYGJiwACoIMzDgFsbqDlINoYowNpcAAAAEAa1BZ41QAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable518385 {
  border: none;
  font-size: 85%;
  }
  .hmisctable518385 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable518385 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable518385">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th></tr>
  <tr><td>13</td><td>52</td><td>7</td><td>0.973</td><td>15.24</td><td>26.09</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value       0.00000000  0.07894737  1.00000000  2.00000000  3.00000000  4.00000000
  Frequency            2           1           3           1           3           1
  Proportion       0.154       0.077       0.231       0.077       0.231       0.077
                        
  Value      90.00000000
  Frequency            2
  Proportion       0.154
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Sept</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABMAAAANCAMAAAB8UqUVAAAACVBMVEUAAADMzMz////1iUV5AAAAIElEQVQYlWNgYMQADAxMGID6YtS2F1MQQ4wBDNAtZQAA0RUBkcrgA0gAAAAASUVORK5CYII=" alt="image" /></div> <style>
  .hmisctable130579 {
  border: none;
  font-size: 85%;
  }
  .hmisctable130579 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable130579 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable130579">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th></tr>
  <tr><td>19</td><td>46</td><td>6</td><td>0.803</td><td>10.74</td><td>20.01</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value        0.00000000   0.02631579   1.00000000   3.00000000  95.00000000
  Frequency            11            1            3            2            1
  Proportion        0.579        0.053        0.158        0.105        0.053
                         
  Value      100.00000000
  Frequency             1
  Proportion        0.053
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Oct</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABYAAAANCAMAAACae25RAAAACVBMVEUAAADMzMz////1iUV5AAAAHUlEQVQYlWNgYMQGGBiYsAHaCtPZJQwMOIWxugMAGTYB2ti1MAkAAAAASUVORK5CYII=" alt="image" /></div> <style>
  .hmisctable842146 {
  border: none;
  font-size: 85%;
  }
  .hmisctable842146 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable842146 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable842146">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th></tr>
  <tr><td>21</td><td>44</td><td>7</td><td>0.812</td><td>9.884</td><td>18.53</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value        0.0000000   0.2593050   0.5681666   0.7368421   1.0000000   2.0000000
  Frequency           12           1           1           1           2           2
  Proportion       0.571       0.048       0.048       0.048       0.095       0.095
                        
  Value      100.0000000
  Frequency            2
  Proportion       0.095
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Nov</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABwAAAANCAMAAACNWf6YAAAACVBMVEUAAADMzMz////1iUV5AAAAJElEQVQYlWNgYMQNGBiYcAMCknhkKZLE51oa2MnAQJEkbrcCALtdAk4UryZdAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable943927 {
  border: none;
  font-size: 85%;
  }
  .hmisctable943927 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable943927 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable943927">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th></tr>
  <tr><td>29</td><td>36</td><td>9</td><td>0.973</td><td>8.311</td><td>14.51</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value        0.0000000   0.1052632   0.2061034   0.7120372   1.0000000   2.0000000
  Frequency            7           1           1           1           5           5
  Proportion       0.241       0.034       0.034       0.034       0.172       0.172
                                                
  Value        3.0000000   4.0000000 100.0000000
  Frequency            3           4           2
  Proportion       0.103       0.138       0.069
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Dec</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABwAAAANCAMAAACNWf6YAAAACVBMVEUAAADMzMz////1iUV5AAAAH0lEQVQYlWNgYGDECRgYGJhwggGSHEyuZWAgJInbrQC2GgJNEsaRFwAAAABJRU5ErkJggg==" alt="image" /></div> <style>
  .hmisctable581838 {
  border: none;
  font-size: 85%;
  }
  .hmisctable581838 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable581838 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable581838">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th></tr>
  <tr><td>33</td><td>32</td><td>9</td><td>0.952</td><td>8.476</td><td>12.77</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value        0.00000000   0.02865784   0.15952609   0.51009983   1.00000000
  Frequency             1            1            1            1            3
  Proportion        0.030        0.030        0.030        0.030        0.091
                                                                
  Value        2.00000000   3.00000000   4.00000000 100.00000000
  Frequency             6            8           10            2
  Proportion        0.182        0.242        0.303        0.061
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Total</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAABMAAAANCAMAAAB8UqUVAAAACVBMVEUAAADMzMz////1iUV5AAAAG0lEQVQYlWNgYGQAAkYEAHGZwAQC0EJs8NgLAIvqARX/1u7KAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable794689 {
  border: none;
  font-size: 85%;
  }
  .hmisctable794689 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable794689 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable794689">
  <tr><th>n</th><th>missing</th><th>distinct</th><th>Info</th><th>Mean</th><th>Gmd</th></tr>
  <tr><td>6</td><td>59</td><td>6</td><td>1</td><td>56517</td><td>90475</td></tr>
  </table>
  <pre style="font-size:85%;">
  Value          38.0   2450.0   3811.5  41780.0  64209.0 226814.0
  Frequency         1        1        1        1        1        1
  Proportion    0.167    0.167    0.167    0.167    0.167    0.167
  </pre>
  <hr class="thinhr"> <span style="font-weight:bold">Other info</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAAFgAAAANCAMAAAAaCFlCAAAACVBMVEUAAADMzMz////1iUV5AAAAUUlEQVQ4jWNgRAMMDOgi5AEGJjTAgCFCHhiKBqOZxIAhMtgMRk8GDBgi5KaKIRcUKMZATKWqwXCSMrMR+hhQDMOLiFYINp4BmgyIQEQrBCcrALXEBssdgvPZAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable660614 {
  border: none;
  font-size: 85%;
  }
  .hmisctable660614 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable660614 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable660614">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>59</td><td>6</td><td>29</td></tr>
  </table>
  <style>
  .hmisctable894284 {
  border: none;
  font-size: 85%;
  }
  .hmisctable894284 td {
  text-align: right;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable894284 th {
  color: Black;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: bold;
  }
  </style>
  <table class="hmisctable894284">
  <tr><td><font color="MidnightBlue">lowest</font> :</td><td>"                                                                                                          </td><td>Acoustic telemetry - see Reckordt et al., 2014)                                                            </td><td>aims a methodology setting up in large rivers; 20 km wide river stretch, many stations, different depths   </td><td>Aims at understanding oceaninc and local drivers of recruitment                                            </td><td>aims at understanding seasonal dynamics and influence of environmental factors                             </td></tr>
  <tr><td><font color="MidnightBlue">highest</font>:</td><td>QUALITATIVE telemetry - early marine spawning migration                                                    </td><td>quality of spawner                                                                                         </td><td>study of escapment and size estimation population                                                          </td><td>to study colonization                                                                                      </td><td>Use data for both periods from fishers authorized outside the season: also compares with commercial fishery</td></tr>
  </table>
  <hr class="thinhr"> <span style="font-weight:bold">Notes</span><div style='float: right; text-align: right;'><img src="data:image/png;base64,
 iVBORw0KGgoAAAANSUhEUgAAADcAAAANCAMAAAA65Aa/AAAACVBMVEUAAADMzMz////1iUV5AAAARUlEQVQokWNgZGRkYGAkGTAwMTExgAgSAQNQ06DRh8dACvThDk88AT0A7qREH0QFXB2UgSyHUx8mwikBRuDwxIpwSgARAEycBA6f+8gQAAAAAElFTkSuQmCC" alt="image" /></div> <style>
  .hmisctable223523 {
  border: none;
  font-size: 85%;
  }
  .hmisctable223523 td {
  text-align: center;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable223523 th {
  color: MidnightBlue;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: normal;
  }
  </style>
  <table class="hmisctable223523">
  <tr><th>n</th><th>missing</th><th>distinct</th></tr>
  <tr><td>50</td><td>15</td><td>18</td></tr>
  </table>
  <style>
  .hmisctable475251 {
  border: none;
  font-size: 85%;
  }
  .hmisctable475251 td {
  text-align: right;
  padding: 0 1ex 0 1ex;
  }
  .hmisctable475251 th {
  color: Black;
  text-align: center;
  padding: 0 1ex 0 1ex;
  font-weight: bold;
  }
  </style>
  <table class="hmisctable475251">
  <tr><td><font color="MidnightBlue">lowest</font> :</td><td>"                                                                                                                                     </td><td>Also data from land fisheries available, do not always coincide                                                                       </td><td>Catch consist of Y/E/GE depending on the period                                                                                       </td><td>Catches within the season inflenced by channel discharge                                                                              </td><td>continuous monitoring                                                                                                                 </td></tr>
  <tr><td><font color="MidnightBlue">highest</font>:</td><td>silver eel escapement and pristine biomass                                                                                            </td><td>single scientific campaigns                                                                                                           </td><td>telemetry                                                                                                                             </td><td>To investgate how morphological characteristcs, origin (stocked/natural) and growing area (coastal/lake) a<U+FB00>ect migraton paterns</td><td>To verify  with Supplementary material                                                                                                </td></tr>
  </table>
  <hr class="thinhr"><!--/html_preserve-->
 
