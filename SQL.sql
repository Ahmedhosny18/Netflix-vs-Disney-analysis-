--1.Find the Top Countries with the Most Content on Netflix
select *
from (
select country as country, count(m.*) as country_content
, sum(count(m.*)) over() as total_content
, dense_rank() over(order by count(m.show_id) desc ) as r
from master m inner join countries c
     on m.show_id = c.show_id
group by 1
order by 2 desc) as tab 
where r <=5

--2. Find the Most Common Rating for Movies and TV Shows
select type, rating 
from  (
		SELECT 
        type,
        rating,
        COUNT(*) AS rating_count,
		rank() over(partition by type order by COUNT(*) desc ) as rank
   			 FROM master
    GROUP BY type, rating
) as tab
WHERE rank <=3;




--3.Identify the Longest Movie
-- SPLIT_PART(col, splitter, part) '312 min'> '312'
SELECT 
    type, title,duration
FROM master
WHERE type = 'Movie' 
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

--4.Find Content Added in the Last 5 Years
SELECT *
FROM master
WHERE TO_DATE(date_added, 'MM/DD/YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--5.List All TV Shows with More Than 5 Seasons
SELECT *
FROM master
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;



--6.Find each year and the average numbers of content release in Egypt on netflix.
WITH total_egypt_shows AS (
    SELECT COUNT(show_id) AS total_shows
    FROM countries
    WHERE country = 'Egypt'
)
SELECT 
    m.release_year,
    COUNT(m.show_id) AS total_release,
    ROUND(
        COUNT(m.show_id)::numeric / total_shows * 100, 2
    ) AS avg_release
FROM master m
INNER JOIN countries c ON m.show_id = c.show_id
CROSS JOIN total_egypt_shows
WHERE c.country = 'Egypt'
GROUP BY m.release_year, total_shows
ORDER BY avg_release DESC
LIMIT 5;

--7.Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies
SELECT 
    actor,
    COUNT(*)
FROM casts
GROUP BY actor
ORDER BY COUNT(*) DESC

--8. No. of actors for countray as percentage from total actors on Netflix
select *, round((actor_No::numeric / TotalActors::numeric)*100,2) as "percentage%"
from (select country, count(distinct actor) as actor_No , 
 sum(count(distinct actor)) over() as TotalActors
from casts a inner join countries c on a.show_id = c.show_id
group by 1 order by 2 desc ) as tab

--9. For directors
select *, round((director_No::numeric / TotalDirector::numeric)*100,2) as "percentage%"
from (select country, count(distinct director) as director_No , 
 sum(count(distinct director)) over() as TotalDirector
from directors d inner join countries c on d.show_id = c.show_id
group by 1 order by 2 desc ) as tab




--10.Growth content for top 5 countries with content on netflix
WITH country_release AS (
    SELECT 
        c.country,
        m.release_year::INTEGER,
        COUNT(m.show_id) AS current_release
    FROM 
        master m 
        INNER JOIN countries c ON m.show_id = c.show_id
    WHERE 
        m.release_year::INTEGER > 2009 
        AND c.country IN ('United States', 'India', 'United Kingdom', 'Canada', 'France')
    GROUP BY 
        c.country, m.release_year
),
release_with_lag AS (
    SELECT 
        country,
        release_year,
        current_release,
        LAG(current_release, 1, 0) OVER (PARTITION BY country ORDER BY release_year) AS previous_release
    FROM 
        country_release
)
SELECT 
    country,
    release_year,
    current_release,
    previous_release,
    ROUND((current_release - previous_release) * 100.0 / NULLIF(previous_release, 0), 2) AS growth_rate
FROM 
    release_with_lag
WHERE 
    previous_release <> 0
ORDER BY 
    country DESC, release_year;





--12.Show the difference in the number of TV Shows added year-over-year for each country
SELECT country, release_year, COUNT(*) AS tv_show_count, 
       COALESCE(COUNT(*) - LAG(COUNT(*)) OVER (PARTITION BY country ORDER BY release_year), 0) AS year_over_year_diff
FROM master m inner join countries c on m.show_id = c.show_id
WHERE type = 'TV Show'
GROUP BY country, release_year;

--13.top casts for distinct genres 
select actor, count(distinct g.genre) as total_genres
from casts c inner join genres g on  c.show_id = g.show_id
group by 1
order by 2 desc

--14.distinct genres for each country تنوع ف المحتوى 
select country, count(distinct g.genre)
,(select count (distinct genre) from genres) as all_genres
from countries c inner join genres g on  c.show_id = g.show_id
group by 1
order by 2 desc

--15. No. of AgeGroup for each country
SELECT 
    country, 
    COUNT(DISTINCT rating) AS distinct_agegroup
	,(SELECT COUNT(DISTINCT rating) FROM master) AS total_rating
FROM 
    countries c 
    INNER JOIN master m ON c.show_id = m.show_id
GROUP BY 
    country
ORDER BY 
    distinct_agegroup DESC;


--16.Find the top 5 most common genres across all shows and their total count.
SELECT rating, COUNT(*) AS genre_count
FROM master
where type = 'Movie'
GROUP BY rating
ORDER BY genre_count DESC
LIMIT 5;

--17.Find the next show's title (lead) and previous show's title (lag) for each show based on the release year.
SELECT title, release_year, LAG(title) OVER(ORDER BY release_year) AS previous_show, 
       LEAD(title) OVER(ORDER BY release_year) AS next_show
FROM master;

--18.Find the top 5 longest movies by duration and their directors
SELECT title, director, duration
FROM master m inner join directors d on m.show_id = d.show_id
WHERE type = 'Movie' and duration is not null
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 5;

--19.Calculate the percentage of TV Shows vs Movies added in the last 4 years (based on date_added).
SELECT type, 
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM master
WHERE EXTRACT(YEAR FROM TO_DATE(date_added, 'MM/DD/YYYY')) BETWEEN 2018 AND 2021
GROUP BY type;

--20.Find the top 3 countries with the most content in 2020 and 2021.
WITH recent_shows AS (
    SELECT country, COUNT(m.*) AS total_shows
    FROM master m inner join countries c on m.show_id = c.show_id
    WHERE release_year :: numeric IN (2020, 2021) and country is not null
    GROUP BY country
)
SELECT country, total_shows
FROM recent_shows
ORDER BY total_shows DESC
LIMIT 3;

--21.Find the 5 directors who have the most shows listed.
select * 
from (
SELECT director, COUNT(m.*) AS total_shows
,dense_rank()over( order by COUNT(m.*) desc) as rank
FROM master m inner join directors d on m.show_id = d.show_id
WHERE director IS NOT NULL
GROUP BY director) as tab
where rank <=5


--22.Calculate the average duration of movies by rating
SELECT rating, ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INT)), 2) AS avg_duration
FROM master
WHERE type = 'Movie' and rating != 'Not detected'
GROUP BY rating;



