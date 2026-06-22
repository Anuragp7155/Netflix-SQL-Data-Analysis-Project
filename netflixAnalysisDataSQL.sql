DROP TABLE netflix;

CREATE TABLE netflix (
    show_id VARCHAR(15),
    type VARCHAR(30),
    title VARCHAR(150),      -- Increased length (titles can be long)
    director VARCHAR(250),   -- Increased length (multiple directors happen)
    country VARCHAR(150),    -- Increased length (multiple countries happen)
    date_added VARCHAR(50),  -- Changed to VARCHAR to handle "9/25/2021" formats smoothly
    release_year INT,
    rating VARCHAR(15),      -- FIXED: Changed from INTEGER to VARCHAR for "PG-13", "R", etc.
    duration VARCHAR(20),
    listed_in VARCHAR(100)   -- Increased length
);

select * from netflix limit 10;

--- 1. what is the total number of movies and tv shows on netlfix

select type, count(DISTINCT show_id)
from netflix
group by type

-- 2. Which country has produced the most content (Movies + TV Shows) on Netflix? List the top 5 countries.

select country, count(type)
from netflix
group by country
order by count(type) desc
limit 5;

delete * from netflix 
where country IS NULL  

-- 3. Retrieve a list of all movies and TV shows released in the year 2020.

select title, type from netflix
where release_year = 2020
limit 10;

-- 4. What are the titles of all movies directed by 'Kirsten Johnson'?

select title, type, director
from netflix 
where director = 'Kirsten Johnson'

-- 5. Which content rating is the most common on Netflix? (Count of titles by rating).

select rating, count(title)
from netflix
group by rating

select * from netflix limit 30;

-- 6. Find the list of all 'TV Shows' that have 5 or more seasons
select type, count(type)
from netflix
where type = 'TV Show' and CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) >=5
group by type;

-- 7. List all the movies produced in 'India' that belong to the 'Comedies' category

select title, country, listed_in
from netflix 
where country = 'India' and type = 'Movie' and listed_in LIKE '%Comedies%';

-- 8. How many new shows/movies were released each year? Sort the results in descending order of the release year.


select release_year, count(type)
from netflix
group by release_year
order by release_year DESC;

select * from netflix limit 30;

--9. Who are the top 5 directors with the highest number of directed movies(excluding 'Not Given')?
select director, count(type) as totalMovies
from netflix
where type = 'Movie'
group by director 
order by totalMovies DESC
limit 5;

--10. In which year did Netflix add the highest amount of content to its platform?

-- select release_year, count(type) as noOfContent
-- from netflix
-- group by release_year
-- order by noOfContent DESC

select RIGHT(date_added, 4) as year_added, COUNT(type) as totalContent
from netflix
group by 1
order by totalContent DESC
LIMIT 3;

-- 11. Which are the 5 oldest movies released in India on Netflix?

select title, release_year
from netflix
where type = 'Movie' AND country = 'India'
order by release_year ASC
limit 5;

--12. Find the titles of all movies listed as 'Documentaries' that were released after the year 2015

select title, release_year, listed_in
from netflix
where type = 'Movie' AND listed_in LIKE '%Documentaries%' AND release_year = 2015

--#window function and subqueries
--13. Which movie has the longest duration in minutes on Netflix?

-- select title, CAST(SUBSRTRING_INDEX(duration,' ',1) AS UNSIGNED) AS duration_minutes
-- FROM netflix
-- WHERE type = 'Movie'
-- ORDER by duration_minutes DESC
-- limit 1;

SELECT title, CAST(split_part(duration, ' ', 1) AS INTEGER) AS duration_minutes
FROM netflix
WHERE type = 'Movie'
ORDER BY duration_minutes DESC
LIMIT 1;

-- 14. What is the most recently released movie for each country?

WITH ranked_movies AS (
    SELECT 
        title, 
        country, 
        release_year, 
        ROW_NUMBER() OVER(PARTITION BY country ORDER BY release_year DESC) AS rnk
    FROM netflix
    WHERE type = 'Movie' 
      AND country IS NOT NULL 
      AND country <> ''
)
SELECT country, title AS latestMovie, release_year
FROM ranked_movies
WHERE rnk = 1;

--15. Identify the release years in which more than 50 movies from India were released.

SELECT release_year, COUNT(*) AS movie_count
FROM netflix
WHERE type = 'Movie' 
  AND country LIKE '%India%'
GROUP BY release_year
HAVING COUNT(*) > 50
ORDER BY release_year DESC;





