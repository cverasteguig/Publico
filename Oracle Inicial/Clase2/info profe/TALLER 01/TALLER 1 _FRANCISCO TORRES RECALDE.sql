SELECT*FROM V$DATABASE;

----------------------------------
-- 1. CREACION DE TBS
----------------------------------
CREATE TABLESPACE DF_COMERCIAL
DATAFILE 'C:\BDORACLE\DF_COMERCIAL_01.DBF'
SIZE 15 M;

CREATE TABLESPACE DF_FINANZAS
DATAFILE 'C:\BDORACLE\DF_FINANZAS_01.DBF'
SIZE 10 M;

CREATE TABLESPACE DF_FINANZAS
DATAFILE 'C:\BDORACLE\DF_FINANZAS_02.DBF'
SIZE 10 M;


CREATE TABLESPACE DF_CONTABILIDAD
DATAFILE 'C:\BDORACLE\DF_CONTABILIDAD_01.DBF'
SIZE 10 M;

CREATE TABLESPACE DF_LOGISTICA
DATAFILE 'C:\BDORACLE\DF_LOGISTICA_01.DBF'
SIZE 10 M;

CREATE TABLESPACE DF_LOGISTICA
DATAFILE 'C:\BDORACLE\DF_LOGISTICA_02.DBF'
SIZE 10 M;

CREATE TABLESPACE TB_CONTABILIDAD
DATAFILE 'C:\BDORACLE\DF_CONTABILIDAD_01.DBF'
SIZE 15M;

----------------------------------
-- 2. CONSULTA ADMINISTRATIVA DE TBS
----------------------------------
SELECT * FROM DBA_TABLESPACES;

----------------------------------
-- 3. CONSULTA ADMINISTRATIVA DE DATAFILES
----------------------------------
SELECT FILE#, NAME FROM V$DATAFILE;    

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
 
 -- 5. CREANDO TABLA EN TB_VENTAS
----------------------------------
CREATE TABLE CURSO 
CREATE TABLE CURSO 
( ID NUMBER (10),
  NOMBRE CHAR(100) )
TABLESPACE TB_LOGISTICA;


SELECT * FROM PEDIDOS;

----------------------------------
-- 6. INSERTANDO 10 MIL REGISTROS 
----------------------------------
INSERT INTO PEDIDOS


SELECT LEVEL ,SYSDATE, 'REF_' || LEVEL
FROM DUAL CONNECT BY LEVEL <= 10000;SELECT /* + RULE */  df.tablespace_name "Tablespace",
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


SELECT DUMMY FROM DUAL CONNECT BY LEVEL <=10000;

-- 7. MODIFICANDO TAMAÑO DE DATAFILES
----------------------------------
ALTER DATABASE 
DATAFILE 'C:\BDORACLE\DF_COMERCIAL_01.DBF'
RESIZE 25M;


-- 8. AGREGANDO UN NUEVO DF AL TBS
----------------------------------
ALTER TABLESPACE TB_VENTAS
ADD DATAFILE 'C:\BDORACLE\DF_VENTAS_02.DBF'
SIZE 10M;

-- 9. CAMBIANDO EL ESTADO DEL TBS
----------------------------------
SELECT * FROM PEDIDOS;
ALTER TABLE ESPACE TB_LOGISTICA OFFLINE;
SELECT * FROM PEDIDOS;
ALTER TABLESPACE TB_LOGISTICA  ONLINE;
SELECT * FROM PEDIDOS;

----------------------------------
-- 10. ELIMINANDO LOS TBS
----------------------------------
DROP TABLESPACE TB_CONTABILIDAD
INCLUDING CONTENTS AND DATAFILES;


SELECT * FROM DBA_TABLES

