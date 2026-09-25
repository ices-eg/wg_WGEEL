# WGEEL VS RDBES landings amounts
# Eirik Ryvoll Åsheim September 2009

#### R session setup --------------------------------------------------------------------
library(tidyverse)
library(readxl)
options(scipen=999)

#### Load WGEEL landings data -----------------------------------------------------------
# Obtain the wgeel data from Cedric's .Rdata file
# Then filter the landings data to include commerciall landings ("4"), all life stages, and all countries
# Finally, countries in the wgeel system uses a 3-char code, but rdbes uses a 2-char code. 

load("R/shiny_data_visualisation/shiny_dv/data/ref_and_eel_data.Rdata")

tb_landings_wgeel <- 
  landings |> 
  filter(eel_typ_id == 4) |> 
  mutate(
    source = "WGEEL",
    year = eel_year,
    mass_landed_kg = eel_value,
    country = recode_values(cou_iso3code,
      "ESP" ~ "ES",
      "IRL" ~ "IE",
      "EST" ~ "EE",
      "FIN" ~ "FI",
      "GRC" ~ "GR",
      "ITA" ~ "IT",
      "DNK" ~ "DK",
      "FRA" ~ "FR",
      "DEU" ~ "DE",
      "LTU" ~ "LT",
      "GBR" ~ "GB",
      "POL" ~ "PL",
      "SVN" ~ "SI",
      "NLD" ~ "NL",
      "ALB" ~ "AL",
      "TUR" ~ "TR",
      "LVA" ~ "LV",
      "SWE" ~ "SE",
      "HRV" ~ "HR",
      "TUN" ~ "TN",
      "PRT" ~ "PT",
      "BEL" ~ "BE",
      "MAR" ~ "MA",
      "DZA" ~ "DZ",
      "LBY" ~ "LY",
      "NOR" ~ "NO",
      "CZE" ~ "CZ",
      "MNE" ~ "ME",
      default = cou_iso3code
    )
  )

#### Load RDBES landings data -----------------------------------------------------------
# We have to adjust the catch year in order to match up against wgeel
# From the data call:"For silver eel, months from june y to may y+1 should be denoted year y"

tb_landings_rdbes <- 
  read_excel("DELETE-ME-commercial_landings.xlsx") |> 
  mutate(
    mass_landed_kg = as.numeric(CLofficialWeight),
    country = recode_values(CLlandingCountry, "GB-ENG"~"GB","GB-NIR"~"GB","GB-SCT"~"GB",default = CLlandingCountry),
    source = "RDBES",
    year = case_when(
      CLmonth %in% c(1:5) ~ CLyear-1,
      TRUE ~ CLyear,
    )
  ) 



#### compare landings data and plot results ---------------------------------------------
# combine the wgeel and rdbes data
# filter wgeel data to only include coastal, transitiona, and marine open data
# also filter wgeel data to only include countries which are in rdbes

list_countries_rdbes <- 
  tb_landings_rdbes |>  
  pull(country) |> 
  unique()

list_countries_missing_rdbes <- 
  tb_landings_wgeel |> 
  filter(!country %in% list_countries_rdbes) |> 
  pull(cou_country) |> 
  unique() |> 
  sort()

list_years_rdbes <- 
  tb_landings_rdbes |> 
  pull(year) |> 
  unique() |> 
  sort()

tb_landings_combined <- 
  bind_rows(
    tb_landings_rdbes,
    tb_landings_wgeel |> 
      filter(eel_hty_code %in% c("C","T","MO")) |> 
      filter(country %in% list_countries_rdbes)
  ) |> 
  summarise(
    .by = c(country, year, source),
    mass_landed_kg = sum(mass_landed_kg, na.rm=T)
  ) |> 
  # remove zero-values as they mess with log-scaling, and are not necessary:
  filter(mass_landed_kg != 0)
  

ggplot(tb_landings_combined |> filter(year %in% list_years_rdbes))+
  aes(x=country, y=mass_landed_kg, fill=source, color=source)+
  labs(
    title = "Total landed mass (kg) reported to WGEEL and RDBES",
    x="",y="",
  ) +
  geom_col(position="identity", width=0.6) +
  scale_fill_manual(values = c("RDBES"="#f9f9f900", "WGEEL"="#3498d65d"))+
  scale_color_manual(values =c("RDBES"="#04040495", "WGEEL"="#f9f9f900"))+
  coord_flip()+
  scale_y_continuous(transform = "log", breaks = c(10,100,1000,10000,100000))+
  facet_wrap(~year,ncol=2,axes="all") + 
  theme_bw() + 
  theme(
    strip.background = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(linewidth = 0.5, color = "black"),
    panel.grid = element_blank(),
    panel.grid.major.x = element_line(color = "black", linewidth=0.5, linetype="dotted"),
    legend.title = element_blank(),
    legend.position = "top",
    legend.key.size = unit(.4, "cm"),
    legend.justification = "left",
    legend.margin = margin(t=0,r=0,b=0,l=0),
    plot.margin = margin(t = 15, r = 20, b = 3, l = 1),
  )
  
ggsave(
  "Misc/RDBES/images/plot-rdbes-vs-wgeel-landings.png",
  width = 3000,
  height =  4000,
  unit = "px",
  scale = 1,
)

