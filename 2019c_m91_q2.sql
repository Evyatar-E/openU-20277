--openU-20277
--@Evyatar-E
--Exam 2015c_m82
--Question 2

--Section a
SELECT
FROM ad 
	JOIN broadcast AS b USING(aid)
WHERE b.firm = 'Dogby'
	AND date_part('year',b.bdate) = 2019 
GROUP BY ad.aid, ad.fee, ad.product
HAVING 300000<fee*COUNT(b.uid,b.vid,b.bdate,b.btime);


--Section b
SELECT u.uname
FROM user AS u
	JOIN broadcast AS b USING(uid)
WHERE u.uid NOT IN (
		SELECT video.uid
		FROM video 
			JOIN placement USING(vid) --not NJ
	)
GROUP BY u.uid, u.uname
HAVING COUNT(DISTINCT b.uid,b.vid,b.bdate,b.btime)>=1000;