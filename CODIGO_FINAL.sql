-- CREACION DE TABLA PRINCIPAL
CREATE TABLE la_crimes (
	DR_NO BIGINT,
	"Date Rptd" TEXT,
	"DATE OCC" TEXT,
	"TIME OCC" BIGINT,
	AREA BIGINT,
	"AREA NAME" TEXT,
	"Rpt Dist No" BIGINT,
	"Part 1-2" BIGINT,
	"Crm Cd" BIGINT,
	"Crm Cd Desc" TEXT,
	Mocodes TEXT,
	VictAge BIGINT,
	VictSex TEXT,
	VictDescent TEXT,
	"Premis Cd" BIGINT,
	"Premis Desc" TEXT,
	"Weapon Used Cd" TEXT,
	"Weapon Desc" TEXT,
	Status TEXT,
	"Status Desc" TEXT,
	"Crm Cd 1" BIGINT,
	"Crm Cd 2" BIGINT,
	"Crm Cd 3" BIGINT,
	"Crm Cd 4" BIGINT,
	LOCATION TEXT,
	"Cross Street" TEXT,
	LAT FLOAT,
	LON FLOAT);
	
-- CARGAMOS LOS DATOS DESDE LA TERMINAL DE SQL SHELL CON EL SIGUIENTE COMANDO
--\copy la_crimes (DR_NO ,"Date Rptd" , "DATE OCC" ,"TIME OCC" ,AREA ,"AREA NAME" ,"Rpt Dist No" ,"Part 1-2" ,"Crm Cd" ,"Crm Cd Desc" ,Mocodes ,VictAge ,VictSex ,VictDescent ,"Premis Cd" ,"Premis Desc" ,"Weapon Used Cd" ,"Weapon Desc" ,Status ,"Status Desc" ,"Crm Cd 1" ,"Crm Cd 2" ,"Crm Cd 3" ,"Crm Cd 4" ,LOCATION ,"Cross Street" ,LAT ,LON ) FROM 'C:\Users\pacoc\Escritorio\Proyecto Bases\Crime_Data_from_2020_to_Present.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');
-- CORROBORAMOS QUE HAYAN CARGADO
SELECT * FROM la_crimes;

-- CREAMOS EL SCHEMA RAW Y LA TABLA SOBRE LA QUE TRABAJAREMOS
CREATE SCHEMA raw;
CREATE TABLE raw.la_crimes_raw (
	DR_NO BIGINT,
	"Date Rptd" TEXT,
	"DATE OCC" TEXT,
	"TIME OCC" BIGINT,
	AREA BIGINT,
	"AREA NAME" TEXT,
	"Rpt Dist No" BIGINT,
	"Part 1-2" BIGINT,
	"Crm Cd" BIGINT,
	"Crm Cd Desc" TEXT,
	Mocodes TEXT,
	VictAge BIGINT,
	VictSex TEXT,
	VictDescent TEXT,
	"Premis Cd" BIGINT,
	"Premis Desc" TEXT,
	"Weapon Used Cd" TEXT,
	"Weapon Desc" TEXT,
	Status TEXT,
	"Status Desc" TEXT,
	"Crm Cd 1" BIGINT,
	"Crm Cd 2" BIGINT,
	"Crm Cd 3" BIGINT,
	"Crm Cd 4" BIGINT,
	LOCATION TEXT,
	"Cross Street" TEXT,
	LAT FLOAT,
	LON FLOAT);
	

-- CARGAMOS LOS DATOS AL SCHEMA RAW
insert into raw.la_crimes_raw (DR_NO, "Date Rptd", "DATE OCC", "TIME OCC", AREA, "AREA NAME" , "Rpt Dist No" , "Part 1-2" , "Crm Cd" , "Crm Cd Desc" , Mocodes , VictAge , VictSex , VictDescent , "Premis Cd" , "Premis Desc" , "Weapon Used Cd" , "Weapon Desc" , Status , "Status Desc" , "Crm Cd 1" , "Crm Cd 2" , "Crm Cd 3" , "Crm Cd 4" , LOCATION , "Cross Street" , LAT , LON)
select * from la_crimes;

