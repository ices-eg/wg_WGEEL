library(httr2)
base <- "http://127.0.0.1:8082"


Sys.setenv(API_password = readline("Password: "))



tok <- request(base) |>
  req_url_path("/login") |>
  req_body_form(username = "hilaire", password = Sys.getenv("API_password")) |>
  req_perform() |>
  resp_body_json()

resp <- request(base) |>
  req_url_path("/recruitment_data") |>
  req_method("POST") |>
  req_auth_bearer_token(tok$token[[1]]) |>
  req_perform()

res <- unserialize(resp_body_raw(resp))   # rds serializer

resp <- request(base) |>
  req_url_path("/eel_stocks") |>
  req_method("POST") |>
  req_auth_bearer_token(tok$token[[1]]) |>
  req_perform()


res <- unserialize(resp_body_raw(resp))   # rds serializer
str(res, max.level = 1)