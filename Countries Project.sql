-- Q1. Get the list of the 3 most populated cities.

SELECT *
FROM cities
ORDER BY population DESC
LIMIT 3;

-- Q2. Get the list of the 3 cities with the smallest surface.

SELECT *
FROM cities
ORDER BY surface
LIMIT 3;

-- Q3. Get the list of states whose department number starts with “97”.
SELECT state_code,state_name
FROM states
WHERE state_code like '97%';

-- Q4. Get the names of the 3 most populated cities, as well as the name of the associated state.

SELECT c.name,population,state_name
FROM cities c
JOIN states s ON c.city_state=s.state_code
ORDER BY population DESC
LIMIT 3;

-- Q5. Get the list of the name of each State, associated with its code and the number of cities within these States,
-- by sorting in order to get in priority the States which have the largest number of cities.

-- using correlated subquery
SELECT state_code,state_name,(select count(*) from cities where city_state=s.state_code) num_cities
FROM states s
ORDER BY num_cities DESC;

-- using join
SELECT state_code,state_name,COUNT(c.name) num_cities
FROM states s
LEFT JOIN cities c ON s.state_code=c.city_state
GROUP BY state_code,state_name
ORDER BY num_cities DESC;


-- Q6. Get the list of the 3 largest States, in terms of surface area.

SELECT state_code,state_name,SUM(c.surface) surface_area
FROM states s
JOIN cities c ON s.state_code=c.city_state
GROUP BY state_code,state_name
ORDER BY surface_area DESC
LIMIT 3;

-- Q7. Count the number of cities whose names begin with “San”.

SELECT COUNT(*) san_count
FROM cities
WHERE name REGEXP '^san';

-- Q8 Get the list of cities whose surface is greater than the average surface

-- with cte
with cte AS(SELECT id,name,surface,AVG(surface) OVER() avg_surface
FROM cities)
SELECT id,name,surface
FROM cte
WHERE surface>avg_surface;

-- with subquery
SELECT id,name,surface
FROM cities
WHERE surface> (select avg(surface) from cities);

-- Q9. Get the list of States with more than 1 million residents.

SELECT state_code,state_name,SUM(population) state_pop
FROM states s
JOIN cities c ON s.state_code=c.city_state
GROUP BY state_code,state_name
HAVING state_pop>1000000;

-- Q10. Replace the dashes with a blank space, for all cities beginning with “SAN-” (inside the column containing the upper case names).

SELECT id,(CASE WHEN name like 'SAN-%' THEN REPLACE(name,'-',' ') ELSE name END) modified_city_name
FROM cities;