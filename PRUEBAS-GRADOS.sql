-- [P] 1. Crear grado con datos correctos.

DELIMITER //
CREATE OR REPLACE PROCEDURE pTestDegree_1()
BEGIN
	CALL pPopulateDB();
	CALL pInsertDegree('Grado en Ingeniería de la Salud', 4);
END //
DELIMITER ;

-- [N] 2. Crear grado con nombre vacío.

DELIMITER //
CREATE OR REPLACE PROCEDURE pTestDegree_2()
BEGIN
	CALL pPopulateDB();
	CALL pInsertDegree(NULL, 4);
END //
DELIMITER ;

-- [N] 3. Crear grado con el mismo nombre que otro ya existente.

DELIMITER //
CREATE OR REPLACE PROCEDURE pTestDegree_3()
BEGIN
	CALL pPopulateDB();
	CALL pInsertDegree('Grado en Ingeniería de la Salud', 4);
	CALL pInsertDegree('Grado en Ingeniería de la Salud', 4);
END //
DELIMITER ;

-- [N] 4. Crear grado con years incorrectos.

DELIMITER //
CREATE OR REPLACE PROCEDURE pTestDegree_4()
BEGIN
	CALL pPopulateDB();
	CALL pInsertDegree('Grado en Ingeniería de la Salud', -1);
END //
DELIMITER ;

-- [P] 5. Actualizar grado con datos correctos.

DELIMITER //
CREATE OR REPLACE PROCEDURE pTestDegree_5()
BEGIN
	CALL pPopulateDB();
	CALL pUpdateDegree(1, 'Grado en Ingeniería de la Salud', 3);
END //
DELIMITER ;

-- [N] 6. Actualizar grado con nombre a NULL.

DELIMITER //
CREATE OR REPLACE PROCEDURE pTestDegree_6()
BEGIN
	CALL pPopulateDB();
	CALL pUpdateDegree(1, NULL, 4);
END //
DELIMITER ;

-- [N] 7. Actualizar grado con el mismo nombre que otro existente.

DELIMITER //
CREATE OR REPLACE PROCEDURE pTestDegree_7()
BEGIN
	CALL pPopulateDB();
	CALL pUpdateDegree(1, 'Grado en Ingeniería de la Salud', 4);
	CALL pUpdateDegree(2, 'Grado en Ingeniería de la Salud', 4);
END //
DELIMITER ;

-- [N] 8. Actualizar grado con years incorrectos.

DELIMITER //
CREATE OR REPLACE PROCEDURE pTestDegree_8()
BEGIN
	CALL pPopulateDB();
	CALL pUpdateDegree(1, 'Grado en Ingeniería de Software', -1);
END //
DELIMITER ;

-- [P] 9. Eliminar grado.

DELIMITER //
CREATE OR REPLACE PROCEDURE pTestDegree_9()
BEGIN
	CALL pPopulateDB();
	CALL pInsertDegree('Grado en Ingeniería de la Salud', 4);
	DELETE FROM Degrees WHERE degreeId = 4;
END //
DELIMITER ;

-- [N] 10. Eliminar grado no existente (no lanza excepción).

DELIMITER //
CREATE OR REPLACE PROCEDURE pTestDegree_10()
BEGIN
	CALL pPopulateDB();
	DELETE FROM Degrees WHERE degreeId = 9999;
END //
DELIMITER ;

-- [N] 11. Eliminar grado con relaciones.

DELIMITER //
CREATE OR REPLACE PROCEDURE pTestDegree_11()
BEGIN
	CALL pPopulateDB();
	DELETE FROM Degrees WHERE degreeId = 1;
END //
DELIMITER ;
