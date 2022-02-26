USE portfolio;

-- show table order by 1,2
SELECT *
FROM vgsales
ORDER BY 1,2


-- 1. 
-- global sales per year
SELECT year, 
		ROUND(SUM(global_sales),2) AS global_sales
FROM vgsales
GROUP BY year WITH ROLLUP
ORDER BY year
-- --> from 1980 to 2008 sales tended to increase, but from 2009 sales began to decline.


-- 2.
-- sales in each region
SELECT  "NA" AS region,
		ROUND(SUM(NA_Sales),2) AS NA_Sales, 
		ROUND((SUM(NA_Sales)/SUM(global_sales))*100,2) AS percentage
FROM vgsales
UNION 
SELECT  "EU" AS region,
		ROUND(SUM(EU_Sales),2) AS EU_Sales, 
		ROUND((SUM(EU_Sales)/SUM(global_sales))*100,2) AS percentage
FROM vgsales
UNION
SELECT  "JP" AS region,
		ROUND(SUM(JP_Sales),2) AS JP_Sales, 
		ROUND((SUM(JP_Sales)/SUM(global_sales))*100,2) AS percentage
FROM vgsales
UNION
SELECT  "Other" AS region,
		ROUND(SUM(Other_Sales),2) AS Other_Sales, 
		ROUND((SUM(Other_Sales)/SUM(global_sales))*100,2) AS percentage
FROM vgsales
-- -> EU - the region with revenue accounting for nearly 50%, followed by NA with 27%


-- 3. 
-- top 5 platform in global
WITH global_sales_by_flatform AS 
(
	SELECT platform, ROUND(SUM(global_sales),2) AS platform_global_sales
	FROM vgsales
	GROUP BY platform
)

SELECT 	platform, 
		platform_global_sales, 
		ROUND((platform_global_sales/(SELECT SUM(platform_global_sales) FROM global_sales_by_flatform)) * 100,2) AS percentage
FROM global_sales_by_flatform
ORDER BY platform_global_sales DESC
LIMIT 5 
-- --> including: PS2, X360, PS3, Wii, DS platforms with more than 50% of total sales


-- 4.
-- the most popular genre in each region
SELECT genre,
		ROUND(SUM(global_sales),2) AS global_sales_by_genre,
        ROUND(SUM(EU_Sales),2) AS EU_sales_by_genre,
        ROUND(SUM(NA_Sales),2) AS NA_sales_by_genre,
        ROUND(SUM(JP_Sales),2) AS JP_sales_by_genre
FROM vgsales
GROUP BY genre
ORDER BY global_sales_by_genre DESC
-- Action, Sports, Shooter genres were popular globally except for JP. In JP, Role_Playing genre was the most popular


-- 5. 
-- top 10 publisher in global and in each region
SELECT 	publisher, 
		ROUND(SUM(global_sales),2) AS global_sales_by_publisher,
		ROUND(SUM(EU_Sales),2) AS EU_sales_by_publisher,
        ROUND(SUM(NA_Sales),2) AS NA_sales_by_publisher,
        ROUND(SUM(JP_Sales),2) AS JP_sales_by_publisher
FROM vgsales
GROUP BY publisher
ORDER BY global_sales_by_publisher DESC
LIMIT 10
/* 
- publishers had a high market share such as: Nintendo, Electronic Arts, Activision
- Nintendo, Electronic Arts, Activision all have an high marker share in EU, NA but in JP Nintendo have an overwhelming high market share 
*/

-- top 10 game 
SELECT name, publisher, ROUND(SUM(global_sales),2) AS global_sales
FROM vgsales
GROUP BY name
ORDER BY SUM(global_sales) DESC
LIMIT 10 
/* 
top 10 game sellers were Nintendo, Take_Two Interactive, Activision
--> Electronic Arts was not included
*/

SELECT name, ROUND(SUM(global_sales),2) AS Electronic_global_sales
FROM vgsales
WHERE publisher = "Electronic Arts"
GROUP BY name 
ORDER BY Electronic_global_sales DESC
-- -> Electronic Arts succeeded in producing the sports game series such as FIFA, Madden

SELECT name, ROUND(SUM(global_sales),2) AS FIFA_global_sales
FROM vgsales
WHERE publisher = "Electronic Arts" AND
		name REGEXP 'FIFA'
GROUP BY name WITH ROLLUP
ORDER BY FIFA_global_sales DESC
-- -> series game FIFA: 171.36











