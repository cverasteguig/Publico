----------------------------------
-- 1. CREACION DE TBS
----------------------------------
 DROP TABLE VENTAS;
 DROP TABLESPACE TBS_ASIA
 INCLUDING CONTENTS AND DATAFILES;

 DROP TABLESPACE TBS_EUROPA
 INCLUDING CONTENTS AND DATAFILES;
 
  DROP TABLESPACE TBS_Al
 INCLUDING CONTENTS AND DATAFILES;
 
 DROP TABLESPACE TBS_OTROS
 INCLUDING CONTENTS AND DATAFILES;

  CREATE TABLESPACE TBS_ASIA
  DATAFILE 'C:\TEMP\DF_COMPROBANTES_ASIA.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_EUROPA
  DATAFILE 'C:\TEMP\DF_COMPROBANTES_EUROPA.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_AL
  DATAFILE 'C:\TEMP\DF_COMPROBANTES_AL.DBF'
  SIZE 100M;
  
 CREATE TABLESPACE TBS_OTROS
  DATAFILE 'C:\TEMP\DF_COMPROBANTES_OTROS.DBF'
  SIZE 100M;
  
  SELECT * FROM DBA_TABLESPACES;
  
  ----------------------------------
-- 2. TABLA PARTICIONADA POR LISTA
----------------------------------

CREATE TABLE Ventas
(ID NUMBER(10),
 ORIGEN VARCHAR2(20),
 FECHA DATE default sysdate )
PARTITION BY LIST( ORIGEN)
(PARTITION ventas_ASIA  VALUES('ASIA')    tablespace TBS_ASIA,
 PARTITION ventas_EUROPA VALUES ('EUROPA') tablespace TBS_EUROPA,
 PARTITION ventas_AL     VALUES ('AL')     tablespace TBS_AL,
 PARTITION ventas_otros  VALUES(DEFAULT)   tablespace TBS_OTROS );

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

TBS_OTROS	  100	91	91	9
TBS_EUROPA	100	91	91	9
TBS_AL	    100	91	91	9
TBS_ASIA	  100	91	91	9

-------------------------------------------------
-- 3 INSERTANDO DATOS EN TABLAS PARTICIONADAS
-------------------------------------------------
INSERT INTO VENTAS
SELECT LEVEL, 'ASIA', SYSDATE
FROM DUAL CONNECT BY LEVEL < 1000000;
 
INSERT INTO VENTAS
SELECT LEVEL, 'EUROPA', SYSDATE
FROM DUAL CONNECT BY LEVEL < 1000000;

--Resultado del dimensionamiento
TBS_OTROS	  100	91	91	9
TBS_AL	    100	91	91	9
TBS_ASIA	  100	67	67	33
TBS_EUROPA	100	67	67	33
-------------------------------------------------
-- 4 QUERY DE TABLAS PARTICIONADAS
-------------------------------------------------
SELECT * FROM VENTAS;

SELECT * FROM VENTAS PARTITION ( ventas_ASIA );
 
SELECT * FROM VENTAS PARTITION (ventas_EUROPA);

