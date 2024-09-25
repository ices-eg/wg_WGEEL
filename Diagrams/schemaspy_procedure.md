# shemaspy procedure


install schemaspy  https://schemaspy.readthedocs.io/en/latest/installation.html


```

java -jar "C:\Program Files (x86)\schemaspy\schemaspy-6.2.4.jar" -t pgsql11 -dp "C:/Program Files (x86)/PostgreSQL/pgJDBC/postgresql-42.7.2.jar" -db wgeel -u postgres -p postgres -host 127.0.0.1 -schemas ref,datawg -o "C:\workspace\wg_WGEEL\Diagrams\wgeel_db.html"

```

This run schemaspy for the data generated in 
https://community.ices.dk/ExpertGroups/wgeel/2024%20Meeting/06.%20Data/database_structure/wgeel_db.html.zip