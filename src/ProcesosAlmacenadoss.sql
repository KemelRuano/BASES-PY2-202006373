DROP PROCEDURE IF EXISTS AppendCarrera;
DROP PROCEDURE IF EXISTS AppendEstudiante;
DROP PROCEDURE IF EXISTS AppendCurso;
DROP PROCEDURE IF EXISTS AppendDocente;
DROP PROCEDURE IF EXISTS AppendHabilitar;
DROP PROCEDURE IF EXISTS AppendHorario;
DROP PROCEDURE IF EXISTS AppendCantidad;
DROP PROCEDURE IF EXISTS AppendAsignacionCurso;
DROP PROCEDURE IF EXISTS AppendDesCurso;
DROP PROCEDURE IF EXISTS AppendNotas;
DROP PROCEDURE IF EXISTS GenerateActa;
-- ============================= PROCEDIMIENTO PARA CARRERA ==============
DELIMITER //
CREATE PROCEDURE AppendCarrera(IN NuevaCarrera VARCHAR(50))
BEGIN
	DECLARE Existe INT;
	IF NuevaCarrera REGEXP '^[A-Za-z ]+$' THEN
			SELECT COUNT(*) INTO Existe
			FROM CARRERA
			WHERE Nombre = NuevaCarrera;

			IF Existe = 0 THEN
				INSERT INTO CARRERA (Nombre) VALUES (NuevaCarrera);
			ELSE SELECT 'LA CARRERA YA EXISTE' AS Msg;
			END IF;
	ELSE SELECT 'DEBE CONTENER SOLO LETRAS' as Msg;
	END IF;
END //
DELIMITER ;
-- ============================= PROCEDIMIENTO PARA ESTUDIANTES ==============
DELIMITER //
CREATE PROCEDURE AppendEstudiante(
	NewCarnet INTEGER,NewNombre VARCHAR(50),NewApellido VARCHAR(50) ,
	NewFechaNac DATE ,NewCorreo VARCHAR(50) ,NewTelefono INTEGER,NewDireccion VARCHAR(50), 
	NewDpi VARCHAR(50) , NewIdCarrera INTEGER
)
BEGIN
     DECLARE Existe INT;
	 IF NewCorreo REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$' THEN
     
			SELECT COUNT(*) INTO Existe
			FROM ESTUDIANTE
			WHERE Carnet = NewCarnet;
			IF Existe = 0 THEN
					INSERT INTO ESTUDIANTE (
						Carnet,Nombre,Apellido,FechaNacimiento,Correo,
						Telefono,Direccion,Dpi,Fecha,Creditos,IdCarrera
					) VALUES (
						NewCarnet,NewNombre,NewApellido,NewFechaNac,NewCorreo,
						NewTelefono,NewDireccion,NewDpi,curdate(),0,NewIdCarrera
					);
			ELSE SELECT 'EL ESTUDIANTE YA ESTA REGISTRADO' AS Msg;
			END IF;
    ELSE SELECT 'CORREO INVALIDO' AS Msg;
    END IF;
END //
DELIMITER ;

-- ============================= PROCEDIMIENTO PARA CURSO ==============

DELIMITER //
CREATE PROCEDURE AppendCurso(
	NewCodigo INTEGER,NewNombre VARCHAR(50),NewCreditoNecesarios INTEGER,
	NewCreditosOtorgados INTEGER ,NewObligatorio BOOLEAN , NewIdCarrera INTEGER
)
BEGIN
		DECLARE Existe INT;
		IF NewCreditoNecesarios  >= 0 AND NewCreditosOtorgados  >= 0 THEN
				SELECT COUNT(*) INTO Existe
				FROM CURSO
				WHERE Codigo = NewCodigo;
				IF Existe = 0 THEN
						INSERT INTO CURSO (
							Codigo,Nombre,CreditoNecesarios,CreditosOtorgados,Obligatorio,IdCarrera
						) VALUES (
							NewCodigo,NewNombre,NewCreditoNecesarios,NewCreditosOtorgados,
							NewObligatorio,NewIdCarrera
						);
				ELSE SELECT 'CURSO YA EXISTENTE' AS Msg;
				END IF;
        ELSE SELECT 'DEBE SER 0 o UN ENTERO POSITIVO' AS Msg;
        END IF;
END //
DELIMITER ;

