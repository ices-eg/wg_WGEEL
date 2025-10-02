library(icesSAG)
library(dplyr)
CY=2025

icesConnect::set_username("hilaire.drouineau@inrae.fr")

cat("# Standard Graphs personal access token",
    "SG_PAT=17a43867-05e1-4919-9283-b08a00ff0099",
    sep = "\n",
    file = "~/.Renviron_SG")
options(icesSAG.use_token = FALSE)
stock_info <- stockInfo("ele.2737.nea", CY, "hilaire.drouineau@inrae.fr",
                        StockCategory= 3.14,
                        ModelType="Other", 
                        ModelName="None",
                        CustomLimitName1="Historical reference 1960-1979",
                        CustomLimitName2="Historical reference 1960-1979",
                        CustomLimitValue1=100,
                        CustomLimitValue2=0.1,
                        CustomSeriesName1="Elsewhere Europe index",
                        CustomSeriesName2="North Sea Index",
                        CustomSeriesName3="Yellow eel Europe index",
                        CustomSeriesName4="Elsewhere Europe Index IC Lower",
                        CustomSeriesName5="Elsewhere Europe Index IC Upper",
                        CustomSeriesName6="North Sea Index IC Lower",
                        CustomSeriesName7="North Sea Index IC Upper",
                        CustomSeriesName8="Yellow Index IC Lower",
                        CustomSeriesName9="yellow Index IC Upper")
# Custom1 EE
# Custom2 NS
# Custom3 YY
# Custom4 EE LB
# Custom5 NS LB
# Custom6 YY LB
# Custom7 EE UB
# Custom8 NS UB
# Custom8 YY UB




load(paste0("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/R/recruitment/",
            CY,
            "/data/dat_ge.Rdata"))
load(paste0("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/R/recruitment/",
            CY,
            "/data/dat_ye.Rdata"))

dat_ge_EE <- bind_rows(dat_ge %>%
                      filter(area=="Elsewhere Europe"),
                    data.frame(year_f = as.character(1950:1959)) ) %>%
  arrange(year_f)
dat_ge_NS <- bind_rows(dat_ge %>%
                         filter(area=="North Sea"),
                       data.frame(year_f = as.character(1950:1959)) ) %>%
  arrange(year_f)

dat_ye <- bind_rows(dat_ye,
                    data.frame(year = CY))

fishdata <- stockFishdata(Year = as.integer(dat_ge_EE$year_f),
              CustomSeries1 = dat_ge_EE$p_std_1960_1979 * 100,
              CustomSeries2= dat_ge_NS$p_std_1960_1979 * 100,
              CustomSeries3= dat_ye$value_std_1960_1979  * 100,
              CustomSeries4= dat_ge_EE$p_std_1960_1979_min * 100,
              CustomSeries5= dat_ge_EE$p_std_1960_1979_max * 100,
              CustomSeries6= dat_ge_NS$p_std_1960_1979_min * 100,
              CustomSeries7= dat_ge_NS$p_std_1960_1979_max * 100,
              CustomSeries8= dat_ye$yellow_eel_min  * 100,
              CustomSeries9= dat_ye$yellow_eel_max  * 100)

tempfile <- paste0("SAG_", CY, ".xml")
writeSAGxml(stock_info , fishdata, file = tempfile)

uploadStock(tempfile, upload = FALSE, verbose = TRUE)
# 