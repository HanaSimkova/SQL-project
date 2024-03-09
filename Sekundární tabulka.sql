CREATE TABLE t_hana_simkova_project_sql_secondary_final
SELECT
	e.country AS country_name,
	e.GDP,
	e.gini,	
	e.`year`,
	e.population 
FROM countries c 
LEFT JOIN economies e
	ON c.country = e.country
WHERE e.`year` BETWEEN '2006' AND '2018'
	AND e.GDP IS NOT NULL;