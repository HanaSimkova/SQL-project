# SQL-project / Discord nick: hanas._23803

Na analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, bylo dohodnuto, že se pokusíme odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

Výzkumné otázky
1.	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2.	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3.	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4.	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5.	Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

K zodpovězení výše uvedených otázek byly připraveny 2 tabulky.

Primární tabulka t_hana_simkova_project_sql_primary_final obsahuje robustní datové podklady, ve kterých je možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období. 
Struktura tabulky: 

food_category – sloupec obsahuje srozumitelný název kategorie potravin.

price – sloupec obsahuje hodnotu cen potravin za daný rok a kategorii.

price_value – sloupec obsahuje základní hodnotu, ve které jsou potraviny uváděny.

price_unit – sloupec obsahuje název měrné jednotky, ve které jsou potraviny uváděny.

industry – sloupec obsahuje srozumitelný název odvětví.

wage – sloupec obsahuje hodnotu mezd v daném roce a odvětví. 

payroll_year – sloupec obsahuje rok, ve kterém jsou data sledována.

Vytvoření tabulky:
Tabulka t_hana_simkova_project_sql_primary_final vznikla spojením dat z různých tabulek (czechia_price, czechia_payroll, czechia_price_category, czechia_payroll_industry_branch) na základě vhodných klíčů a podmínek spojení. 
Při výpočtu sloupce price byla použita funkce avg, protože hodnota ceny v tabulce czechia_price byla zaznamenávána za časové období od-do. 
Stejně tak byl vypočítán i sloupec wage, protože hodnota mzdy v tabulce czechia_payroll byla uvedena pro jednotlivá čtvrtletí. 
Období payroll_year, ve kterém jsou data sledována, bylo spojeno z tabulky czechia_price na sloupci „date_from“ a z tabulky czechia_payroll na sloupci „payroll_year“. Výsledkem jsou data sledovaná pro období mezi lety 2006 – 2018.
Primární tabulka byla dále vhodně doplněna o sloupce price_value, price_unit, food_category a industry.
Na závěr byla použita klauzule GROUP BY aby došlo k seskupení řádků, které mají stejnou hodnotu v jednom nebo více sloupcích. 

Sekundární tabulka t_hana_simkova_project_sql_secondary_final obsahuje HDP, GINI koeficientem a hodnotu populace dalších evropských států ve stejném období jako primární tabulka.

Struktura tabulky:

country_name – sloupec obsahuje název země.

GDP – sloupec obsahuje hodnotu HDP.

gini – sloupec obsahuje hodnotu gini koeficientu.

year – sloupec obsahuje rok, ve kterém jsou data sledována.

population – sloupec obsahuje informaci o populaci v dané zemi.

Vytvoření tabulky:
Tabulka t_hana_simkova_project_sql_secondary_final vznikla spojením dat z tabulek economies a countries na základě vhodných klíčů a podmínek spojení. Protože v zadání byla podmínka vytvořit sekundární tabulku pro stejné období jako tabulka primární, byl zvolen filtr roku na období 2006-2018.

Otázka č.1
Pomocí WITH klauzule došlo k vytvoření dočasné tabulky value_data, která obsahuje data o mzdách. LAG funkce byla použita k získání předchozích hodnot za každé odvětví a rok. V SUBSELECTU došlo k výpočtu procentuální změny. Data byla vhodně seřazena. Rok 2006 vrací NULL hodnoty ve sloupci value_percentage, protože rok 2006 je v tabulce první a nemá data pro porovnání z předchozího roku.

Odpověď: V průběhu let nerostou mzdy ve všech odvětvích. Z výsledků lze uvést, že největší pokles mezd zaznamenalo odvětví Peněžnictví a pojišťovnictví mezi lety 2012-2013 a to téměř o 9 %. Ve stejném období zaznamenaly pokles mezd také odvětví Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu, Profesní, vědecké a technické činnosti, Těžba a dobývání, Stavebnictví apod. Procentuální pokles mezd se pohyboval od 4,37 % do 2,13 %.

