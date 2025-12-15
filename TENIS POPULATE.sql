-- Dentro del procedimiento p_populate_db()

-- 1. Insertar las Personas nuevas (Entrenadores)
INSERT INTO people (person_id, name, age, nationality) VALUES
    (19, 'Juan Carlos Ferrero', 44, 'España'),
    (20, 'Goran Ivanisevic', 52, 'Croacia');-- 2. Insertar en la nueva tabla COACHES
INSERT INTO coaches (coach_id, experience, specialty) VALUES
    (19, 15, 'Individual'),
    (20, 10, 'Individual');-- 3. Insertar JUGADORES (Actualizado)
INSERT INTO players (player_id, ranking, active, coach_id) VALUES 
    (1, 1, TRUE, 20),
    (2, 2, TRUE, 19),
    (3, 4, TRUE, NULL),
    (4, 5, TRUE, NULL),
    (5, 9, FALSE, NULL),
    (14, 11, TRUE, NULL);