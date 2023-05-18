DROP TABLE IF EXISTS continent_map;

CREATE TABLE continent_map(
	country_code VARCHAR,
	continent_code VARCHAR);

DROP TABLE IF EXISTS continents;

CREATE TABLE continents(
		continent_code VARCHAR,
		continent_name VARCHAR);

DROP TABLE IF EXISTS country;

CREATE TABLE country(
	country_code VARCHAR,
	country_name VARCHAR);
	
DROP TABLE IF EXISTS per_capita;

CREATE TABLE per_capita(
	country_code VARCHAR,
	year INT,
	gpd_per_capita float);
	
	
-- 1. Data Integrity Checking & Cleanup

-- Alphabetically list all of the country codes in the continent_map table that appear more than once. 
-- Display any values where country_code is null as country_code = "FOO" and make this row appear first in the list, 
-- even though it should alphabetically sort to the middle. Provide the results of this query as your answer.

-- For all countries that have multiple rows in the continent_map table, 
-- delete all multiple records leaving only the 1 record per country. 
-- The record that you keep should be the first one when sorted by the continent_code alphabetically ascending. 
-- Provide the query/ies and explanation of step(s) that you follow to delete these records.


SELECT country_code, count(country_code)
FROM continent_map
GROUP BY 1
HAVING count(country_code) > 1
ORDER BY 1 ASC

SELECT country_code
FROM continent_map
WHERE country_code IS NULL

UPDATE continent_map
SET country_code = 'FOO'
WHERE country_code IS NULL;


DELETE FROM continent_map
WHERE (country_code) NOT IN (
  SELECT DISTINCT country_code
  FROM continent_map
);




SELECT 
    CASE 
        WHEN country_code IS NULL THEN 'FOO'
        ELSE country_code
    END AS country_code
FROM continent_map
GROUP BY country_code
HAVING COUNT(*) > 1
ORDER BY CASE WHEN country_code IS NULL THEN 0 ELSE 1 END, country_code ASC;

DELETE FROM continent_map
WHERE (country_code, continent_code) NOT IN (
    SELECT country_code, MIN(continent_code)
    FROM continent_map
    GROUP BY country_code
);

SELECT *
FROM continent_map