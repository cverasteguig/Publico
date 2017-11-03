




1.	CREAR LOS SGTES TABLESPACES EN LA CARPETA C:\PRACTICA

CREATE TABLESPACE TBS_COMERCIAL
DATAFILE 'C:\PRACTICA\DF_COMERCIAL_01.DBF'
SIZE 15M;

SELECT * FROM DBA_TABLESPACES;

SELECT FILE#, NAME FROM V$DATAFILE; 


CREANDO TBS FINANZAS:

CREATE TABLESPACE TBS_FINANZAS
DATAFILE 'C:\PRACTICA\DF_FINANZAS_01.DBF'
SIZE 10M;

SELECT * FROM DBA_TABLESPACES;

ALTER TABLESPACE TBS_FINANZAS
ADD DATAFILE 'C:\PRACTICA\DF_FINANZAS_02.DBF'
SIZE 10M;

SELECT * FROM DBA_TABLESPACES;

CREANDO TBS CONTABILIDAD
CREATE TABLESPACE TBS_CONTABILIDAD
DATAFILE 'C:\PRACTICA\DF_CONTABILIDAD_DBF'
SIZE 10M;

SELECT * FROM DBA_TABLESPACES;

CREANDO TBS LOGISTICA
CREATE TABLESPACE TBS_LOGISTICA
DATAFILE 'C:\PRACTICA\DF_LOGISTICA_01.DBF'
SIZE 10M;

SELECT * FROM DBA_TABLESPACES;


ALTER TABLESPACE TBS_LOGISTICA
ADD DATAFILE 'C:\PRACTICA\DF_LOGISTICA_02.DBF'
SIZE 10M;
SELECT * FROM DBA_TABLESPACES;



-- 3. CONSULTA ADMINISTRATIVA DE DATAFILES
----------------------------------
SELECT FILE#, NAME FROM V$DATAFILE; 


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







