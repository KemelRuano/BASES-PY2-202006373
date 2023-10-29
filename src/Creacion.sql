CREATE DATABASE  sistemausac;
USE sistemausac;


CREATE TABLE  CARRERA (
    IdCarrera INTEGER NOT NULL AUTO_INCREMENT ,
    Nombre VARCHAR(50) NOT NULL ,
    PRIMARY KEY(IdCarrera)
); 

CREATE TABLE  CURSO (
	Codigo INTEGER NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    CreditoNecesarios INTEGER NOT NULL,
    CreditosOtorgados INTEGER NOT NULL,
    Obligatorio CHAR(1),
    IdCarrera INTEGER NOT NULL ,
    PRIMARY KEY(Codigo),
	FOREIGN KEY (IdCarrera) REFERENCES CARRERA (IdCarrera)
); 

CREATE TABLE ESTUDIANTE (
    Carnet           INTEGER NOT NULL,
    Nombre           VARCHAR(50) NOT NULL,
    Apellido         VARCHAR(50) NOT NULL,
    FechaNacimiento  DATE NOT NULL,
    Correo           VARCHAR(50) NOT NULL,
    Telefono         INTEGER NOT NULL,
    Direccion        VARCHAR(100) NOT NULL,
    Dpi              INTEGER NOT NULL,
    Fecha            DATE,
    Creditos         INTEGER,
    IdCarrera        INTEGER NOT NULL,
    PRIMARY KEY(Carnet),
	FOREIGN KEY (IdCarrera) REFERENCES CARRERA (IdCarrera)
);


CREATE TABLE DOCENTE (
    SiifDocente    		INTEGER NOT NULL,
    Nombre           	VARCHAR(50) NOT NULL,
    Apellido         	VARCHAR(50) NOT NULL,
    FechaNacimiento 	DATE NOT NULL,
    Correo           	VARCHAR(50) NOT NULL,
    Telefono         	INTEGER NOT NULL,
    Direccion        	VARCHAR(100) NOT NULL,
    Dpi              	INTEGER NOT NULL,
    Fecha            	DATE ,
    PRIMARY KEY(SiifDocente)
);

CREATE TABLE HABILITARCURSO (
    IdHabilitar          INTEGER NOT NULL AUTO_INCREMENT,
    Ciclo                VARCHAR(2) NOT NULL,
    CupoMaximo           INTEGER NOT NULL,
    Seccion              CHAR(1) NOT NULL,
    Año                  YEAR,
    Codigo         		 INTEGER NOT NULL,
	SiifDocente 		 INTEGER NOT NULL,
	PRIMARY KEY(IdHabilitar),
    FOREIGN KEY (Codigo) REFERENCES CURSO (Codigo),
    FOREIGN KEY (SiifDocente) REFERENCES DOCENTE (SiifDocente)
);

CREATE TABLE ASIGNADO (
    IdAsignado          INTEGER NOT NULL AUTO_INCREMENT,
    Cantidad            INTEGER NOT NULL,
    IdHabilitar 		INTEGER NOT NULL,
	PRIMARY KEY(IdAsignado),
    FOREIGN KEY (IdHabilitar) REFERENCES HABILITARCURSO (IdHabilitar)
);

CREATE TABLE HORARIO (
    IdHorario         INTEGER NOT NULL AUTO_INCREMENT,
    Dia               INTEGER NOT NULL,
    Horario           VARCHAR(20) NOT NULL,
    IdHabilitar 	  INTEGER NOT NULL,
    PRIMARY KEY(IdHorario),
    FOREIGN KEY (IdHabilitar) REFERENCES HABILITARCURSO (IdHabilitar)
);
CREATE TABLE ACTA (
    IdActa              INTEGER NOT NULL AUTO_INCREMENT,
    Fecha             	DATE,
    Hora               	DATE,
    IdHabilitar 		INTEGER NOT NULL,
	PRIMARY KEY(IdActa),
    FOREIGN KEY (IdHabilitar) REFERENCES HABILITARCURSO (IdHabilitar)
);


CREATE TABLE ASIGNACIONCURSO (
	IdAsigCurso      	INTEGER NOT NULL AUTO_INCREMENT,
    IdHabilitar 		INTEGER NOT NULL,
    Carnet  			INTEGER NOT NULL,
    PRIMARY KEY(IdAsigCurso),
    FOREIGN KEY (IdHabilitar) REFERENCES HABILITARCURSO (IdHabilitar),
	FOREIGN KEY (Carnet) REFERENCES ESTUDIANTE (Carnet)
);

CREATE TABLE DESASIGNACIONCURSO (
	IdDesgCurso      	INTEGER NOT NULL AUTO_INCREMENT,
    IdHabilitar 		INTEGER NOT NULL,
    Carnet  			INTEGER NOT NULL,
    PRIMARY KEY(IdDesgCurso),
    FOREIGN KEY (IdHabilitar) REFERENCES HABILITARCURSO (IdHabilitar),
	FOREIGN KEY (Carnet) REFERENCES ESTUDIANTE (Carnet)
);

CREATE TABLE NOTA (
    IdNota                             INTEGER NOT NULL AUTO_INCREMENT,
    Nota                           	   INTEGER NOT NULL,
	IdHabilitar 		INTEGER NOT NULL,
    Carnet  			INTEGER NOT NULL,
	PRIMARY KEY(IdNota),
	FOREIGN KEY (IdHabilitar) REFERENCES HABILITARCURSO (IdHabilitar),
	FOREIGN KEY (Carnet) REFERENCES ESTUDIANTE (Carnet)
);

