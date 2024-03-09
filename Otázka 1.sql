WITH value_data AS (
	SELECT 
		payroll_year, 
		industry,
		wage,
		lag(wage) OVER (PARTITION BY industry ORDER BY payroll_year) AS prev_value
FROM t_hana_simkova_project_sql_primary_final
GROUP BY  payroll_year, industry 
)
SELECT 
	payroll_year, 
	industry,
	wage,
	round((wage - prev_value) / prev_value * 100, 2) AS value_percentage
FROM value_data
ORDER BY value_percentage;