USE sistemausac;

-- CARGAR CARRERAS
CALL AppendCarrera('Ingenieria Sistemas');
CALL AppendCarrera('Ingenieria Industrial');
CALL AppendCarrera('Ingenieria Mecanica');
CALL AppendCarrera('Ingenieria Quimica');
CALL AppendCarrera('Ingenieria Electrica');
INSERT INTO CARRERA(IdCarrera , Nombre) VALUES (0,'Area Comun');
UPDATE CARRERA SET IdCarrera = 0 WHERE IdCarrera = LAST_INSERT_ID();

-- CARGAR ESTUDIANTES
CALL AppendEstudiante(202006373 ,'Kemel','Jeronimo','2000-4-19','kem@gmail.com',48782865,'6ta calle b','2959297030101',0);
CALL AppendEstudiante(202006374 ,'Denis','Toj','2000-12-25','denis@gmail.com',56782867,'6ta calle a','2959297030100',1);
CALL AppendEstudiante(202006375 ,'William','Cuxum','2010-6-12','wil@gmail.com',48787867,'6ta calle c','2959297030999',2);
CALL AppendEstudiante(202006376 ,'Kevin','Martinez','2008-1-18','kevin@gmail.com',4888865,'6ta calle d','2959297030115',3);

-- CARGAR CURSO
CALL AppendCurso(2001,'MATEMATICA BASICA I',0,8,true,0);
CALL AppendCurso(2002,'TEO 1',0,5,true,1);
CALL AppendCurso(2003,'MATEMATICA BASICA II',5,7,true,0);
CALL AppendCurso(2004,'IO 1',0,10,true,2);
CALL AppendCurso(0099,'ECOLOGIA',0,5,false,0);

-- -- CARGAR DOCENTE

CALL AppendDocente(569,'Luis','Espino','1990-2-15','esp@gmail.com',45454545,'7av 8-53','3030012986');
CALL AppendDocente(162,'Aron','Estrada','1980-12-15','a@gmail.com',45344534,'7av 8-54','3030012987');
CALL AppendDocente(502,'Pilar','Ruiz','1992-8-15','p@gmail.com',67454567,'7av 8-55','3030012988');
CALL AppendDocente(301,'Nathan','Castillo','1990-12-15','n@gmail.com',45124512,'7av 8-56','3030012989');
CALL AppendDocente(660,'Jonatan','Saenz','2000-4-15','j@gmail.com',77754599,'7av 8-57','30300129810');

-- HABILITAR CURSO
CALL AppendHabilitar('VD',3,'A',2001,569);
CALL AppendHabilitar('1S',50,'B',2002,162);
CALL AppendHabilitar('1S',105,'C',2003,502);


-- HORARIO
CALL AppendHorario(1,"9:00-10:40",1);
CALL AppendHorario(2,"9:00-10:40",1);
CALL AppendHorario(3,"9:00-10:40",1);
CALL AppendHorario(3,"9:00-10:40",2);


CALL AppendAsignacionCurso(2001,202006373,'VD','A');
CALL AppendAsignacionCurso(2001,202006374,'VD','A');


CALL  AppendDesCurso(2001,202006373,'VD','A');


CALL AppendNotas(2001,202006374,'VD','A',61);

CALL GenerateActa(2001,'VD','A')





