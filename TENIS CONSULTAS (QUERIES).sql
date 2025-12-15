SELECT 
    m.match_date AS 'Fecha', 
    m.duration AS 'Duración'
FROM matches m
JOIN sets s ON m.match_id = s.match_id
GROUP BY m.match_id
HAVING COUNT(s.set_id) = 2;

SELECT 
    p.name AS 'Nombre Árbitro', 
    COUNT(m.match_id) AS 'Partidos Arbitrados'
FROM people p
JOIN matches m ON p.person_id = m.referee_id
GROUP BY p.person_id, p.name
ORDER BY COUNT(m.match_id) DESC;