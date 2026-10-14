library(httr2)

# local test 
# base <- "http://127.0.0.1:8082"
base <- "https://api.mercure.eaux-et-vilaine.bzh"


Sys.setenv(API_password = readline("Password: "))



tok <- request(base) |>
  req_url_path("api/login") |>
  req_body_form(username = "wgeel_read", 
                password = Sys.getenv("API_password")) |>
  req_perform() |>
  resp_body_json()

resp <- request(base) |>
  req_url_path("api/recruitment_data") |>
  req_method("POST") |>
  req_auth_bearer_token(tok$token[[1]]) |>
  req_perform()

res <- unserialize(resp_body_raw(resp))   # rds serializer

resp <- request(base) |>
  req_url_path("api/eel_stocks") |>
  req_method("POST") |>
  req_auth_bearer_token(tok$token[[1]]) |>
  req_perform()


res <- unserialize(resp_body_raw(resp))   # rds serializer
str(res, max.level = 1)


resp <- request(base) |>
  req_url_path("api/series_detail") |>
  req_method("POST") |>
  req_body_json(list(
    series = c("VilG", "BreSGY")
  )) |>
  req_auth_bearer_token(tok$token[[1]]) |>
  req_perform()

res <- unserialize(resp_body_raw(resp))  