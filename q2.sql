-- What kinds of factors influence the average rating's that a hotel receives? 
-- Factors such as city and number of categories fulfilled

SET SEARCH_PATH TO hotelreviews;
DROP TABLE IF EXISTS q2 cascade;

CREATE TABLE q2 (
    hotel TEXT NOT NULL,
    city TEXT NOT NULL,
    numCategories INT NOT NULL,
    rating FLOAT NOT NULL
);

DROP VIEW IF EXISTS numcategories CASCADE;
DROP VIEW IF EXISTS avgrating CASCADE;

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

-- 3. Join with 
CREATE VIEW result AS
SELECT hotels.name AS hotel, cities.name as city, numcategories, rating
FROM numcategories NATURAL JOIN avgrating
JOIN hotels ON hotels.hotelID = numcategories.hotelID
JOIN cities ON cities.cityID = hotels.city
ORDER BY numCategories DESC, rating DESC
;


insert into q2 SELECT * FROM result;
