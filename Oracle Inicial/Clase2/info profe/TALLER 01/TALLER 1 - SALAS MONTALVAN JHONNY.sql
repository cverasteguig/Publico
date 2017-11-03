
SELECT  * FROM  V$DATABASE;

----------------------------------
-- 1. CREACION DE TBS
----------------------------------
CREATE TABLESPACE TB_VENTAS
DATAFILE 'C:\BDORACLE\DF_VENTAS_01.DBF'
SIZE 3M;

----------------------------------
-- 2. CONSULTA ADMINISTRATIVA DE TBS
----------------------------------
SELECT * FROM DBA_TABLESPACES;


-- 3. CONSULTA ADMINISTRATIVA DE DATAFILES
----------------------------------
SELECT FILE#, NAME FROM V$DATAFILE;    



--------------------------------------------------------
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



----------------------------------
-- 5. CREANDO TABLA EN TB_VENTAS
----------------------------------
CREATE TABLE CURSO 
( ID NUMBER,
  NOMBRE CHAR(50) )
TABLESPACE TB_VENTAS;


SELECT * FROM CURSO;

----------------------------------
-- 6. INSERTANDO 10 MIL REGISTROS 
----------------------------------
INSERT INTO CURSO
SELECT LEVEL , 'CURSO' || LEVEL
FROM DUAL CONNECT BY LEVEL <= 10000;


----------------------------------
-- 7. MODIFICANDO TAMAÑO DE DATAFILES
----------------------------------
ALTER DATABASE 
DATAFILE 'C:\BDORACLE\DF_VENTAS_01.DBF'
RESIZE 10M;


----------------------------------
-- 8. AGREGANDO UN NUEVO DF AL TBS
----------------------------------
ALTER TABLESPACE TB_VENTAS
ADD DATAFILE 'C:\BDORACLE\DF_VENTAS_02.DBF'
SIZE 10M;



----------------------------------
-- 9. CAMBIANDO EL ESTADO DEL TBS
----------------------------------
SELECT * FROM CURSO;

ALTER TABLESPACE TB_VENTAS OFFLINE;

ALTER TABLESPACE TB_VENTAS  ONLINE;


----------------------------------
-- 10. ELIMINANDO LOS TBS
----------------------------------
DROP TABLESPACE TB_VENTAS
INCLUDING CONTENTS AND DATAFILES;



----------------------------------------------------

-- TALLER 01

----------------------------------------------------

-- 1 
CREATE TABLESPACE TBS_COMERCIAL
DATAFILE 'C:\PRACTICA\DF_COMERCIAL_01.DBF'
SIZE 15M;

-----------------------------

CREATE TABLESPACE TBS_FINANZAS
DATAFILE 'C:\PRACTICA\DF_FINANZAS_01.DBF'
SIZE 10M;

ALTER TABLESPACE TBS_FINANZAS
ADD DATAFILE 'C:\PRACTICA\DF_FINANZAS_02.DBF'
SIZE 10M;

-----------------------------

CREATE TABLESPACE TBS_CONTABILIDAD
DATAFILE 'C:\PRACTICA\DF_CONTABILIDAD.DBF'
SIZE 10M;

-----------------------------


CREATE TABLESPACE TBS_L0GISTICA
DATAFILE 'C:\PRACTICA\DF_LOGISTICA_01.DBF'
SIZE 10M;

ALTER TABLESPACE TBS_LOGISTICA
ADD DATAFILE 'C:\PRACTICA\DF_LOGISTICA_02.DBF'
SIZE 10M;


--------------------------------------------------------
-- 2

ALTER TABLESPACE TBS_CONTABILIDAD
ADD DATAFILE 'C:\PRACTICA\DF_CONTABILIDAD_02.DBF'
SIZE 15M;


---------------------------------------------------------
--3

ALTER DATABASE 
DATAFILE 'C:\PRACTICA\DF_COMERCIAL_01.DBF'
RESIZE 25M;


------------------------------------------------------------
--4

CREATE TABLE PEDIDOS
( IDPEDIDO NUMBER,
  FECHA DATE,
  REFERENCIA CHAR(100) )
TABLESPACE TBS_LOGISTICA;


-----------------------------------------------------------
--5

INSERT INTO PEDIDOS
SELECT LEVEL , SYSDATE, 'REF' || LEVEL
FROM DUAL 
CONNECT BY LEVEL <= 10000;


------------------------------------------------------------
--6

DROP TABLESPACE TBS_CONTABILIDAD
INCLUDING CONTENTS AND DATAFILES;


---------------------------------------------------------------
--7


SELECT * FROM PEDIDO;

-- AL EJECUTAR EL SCRIPT SE PUEDE ACCEDER A LA TABLA PEDIDO

ALTER TABLESPACE TBS_LOGISTICA OFFLINE;


SELECT * FROM PEDIDO;

-- YA NO SE PUEDE TENER ACCESO A LA TABLA PEDIDO YA QUE SE DESHABILITO
-- EL TBS_LOGISTICA EL CUAL INFLUYE AL REALIZAR LA CONSULTA A LA TABLA.

----------------------------------------------------------------
--8

ALTER TABLESPACE TBS_LOGISTICA  ONLINE;


-- SE ACTIVA  EL TBS_LOGISTICA EL CUAL YA NOS VA A PERMITIR ACCEDER AL
-- CONTENIDO QUE TIENE EL TBS_LOGISTICA.