Otázka č. 2
Z primární tabulky byly vybrány vhodné sloupce. Pomocí CASE Expression byly dopočítány hodnoty sloupců, ze kterých lze odpovědět na zadanou otázku. V roce 2006 dojde k výběru průměrné mzdy a vydělí se průměrnou hodnotou ceny dané potraviny. Stejný vzorec je zadán pro rok 2018. Ve WHERE klauzuli se omezujeme na výběr dat pro první (2006) a poslední (2018) sledované období a dále na výběr dané kategorie potravin – chléb a mléko.

Odpověď: V roce 2006 (první sledované období) si bylo možné zakoupit 1287 kilogramů chleba a 1437 litrů mléka. V roce 2018 (poslední sledované období) si bylo možné koupit 1342 kilogramů chleba a 1642 litrů mléka.

Otázka č. 3
Pomocí WITH klauzule došlo k vytvoření dočasné tabulky price_data, která obsahuje data o průměrných cenách potravin, název kategorie potravin a rok. LAG funkce byla použita k získání předchozích cen za každou kategorii potravin a rok. Následně byla vypočtena procentuální změna mezi předchozím a aktuálním rokem. Data byla vhodně seřazena. Rok 2006 vrací NULL hodnoty ve sloupci price_percentage, protože rok 2006 je v tabulce první a nemá data pro porovnání z předchozího roku. Všechny kategorie potravin se zápornou hodnotou ve sloupci price_percentage zaznamenaly zlevnění, tzn. meziroční pokles ceny potraviny. Naopak kladné hodnoty v tomto sloupci značí meziroční percentuálně nárůst ceny potraviny.

Odpověď: Nejnižší percentuálně nárůst ceny zaznamenala kategorie potravin Rajská jablka červená kulatá, ta v letech 2007, 2008, 2009, 2011, 2013, 2018 dokonce zlevnila. Stejně tak by se dala interpretovat kategorie potravin Pečivo pšeničné bílé, která zlevnila v letech 2009, 2010, 2013, 2014, 2015, 2018. 

Otázka č. 4
Ve výběru jsou vypočítána data průměrných mezd a cen potravin, vybrány vhodné sloupce jako rok, průměrná cena, průměrná mzda. LAG funkce byla použita k získání meziročního růstu cen potravin a mezd. Následně byla vypočtena procentuální změna mezi předchozím a aktuálním rokem. Data byla seřazena sestupně dle rozdílu procentuálního nárůstu cen a mezd potravin. Rok 2006 vrací NULL hodnoty ve sloupci price_percentage, protože rok 2006 je v tabulce první a nemá data pro porovnání z předchozího roku.

Odpověď: Rok, ve kterém by byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %), nebyl v dostupných datech nalezen. Výrazně větší nárůst cen potravin, než růst mezd byl zaznamenán v roce 2013, kdy ceny vzrostly o 5,1 % a mzdy dokonce klesly o 1,56 %. 

Otázka č. 5
Z tabulky t_hana_simkova_project_sql_primary_final byly vybrány vhodné sloupce pro zobrazení dat. Pomocí AVG funkce byly vypočítány průměrné hodnoty cen potravin a mezd. Pomocí „window function“ byl vypočítán meziroční růst HDP, cen potravin a mezd. Výsledky ukazují procentuální změny v cenách potravin a ve mzdách mezi lety 2006 – 2018. Rok 2006 vrací NULL hodnoty, protože rok 2006 je v tabulce první a nemá data pro porovnání z předchozího roku.

Odpověď: Největší růst hodnoty HDP je v roce 2007 a v následujícím roce došlo k růstu cen potravin i mezd. Tento trend ale neplatí v celém sledovaném období. Například v letech 2014 a 2015 hodnota HDP vzrostla, ale průměrné ceny potravin v následujícím roce klesly, a naopak průměrné hodnoty mezd vzrostly. Pokud HDP v jednom roce vzroste, ne vždy tento růst koleruje s růstem cen potravin a mezd v následujícím roce. 

