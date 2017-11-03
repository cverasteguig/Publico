
----------------------------------
-- PREGUNTA  1
----------------------------------
  CREATE TABLESPACE TBS_AUTOS
  DATAFILE 'C:\TEMP\DF_COMPROBANTES_AUTOS.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_CAMIONETA
  DATAFILE 'C:\TEMP\DF_COMPROBANTES_CAMIONETA.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_BUS
  DATAFILE 'C:\TEMP\DF_COMPROBANTES_BUS.DBF'
  SIZE 100M;
  
 CREATE TABLESPACE TBS_CAMIONES
  DATAFILE 'C:\TEMP\DF_COMPROBANTES_CAMIONES.DBF'
  SIZE 100M;
  
  
  select * from DBA_TABLESPACES;


----------------------------------
-- 2. TABLA PARTICIONADA POR LISTA
----------------------------------

CREATE TABLE VEHICULO
(ID NUMBER(10),
 TIPO VARCHAR2(10),
 AÑO INTEGER,
  PLACA VARCHAR2(10))
PARTITION BY LIST( TIPO)
(PARTITION VEHICULO_AUTO  VALUES('AUTOS')    tablespace TBS_AUTOS,
 PARTITION VEHICULO_CAMIONETA VALUES ('CAMIONETA') tablespace TBS_CAMIONETA,
 PARTITION VEHICULO_BUS    VALUES ('BUS')     tablespace TBS_BUS,
 PARTITION VEHICULO_CAMION  VALUES('CAMIONES')   tablespace TBS_CAMIONES );


-------------------------------------------------
-- PREGUNTA 2
-------------------------------------------------
INSERT INTO VEHICULO
SELECT LEVEL, 'AUTOS', 2017,'WYT'
FROM DUAL CONNECT BY LEVEL < 100000;
 
 
 -------------------------------------------------
-- PREGUNTA 3
-------------------------------------------------
INSERT INTO VEHICULO
SELECT LEVEL, 'BUS', 2017, 'DRT'
FROM DUAL CONNECT BY LEVEL < 100000;



-------------------------------------------------
--PREGUNTA 4
-------------------------------------------------


SELECT * FROM VEHICULO;

SELECT * FROM VEHICULO PARTITION ( VEHICULO_AUTO );
 

-------------------------------------------------
--PREGUNTA 5
-- AL EJECUTAR ME SALE ERROR, PORQUE NO HAY NINGUNA PARTICION 'MOTOS'
-------------------------------------------------






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
 




