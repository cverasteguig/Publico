
----------------------------------
-- 1. CREACION DE TBS
----------------------------------

  CREATE TABLESPACE TBS_AUTOS
  DATAFILE 'C:\TEMP\DF_AUTOS.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_BUSES
  DATAFILE 'C:\TEMP\DF_BUSES.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_MOTOS
  DATAFILE 'C:\TEMP\DF_MOTOS.DBF'
  SIZE 100M;
  
 CREATE TABLESPACE TBS_CAMIONES
  DATAFILE 'C:\TEMP\DF_CAMIONES.DBF'
  SIZE 100M;
  
  SELECT * FROM DBA_TABLESPACES;
  
  ----------------------------------
-- 2. TABLA PARTICIONADA POR LISTA
----------------------------------
TABLA : VEHICULOS
ID          NUMERIC   10
TIPO     VARCHAR   10
AÑO    INTEGER
PLACA VARCHAR   10



CREATE TABLE VEHICULOS
(ID NUMERIC(10),
 TIPO VARCHAR(10),
 AÑO INTEGER , 
 PLACA VARCHAR(10))
PARTITION BY LIST( TIPO)
(PARTITION vehiculo_Autos  VALUES('AUTOS')    tablespace TBS_AUTOS,
 PARTITION vehiculo_Buses VALUES ('BUSES') tablespace TBS_BUSES,
 PARTITION vehiculo_MOTOS VALUES ('MOTOS')     tablespace TBS_MOTOS,
 PARTITION vehiculo_CAMIONES VALUES('CAMIONES')   tablespace TBS_CAMIONES );

-- 4. CONSULTA DE TAMAÑO Y PORCENTAJE DE ESPACIO LIBRE
--------------------------------------------------------
SELECT /* + RULE */  df.tablespace_name "Tablespace",
       df.bytes / (1024 * 1024) "Size (MB)",
       SUM(fs.bytes) / (1024 * 1024) "Free (MB)",
       Nvl(Round(SUM(fs.bytes) * 100 / df.bytes),1) "% Free",
       Round((df.bytes - SUM(fs.bytes)) * 100 / df.bytes) "% Used"
  FROM dba_free_space fs,
       (SELECT tablespace_name,SUM(bytes) bytes
          FROM dba_data_files
         GROUP BY tablespace_name) df
 WHERE fs.tablespace_name (+)  = df.tablespace_name
 GROUP BY df.tablespace_name,df.bytes
UNION ALL
SELECT /* + RULE */ df.tablespace_name tspace,
       fs.bytes / (1024 * 1024),
       SUM(df.bytes_free) / (1024 * 1024),
       Nvl(Round((SUM(fs.bytes) - df.bytes_used) * 100 / fs.bytes), 1),
       Round((SUM(fs.bytes) - df.bytes_free) * 100 / fs.bytes)
  FROM dba_temp_files fs,
       (SELECT tablespace_name,bytes_free,bytes_used
          FROM v$temp_space_header
         GROUP BY tablespace_name,bytes_free,bytes_used) df
 WHERE fs.tablespace_name (+)  = df.tablespace_name
 GROUP BY df.tablespace_name,fs.bytes,df.bytes_free,df.bytes_used
 ORDER BY 4 DESC;

--Resultado del dimensionamiento
TBS_MOTOS	    100	91	91	9
TBS_BUSES	    100	91	91	9
TBS_CAMIONES	100	91	91	9
TBS_AUTOS	    100	91	91	9

(ID NUMERIC(10),
 TIPO VARCHAR(10),
 AÑO INTEGER , 
 PLACA VARCHAR(10)

-------------------------------------------------
-- 3 INSERTANDO DATOS EN TABLAS PARTICIONADAS
-------------------------------------------------
INSERT INTO VEHICULOS
SELECT LEVEL, 'AUTOS', 2017, 'P'||LEVEL
FROM DUAL CONNECT BY LEVEL < 1000000;
 
INSERT INTO VEHICULOS
SELECT LEVEL, 'BUSES', 2017, 'P'||LEVEL
FROM DUAL CONNECT BY LEVEL < 1500000;

INSERT INTO VEHICULOS
SELECT LEVEL, 'MOTOS', 2017, 'P'||LEVEL
FROM DUAL CONNECT BY LEVEL < 800000;

--Resultado del dimensionamiento

TBS_CAMIONES	100	91	91	9
TBS_AUTOS	    100	67	67	33
TBS_MOTOS	    100	67	67	33
TBS_BUSES	    100	51	51	49



-------------------------------------------------
-- 4 QUERY DE TABLAS PARTICIONADAS
-------------------------------------------------
SELECT * FROM VEHICULOS;

SELECT * FROM VEHICULOS PARTITION (vehiculo_Autos);
 
SELECT * FROM VEHICULOS PARTITION (vehiculo_Buses);

SELECT * FROM VEHICULOS PARTITION (vehiculo_motos);
