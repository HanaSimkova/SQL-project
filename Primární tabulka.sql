CREATE TABLE t_hana_simkova_project_sql_primary_final
SELECT
	cpc.name AS food_category, 
	round (avg(cp.value), 2) AS price,
	cpc.price_value,
	cpc.price_unit, 
	cpib.name AS industry,
	round (avg(cpay.value), 2) AS wage,
	cpay.payroll_year
FROM czechia_price cp
LEFT JOIN czechia_payroll cpay
	ON YEAR(cp.date_from) = cpay.payroll_year 
	AND cpay.value_type_code = 5958
	AND cpay.industry_branch_code IS NOT NULL
LEFT JOIN czechia_price_category cpc
	ON cp.category_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch cpib
	ON cpay.industry_branch_code = cpib.code
GROUP BY cpc.name, cpib.name, cpay.payroll_year;