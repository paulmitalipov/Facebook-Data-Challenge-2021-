/*
A sampling of queries used for FB Data Challenge 2021 project 
on analyzing a dataset of content added to Netflix in conjunction
with a table of IMDB ratings.

*/
SELECT COUNT(*)
FROM netflix_titles

SELECT COUNT(*)
FROM imdb_ratings

/*
Finds the top ten pieces of content on Netflix by IMDB rating
*/
SELECT DISTINCT TOP 10 n.show_id, n.title, i.rating, n.type
FROM netflix_titles n
JOIN imdb_ratings i
ON i.title = n.title
ORDER BY i.rating DESC

/*
Sample query that finds 10 pieces of content released in 2016 that contain 
the word "the" somewhere in the title
*/
SELECT TOP 10 title
FROM netflix_titles
WHERE release_year = '2016'
AND UPPER(title) LIKE '%THE%'

/*
Finds number of movies added every year onto Netflix
*/
SELECT YEAR(date_added) q, COUNT(*) as num_tv
FROM netflix_titles n
WHERE type = 'Movie'
GROUP BY YEAR(date_added)
ORDER BY YEAR(date_added) ASC

/*
Average rating and number of pieces of content to come out of a country 
or certain group of countries (some pieces of content came from multiple countries). 
Used subquery to avoid duplicates when joining the two tables (they lack a common identifier so had to join on title)
*/
SELECT T.country, AVG(T.rating) as average_rating, COUNT(*) as num_content
FROM (SELECT DISTINCT n.title, i.rating, n.country
	FROM netflix_titles n
	JOIN imdb_ratings i
	ON i.title = n.title) T
GROUP BY T.country
HAVING country NOT LIKE '%,%'
ORDER BY average_rating DESC

/*
Number of pieces of content to come out of a single country
*/
SELECT COUNT(*) as num_content
FROM (
	SELECT DISTINCT n.title, i.rating, n.country
	FROM netflix_titles n
	JOIN imdb_ratings i
	ON i.title = n.title) T
WHERE country NOT LIKE '%,%'

/*
Number of TV shows added from Japan grouped by year.
Surprisingly, a lot more TV shows than movies came to Netflix from Japan,
flipping the global trend 
*/
SELECT YEAR(n.date_added), COUNT(*)
FROM netflix_titles n
WHERE n.country LIKE '%Japan%'
AND n.type = 'TV Show'
GROUP BY YEAR(n.date_added)

SELECT n.listed_in, COUNT(*)
FROM netflix_titles n
WHERE n.type = 'TV Show'
AND n.country = 'Japan'
GROUP BY n.listed_in
ORDER BY COUNT(*) DESC


/*
Average rating of thriller movies/tv shows.
Had to use LIKE keyword and wildcard % because some pieces of content
have many genres listed.
*/
SELECT AVG(i.rating) as avg_genre_rating
FROM netflix_titles n
JOIN imdb_ratings i
ON i.title = n.title
WHERE listed_in LIKE '%Thrillers%'
