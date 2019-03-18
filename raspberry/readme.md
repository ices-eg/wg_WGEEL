# Raspberry installation
## Objective
Having an easy way to handle data during the WGEEL.
This requires a common database and having a computer running R and shiny app.
We will use a [Raspberry](https://en.wikipedia.org/wiki/Raspberry_Pi) for that (model Pi3 B+).

## Installing Raspbian on a raspberry
You need to install [Raspbian](https://en.wikipedia.org/wiki/Raspbian) on your Raspberry. You can find some instruction on [Raspberry website](https://www.raspberrypi.org/documentation/installation/installing-images/README.md).

From a ubuntu computer, you can use etcher software, installed through the following instruction:

```shell
echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
sudo apt update
sudo apt install balena-etcher-electron
```

Download the appropriate version of raspbian from <https://www.raspberrypi.org/downloads/raspbian/> (e.g. Raspbian Stretch with desktop and recommended software).
Once Raspbian is installed make sure you are ins last version:

```shell
sudo apt update
sudo apt upgrade
```
## Network configuration
### Static IP
To edit the conf file

```shell
sudo nano /etc/dhcpcd.conf 
```

lines to add to it:

``` shell
profile static_wlan0
interface wlan0
static ip_address=192.168.0.100/24c 
static routers=192.168.0.1
static domain_name_servers=192.168.0.1
```
### Remote access to Raspberry
We will use [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing), but SSH, ... is also possible.
<https://www.raspberrypi.org/documentation/remote-access/vnc/>

```shell
sudo apt install realvnc-vnc-server realvnc-vnc-viewer
```
Enabling VNC Server graphically
    On your Raspberry Pi, boot into the graphical desktop.
    Select Menu > Preferences > Raspberry Pi Configuration > Interfaces.
    Ensure VNC is Enabled.

In VNC server option, choose auhtentification  'VNC password' and in 'user & permissions' add a password in the standard user.

Use then any VNC client to remotely access to the Raspberry, for example [remmina](https://remmina.org/how-to-install-remmina/) or [real VNC](https://www.realvnc.com/fr/connect/download/viewer/).

## PostgreSQL
Installation of PostgreSQL (@17/03/2019 = 9.6) and PostGIS (@17/03/2019 = 2.3):

```shell
sudo apt install postgresql postgis
```

Create a new PostgreSQL user:

```shell
sudo -u postgres createuser  --superuser --createrole  --createdb --pwprompt wgeel
```

Configure PostgreSQL for external access

```shell
sudo nano /etc/postgresql/9.6/main/postgresql.conf
```
change for listen_adress = ‘*’

```shell
sudo nano /etc/postgresql/9.6/main/pg_hba.conf
```
add or change :

host    all             all             0.0.0.0/0            md5

and restart PostgreSQL:

```shell
sudo /etc/init.d/postgresql restart
```

## git
Install git software:

```shell
sudo apt install git
```

Create local git directory:

```shell
mkdir 'WGEEL-git'
```

git configuration:

```shell
git config --global user.email //your email adress//
git config --global user.name //your name//
```

Clone of git repository:

```shell
cd WGEEL-git
git clone https://github.com/ices-eg/wg_WGEEL.git
```

To update your git:

```shell
git pull
```
#R
Install R software

``` shell
sudo apt install r-base r-base-dev
```

Create personnal directory for R packages

``` shell
mkdir 'R' 
mkdir 'R/Rlib'
```

Configure defaults in Rprofile = directory for packages, default CRAN server, git directory ad default working directory:

```shell
echo '.libPaths("~/R/Rlib")' >> ~/.Rprofile
echo 'options(repos=structure(c(CRAN="https://cloud.r-project.org/")))' >> ~/.Rprofile
echo 'setwd("~/WGEEL-git/wg_WGEEL")' >> ~/.Rprofile
```

## Examples
Install a package

```shell
R -e "install.packages(c('shiny'), repos='https://cloud.r-project.org/', lib= '~/R/Rlib')
```

First test of shiny app

```shell
R -e "shiny::runGitHub('shiny-examples', 'rstudio', subdir = '001-hello', host = '0.0.0.0')"
```

Run a particular script

```shell
R -e "source('R/shiny_data_visualisation/run.R')"
```
## Solve package installation particularities

| R package | sudo apt install |
| --- | --- |
| Rpostgresql | libpq-dev |
| fs | libssl-dev |
| units | libcurl4-openssl-dev libudunits2-devl-dev |
| gdtools | libcairo2-dev |
| xml2 | libxml2-dev |

All in one

```shell
sudo apt install libssl-dev libcurl4-openssl-dev libudunits2-dev libpq-dev libcairo2-dev libxml2-dev
```