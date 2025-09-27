SELECT * 
FROM world_life_expectancy;

# Identifying duplicates
SELECT country, year, concat(country, year)      # The data has same country with different year and each year can not have a duplicate so we did this to find the duplicate in the years
FROM world_life_expectancy
;

SELECT country, year, concat(country, year), count(concat(country,year))   # I found duplicates, used the aggregate function to count and Having function to group the duplicates. 
FROM world_life_expectancy
GROUP BY country, year, concat(country,year) 
HAVING count(concat(country,year)) > 1
;


SELECT *
FROM (
   SELECT ROW_ID,							# Because they have unique row id, we have to use this query to be sure that the row id is actually duplicate too
   concat(country, year),
ROW_NUMBER() OVER(PARTITION BY concat(country, year) ORDER BY concat(country, year)) AS ROW_NUM
FROM world_life_expectancy) AS ROW_NUM
WHERE ROW_NUM > 1
; 

DELETE							# Found the duplicate row id and deleted them
FROM world_life_expectancy
WHERE ROW_ID IN (
 SELECT ROW_ID
 FROM (
   SELECT ROW_ID,
   concat(country, year),
ROW_NUMBER() OVER(PARTITION BY concat(country, year) ORDER BY concat(country, year)) AS ROW_NUM
FROM world_life_expectancy) AS ROW_NUM
WHERE ROW_NUM > 1)
;


DELETE FROM world_life_expectancy
WHERE ROW_ID IN (
SELECT ROW_ID
FROM (
   SELECT ROW_ID,
   concat(country, year),
ROW_NUMBER() OVER(PARTITION BY concat(country, year) ORDER BY concat(country, year)) AS ROW_NUM
FROM world_life_expectancy) AS ROW_NUM
WHERE ROW_NUM > 1)
;

 
SELECT Status
FROM world_life_expectancy      # Checking the status column for rows that are not populated
WHERE status = '';

SELECT DISTINCT(Status)     
FROM world_life_expectancy      # Checking how many types of statuses we have(Developing or Developed)
WHERE status <> '';

SELECT DISTINCT(Country)      # The countries are grouped by developing or developed and we want to know the countries to populat their status to either developing or developed
FROM world_life_expectancy
WHERE status = 'Developing';

SELECT DISTINCT(Country) 
FROM world_life_expectancy
WHERE status = 'Developed';

UPDATE world_life_expectancy T1					# This query worked because we joined two tables and gave an instruction for one to be populated with developing while the other is not
JOIN world_life_expectancy T2
ON T1.Country = T2.Country
SET T1.Status = 'Developing'
WHERE T1.Status = ''
AND T2.Status <> ''
AND T2.Status = 'Developing';


UPDATE world_life_expectancy T1					# Did thesame thing for the developed row
JOIN world_life_expectancy T2
ON T1.Country = T2.Country
SET T1.Status = 'Developed'
WHERE T1.Status = ''
AND T2.Status <> ''
AND T2.Status = 'Developed';


SELECT * 
FROM world_life_expectancy       # Checking for blank rows in world life expectancy coulumn
WHERE `life expectancy` = '';


SELECT t1.country, t1.year, t1.`life expectancy`,
		t2.country, t2.year, t2.`life expectancy`,
        t3.country, t3.year, t3.`life expectancy`,
