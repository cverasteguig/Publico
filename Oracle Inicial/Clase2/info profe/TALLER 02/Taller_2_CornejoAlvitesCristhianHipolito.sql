----------------------------------
-- 1. CREACION DE TBS
----------------------------------
  CREATE TABLESPACE TBS_AUTOS
  DATAFILE 'C:\TEMP\DF_AUTOS.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_CAMIONETAS
  DATAFILE 'C:\TEMP\DF_CAMIONETAS.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_BUSES
  DATAFILE 'C:\TEMP\DF_BUSES.DBF'
  SIZE 100M;
  
 CREATE TABLESPACE TBS_CAMIONES 
  DATAFILE 'C:\TEMP\DF_CAMIONES.DBF'
  SIZE 100M;
  
CREATE TABLE VEHICULOS
(ID NUMBER(10),
 TIPO VARCHAR2(10),
 A�O INTEGER,
 PLACA VARCHAR2(10) )
PARTITION BY LIST(TIPO)
(PARTITION LISTA_AUTOS  VALUES('AUTOS')    tablespace TBS_AUTOS,
 PARTITION LISTA_CAMIONETAS VALUES ('CAMIONETAS') tablespace TBS_CAMIONETAS,
 PARTITION LISTA_BUSES     VALUES ('BUSES')     tablespace TBS_BUSES,
 PARTITION LISTA_CAMIONES  VALUES('CAMIONES')   tablespace TBS_CAMIONES );

-------------------------------------------------
-- 2 INSERTANDO DATOS EN TABLAS PARTICIONADAS
-------------------------------------------------
INSERT INTO VEHICULOS
SELECT LEVEL, 'AUTOS', 1960,'ABC-' || LEVEL
FROM DUAL CONNECT BY LEVEL <= 15000;
-------------------------------------------------
-- 3 INSERTANDO DATOS EN TABLAS PARTICIONADAS
-------------------------------------------------
INSERT INTO VEHICULOS
SELECT LEVEL, 'BUSES', 1960,'ABC-' || LEVEL
FROM DUAL CONNECT BY LEVEL <= 25000;

-------------------------------------------------
-- 4 QUERY DE TABLAS PARTICIONADAS
-------------------------------------------------
SELECT COUNT(1) FROM VEHICULOS;

SELECT * FROM VEHICULOS PARTITION ( LISTA_AUTOS );

-------------------------------------------------
-- 5
-------------------------------------------------
INSERT INTO VEHICULOS
SELECT LEVEL, 'MOTOS', 1960,'ABC-' || LEVEL
FROM DUAL CONNECT BY LEVEL <= 5000;
--RPTA
--EL TIPO INGRESADO NO CORRESPONDE A NINGUNA PARTICION DEFINIDA CON LO CUAL EL SISTEMA NO PUEDE ASIGNARLO
--, SE DEBE AGREGAR UN DEFAULT PARA PODER REGISTRARLO
