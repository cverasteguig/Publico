
----------------------------------
------PREGUNTA 1. CREACION DE TBS COMERCIAL----
----------------------------------

CREATE TABLESPACE TBS_COMERCIAL
DATAFILE 'C:\BDORACLE\DF_COMERCIAL_01.DBF'
SIZE 15M;
CREATE TABLESPACE TBS_FINANZAS
DATAFILE 'C:\BDORACLE\DF_FINANZAS_01.DBF'
SIZE 10M;
CREATE TABLESPACE TBS_FINANZAS
DATAFILE 'C:\BDORACLE\DF_FINANZAS_02.DBF'
SIZE 10M;
CREATE TABLESPACE TBS_CONTABILIDAD
DATAFILE 'C:\BDORACLE\DF_CONTABILIDAD.DBF'
SIZE 10M;
CREATE TABLESPACE TBS_LOGISTICA
DATAFILE 'C:\BDORACLE\DF_LOGISTICA_01.DBF'
SIZE 10M;
CREATE TABLESPACE TBS_LOGISTICA
DATAFILE 'C:\BDORACLE\DF_LOGISTICA_02.DBF'
SIZE 10M;

---PREGUNTA 2-------
CREATE TABLESPACE TBS_CONTABILIDAD
DATAFILE 'C:\BDORACLE\DF_CONTABILIDAD.DBF'
SIZE 15M;

-------PREGUNTA 3---------
ALTER DATABASE 
DATAFILE 'C:\BDORACLE\DF_COMERCIAL_01.DBF'
RESIZE 25M;

-------PREGUNTA 4---------
CREATE TABLE PEDIDOS
( IDPEDIDO NUMBER (10) ,FECHA DATE, 
  REFERENCIA CHAR(100) )
TABLESPACE TBS_LOGISTICA;

SELECT * FROM PEDIDOS;

---pREGUNTA 5----

INSERT INTO PEDIDOS
SELECT LEVEL, SYSDATE,'REF_'||LEVEL
FROM DUAL
CONNECT BY LEVEL <=10000;

----PREGUNTA 6----
DROP TABLESPACE TBS_CONTABILIDAD
INCLUDING CONTENTS AND DATAFILES;

----PREGUNTA 7----

ALTER TABLESPACE TBS_LOGISTICA OFFLINE;

----PREGUNTA 8----

ALTER TABLESPACE TBS_LOGISTICA  ONLINE;