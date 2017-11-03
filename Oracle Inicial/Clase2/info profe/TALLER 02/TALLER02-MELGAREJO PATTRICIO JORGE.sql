
------------------------------------
Los Registros P�blicos mantiene la informaci�n de los veh�culos a 
nivel nacional, autos, camionetas, buses y camiones.
Se requiere crear una tabla que almacene esta informaci�n 
considerando que existen 50 millones de veh�culos desde el a�o 1960 ( fecha inicial de registro).

TABLA : VEHICULOS
ID          NUMERIC   10
TIPO     VARCHAR   10
A�O    INTEGER
PLACA VARCHAR   10

CREATE TABLESPACE TBS_REGISTROP
  DATAFILE 'C:\TEMP\DF_REGISTRO.DBF'
  SIZE 100M;
  -------------------------------
   CREATE TABLESPACE TBS_AUTO
  DATAFILE 'C:\TEMP\DF_REGISTRO_AUTO.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_BUSES
  DATAFILE 'C:\TEMP\DF_REGISTRO_BUSES.DBF'
  SIZE 100M;
  
  CREATE TABLESPACE TBS_MOTOS
  DATAFILE 'C:\TEMP\DF_MOTOS.DBF'
  SIZE 100M;
  
2. Insertar 15,000 AUTOS, verificar la partici�n donde se guarda dichos registros
 
 INSERT INTO Vehiculos
SELECT LEVEL, 'AUTO', 1960,'1'
FROM DUAL CONNECT BY LEVEL <1000000;

3. Insertar 25,000 BUSES, verificar la partici�n donde se guarda dichos registros

INSERT INTO Vehiculos
SELECT LEVEL, 'BUSES', 1960,'12'
FROM DUAL CONNECT BY LEVEL < 50000;
SELECT *FROM DBA_TABLESPACES;

4. Utilizando SELECT PARTITION, liste los AUTOS.

SELECT * FROM Vehiculos PARTITION ( registro_AUTO );

5. Insertar 5,000 MOTOS. �Qu� sucede?. Por que?

INSERT INTO Vehiculos
SELECT LEVEL, 'MOTOS', 1960,'13'
FROM DUAL CONNECT BY LEVEL < 5000;
SELECT *FROM DBA_TABLESPACES;

 
 
 























