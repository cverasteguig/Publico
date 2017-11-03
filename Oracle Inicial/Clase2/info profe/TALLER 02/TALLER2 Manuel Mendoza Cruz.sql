
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


CREATE TABLE PEDIDO 
( IDPEDIDO NUMBER(10),FECHA DATE, REFERNCIA CHAR(100) )
TABLESPACE TBS_LOGISTICA;

SELECT * FROM PEDIDO;

----------------------------------
-- 6. INSERTANDO 10 MIL REGISTROS 
----------------------------------

INSERT INTO PEDIDO
SELECT LEVEL ,SYSDATE,'REF'|| LEVEL
FROM DUAL CONNECT BY LEVEL <= 10000;
select * from PEDIDO;

----------------------------------
-- 7. MODIFICANDO TAMAÑO DE DATAFILES
----------------------------------


ALTER DATABASE 
DATAFILE 'C:\PRACTICA\DF_COMERCIAL_01.DBF'
RESIZE 25M;


ALTER TABLESPACE TBS_FINANZAS
ADD DATAFILE 'C:\PRACTICA\DF_FINANZAS_02.DBF'
SIZE 10M;

ALTER TABLESPACE TBS_LOGISTICA
ADD DATAFILE 'C:\PRACTICA\DF_LOGISTICA_02.DBF'
SIZE 10M;

ALTER TABLESPACE TBS_CONTABILIDAD
ADD DATAFILE 'C:\PRACTICA\DF_CONTABILIDAD_02.DBF'
SIZE 15M;
----------------------------------
-- 9. CAMBIANDO EL ESTADO DEL TBS
----------------------------------
SELECT * FROM PEDIDOS;

ALTER TABLESPACE TBS_LOGISTICA OFFLINE;

ALTER TABLESPACE TBS_LOGISTICA  ONLINE;
----------------------------------
-- 10. ELIMINANDO LOS TBS
----------------------------------

DROP TABLESPACE TBS_CONTABILIDAD
INCLUDING CONTENTS AND DATAFILES;



---- 1. CREANDO UNA TABLA REGULAR EN EL TBS_REGULAR
----------------------------------------------------------------------
CREATE TABLESPACE TBS_REGULAR
DATAFILE 'C:\TEMP\DF_COMPROBANTES_REGULAR.DBF'
SIZE 150M;
  
CREATE TABLE VENTASREGULAR
(ID NUMBER(10),
 ORIGEN VARCHAR2(20),
 FECHA DATE default sysdate ) TABLESPACE TBS_REGULAR;

----------------------------------------------------------------------
--- 2. INSERTANDO 4 MILLONES DE REGISTROS
----------------------------------------------------------------------
INSERT INTO VENTASREGULAR
SELECT LEVEL, 'ASIA', SYSDATE
FROM DUAL CONNECT BY LEVEL <= 2000000;

INSERT INTO VENTASREGULAR
SELECT LEVEL, 'EUROPA', SYSDATE
FROM DUAL CONNECT BY LEVEL <= 2000000;

select count(*) from ventasregular;

----------------------------------------------------------------------
--- 4. OBTENIENDO EL PLAN DE EJECUCION
----------------------------------------------------------------------
EXPLAIN PLAN 
FOR
SELECT * FROM VENTASREGULAR
WHERE ORIGEN = 'ASIA';

SELECT * FROM TABLE( DBMS_XPLAN.DISPLAY );

select count(*)from dba_source;

select executions,SQL_text
from V$SQL order by 1 desc;

drop table Ventas;

drop TABLESPACE TBS_OTROS;
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

CREATE TABLE Ventas
(ID NUMBER(10),
 ORIGEN VARCHAR2(20),
 FECHA DATE default sysdate )
PARTITION BY LIST( ORIGEN)
(PARTITION ventas_ASIA  VALUES('ASIA')    tablespace TBS_ASIA,
 PARTITION ventas_EUROPA VALUES ('EUROPA') tablespace TBS_EUROPA,
 PARTITION ventas_AL     VALUES ('AL')     tablespace TBS_AL,
 PARTITION ventas_otros  VALUES(DEFAULT)   tablespace TBS_OTROS );


INSERT INTO VENTAS
SELECT LEVEL, 'ASIA', SYSDATE
FROM DUAL CONNECT BY LEVEL < 1000000;
 
INSERT INTO VENTAS
SELECT LEVEL, 'EUROPA', SYSDATE
FROM DUAL CONNECT BY LEVEL < 1000000;

-------------------------------------------------
-- 4 QUERY DE TABLAS PARTICIONADAS
-------------------------------------------------
SELECT * FROM VENTAS;

SELECT * FROM VENTAS PARTITION ( ventas_ASIA );
 
SELECT * FROM VENTAS PARTITION (ventas_EUROPA);


-- TALLER ---

  CREATE TABLESPACE TBS_AUTOS
  DATAFILE 'C:\TEMP\DF_AUTOS.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_BUSES
  DATAFILE 'C:\TEMP\DF_BUSES.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_MOTOS
  DATAFILE 'C:\TEMP\DF_MOTOS.DBF'
  SIZE 100M;
  

CREATE TABLE VEHICULOS
(ID NUMBER(10),
 TIPO VARCHAR2(10),
 AÑO DATE default sysdate,
 PLACA VARCHAR2(10))
PARTITION BY LIST(TIPO)
(PARTITION VEH_AUTOS VALUES('AUTOS')  tablespace TBS_AUTOS,
 PARTITION VEH_BUSES VALUES ('BUSES') tablespace TBS_BUSES,
 PARTITION VEH_MOTOS VALUES ('MOTOS') tablespace TBS_MOTOS);

INSERT INTO VEHICULOS
SELECT LEVEL, 'AUTOS',SYSDATE,'AH5211'
FROM DUAL CONNECT BY LEVEL < 15000;
 
INSERT INTO VEHICULOS
SELECT LEVEL, 'BUSES',SYSDATE,'BU5211'
FROM DUAL CONNECT BY LEVEL < 25000;

INSERT INTO VEHICULOS
SELECT LEVEL, 'MOTOS',SYSDATE,'MO5211'
FROM DUAL CONNECT BY LEVEL < 5000;


SELECT * FROM VEHICULOS;

SELECT * FROM VEHICULOS PARTITION ( VEH_AUTOS );
 


