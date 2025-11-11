CREATE OR REPLACE VIEW vGradesGroup1 AS
			SELECT * FROM Grades g WHERE g.groupId = 1;
			
-- 			
SELECT MAX(v.value) AS max FROM vGradesGroup1 v;


SELECT COUNT(*) FROM vGradesGroup1 v;

SELECT * FROM vGradesGroup1 v WHERE v.gradeCall = 1;
			
CREATE OR REPLACE VIEW vGradesGroup1Call1 AS
			SELECT * FROM vGradesGroup1 v WHERE v.gradeCall = 1;
	
			SELECT * FROM vGradesGroup1Call1 v;
	
	
SELECT * 
	FROM Subjects s
;

SELECT * 
	FROM Subjects s
	WHERE s.acronym = 'FP'
;


SELECT s.name, s.acronym 
	FROM Subjects s
;


SELECT AVG(g.value) 
	FROM Grades g
	WHERE g.groupId = 18
;


SELECT SUM(s.credits) 
	FROM Subjects s 
	WHERE s.degreeId = 3
;


SELECT * 
	FROM Grades g
	WHERE g.value < 4 OR g.value > 6
;


SELECT DISTINCT g.name 
	FROM Groups g
;


SELECT MAX(g.value) 
	FROM Grades g
	WHERE g.studentId = 1
;


SELECT DISTINCT(gs.studentId) 
	FROM GroupsStudents gs
	WHERE gs.groupId IN (SELECT g.groupId FROM Groups g WHERE g.year = 2019)
;


SELECT *
	FROM Students s
	WHERE s.dni LIKE('%C')
;


SELECT *
	FROM Students s
	WHERE s.firstName LIKE('______') -- 6 guiones bajos	
;


SELECT *
	FROM Students s
	WHERE YEAR(s.birthdate) < 1995
;


SELECT *
	FROM Students s
	WHERE (MONTH(s.birthdate) >= 1 AND MONTH(s.birthdate) <= 2)
;


			
