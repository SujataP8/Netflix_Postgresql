--Netflix_db--
drop table if exists netflix;
create table netflix
(
 show_id varchar(20),
 type varchar(10),
 title	varchar(150),
 director varchar(208),	
 casts	varchar(1000),
 country varchar(150),	
 date_added	varchar(50),
 release_year varchar(100),	
 rating	varchar(50),
 duration varchar(15),	
 listed_in	varchar(150),
 description varchar(250)
);

select * from netflix;

select count(*) as total_count from netflix;

select  distinct type from netflix;

-- 15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows
select 
  type ,
 count(*) as total_content 
 from netflix
 group by type

2. Find the most common rating for movies and TV shows
select 
  type,
  rating 
 from(
    select type ,
	rating,
	count(*),
	rank() over(partition by type order by count(*) desc) as ranking
	from netflix
	group by 1,2 
 ) as t1
where ranking=1;

3. List all movies released in a specific year (e.g., 2020)
select * from netflix
 where type= 'Movie'
   AND
   release_year= '2020'
 
4. Find the top 5 countries with the most content on Netflix
  select 
     unnest (String_to_Array(country,',')) as new_country,
	 count(Show_id) as total_content
  from netflix
   group by 1
   order by 2 desc
   limit 5;
   
5. Identify the longest movie
 select * from netflix
  where 
     type = 'Movie'
	 AND 
	 duration = (select max(duration)from netflix);
   
6. Find content added in the last 5 years
 select * from netflix 
  where
   to_date(date_added,'month DD,YYYY')>= current_Date - interval  '5 years'
  
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
 select * from netflix
  where director ilike '%Rajiv Chilaka%';

  
8. List all TV shows with more than 5 seasons
select * 
from netflix
where 
  type='Tv Show'
  AND
   split_part(duration, ' ', 1)::numeric > 5;
  
9. Count the number of content items in each genre
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;


10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

11. List all movies that are documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

12. Find all content without a director
SELECT * 
FROM netflix
WHERE director IS NULL;

13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
  
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;

