/*
Trigger to store the last date at which the line has been changed / updated
*/

CREATE OR REPLACE FUNCTION datawg.update_das_last_update()	
RETURNS TRIGGER AS $$
BEGIN
    NEW.das_last_update = now()::date;
    RETURN NEW;	
END;
$$ language 'plpgsql';

DROP TRIGGER update_das_time ON datawg.t_dataseries_das;
CREATE TRIGGER update_das_time BEFORE INSERT OR UPDATE ON datawg.t_dataseries_das FOR EACH ROW EXECUTE PROCEDURE  datawg.update_das_last_update();