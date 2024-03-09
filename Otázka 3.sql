WITH price_data AS (
	SELECT 
		th.payroll_year, 
		th.food_category, 
		price, 
		lag(avg(price)) OVER (PARTITION BY th.food_category ORDER BY payroll_year) AS prev_price
	FROM t_hana_simkova_project_sql_primary_final th
	GROUP BY th.payroll_year, th.food_category
)
SELECT 
	payroll_year, 
	food_category, 
	price, 
	round((price - prev_price) / prev_price * 100, 2) AS price_percentage
FROM price_data
ORDER BY price_percentage;