--Vamos a borrar las columnas que no nos sirven 
alter table la_crimes drop COLUMN "Part 1-2";
alter table la_crimes drop COLUMN Mocodes; 
alter table la_crimes drop COLUMN victdescent;
alter table la_crimes drop COLUMN "Crm Cd 1";
alter table la_crimes drop COLUMN "Crm Cd 2";
alter table la_crimes drop COLUMN "Crm Cd 3";
alter table la_crimes drop COLUMN "Crm Cd 4";
alter table la_crimes drop COLUMN "Cross Street";


--INTENTO TRANSACCION PARA CAMBIAR LOS TIPOS DE DATOS
START TRANSACTION;

alter table la_crimes alter COLUMN "Date Rptd" type varchar; 
alter table la_crimes alter COLUMN "DATE OCC" type varchar;
alter table la_crimes alter COLUMN "Crm Cd Desc" type varchar;
alter table la_crimes alter COLUMN "victsex" type VARCHAR;
alter table la_crimes alter COLUMN "Weapon Used Cd" type BIGINT USING "Weapon Used Cd"::bigint;
alter table la_crimes alter COLUMN "Weapon Desc" type VARCHAR;
alter table la_crimes alter COLUMN "Status Desc" type VARCHAR;
alter table la_crimes alter COLUMN "Premis Desc" type VARCHAR;
alter table la_crimes alter COLUMN STATUS type VARCHAR;
alter table la_crimes alter COLUMN "AREA NAME" type varchar; 

commit;
ROLLBACK;


-- MANEJAREMOS LOS DATOS EN EL SCHEMA RAW
--Vamos a borrar las columnas que no nos sirven 
alter table raw.la_crimes_raw drop COLUMN "Part 1-2";
alter table raw.la_crimes_raw drop COLUMN Mocodes; 
alter table raw.la_crimes_raw drop COLUMN victdescent;
alter table raw.la_crimes_raw drop COLUMN "Crm Cd 1";
alter table raw.la_crimes_raw drop COLUMN "Crm Cd 2";
alter table raw.la_crimes_raw drop COLUMN "Crm Cd 3";
alter table raw.la_crimes_raw drop COLUMN "Crm Cd 4";
alter table raw.la_crimes_raw drop COLUMN "Cross Street";


--INTENTO TRANSACCION PARA CAMBIAR LOS TIPOS DE DATOS
START TRANSACTION;

alter table raw.la_crimes_raw alter COLUMN "Date Rptd" type varchar; 
alter table raw.la_crimes_raw alter COLUMN "DATE OCC" type varchar; 
alter table raw.la_crimes_raw alter COLUMN "Crm Cd Desc" type varchar;
alter table raw.la_crimes_raw alter COLUMN "victsex" type VARCHAR;
alter table raw.la_crimes_raw alter COLUMN "Weapon Used Cd" type BIGINT USING "Weapon Used Cd"::bigint;
alter table raw.la_crimes_raw alter COLUMN "Weapon Desc" type VARCHAR;
alter table raw.la_crimes_raw alter COLUMN "Status Desc" type VARCHAR;
alter table raw.la_crimes_raw alter COLUMN "Premis Desc" type VARCHAR;
alter table raw.la_crimes_raw alter COLUMN STATUS type VARCHAR;
alter table raw.la_crimes_raw alter COLUMN "AREA NAME" type varchar; 

commit;
ROLLBACK;

-- CONFIRMAMOS QUE HAYA O QUE NO HAYA CLAVES dr_no REPETIDAS
SELECT dr_no, COUNT(dr_no)
FROM raw.la_crimes_raw
GROUP BY dr_no
HAVING COUNT(dr_no) > 1;