--23.Count the Number of Content Items in Each Genre
SELECT 
    genre,
    COUNT(*) AS total_content
FROM genres
GROUP BY 1 
order by 2 desc

--24.Find the Most Common Rating for Movies and TV Shows
select type, rating 
from  (
		SELECT 
        type,
        rating,
        COUNT(*) AS rating_count,
		rank() over(partition by type order by COUNT(*) desc ) as rank
   			 FROM master
    GROUP BY type, rating
) as tab
WHERE rank <=5;

--25.Show a running total of movies added for each rating type year-over-year.
SELECT rating, release_year, COUNT(*) AS yearly_movie_count,
       SUM(COUNT(*)) OVER (PARTITION BY rating ORDER BY release_year) AS running_total
FROM master 
WHERE type = 'Movie'
GROUP BY rating, release_year;

--26. number of content for each Release Year 
select *, round(content_ReleaseYear::numeric *100 /total_content::numeric,2 ) || '%' as Year_percentage
from(
select release_year , count(show_id) as content_ReleaseYear
, sum(count(show_id)) over() as total_content
from master
group by 1
order by release_year desc) as tab

--27. number of content for each Yeat that added into netflix 
select *, round(content_Added::numeric *100 /total_content::numeric,2 ) || '%' as Year_percentage
from(
select extract(year from date_added :: date) as Netflix_year , count(show_id) as content_Added
, sum(count(show_id)) over() as total_content
from master
where date_added is not null
group by 1
order by 1 desc) as tab

