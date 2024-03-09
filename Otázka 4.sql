SELECT 
	th.payroll_year, 
	round(avg(th.price)) AS avg_price, 
	round(avg(th.wage)) AS avg_wage, 
	round((avg(th.price) - lag(avg(th.price)) OVER (ORDER BY th.payroll_year)) / lag(avg(th.price)) 
 	OVER (ORDER BY th.payroll_year) * 100, 2) AS price_increase_percentage, 
    round((avg(th.wage) - lag(avg(th.wage)) OVER (ORDER BY th.payroll_year)) / lag(avg(th.wage)) 
    OVER (ORDER BY th.payroll_year) * 100, 2) AS value_increase_percentage, 
    round((avg(th.price) - lag(avg(th.price)) OVER (ORDER BY th.payroll_year)) / lag(avg(th.price)) 
    OVER (ORDER BY th.payroll_year) * 100, 2) - round((avg(th.wage) - lag(avg(th.wage)) OVER (ORDER BY th.payroll_year)) / lag(avg(th.wage)) 
    OVER (ORDER BY th.payroll_year) * 100, 2) AS difference_percentage
FROM t_hana_simkova_project_sql_primary_final th
WHERE th.payroll_year BETWEEN 2006 AND 2018
GROUP BY th.payroll_year
ORDER BY difference_percentage DESC;