-- BORRAMOS LAS TUPLAS REPETIDAS POR dr_no
WITH x AS
( 
         SELECT   dr_no , 
                  Min(ctid) AS min
         FROM     raw.la_crimes_raw 
         GROUP BY dr_no 
         HAVING   Count(dr_no) > 1 ) 
DELETE
FROM   raw.la_crimes_raw b 
using  x 
WHERE  x.dr_no = b.dr_no 
AND    x.min <> b.ctid 
returning *;

-- CONFIRMAMOS QUE SE BORRARON LOS DUPLICADOS
SELECT dr_no, COUNT(dr_no)
FROM raw.la_crimes_raw
GROUP BY dr_no
HAVING COUNT(dr_no) > 1;

-- BORRAMOS LAS TUPLAS QUE TENGAN 0 EL LONGITUD Y LATITUD
DELETE FROM raw.la_crimes_raw 
	WHERE lat = 0 AND lon = 0;
	
-- CAMBIAMOS EL FORMATO DE LAS FECHAS PARA PODER MANIPULARLAS COMO FECHAS
UPDATE raw.la_crimes_raw
SET "Date Rptd" = SUBSTRING("Date Rptd" FROM '^\d{1,2}/\d{1,2}/\d{4}');

-- CAMBIAMOS EL TIPO DE DATO DE LA COLUMNA 
alter table raw.la_crimes_raw alter COLUMN "Date Rptd" type DATE USING "Date Rptd"::DATE; 

UPDATE raw.la_crimes_raw
SET "DATE OCC" = SUBSTRING("DATE OCC" FROM '^\d{1,2}/\d{1,2}/\d{4}'); 

--CAMBIAMOS EL TIPO DE DATO DE LA COLUMNA
alter table raw.la_crimes_raw alter COLUMN "DATE OCC" type DATE USING "DATE OCC"::DATE; 

--Cambiar el formato de time_occ para que pase de 2100 a 21:00:00
alter table raw.la_crimes_raw alter COLUMN "TIME OCC" type VARCHAR; 

UPDATE raw.la_crimes_raw
SET "TIME OCC" = LEFT(LPAD("TIME OCC"::TEXT, 4, '0'), 2) || ':' || RIGHT(LPAD("TIME OCC"::TEXT, 4, '0'), 2);

alter table raw.la_crimes_raw alter COLUMN "TIME OCC" type TIME USING "TIME OCC"::TIME WITHOUT TIME ZONE; 

-- QUITAMOS LOS ESPACIOS DE LA COLUMNA LOCATION
UPDATE raw.la_crimes_raw
SET location = REGEXP_REPLACE(TRIM(location), '\s+', ' ', 'g');

-- VERIFICAMOS SI EXISTE ALGUNA TUPLA CON UN VALOR NULO EN LA COLUMNA STATUS
SELECT * FROM raw.la_crimes_raw WHERE status IS NULL;

-- HACEMOS UN UPDATE PARA CAMBIAR EL VALOR NULL AL VALOR DE STATUS QUE CORRESPONDE
UPDATE raw.la_crimes_raw 
SET status = 'CC' WHERE status IS NULL;

-- CREACIÓN DE TABLAS DESPUÉS DE LA NORMALIZACIÓN

-- CREACIÓN DE LA TABLA AREAS 
CREATE TABLE areas(
	Id_Area BIGINT,
	Nombre VARCHAR(100));

-- CARGA DE DATOS DE AREAS DESDE EL SCHEMA RAW
INSERT INTO areas (Id_Area, Nombre) SELECT DISTINCT(area), "AREA NAME" FROM raw.la_crimes_raw ORDER BY area ASC;

-- CREACIÓN DE LA TABLA TIPO_CRIMEN
CREATE TABLE tipo_crimen(
	Id_Crimen BIGINT,
	Nombre_Crimen VARCHAR(500));

