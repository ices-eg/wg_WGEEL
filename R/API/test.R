library(httr2)


res <- request("http://127.0.0.1:37688/recruitment_data") |> 
  req_method("POST") |> 
  req_body_json(list(
    username = "",
    password = "wgeel"
  )) |> 
  req_perform() |>
  resp_body_raw()
res <- readRDS(rawConnection(res))


wger_init = res$wger_init
statseries = res$statseries
R_stations = res$R_stations
last_years_with_problem = res$last_years_with_problem
t_series_ser = res$t_series



res <- request("http://127.0.0.1:37688/eel_stocks") |> 
  req_method("POST") |> 
  req_body_json(list(
    username = "wgeel",
    password = "wgeel"
  )) |> 
  req_perform() |>
  resp_body_raw()
res <- readRDS(rawConnection(res))


precodata_all = res$precodata_all
precodata = res$precodata
precodata_emu = res$precodata_emu
precodata_country = res$precodata_country
emu_cou = res$emu_cou
emu_ref = res$emu_ref
country_ref = res$country_ref
lfs_code_base = res$lfs_code_base
habitat_ref = res$habitat_ref
release = res$release 
aquaculture = res$aquaculture
other_landings = res$other_landings
landings = res$landings
ys_stations = res$ys_stations
wger_ys = res$wger_ys
wger_init_ys = res$wger_init_ys
statseries_ys = res$statseries_ys
biometry_group_data_sampling_long = res$biometry_group_data_sampling_long
biometry_group_data_series_long = res$biometry_group_data_series_long



