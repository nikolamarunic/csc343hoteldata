-- Do people who tend to travel more (have more reviews posted) tend to give a higher/lower score

SET SEARCH_PATH TO hotelreviews;
DROP TABLE IF EXISTS q3 cascade;

CREATE TABLE q3 (
    user TEXT NOT NULL,
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
