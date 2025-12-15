
USE TenisDB;
-- ==========================================================
-- EJERCICIO 1: Modificación de tablas (DDL)
-- ==========================================================

-- 1. Limpieza: Borrar tablas nuevas antes que las antiguas (evitar error FK)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS players;  -- La borramos para recrearla con cambios
DROP TABLE IF EXISTS coaches;  -- NUEVA TABLA (Entrenadores)-- ... (Aquí irían los DROP del resto de tablas originales: matches, sets, etc.)
SET FOREIGN_KEY_CHECKS = 1;

-- 2. Crear la tabla COACHES (Entrenador) - Variante 3
CREATE TABLE coaches (
    coach_id INT,
    experience INT NOT NULL,      -- Atributo específico
    specialty VARCHAR(20) NOT NULL,
    PRIMARY KEY (coach_id),
    -- Herencia: ID apunta a PEOPLE
    FOREIGN KEY (coach_id) REFERENCES people(person_id) ON DELETE CASCADE,
    -- RA-01: Restricción de especialidad
    CONSTRAINT ra_01_specialty CHECK (specialty IN ('Individual', 'Dobles'))
    );
    
-- 3. Recrear la tabla PLAYERS (Tenista) con los cambios
CREATE TABLE players (
    player_id INT,
    ranking INT NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE, -- NUEVO: Atributo 'activo' del diagrama
    coach_id INT,                         -- NUEVO: Relación "entrena" (FK a coaches)
    PRIMARY KEY (player_id),
    FOREIGN KEY (player_id) REFERENCES people(person_id) ON DELETE CASCADE,
    FOREIGN KEY (coach_id) REFERENCES coaches(coach_id), -- Vinculación con Entrenador
    CONSTRAINT rn_04_ranking CHECK (ranking > 0 AND ranking <= 1000)
);
DELIMITER //

-- ==========================================================
-- EJERCICIO 2: Disparador (Trigger) - RA-02
-- ==========================================================

CREATE OR REPLACE TRIGGER t_biu_players_ra02
BEFORE INSERT OR UPDATE ON players
FOR EACH ROW
BEGIN
    DECLARE v_current_trainees INT;
    -- Solo comprobamos si se está asignando un entrenador
    IF NEW.coach_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_current_trainees
        FROM players
        WHERE coach_id = NEW.coach_id
          AND player_id <> IFNULL(NEW.player_id, 0);
        -- Si ya tiene 2 (o más), prohibimos entrar
        IF v_current_trainees >= 2 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RA-02: Un entrenador no puede entrenar a más de 2 tenistas simultáneamente';
        END IF;
    END IF;
END //
-- ==========================================================
-- EJERCICIO 4: Funciones
-- ==========================================================
CREATE OR REPLACE FUNCTION f_get_sets_won(
    p_player_id INT,
    p_match_id INT
) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_sets_won INT;
    -- Contamos las filas donde coincida partido y ganador
    SELECT COUNT(*) INTO v_sets_won
    FROM sets
    WHERE match_id = p_match_id
      AND winner_id = p_player_id;
    RETURN v_sets_won;
END //
-- ==========================================================
-- EJERCICIO 6: Transacciones
-- ==========================================================
CREATE OR REPLACE PROCEDURE p_create_two_coaches_transaction(
    IN p_name1 VARCHAR(100), IN p_age1 INT, IN p_nat1 VARCHAR(50),
    IN p_exp1 INT, IN p_spec1 VARCHAR(20),
    IN p_name2 VARCHAR(100), IN p_age2 INT, IN p_nat2 VARCHAR(50),
    IN p_exp2 INT, IN p_spec2 VARCHAR(20)
)
BEGIN
    DECLARE v_id1 INT;
    DECLARE v_id2 INT;
    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
        -- Entrenador 1
        INSERT INTO people (name, age, nationality) VALUES (p_name1, p_age1, p_nat1);
        SET v_id1 = LAST_INSERT_ID();
        INSERT INTO coaches (coach_id, experience, specialty) VALUES (v_id1, p_exp1, p_spec1);
        -- Entrenador 2
        INSERT INTO people (name, age, nationality) VALUES (p_name2, p_age2, p_nat2);
        SET v_id2 = LAST_INSERT_ID();
        INSERT INTO coaches (coach_id, experience, specialty) VALUES (v_id2, p_exp2, p_spec2);
    COMMIT;
END //
DELIMITER ;