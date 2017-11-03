
-- CREANDO UNA TABLA:

CREATE TABLE PERSONA
(IDPERSONA INTEGER PRIMARY KEY, -- DATO UNICO Y NO NULO
 PAT CHAR (50) NOT NULL,
 MAT CHAR (50) NOT NULL,
 NOM CHAR (50) NOT NULL,
 DNI CHAR (8)  UNIQUE,
 FEC_NAC DATE,
 EDAD INTEGER CHECK (EDAD>=18),
 ESTADO INTEGER)
 TABLESPACE USERS;


--VERIFICAR SI LA TABLA EXISTE:


DESCRIBE PERSONA01;

DESC PERSONA;

SELECT * FROM PERSONA01;


-- CONSULTA ADMINISTRATIVA DE TABLAS:

SELECT * FROM DBA_TABLES;

--CONSULTA CON MAS DETALLE DE NUESTRA TABLA:

SELECT * FROM DBA_TABLES
WHERE TABLE_NAME = 'PERSONA';




--                   TALLER 03



CREATE TABLE AFP (
       CODAFP               NUMBER(4) NOT NULL,
       DESCRIPCION          VARCHAR2(50) NULL,
       COMISION_FIJA        NUMBER(15,3) NULL,
       COMISION_VARIABLE    NUMBER(15,3) NULL,
       ESTADO               CHAR(1) NULL
);


ALTER TABLE AFP
       ADD  ( PRIMARY KEY (CODAFP) ) ;


CREATE TABLE AREA (
       CODAREA              NUMBER(4) NOT NULL,
       DESCRIPCION          VARCHAR2(40) NULL,
       ES_PRODUCCION        CHAR(1) NULL,
       ESTADO               CHAR(1) NULL
);


ALTER TABLE AREA
       ADD  ( PRIMARY KEY (CODAREA) ) ;


CREATE TABLE PLANILLA (
       CODPLANILLA          NUMBER NOT NULL,
       CODTRABAJADOR        NUMBER(4) NULL,
       ANNO                 NUMBER NULL,
       MES                  NUMBER NULL,
       BASICO               NUMBER(20,3) NULL,
       HRS_LAB              NUMBER(10,2) NULL,
       HRS_EXT              NUMBER(10,2) NULL,
       BASICO_CALCULADO     NUMBER(15,3) NULL,
       PAGO_HRS_EXTRAS      NUMBER(10,2) NULL,
       BONIFICACION         NUMBER(15,3) NULL,
       TOTAL_INGRESO        NUMBER(15,3) NULL,
       PRESTAMO             NUMBER(10,2) NULL,
       AFP_COMFIJA          NUMBER(20,2) NULL,
       AFP_COMVAR           NUMBER(15,2) NULL,
       FONDO                NUMBER(10,2) NULL,
       TOTAL_DSCTO          NUMBER(15,2) NULL,
       TOTAL_PAGO           NUMBER(10,2) NULL
);


ALTER TABLE PLANILLA
       ADD  ( PRIMARY KEY (CODPLANILLA) ) ;


CREATE TABLE PRESTAMOS (
       CODPRESTAMO          NUMBER(4) NOT NULL,
       CODTRABAJADOR        NUMBER(4) NULL,
       ANNO                 NUMBER NULL,
       MES                  NUMBER NULL,
       FECHA                DATE NULL,
       MONTO                NUMBER(15,3) NULL,
       ESTADO               CHAR(1) NULL
);


ALTER TABLE PRESTAMOS
       ADD  ( PRIMARY KEY (CODPRESTAMO) ) ;


CREATE TABLE REG_HRS_LABORADAS (
       CODREGHRS            NUMBER NOT NULL,
       CODTRABAJADOR        NUMBER(4) NOT NULL,
       NANNO                NUMBER NULL,
       NMES                 INTEGER NULL,
       HRS_LABORADAS        NUMBER(15,2) NULL,
       HRS_EXTRAS           NUMBER(15,3) NULL,
       ESTADO               CHAR(1) NULL
);


ALTER TABLE REG_HRS_LABORADAS
       ADD  ( PRIMARY KEY (CODREGHRS) ) ;


CREATE TABLE RPTBANCO (
       CODRPTBANCO          NUMBER NOT NULL,
       CODPLANILLA          NUMBER NULL,
       CODTRABAJADOR        NUMBER NULL,
       ANNO                 NUMBER NULL,
       MES                  NUMBER NULL,
       CTABANCO             VARCHAR2(20) NULL,
       DEPOSITO             NUMBER(10,2) NULL,
       ESTADO               VARCHAR2(1) NULL
);


ALTER TABLE RPTBANCO
       ADD  ( PRIMARY KEY (CODRPTBANCO) ) ;


CREATE TABLE TRABAJADORES (
       CODTRABAJADOR        NUMBER(4) NOT NULL,
       CODAFP               NUMBER(4) NULL,
       CODAREA              NUMBER(4) NULL,
       PATERNO              VARCHAR2(50) NULL,
       MATERNO              VARCHAR2(50) NULL,
       NOMBRE               VARCHAR2(50) NULL,
       TIPO                 VARCHAR2(1) NULL,
       CTABANCO             CHAR(20) NULL,
       BASICO               NUMBER(15,3) NULL,
       ESTADO               CHAR(1) NULL
);

ALTER TABLE TRABAJADORES
       ADD  ( PRIMARY KEY (CODTRABAJADOR) ) ;

-- CREANDO RELACIONES DEL ESQUEMA :


-- 1. FK_RPTBANCO_PLANILLA:

ALTER TABLE RPTBANCO
ADD CONSTRAINT FK_RPTBANCO_PLANILLA
FOREIGN KEY (CODPLANILLA)
REFERENCES PLANILLA(CODPLANILLA);


-- 2. FK_RPTBANCO_TRABAJADORES:
ALTER TABLE RPTBANCO
ADD CONSTRAINT FK_RPTBANCO_TRABAJADORES
FOREIGN KEY (CODTRABAJADOR)
REFERENCES TRABAJADORES (CODTRABAJADOR);


-- 3. FK_PRESTAMOS_TRABAJADORES:
ALTER TABLE PRESTAMOS
ADD CONSTRAINT FK_PRESTAMOS_TRABAJADORES
FOREIGN KEY (CODTRABAJADOR)
REFERENCES TRABAJADORES (CODTRABAJADOR);


-- 4. FK_TRABAJADORES_AREA:
ALTER TABLE TRABAJADORES
ADD CONSTRAINT FK_TRABAJADORES_AREA
FOREIGN KEY (CODAREA)
REFERENCES AREA (CODAREA);


-- 5. FK_TRABAJADORES_AFP:
ALTER TABLE TRABAJADORES
ADD CONSTRAINT FK_TRABAJADORES_AFP
FOREIGN KEY (CODAFP)
REFERENCES AFP (CODAFP);


-- 6. FK_REG_HRS_LABORADAS_TRABAJADORES:
ALTER TABLE REG_HRS_LABORADAS
ADD CONSTRAINT FK_REG_HRS_LABORADAS_TRABAJADORES
FOREIGN KEY (CODTRABAJADOR)
REFERENCES TRABAJADORES (CODTRABAJADOR);



