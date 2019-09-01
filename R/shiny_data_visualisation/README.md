# Shiny application to visualise, analyse, ... data
to launch this application you have to launch the run.R


This script will first run global.R so just start with it manually.

You need to copy the content of `R/shiny/www/`and `/data` folder as 
in contains some large files that are not under version control.

This file no longer accesses the database. To update data run `load_data_from_the_database.R`, and
the `recruitment/recruitment_analysis.Rnw`

Then copy files in data and data/recruitment folder to the server.

You need to restart the server to account for those changes

```(sh)
sudo service shiny-server restart
```