ROUND((t2.`life expectancy` + t3.`life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
    AND t2.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year = t3.year + 1
WHERE t1.`life expectancy` = '';




UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
    AND t2.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year = t3.year + 1
SET t1.`life expectancy` = ROUND((t2.`life expectancy` + t3.`life expectancy`)/2,1)
WHERE t1.`life expectancy` = ''
;



#QUESTIONS ON LIFE EXPECTANCY

SELECT Country, AVG(`life expectancy`) Avg_life_expectancy       #List of top 10 countries with the highest average life expectancy
FROM world_life_expectancy
GROUP BY Country
ORDER BY Avg_life_expectancy DESC
LIMIT 10;

SELECT Country, `life expectancy`      # Country with the lowest life expectancy in 2015
FROM world_life_expectancy
WHERE Year = 2015
ORDER BY `life expectancy` ASC
LIMIT 1;

SELECT * 
FROM world_life_expectancy;

SELECT Status, COUNT(DISTINCT(Country)) count_stat       #Count how many Developed and Developing countries are in the dataset
FROM world_life_expectancy
WHERE Status IN  ('Developing', 'Developed')
GROUP BY Status
ORDER  BY Status;

SELECT Year, ROUND(AVG(`life expectancy`),1) Avg_EXP			# Average life expectancy in each year
FROM world_life_expectancy
GROUP BY Year
ORDER BY Year;

SELECT w1.Country, ROUND(w2.`life expectancy` - w1.`life expectancy`) improvement   # Find the top 5 greatest improvement in life expectancy between 2000 and 2015
FROM world_life_expectancy w1													
JOIN world_life_expectancy W2
 ON W1.Country = w2.Country
 AND w1.Year = 2007
 AND w2.Year = 2015
 WHERE w1.`life expectancy` IS NOT NULL
	AND w2.`life expectancy` IS NOT NULL
ORDER BY Improvement DESC
LIMIT 5 ;
							#OR THE QUERY BELOW CAN BE USED TOO

SELECT Country, ROUND(MIN(CASE WHEN Year = 2015 THEN `life expectancy` END) -
					 MIN( CASE WHEN Year = 2007 THEN `life expectancy` END),2) AS Improvement
FROM world_life_expectancy
GROUP BY Country 
HAVING Improvement IS NOT NULL
ORDER BY Improvement DESC
LIMIT 5;

SELECT Country, ROUND(AVG(GDP)) AVG_GDP,				#Relationship between life expectancy and GDP 
	   ROUND(AVG(`life expectancy`)) avg_life_expectancy
FROM world_life_expectancy
GROUP BY Country
ORDER BY AVG_GDP DESC;

SELECT Country, `life expectancy`,					#Ranking countries by life expectancy in 2015 and showing the top 20
RANK() OVER( ORDER BY `life expectancy`)
FROM world_life_expectancy
WHERE Year = 2015
ORDER BY `life expectancy`
LIMIT 20;

SELECT Country, Year, 			#Using a window function to calculate the year-over-year change in life expectancy for each country
`life expectancy`, 
ROUND(`life expectancy` - LAG(`life expectancy`) OVER(PARTITION BY Country ORDER BY Year),1) YOY_change
FROM world_life_expectancy
ORDER BY Country, Year;


SELECT Country, MAX(`infant deaths`) highest_death			# Country with the highest infant deaths in 2020 
FROM world_life_expectancy
WHERE Year = 2020
GROUP BY Country
ORDER BY highest_death DESC
LIMIT 1;

SELECT * 
FROM world_life_expectancy;

SELECT Country, MIN(BMI)				#Countries with the lowest BMI
FROM world_life_expectancy
WHERE Year = 2015
GROUP BY Country
ORDER BY Country DESC
LIMIT 5;

SELECT COUNT(GDP)				#Count of GDP records having null/missing values
FROM world_life_expectancy
WHERE GDP IS NULL;


SELECT Country, MIN(`Adult Mortality`) highest_death			# Country with the highest infant deaths in 2020 
FROM world_life_expectancy
WHERE Year = 2015
GROUP BY Country
ORDER BY highest_death DESC
LIMIT 1;

SELECT Country, MAX(`HIV/AIDS`) highest_HIV       # Country with the highest HIV rate
FROM world_life_expectancy
WHERE Year = 2012
GROUP BY  Country
ORDER BY highest_HIV DESC
LIMIT 10;

SELECT Year, ROUND(AVG(`percentage expenditure`), 2) AS Avg_Health_Spending
FROM world_life_expectancy			# Average percentage expenditure on health per year across all counttries
GROUP BY Year
ORDER BY Year;

SELECT 								# Correlation between GDP and life expectancy
		CASE
			WHEN GDP < 1000 THEN 'LOW GDP'
            WHEN GDP BETWEEN 1000 AND 10000 THEN 'MEDIUM GDP'
            ELSE 'HIGH GDP'
		END AS GDP_CATEGORY,
        ROUND(AVG(`life expectancy`), 2) AS Avg_life_Expectancy
FROM world_life_expectancy
WHERE GDP IS NOT NULL
GROUP BY GDP_CATEGORY
ORDER BY Avg_Life_Expectancy DESC;


SELECT W1.Country, (w1.`infant deaths` - w2.`infant deaths`) AS Reduction			#Top 5 countries with the largest reduction in infant deaths between 2007 and 2015
FROM world_life_expectancy w1
JOIN world_life_expectancy W2
	ON W1.Country = w2.Country AND W1.Year = 2007 AND W2.Year = 2015
ORDER BY Reduction DESC
LIMIT 5;

 

        



