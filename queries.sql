-- Query 1: Is there a correlation between a city's popularity (in terms of rating) 
-- and the number of travellers that are based in that city?

SET SEARCH_PATH TO hotelreviews;
DROP TABLE IF EXISTS q1 cascade;

CREATE TABLE q1 (
    city TEXT NOT NULL,
    numTravellers INT NOT NULL,
    rating FLOAT NOT NULL
);

DROP VIEW IF EXISTS ratingPerCity CASCADE;
DROP VIEW IF EXISTS travellersPerCity CASCADE;

-- 1. Create view with average rating per city.
CREATE VIEW ratingPerCity AS
SELECT cityID, avg(rating) AS rating
FROM cities JOIN hotels ON (cityID = city)
JOIN reviews ON hotels.hotelID = reviews.hotelID
GROUP BY cityID;

-- 2. Create view with number of travellers ber city
CREATE VIEW travellersPerCity AS
SELECT city, count(*) AS numTravellers
FROM users
WHERE city IS NOT NULL
GROUP BY city;

-- 3. Join the views

CREATE VIEW cityinfo AS
SELECT name AS city, numTravellers, rating FROM
travellersPerCity JOIN ratingPerCity ON city = cityID
JOIN cities ON city = cities.cityID
ORDER BY numTravellers DESC;

insert into q1 SELECT * FROM cityinfo;

-- ----------------------------------------------------------------------------------
-- Query 2: What kinds of factors influence the average rating's that a hotel 
-- receives? Factors such as city and number of categories fulfilled

SET SEARCH_PATH TO hotelreviews;
DROP TABLE IF EXISTS q2 cascade;

CREATE TABLE q2 (
    hotel TEXT NOT NULL,
    city TEXT NOT NULL,
    avgCityRating FLOAT NOT NULL,
    numCategories INT NOT NULL,
    rating FLOAT NOT NULL
);

DROP VIEW IF EXISTS numcategories CASCADE;
DROP VIEW IF EXISTS avgrating CASCADE;
DROP VIEW IF EXISTS cityratings CASCADE;
DROP VIEW IF EXISTS moreCityRatings CASCADE;

-- 1. Create view with hotels to num categories
CREATE VIEW numcategories AS 
SELECT hotelID, count(*) AS numcategories
FROM categories
GROUP BY hotelID;

-- 2. Create view hotel to avg rating
CREATE VIEW avgrating AS
SELECT hotelID, avg(rating) AS rating
FROM reviews
GROUP BY hotelID;

-- 3. Create view to capture avg hotel rating per city
CREATE VIEW cityratings as
SELECT city AS cityID, avg(rating) as avgCityRating
FROM reviews NATURAL JOIN hotels
GROUP BY city;

CREATE VIEW moreCityRatings as
SELECT city AS cityID, avg(rating) as avgCityRating
FROM reviews NATURAL JOIN hotels
GROUP BY city
HAVING count(rating) > 5;

-- 4. Join with 
CREATE VIEW result AS
SELECT hotels.name AS hotel, cities.name as city, avgCityRating, numcategories, rating
FROM numcategories NATURAL JOIN avgrating
JOIN hotels ON hotels.hotelID = numcategories.hotelID
JOIN cities ON cities.cityID = hotels.city
JOIN cityratings ON cityratings.cityID = hotels.city
ORDER BY city DESC, numcategories DESC
;

insert into q2 SELECT * FROM result;

-- ----------------------------------------------------------------------------------
-- Query 3: Do people who tend to travel more (have more reviews posted) 
-- tend to give a higher/lower score

SET SEARCH_PATH TO hotelreviews;
DROP TABLE IF EXISTS q3 cascade;

CREATE TABLE q3 (
    name TEXT NOT NULL,
    numReviews INT NOT NULL,
    avgScore FLOAT NOT NULL
);

DROP VIEW IF EXISTS numReviews CASCADE;
DROP VIEW IF EXISTS avgrating CASCADE;

-- 1. Create view with user to hum reviews
CREATE VIEW numReviews AS
SELECT userID, count(*) AS numReviews
FROM reviews
GROUP BY userID;

-- 2. Create view user to average score
CREATE VIEW avgrating AS
SELECT userID, avg(rating) AS avgScore
FROM reviews
GROUP BY userID;

-- 3. Join with each other and get name from user
CREATE VIEW result AS
SELECT name, numReviews, avgScore
FROM avgrating NATURAL JOIN numReviews
JOIN users ON avgrating.userID = users.userID
ORDER BY numReviews DESC
;

insert into q3 SELECT * FROM result;