-- -- ============================= PROCEDIMIENTO PARA DOCENTE ==============
DELIMITER //
CREATE PROCEDURE AppendDocente(
	NewSiifDocente INTEGER,NewNombre VARCHAR(50),NewApellido VARCHAR(50) ,
	NewFechaNac DATE ,NewCorreo VARCHAR(50) ,NewTelefono INTEGER,NewDireccion VARCHAR(50), 
	NewDpi VARCHAR(50)
)
BEGIN
	 DECLARE Existe INT;
	 IF NewCorreo REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$' THEN
     
			SELECT COUNT(*) INTO Existe
			FROM DOCENTE
			WHERE SiifDocente = NewSiifDocente;
			IF Existe = 0 THEN
					INSERT INTO DOCENTE (
						SiifDocente,Nombre,Apellido,FechaNacimiento,
						Correo,Telefono,Direccion,Dpi,Fecha
					) VALUES (
						NewSiifDocente,NewNombre,NewApellido,NewFechaNac,
						NewCorreo,NewTelefono,NewDireccion,NewDpi,curdate()
					);
			ELSE SELECT 'EL DOCENTE YA ESTA REGISTRADO' AS Msg;
			END IF;
    ELSE SELECT 'CORREO INVALIDO' as Msg;
    END IF;
END //
DELIMITER ;

-- -- ============================= PROCEDIMIENTO PARA HABILITAR CURSO ==============
DELIMITER //
CREATE PROCEDURE AppendHabilitar(
	NewCiclo VARCHAR(2),NewCupoMaximo INTEGER , NewSeccion CHAR(1), NewCodigo INTEGER , NewSiifDocente INTEGER
)
BEGIN
        DECLARE anios INT;
		DECLARE CursoExist INT;
        IF NewCiclo IN('1S','2S','VJ','VD') THEN
				IF NewCupoMaximo >= 0 THEN
						IF NewSeccion REGEXP '[A-Za-z]'THEN
                            SELECT COUNT(*) INTO CursoExist
							FROM CURSO
							WHERE Codigo = NewCodigo;
							IF CursoExist = 0 THEN SELECT 'EL CURSO NO EXISTE' AS Msg;
                            ELSE 
		
									SET anios = YEAR(CURDATE());
									INSERT INTO HABILITARCURSO (Ciclo,CupoMaximo,Seccion,Año,Codigo,SiifDocente) 
									VALUES (NewCiclo,NewCupoMaximo,UPPER(NewSeccion),anios,NewCodigo,NewSiifDocente);
									CALL AppendCantidad(last_insert_id());
                           END IF;
						ELSE SELECT 'LA SECCION DEBE SER UNA LETRA' as Msg; END IF;
				ELSE SELECT 'CUPO MAXIMO DEBE SER DE TIPO ENTERO +' as Msg; END IF;
        ELSE SELECT 'EL CICLO ES INVALIDO' as Msg; END IF;
END //
DELIMITER ;
-- ============================= PROCEDIMIENTO PARA HORARIO ==============
DELIMITER //
CREATE PROCEDURE AppendHorario(Newdia INTEGER , NewHorario VARCHAR(20) , NewIdHabilitar INTEGER )
BEGIN
			DECLARE EstaHabilitado INT;
			IF Newdia BETWEEN 1 AND 7  THEN
							SELECT COUNT(*) INTO EstaHabilitado
							FROM HABILITARCURSO
							WHERE IdHabilitar = NewIdHabilitar;
							IF EstaHabilitado = 0 THEN SELECT 'EL CURSO NO ESTA HABILITADO' AS Msg;
                            ELSE 
									INSERT INTO HORARIO (Dia,Horario,IdHabilitar) 
									VALUES (Newdia,NewHorario,NewIdHabilitar);
                            END IF;
            ELSE SELECT 'DIA INVALIDO' as Msg;
            END IF;
				
END //
DELIMITER ;

-- ============================= PROCEDIMIENTO PARA ASIGNADO ==============
DELIMITER //
CREATE PROCEDURE AppendCantidad(NewIdHabilitar INTEGER )
BEGIN
				INSERT INTO ASIGNADO (Cantidad,IdHabilitar) 
				VALUES (0,NewIdHabilitar);				
END //
DELIMITER ;

