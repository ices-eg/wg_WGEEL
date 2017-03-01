-- Created by BEAULATON Laurent
-- last update 2017/03/01
-- based on station dictionnay (http://ices.dk/marine-data/tools/Pages/Station-dictionary.aspx)

CREATE TABLE ts2.tr_station(
	"tblCodeID" DOUBLE PRECISION PRIMARY KEY,
	"Station_Code" DOUBLE PRECISION,
	"Country" TEXT,
	"Organisation" TEXT,
	"Station_Name" TEXT,
	"WLTYP" TEXT, -- Water and land station types 
	"Lat" DOUBLE PRECISION,
	"Lon" DOUBLE PRECISION,
	"StartYear" DOUBLE PRECISION,
	"EndYear" DOUBLE PRECISION,
	"PURPM" TEXT, -- Purpose of monitoring
	"Notes" TEXT
);

COMMENT ON COLUMN ts2.tr_station."Country" IS 'country responsible of the data collection ?';
COMMENT ON COLUMN ts2.tr_station."WLTYP" IS 'Water and land station types ';
COMMENT ON COLUMN ts2.tr_station."PURPM" IS 'Purpose of monitoring';
