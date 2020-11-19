-- Is there a correlation between a city's popularity (in terms of rating) 
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
