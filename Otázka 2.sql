SELECT 
	th.food_category,
	th.price_value,
	th.price_unit,
	round(avg(CASE WHEN payroll_year = 2006 THEN wage END) / avg(CASE WHEN payroll_year = 2006 THEN price END)) AS wage_price_ratio_2006,
	round(avg(CASE WHEN payroll_year = 2018 THEN wage END) / avg(CASE WHEN payroll_year = 2018 THEN price END)) AS wage_price_ratio_2018
FROM t_hana_simkova_project_sql_primary_final th
WHERE payroll_year IN (2006, 2018) 
	AND th.food_category LIKE '%mléko%' OR th.food_category LIKE '%chléb%'
GROUP BY food_category;