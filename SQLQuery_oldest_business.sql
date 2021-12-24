CREATE TABLE categories (
  category_code VARCHAR(5) PRIMARY KEY,
  category VARCHAR(50)
);
CREATE TABLE countries (
  country_code CHAR(3) PRIMARY KEY,
  country VARCHAR(50),
  continent VARCHAR(20)
);
CREATE TABLE businesses (
  business VARCHAR(64) PRIMARY KEY,
  year_founded INT,
  category_code VARCHAR(5),
  country_code CHAR(3)
);
\copy categories FROM 'categories.csv' DELIMITER ',' CSV HEADER;
\copy countries FROM 'countries.csv' DELIMITER ',' CSV HEADER;
\copy businesses FROM 'businesses.csv' DELIMITER ',' CSV HEADER;

-- the oldest and newest founding years from the businesses table
 SELECT MIN(year_founded), MAX(year_founded)
    from businesses;
-- the count of rows in businesses where the founding year was before 1000
SELECT COUNT(*)
from businesses
where year_founded < 1000
-- columns from businesses where the founding year was before 1000
-- the results from oldest to newest
Select *
from businesses 
where year_founded < 1000
order by year_founded  
--  business name, founding year, and country code from businesses; and category from categories
-- where the founding year was before 1000, arranged from oldest to newest
Select bus.business , bus.year_founded , bus.country_code , cat.category
from businesses AS bus
 inner join categories AS cat 
 ON bus.category_code = cat.category_code
where year_founded <1000
order by year_founded 
--  category and count of category (as "n")
-- arranged by descending count, limited to 10 most common categories
SELECT cat.category, COUNT(cat.category) AS n
    FROM businesses AS bus
    INNER JOIN categories AS cat
        ON bus.category_code = cat.category_code
    GROUP BY cat.category
    ORDER BY n DESC
    LIMIT 10;
	-- the oldest founding year (as "oldest") from businesses, 
-- and continent from countries
-- for each continent, ordered from oldest to newest 
Select MIN(bus.year_founded) as oldest, cnt.continent
from businesses as bus
   Inner join countries as cnt
    ON bus.country_code = cnt.country_code
    group by continent
    order by oldest ;
-- the business, founding year, category, country, and continent
Select bus.business,bus.year_founded, cat.category, cnt.country, cnt.continent
From businesses as bus
Inner join categories as cat
ON bus.category_code = cat.category_code
inner join countries as cnt
on bus.country_code = cnt.country_code
-- Count number of businesses in each continent and category
SELECT cnt.continent, cat.category, COUNT(*) AS n
    FROM businesses AS bus
    INNER JOIN categories as cat
        ON bus.category_code = cat.category_code
    INNER JOIN countries as cnt
        ON bus.country_code = cnt.country_code
    GROUP BY cnt.continent, cat.category;
-- filtering for results having a count greater than 5
SELECT cnt.continent, cat.category, COUNT(*) AS n
    FROM businesses AS bus
    INNER JOIN categories as cat
        ON bus.category_code = cat.category_code
    INNER JOIN countries as cnt
        ON bus.country_code = cnt.country_code
    GROUP BY cnt.continent, cat.category
    Where n >5;