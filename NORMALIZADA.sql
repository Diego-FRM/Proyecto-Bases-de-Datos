
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

-- 