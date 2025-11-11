

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
