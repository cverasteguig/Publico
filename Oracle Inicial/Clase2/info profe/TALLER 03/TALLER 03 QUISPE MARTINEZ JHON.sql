
ALTER TABLE RPTBANCO
ADD CONSTRAINT FK_BANCO_PLANILLA
FOREIGN KEY (CODPLANILLA)
REFERENCES PLANILLA (CODPLANILLA);

ALTER TABLE PLANILLA
ADD CONSTRAINT FK_PLANILLA_TRABAJADORES
FOREIGN KEY (CODTRABAJADOR)
REFERENCES TRABAJADORES (CODTRABAJADOR);

ALTER TABLE TRABAJADORES
       ADD  ( PRIMARY KEY (CODTRABAJADOR) ) ;
       
ALTER TABLE PRESTAMOS
ADD CONSTRAINT FK_PRESTAMO_TRABAJADORES
FOREIGN KEY (CODTRABAJADOR)
REFERENCES TRABAJADORES (CODTRABAJADOR);

ALTER TABLE TRABAJADORES
ADD CONSTRAINT FK_TRABAJADORES_AREA
FOREIGN KEY (CODAREA)
REFERENCES AREA (CODAREA);

ALTER TABLE TRABAJADORES
ADD CONSTRAINT FK_TRABAJADORES_AFP
FOREIGN KEY (CODAFP)
REFERENCES AFP (CODAFP);

ALTER TABLE REG_HRS_LABORADAS
ADD CONSTRAINT FK_REG_HRS_LABORADAS_TRABAJADORES
FOREIGN KEY (CODTRABAJADOR)
REFERENCES TRABAJADORES (CODTRABAJADOR);
