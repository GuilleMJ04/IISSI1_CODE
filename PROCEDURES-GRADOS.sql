USE grados;
#RF-002
DELIMITER //
CREATE OR REPLACE PROCEDURE procDeleteGrades(studentDni CHAR(9))
BEGIN
	DECLARE id INT;
	SET id = (SELECT studentId s FROM Students s WHERE s.dni=studentDni);
	DELETE FROM Grades WHERE studentId=id;
END //
DELIMITER ;

CALL procDeleteGrades('12345678A');

#RF-007

DELIMITER //
CREATE OR REPLACE FUNCTION avgGrade(studentId INT) RETURNS DOUBLE
BEGIN
	DECLARE avgStudentGrade DOUBLE;
	SET avgStudentGrade = (SELECT AVG(value) FROM Grades
		WHERE Grades.studentId = studentId);
	RETURN avgStudentGrade;
END //
DELIMITER ;

SELECT avgGrade(2);

SELECT s.firstName, s.surname, avgGrade(s.studentId) FROM Students s;

#TRIGGERS
DELIMITER //
CREATE OR REPLACE TRIGGER RN001_triggerWithHonours
BEFORE update ON Grades
FOR EACH ROW
BEGIN
    IF (new.withHonours = 1 AND new.value < 9.0) THEN
        SIGNAL SQLSTATE '45000' SET message_text = 
        'You cannot insert a grade with honours whose value is less than 9';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE pWithHonours
(withHonours INT, value DECIMAL(4,2))
BEGIN
    IF (withHonours = 1 AND value < 9.0) THEN
        SIGNAL SQLSTATE '45000' SET message_text = 
        'A grade with honours can not have a value less than 9';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER RN001I_triggerWithHonours
BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
    CALL pWithHonours(new.withHonours, new.value);
END//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER RN001U_triggerWithHonours
BEFORE UPDATE ON Grades
FOR EACH ROW
BEGIN
    CALL pWithHonours(new.withHonours, new.value);
END//
DELIMITER ;


DELIMITER //
CREATE OR REPLACE TRIGGER RN004_triggerGradeStudentGroup
BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
    DECLARE isInGroup INT;
    SET isInGroup = (SELECT COUNT(*) 
        FROM GroupsStudents
            WHERE studentId = new.studentId AND groupId = new.groupId);
    IF(isInGroup < 1) THEN
        SIGNAL SQLSTATE '45000' SET message_text = 
    	    'A student cannot have grades for groups in which they are not registered';
    END IF;
END//
DELIMITER ;


DELIMITER //
CREATE OR REPLACE TRIGGER RN005_triggerGradesChangeDifference
BEFORE UPDATE ON Grades
FOR EACH ROW
BEGIN
    DECLARE difference DECIMAL(4,2);
    DECLARE student ROW TYPE OF Students;
    SET difference = new.value - old.value;
    IF(difference > 4) THEN
        SELECT * INTO student FROM Students WHERE studentId = new.studentId;
        SET @error_message = CONCAT('You cannot add ', difference, 
            ' points to a grade for the student',
            student.firstName, ' ', student.surname);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_message;
    END IF;
END//
DELIMITER ;