-- ============================= PROCEDIMIENTO PARA ASIGNACIONCURSO ==============
DELIMITER //
CREATE PROCEDURE AppendAsignacionCurso(NewCodigo INTEGER ,NewCarnet INTEGER ,NewCiclo  VARCHAR(2) ,NewSeccion CHAR(1))
BreakAsig : BEGIN
		--  SI EL CURSO NO ESTA HABILITADO
		IF (SELECT COUNT(*) FROM HABILITARCURSO  WHERE Codigo = NewCodigo) = 0 THEN 
			SELECT 'EL CURSO NO ESTA HABILITADO' AS Msg;
			LEAVE BreakAsig;
		END IF;
        --  SI EL ESTUDIANTE NO EXISTE
        IF (SELECT COUNT(*) FROM ESTUDIANTE  WHERE Carnet = NewCarnet) = 0 THEN 
			SELECT 'NO EXISTE ESTUDIANTE' AS Msg;
			LEAVE BreakAsig;
		END IF;
        --  SI NO CUMPLE CON LOS CREDITOS SUFICIENTE
		IF (SELECT Creditos FROM ESTUDIANTE WHERE Carnet = NewCarnet) < (SELECT CreditoNecesarios FROM CURSO WHERE Codigo = NewCodigo) THEN
			SELECT 'CREDITOS INSUFICIENTES' AS Msg;
			LEAVE BreakAsig;
		END IF;
        --  SI EL ESTUDIANTE YA ESTA ASIGNADO
        IF EXISTS (SELECT * FROM ASIGNACIONCURSO WHERE Carnet = NewCarnet AND IdHabilitar = (SELECT   IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo  AND Seccion = NewSeccion AND Año = YEAR(CURDATE()))) THEN
			SELECT 'YA ESTA ASIGNADO AL CURSO' AS Msg;
			LEAVE BreakAsig;
		END IF; 
        -- VERIFICAR SI EXISTE LA SECCION 
		IF NOT EXISTS (SELECT * FROM HORARIO WHERE IdHabilitar = (SELECT IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo AND Seccion = NewSeccion AND Año = YEAR(CURDATE()))) THEN
			SELECT 'ESTA SECCION NO EXISTE EN EL CURSO' AS Msg;
			LEAVE BreakAsig;
		END IF;
        
        -- Validacion si hay cupo aun 
         IF (SELECT Cantidad FROM ASIGNADO WHERE IdHabilitar = (SELECT IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo AND Seccion = NewSeccion AND Año = YEAR(CURDATE()))) >= (SELECT CupoMaximo FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo AND Seccion = NewSeccion AND Año = YEAR(CURDATE())) THEN
			SELECT 'LOS CUPOS LLEGARON A SU MAXIMO' AS Msg;
			LEAVE BreakAsig;
		END IF;
        
          IF (SELECT IdCarrera FROM ESTUDIANTE WHERE Carnet = NewCarnet) != (SELECT IdCarrera FROM CURSO WHERE Codigo = NewCodigo) AND (SELECT IdCarrera FROM CURSO WHERE Codigo = NewCodigo) != 0 THEN
			SELECT 'EL CURSO NO EXISTE EN LA CARRERA ' AS Msg;
			LEAVE BreakAsig;
		END IF;
        
        INSERT INTO ASIGNACIONCURSO (IdHabilitar,Carnet) VALUES ((SELECT IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo  AND Seccion = NewSeccion AND Año =  YEAR(CURDATE())), NewCarnet);	
        UPDATE ASIGNADO SET Cantidad = Cantidad + 1 WHERE IdHabilitar = (SELECT IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo  AND Seccion = NewSeccion AND Año =  YEAR(CURDATE()));
        
