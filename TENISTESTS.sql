TESTS
-- ==========================================================
-- EJERCICIO 3: Prueba del Trigger (RA-02)

-- ==========================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ra02_max_trainees()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RA-02', 'Pass: Se bloqueó correctamente el 3er alumno', 'PASS');
    UPDATE players SET coach_id = 19 WHERE player_id = 3;
    UPDATE players SET coach_id = 19 WHERE player_id = 4;
    CALL p_log_test('RA-02', 'Error: Se permitió un 3er alumno', 'FAIL');
END //
DELIMITER ;
-- ==========================================================
-- EJERCICIO 4: Prueba de la Función
-- ==========================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_function_sets()
BEGIN
    DECLARE v_result INT;
    SELECT f_get_sets_won(2, 1) INTO v_result;
    IF v_result = 2 THEN
        CALL p_log_test('FUNC-01', 'Pass: Función contó 2 sets correctamente', 'PASS');
    ELSE
        CALL p_log_test('FUNC-01', CONCAT('Fail: Esperaba 2, obtuvo ', v_result), 'FAIL');
    END IF;
END //
DELIMITER ;
-- ==========================================================
-- EJERCICIO 6: Prueba de la Transacción
-- ==========================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_transaction_rollback()
BEGIN
    DECLARE v_count INT;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            CALL p_log_test('TRAN-01', 'Pass: La transacción falló por duplicado (esperado)', 'PASS');
        CALL p_create_two_coaches_transaction(
            'Entrenador Nuevo', 40, 'Italia', 10, 'Individual',
            'Carlos Alcaraz', 22, 'España', 5, 'Individual'
        );
        CALL p_log_test('TRAN-01', 'Error: La transacción no falló', 'FAIL');
    END;
    SELECT COUNT(*) INTO v_count FROM people WHERE name = 'Entrenador Nuevo';
    IF v_count = 0 THEN
        CALL p_log_test('TRAN-02', 'Pass: Rollback OK', 'PASS');
    ELSE
        CALL p_log_test('TRAN-02', 'Fail: Rollback incorrecto', 'FAIL');
    END IF;
END //
DELIMITER ;