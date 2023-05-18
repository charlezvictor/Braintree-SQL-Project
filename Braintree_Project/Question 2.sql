-- 2. List the countries ranked 10-12 in each continent 
-- by the percent of year-over-year growth descending from 2011 to 2012.

-- The percent of growth should be calculated as: ((2012 gdp - 2011 gdp) / 2011 gdp)

-- The list should include the columns:

-- rank
-- continent_name
-- country_code
-- country_name
-- growth_percent


SELECT *
FROM continent

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
	
SELECT rank,
continent_code,
pt.country_code,
country_name,
growth_percent
FROM pt
WHERE rank BETWEEN 10 AND 12