-- CARGA DE DATOS DE TIPOS DE CRIMEN DESDE EL SCHEMA RAW
INSERT INTO tipo_crimen (Id_crimen, Nombre_Crimen) SELECT DISTINCT("Crm Cd"),"Crm Cd Desc" FROM raw.la_crimes_raw ORDER BY "Crm Cd" ASC;

-- CREACION DE TABLA LUGAR
CREATE TABLE lugar(
	Id_Lugar BIGSERIAL,
	Lugar VARCHAR(500),
	Latitud FLOAT,
	Longitud FLOAT);

-- CARGA DE DATOS DE LUGARES DESDE EL SCHEMA RAW
INSERT INTO lugar (Lugar, Latitud, Longitud) SELECT DISTINCT(location), lat, lon  FROM raw.la_crimes_raw ORDER BY LOCATION ASC;

-- CREACION DE TABLA TIPO LUGAR
CREATE TABLE tipo_lugar(
	Id_Tipo BIGINT,
	Nombre_Lugar VARCHAR(500));

-- CARGA DE DATOS DE TIPO DE LUGAR DESDE EL SCHEMA RAW
INSERT INTO tipo_lugar (Id_Tipo, Nombre_Lugar) SELECT DISTINCT("Premis Cd"), "Premis Desc" FROM raw.la_crimes_raw ORDER BY "Premis Cd" ASC;

-- BORRAMOS LAS TUPLAS DONDE EL ID_TIPO SEA NULL
DELETE FROM tipo_lugar WHERE id_tipo IS NULL;

-- CREACION DE TABLA DE STATUS ACTUAL
CREATE TABLE status_actual(
	Id_Status BIGSERIAL,
	Siglas_Status VARCHAR(100),
	Status VARCHAR(500));

-- CARGA DE DATOS DE STATUS DEL CRIMEN DESDE EL SCHEMA RAW
INSERT INTO status_actual (Siglas_Status, Status) SELECT DISTINCT(status), "Status Desc" FROM raw.la_crimes_raw;

-- CREACION DE TABLA DE TIPOS DE ARMA
CREATE TABLE tipo_arma(
	Id_Arma BIGINT,
	Arma_Desc VARCHAR(500));

-- CARGA DE DATOS DE ARMA UTILIZADA EN EL CRIMEN DESDE EL SCHEMA RAW
INSERT INTO tipo_arma (Id_Arma, Arma_Desc) SELECT DISTINCT("Weapon Used Cd"), "Weapon Desc" FROM raw.la_crimes_raw ORDER BY "Weapon Used Cd" ASC;

-- BORRAMOS LAS TUPLAS DONDE EL ID_ARMA SEA NULL
DELETE FROM tipo_arma WHERE id_arma IS NULL;

-- CREACION DE LA TABLA PRINCIPAL DE REPORTES
CREATE TABLE reportes(
	No_Crimen BIGINT,
	Date_Rptd DATE,
	Date_Occ DATE,
	Time_Occ TIME,
	Rpt_Dist_No BIGINT,
	Vict_Age BIGINT,
	Vict_Sex VARCHAR(100),
	Area_Id BIGINT,
	Lugar_Id BIGINT,
	Status_Id BIGINT,
	Tipo_Crimen_Id BIGINT,
	Location_Id BIGINT,
	Arma_Id BIGINT);
	
-- CARGA DE DATOS DE REPORTES DESDE EL SCHEMA RAW
INSERT INTO reportes (No_Crimen, Date_Rptd, Date_Occ, Time_Occ, Rpt_Dist_No, Vict_Age, Vict_Sex) SELECT dr_no, "Date Rptd", "DATE OCC", "TIME OCC", "Rpt Dist No", victage, victsex FROM raw.la_crimes_raw;

