
# Proyecto-Bases-de-Datos

Repositorio para el proyecto final de la materia de Bases de Datos en el ITAM (Otoño 2024) con el profesor José Antonio Lechuga Rivera

## Autores
- Diego Federico Romero Miravete
- Eduardo Turriza Fortoul
- Francisco Emilio Cervantes Silva

## Introducción
Se diseñó un sistema de gestión de datos sobre el dataset de crímenes en Los Ángeles con el propósito de almacenar, administrar y analizar de forma efectiva la información relacionada con actividades delictivas. Este informe se enfoca tanto en el diseño de bases de datos como en la normalización de los datos para una serie de consultas con fines estadísticos.

- El archivo llamado *NORMALIZADA.sql* contiene el código para la creación de tablas e inserción de datos.
- El archivo llamado *LIMPIEZA2.sql* contiene el código para el proceso de limpieza y descarga de los datos.

## DataSet
Los datos se pueden descargar desde el *DATA GOV* en formato CSV:  
[https://catalog.data.gov/dataset/crime-data-from-2020-to-present](https://catalog.data.gov/dataset/crime-data-from-2020-to-present)

## Consultas
Las estadísticas obtenidas son:
1. La hora del día con mayor número de crímenes reportados, ordenando las horas de mayor a menor incidencia.
2. Las áreas con mayor número de crímenes reportados, ordenándolas de mayor a menor incidencia delictiva.
3. El tipo de crimen más común en cada área, y la cantidad de veces que se ha cometido en dicha área.
