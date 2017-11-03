
-- 1.	CREAR LOS SGTES TABLESPACES EN LA CARPETA C:\PRACTICA

CREATE TABLESPACE TB_COMERCIAL
DATAFILE 'C:\PRACTICA\DF_COMERCIAL_01.DBF'
SIZE 15M;

CREATE TABLESPACE TB_FINANZAS
DATAFILE 'C:\PRACTICA\DF_FINANZAS_01.DBF'
SIZE 10M;
CREATE TABLESPACE TB_FINANZAS
DATAFILE 'C:\PRACTICA\DF_FINANZAS_02.DBF'
SIZE 10M;

CREATE TABLESPACE TB_CONTABILIDAD
DATAFILE 'C:\PRACTICA\DF_CONTABILIDAD.DBF'
SIZE 10M;

CREATE TABLESPACE TB_LOGISTICA
DATAFILE 'C:\PRACTICA\DF_LOGISTICA_02.DBF'
SIZE 10M;


--  AGREGAR UN NUEVO DATAFILE A TBS_CONTABILIDAD DE 15MB.

ALTER TABLESPACE TB_CONTABILIDAD
ADD DATAFILE 'C:\PRACTICA\DF_CONTABILIDAD_02.DBF'
SIZE 10M;

SELECT * FROM DBA_TABLESPACES;

--3.	CREAR LA TABLA PEDIDOS EN TBS_LOGISTICA
CREATE TABLE PEDIDOS 
( IDPEDIDO NUMBER(10),
  FECHA DATE,
  REFERENCIA CHAR(100) )
TABLESPACE TB_LOGISTICA;

--4.	INSERTAR 10 MIL REGISTROS EN LA TABLA PEDIDOS, VERIFIQUE EL PORCENTAJE DE POBLAMIENTO.

INSERT INTO PEDIDOS
SELECT LEVEL , SYSDATE, 'REF' || LEVEL
FROM DUAL CONNECT BY LEVEL <= 10000;

 CONSULTA DE TAMAÑO Y PORCENTAJE DE ESPACIO LIBRE
--------------------------------------------------------
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


--5.	ELIMINAR EL TABLESPACE TBS_CONTABILIDAD. VERIFICAR.

DROP TABLESPACE TB_CONTABILIDAD
INCLUDING CONTENTS AND DATAFILES;

SELECT * FROM DBA_TABLESPACES;

--6.	CAMBIAR EL ESTADO DEL TBS_LOGISITCA A OFFLINE, CONSULTE LA TABLA PEDIDOS, QUE SUCEDE. PORQUE?
ALTER TABLESPACE TB_LOGISTICA OFFLINE;

-- TBS_LOGISTICA ha sido alterado

SELECT * FROM PEDIDOS

-- porque esta fuera de linea y no puede leer
7.	MODIFICAR EL ESTADO DE TBS_LOGISTICA A ONLINE, CONSULTE LA TABLA PEDIDOS.

ALTER TABLESPACE TB_LOGISTICA  ONLINE;
SELECT * FROM PEDIDOS
