-- Do people who tend to travel more (have more reviews posted) tend to give a higher/lower score

SET SEARCH_PATH TO hotelreviews;
DROP TABLE IF EXISTS q3 cascade;

CREATE TABLE q3 (
    hotel TEXT NOT NULL,
    city TEXT NOT NULL,
    numCategories INT NOT NULL,
    rating FLOAT NOT NULL
);

DROP VIEW IF EXISTS numcategories CASCADE;
DROP VIEW IF EXISTS avgrating CASCADE;

-- 1. Create view with hotels to num categories

-- 2. Create view hotel to avg rating


-- 3. Join with 


insert into q3 SELECT * FROM result;
