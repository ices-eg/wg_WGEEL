# Shiny application to visualise, analyse, ... data
to launch this application you have to launch the run.R

```r
source("R/utilities/set_directory.R")
set_directory("shiny_data") # shiny_data_wd will be created
```

This script will first run global.R so just start with it manually.

You need to copy the content of `R/shiny/www/`and `/data` folder as 
in contains some large files that are not under version control.

You also need a connexion to the postgres database.