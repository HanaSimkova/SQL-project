SELECT 
	th.payroll_year, 
	round(avg(th.price)) AS avg_price, 
	round(avg(th.wage)) AS avg_wage, 
	round((avg(th.price) - lag(avg(th.price)) OVER (ORDER BY th.payroll_year)) / lag(avg(th.price)) 
  	OVER (ORDER BY th.payroll_year) * 100, 2) AS price_increase_percentage, 
	round((avg(th.wage) - lag(avg(th.wage)) OVER (ORDER BY th.payroll_year)) / lag(avg(th.wage)) 
   	OVER (ORDER BY th.payroll_year) * 100, 2) AS wage_increase_percentage, 
	th2.GDP, 
	round((avg(th2.GDP) - lag(avg(th2.GDP)) OVER (ORDER BY th.payroll_year)) / lag(avg(th2.GDP)) 
   	OVER (ORDER BY th.payroll_year) * 100, 2) AS gdp_increase_percentage
FROM t_hana_simkova_project_sql_primary_final th
LEFT JOIN t_hana_simkova_project_sql_secondary_final th2 
	ON th.payroll_year = th2.`year`
WHERE th2.country_name LIKE '%czech%'
GROUP BY th.payroll_year;