-- 3. For the year 2012, create a 3 column, 
-- 1 row report showing the percent share of gdp_per_capita for the following regions:

-- (i) Asia, (ii) Europe, (iii) the Rest of the World. Your result should look something like

--  Asia  | Europe | Rest of World
   ------------------------------
--  25.0% | 25.0%  |	50.0%

SELECT pc.country_code, gpd_per_capita as gpd_2012, co.continent_code,
AVG ()
FROM per_capita pc
INNER JOIN country c
ON pc.country_code = c.country_code
INNER JOIN continent_map cm
ON c.country_code = cm.country_code
INNER JOIN continent co
ON cm.continent_code = co.country_code
WHERE year = 2012











WITH pt AS(
WITH t2011 AS (
	SELECT country_code, gpd_per_capita as gpd_2011
	FROM per_capita
	WHERE year = 2011
	ORDER BY 1),
 t2012 AS (
	SELECT country_code, gpd_per_capita as gpd_2012
	FROM per_capita
	WHERE year = 2012
	ORDER BY 1)

SELECT t2011.country_code, CONCAT(ROUND(((gpd_2012 - gpd_2011)::numeric/gpd_2011 * 100)::numeric,2),'%') AS growth_percent,
	ROUND(((gpd_2012 - gpd_2011)::numeric/gpd_2011 * 100)::numeric,2) AS number,
	RANK() OVER (PARTITION BY co.continent_code ORDER BY ((gpd_2012 - gpd_2011)::numeric/gpd_2011 * 100)::numeric DESC) AS rank,
co.continent_code,country_name
FROM t2011 INNER JOIN t2012
ON t2011.country_code = t2012.country_code
INNER JOIN country c
ON t2012.country_code = c.country_code
INNER JOIN continent_map cm
ON c.country_code = cm.country_code
INNER JOIN continent co
ON cm.continent_code = co.country_code
WHERE ((gpd_2012 - gpd_2011)::numeric/gpd_2011 * 100)::numeric IS NOT NULL
	)
	
SELECT ROUND(AVG(number),2), continent_code
FROM pt
GROUP BY continent_code