END //
DELIMITER ;
-- ============================= PROCEDIMIENTO PARA DESASIGNACION ==============
DELIMITER //
CREATE PROCEDURE AppendDesCurso(NewCodigo INTEGER ,NewCarnet INTEGER ,NewCiclo  VARCHAR(2) ,NewSeccion CHAR(1))
Breakdesg : BEGIN

        --  SI EL ESTUDIANTE NO EXISTE
        IF (SELECT COUNT(*) FROM ESTUDIANTE  WHERE Carnet = NewCarnet) = 0 THEN 
			SELECT 'NO EXISTE ESTUDIANTE' AS Msg;
			LEAVE Breakdesg;
		END IF;
          --  SI EL ESTUDIANTE YA ESTA ASIGNADO
        IF NOT EXISTS (SELECT * FROM ASIGNACIONCURSO WHERE Carnet = NewCarnet AND IdHabilitar = (SELECT   IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo  AND Seccion = NewSeccion AND Año = YEAR(CURDATE()))) THEN
			SELECT 'NO ESTA ASIGNADO AL CURSO ' AS Msg;
			LEAVE Breakdesg;
		END IF; 
        
        IF (SELECT IdCarrera FROM ESTUDIANTE WHERE Carnet = NewCarnet) != (SELECT IdCarrera FROM CURSO WHERE Codigo = NewCodigo) AND (SELECT IdCarrera FROM CURSO WHERE Codigo = NewCodigo) != 0 THEN
			SELECT 'EL CURSO NO EXISTE EN LA CARRERA ' AS Msg;
			LEAVE Breakdesg;
		END IF;
        
        DELETE FROM ASIGNACIONCURSO WHERE Carnet = NewCarnet  AND IdHabilitar = (SELECT IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo  AND Seccion = NewSeccion AND Año = YEAR(CURDATE()));
        UPDATE ASIGNADO SET Cantidad = Cantidad - 1 WHERE  IdHabilitar = (SELECT IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo  AND Seccion = NewSeccion AND Año = YEAR(CURDATE()));
		INSERT INTO DESASIGNACIONCURSO(Carnet, IdHabilitar) VALUES(NewCarnet, (SELECT IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo AND Seccion = NewSeccion AND Año = YEAR(CURDATE())));
        SELECT 'CURSO DESASIGNADO' AS Msg;
END //
DELIMITER ;

-- ============================= PROCEDIMIENTO PARA NOTAS ==============
DELIMITER //
CREATE PROCEDURE AppendNotas(NewCodigo INTEGER ,NewCarnet INTEGER ,NewCiclo  VARCHAR(2) ,NewSeccion CHAR(1) ,NewNota FLOAT)
BreakNota : BEGIN
		--  SI EL ESTUDIANTE NO EXISTE
        IF (SELECT COUNT(*) FROM ESTUDIANTE  WHERE Carnet = NewCarnet) = 0 THEN 
			SELECT 'NO EXISTE ESTUDIANTE' AS Msg;
			LEAVE BreakNota;
		END IF;
        IF NewNota <= 0 THEN 
			SELECT 'LA NOTA DEBE SER POSITIVA ' AS Msg;
            LEAVE BreakNota;
        END IF;
        
        IF EXISTS (SELECT * FROM NOTA WHERE Carnet = NewCarnet AND IdHabilitar = (SELECT   IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo  AND Seccion = NewSeccion AND Año = YEAR(CURDATE()))) THEN
            SELECT 'EL ESTUDIANTE YA TIENE NOTA DEL CURSO' AS Msg;
			LEAVE BreakNota;
        END IF;
        
        INSERT INTO NOTA(IdHabilitar, Carnet,Nota) VALUES((SELECT IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo AND Seccion = NewSeccion AND Año = YEAR(CURDATE())),NewCarnet, CAST(NewNota AS SIGNED)); 
        IF NewNota >= 61 THEN 
			UPDATE ESTUDIANTE  SET  Creditos = Creditos + (SELECT CreditosOtorgados FROM CURSO WHERE Codigo = NewCodigo )
			WHERE Carnet = NewCarnet ;
        END IF;
END //
DELIMITER ;

-- ============================= PROCEDIMIENTO PARA ACTA ==============
DELIMITER //
CREATE PROCEDURE GenerateActa(NewCodigo INTEGER ,NewCiclo  VARCHAR(2) ,NewSeccion CHAR(1))
BreakActa : BEGIN
		DECLARE TIEMPO TIME;
        DECLARE FECHA DATE;
		SET TIEMPO = CURTIME();
        SET FECHA = curdate();
		IF NOT EXISTS (SELECT * FROM NOTA WHERE IdHabilitar = (SELECT IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo AND Seccion = NewSeccion)) THEN 
 			 SELECT 'NO EXISTEN NOTAS DEL CURSO AUN ' AS Msg;
             LEAVE BreakActa;
 		END IF;
		INSERT INTO ACTA(Fecha,Hora,IdHabilitar) VALUES(FECHA,TIEMPO,(SELECT IdHabilitar FROM HABILITARCURSO WHERE Codigo = NewCodigo AND Ciclo = NewCiclo AND Seccion = NewSeccion AND Año = YEAR(CURDATE()))); 
END //
DELIMITER ;

