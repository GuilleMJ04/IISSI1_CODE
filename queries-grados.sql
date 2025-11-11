SELECT * 
   FROM Grades g
   ORDER BY g.value
;


SELECT * 
   FROM Grades g
   WHERE g.value >= 5
	ORDER BY (SELECT s.surname
	         FROM Students s
	         WHERE s.studentId = g.studentId) 
	DESC
;

SELECT * 
	FROM Grades g
	ORDER BY g.value DESC
	LIMIT 5 OFFSET 5
;

SELECT * FROM Groups, GroupsStudents, students;


SELECT *
	FROM GROUPS g
	JOIN GroupsStudents gs ON (g.groupId = gs.groupId)
	JOIN Students s ON (gs.studentId = s.studentId)
;

SELECT *
	FROM Groups
	NATURAL JOIN GroupsStudents 
	NATURAL JOIN Students
;



