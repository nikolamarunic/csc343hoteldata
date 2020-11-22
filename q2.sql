-- What kinds of factors influence the average rating's that a hotel receives? 
-- Factors such as city and number of categories fulfilled

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
DROP VIEW IF EXISTS moreReviewsResult CASCADE;


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

-- 3b. Create a view to see if there is perhaps a trend with cities that have more ratings
CREATE VIEW moreCityRatings as
SELECT city AS cityID, avg(rating) as avgCityRating
FROM reviews NATURAL JOIN hotels
GROUP BY city
HAVING count(rating) > 5;

-- 4. Compile all data together 
-- We manipulated the ORDER BY here as mentioned in the discussion to see
-- if they perhaps individually affected our result.
CREATE VIEW result AS
SELECT hotels.name AS hotel, cities.name as city, avgCityRating, numcategories, rating
FROM numcategories NATURAL JOIN avgrating
JOIN hotels ON hotels.hotelID = numcategories.hotelID
JOIN cities ON cities.cityID = hotels.city
JOIN cityratings ON cityratings.cityID = hotels.city
ORDER BY city DESC, numcategories DESC
;

-- 4b. Compile all data together, now checking for cities with many reviews
-- We manipulated the ORDER BY here as mentioned in the discussion to see
-- if they perhaps individually affected our result.
CREATE VIEW moreReviewsResult AS
SELECT hotels.name AS hotel, cities.name as city, avgCityRating, numcategories, rating
FROM numcategories NATURAL JOIN avgrating
JOIN hotels ON hotels.hotelID = numcategories.hotelID
JOIN cities ON cities.cityID = hotels.city
JOIN moreCityRatings ON moreCityRatings.cityID = hotels.city
ORDER BY city DESC, numcategories DESC
;

insert into q2 SELECT * FROM result;