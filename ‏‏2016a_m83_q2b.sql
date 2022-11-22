--openU-20277
--@Evyatar-E
--Exam 2016a_m83
--Question 2, Section b

SELECT /*DISTINCT ??? */ parent.id
FROM parent AS p1
WHERE 6 = COUNT (SELECT DISTINCT category
FROM child 
WHERE p1.id = child.pid)

--("מעון", "גן", "חטיבה צעירה", "חטיבת יסודי1", "חטיבת יסודי2", "חטיבה בוגרת")