-- CARGA DE DATOS DE ID_AREA POR CADA NO_CRIMEN
UPDATE reportes 
SET area_id = areas.id_area 
FROM  areas JOIN raw.la_crimes_raw ON areas.id_area = raw.la_crimes_raw.area
WHERE reportes.no_crimen = raw.la_crimes_raw.dr_no;

-- CARGA DE DATOS DE ID_LUGAR POR CADA NO_CRIMEN
UPDATE reportes 
SET lugar_id = tipo_lugar.id_tipo 
FROM  tipo_lugar JOIN raw.la_crimes_raw ON tipo_lugar.id_tipo = raw.la_crimes_raw."Premis Cd"
WHERE reportes.no_crimen = raw.la_crimes_raw.dr_no;

-- CARGA DE DATOS DE ID_STATUS POR CADA NO_CRIMEN
UPDATE reportes 
SET status_id = status_actual.id_status
FROM  status_actual JOIN raw.la_crimes_raw ON status_actual.siglas_status = raw.la_crimes_raw.status
WHERE reportes.no_crimen = raw.la_crimes_raw.dr_no;

-- CARGA DE DATOS DE ID_CRIMEN POR CADA NO_CRIMEN
UPDATE reportes 
SET tipo_crimen_id = tipo_crimen.id_crimen
FROM  tipo_crimen JOIN raw.la_crimes_raw ON tipo_crimen.id_crimen = raw.la_crimes_raw."Crm Cd"
WHERE reportes.no_crimen = raw.la_crimes_raw.dr_no;

-- CARGA DE DATOS DE ID_LOCATION POR CADA NO_CRIMEN
UPDATE reportes 
SET location_id = lugar.id_lugar 
FROM  lugar JOIN raw.la_crimes_raw ON lugar.lugar = raw.la_crimes_raw."location" 
AND lugar.longitud = raw.la_crimes_raw.lon AND lugar.latitud = raw.la_crimes_raw.lat
WHERE reportes.no_crimen = raw.la_crimes_raw.dr_no;

-- CARGA DE DATOS DE ID_ARMA POR CADA NO_CRIMEN
UPDATE reportes 
SET arma_id = tipo_arma.id_arma
FROM  tipo_arma JOIN raw.la_crimes_raw ON tipo_arma.id_arma = raw.la_crimes_raw."Weapon Used Cd"
WHERE reportes.no_crimen = raw.la_crimes_raw.dr_no;

-- AHORA ASIGNAREMOS LAS LLAVES PRIMARIAS DE CADA TABLA
ALTER TABLE reportes ADD PRIMARY KEY (no_crimen);
ALTER TABLE areas ADD PRIMARY KEY (id_area);
ALTER TABLE lugar ADD PRIMARY KEY (id_lugar);
ALTER TABLE status_actual ADD PRIMARY KEY (id_status);
ALTER TABLE tipo_arma ADD PRIMARY KEY (id_arma);
ALTER TABLE tipo_crimen ADD PRIMARY KEY (id_crimen);
ALTER TABLE tipo_lugar ADD PRIMARY KEY (id_tipo);

-- AGREGAMOS LAS LLAVES FORANEAS A LA TABLA REPORTES
ALTER TABLE reportes ADD FOREIGN KEY (area_id) REFERENCES areas(id_area);
ALTER TABLE reportes ADD FOREIGN KEY (lugar_id) REFERENCES tipo_lugar(id_tipo);
ALTER TABLE reportes ADD FOREIGN KEY (status_id) REFERENCES status_actual(id_status);
ALTER TABLE reportes ADD FOREIGN KEY (tipo_crimen_id) REFERENCES tipo_crimen(id_crimen);
ALTER TABLE reportes ADD FOREIGN KEY (location_id) REFERENCES lugar(id_lugar);
ALTER TABLE reportes ADD FOREIGN KEY (arma_id) REFERENCES tipo_arma(id_arma);

-- QUITAMOS LA TABLA LA_CRIMES
DROP TABLE la_crimes;