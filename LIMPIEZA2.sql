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
