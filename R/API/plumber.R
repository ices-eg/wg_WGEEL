
run_location <- "local" # server

# modify this on the server. here we assume you start from API
if (run_location == "local") {
path_to_shiny_dv <- "../shiny_data_visualisation/shiny_dv/"
} else {
  path_to_shiny_dv <- "srv/shiny_server/shiny_dv/"  
}

# dynamically re-reads the yaml file (if we add things in it) 
# see within check_login function launched from Authentication
read_cred <- function() yaml::read_yaml("credentials.yml")
cred <- read_cred()
jwt_secret <- charToRaw(cred$jwt_secret)
TOKEN_TTL <- 60 * 60   # token validity in seconds (1 hour)

# Dummy hash used when the user doesn't exist, so response time doesn't reveal valid usernames
dummy_hash <- password_store("dummy")


check_login <- function(username, password) {
  users <- read_cred()$users   # use read_cread to add users without restarting
  u <- users[[username]]
  hash <- if (is.null(u)) dummy_hash else u$hash
  ok <- tryCatch(password_verify(hash, password), error = function(e) FALSE)
  if (ok && !is.null(u)) u$role else NULL
}


has_stock_access <- function(req, res, roles) {
  if (!req$role %in% roles) {
    res$status <- 403
    return(list(error = "Forbidden", message = "Insufficient rights, you don't have access to stock data"))
  }
  NULL
}


#* @apiTitle WGEEL API
#* @apiDescription regenerate and get data for assessment.

# ---- Authentication filter -------------------------------------------------
#* Verify the JWT on every request except login and docs
#* @filter check_jwt
function(req, res) {
  open_paths <- c("/login", "/openapi.json")
  if (req$PATH_INFO %in% open_paths || grepl("^/__docs__", req$PATH_INFO)) {
    return(plumber::forward())
  }
  
  auth <- req$HTTP_AUTHORIZATION
  if (is.null(auth) || !grepl("^Bearer ", auth)) {
    res$status <- 401
    return(list(error = "Unauthorized", message = "Missing bearer token"))
  }
  
  claim <- tryCatch(jwt_decode_hmac(sub("^Bearer ", "", auth), secret = jwt_secret),
                    error = function(e) NULL)
  # also reject tokens of users who have since been removed from credentials.yml
  if (is.null(claim) || is.null(read_cred()$users[[claim$user]])) {
    res$status <- 401
    return(list(error = "Unauthorized", message = "Invalid or expired token"))
  }
  
  req$user <- claim$user
  req$role <- claim$role
  plumber::forward()
}

# ---- Login -----------------------------------------------------------------
#* Get a JWT token
#* @tag Authentication
#* @serializer json
#* @param username
#* @param password
#* @post /login
function(username = "", password = "", res) {
  role <- check_login(username, password)
  if (is.null(role)) {
    res$status <- 401
    return(list(error = "Unauthorized", message = "Wrong username or password"))
  }
  claim <- jwt_claim(user = username, 
                     role = role,
                     exp = as.numeric(Sys.time()) + TOKEN_TTL)
  list(token = jwt_encode_hmac(claim, secret = jwt_secret),
       expires_in = TOKEN_TTL)
}

#---- Recruitment ------------------------------------------------------------
# Any authenticated user (with role recruit or stock (we don't run forbid_unless))
#* getRecruitment
#* @tag Data
#* @serializer rds
#* @post /recruitment_data
function(req, res) {
  cred <- read_cred()
  con <- dbConnect(Postgres(),
                   host = cred$host, 
                   password = cred$password,
                   user = cred$user, 
                   dbname = cred$dbname
  )
  
  on.exit(dbDisconnect(con), add = TRUE) # always close, even on error

  CY <- lubridate::year(Sys.Date())
  # runs the load database with path = NULL => does not write anything 
  rec_list <- load_database(con, path=NULL, year= CY)
  return(rec_list)
}

#---- stock ------------------------------------------------------------
# only accessible with role stock
#* getEelStock
#* @tag Data
#* @serializer rds
#* @post /eel_stocks
function(req , res) {
  # test whether the user has access to stock data
  denied <- has_stock_access(req, res, "stock")
  if (!is.null(denied)) return(denied)
  wd <- getwd()
  on.exit(setwd(wd), add = TRUE)           # restore wd even on error
  cred <- read_cred()
  wd <- getwd()
  setwd(path_to_shiny_dv)
  source("load_data_from_database.R", local = TRUE)
  setwd(wd)
  return(list(precodata_all = precodata_all,
       precodata = precodata,
       precodata_emu = precodata_emu,
       precodata_country = precodata_country,
       emu_cou = emu_cou,
       emu_ref = emu_ref,
       country_ref = country_ref,
       lfs_code_base = lfs_code_base,
       habitat_ref = habitat_ref,
       release = release,
       aquaculture = aquaculture,
       other_landings = other_landings,
       landings = landings,
       ys_stations = ys_stations,
       wger_ys = wger_ys,
       wger_init_ys = wger_init_ys,
       statseries_ys = statseries_ys,
       biometry_group_data_sampling_long = biometry_group_data_sampling_long,
       biometry_group_data_series_long = biometry_group_data_series_long))
}