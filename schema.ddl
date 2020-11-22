-- Schema for hotel reviews

drop schema if exists hotelReviews cascade;
create schema hotelReviews;
set search_path to hotelReviews;

-- Each city observed in the data set
CREATE TABLE cities (
    cityID integer NOT NULL,
    -- The name of this city
    name TEXT NOT NULL,
    -- The pronvince/state this city is in
    province TEXT NOT NULL,
    PRIMARY KEY (cityID)
);

-- The name and city of each hotel in the data set
CREATE TABLE hotels (
    hotelID TEXT NOT NULL,
    -- The city id of this hotel
    city integer NOT NULL,
    -- Name of this hotel
    name TEXT NOT NULL,
    PRIMARY KEY (hotelID),
    foreign key (city) references cities
);

-- The users that have left reviews for hotels
CREATE TABLE users (
    userID integer NOT NULL,
    -- The city that this user is from
    city integer,
    -- this user's name
    name TEXT NOT NULL,
    PRIMARY KEY (userID),
    foreign key (city) references cities
);

-- Each review left by a user
CREATE TABLE reviews (
    reviewID integer NOT NULL,
    hotelID TEXT NOT NULL,
    -- The day this review was submitted
    Date DATE,
    -- The rating that the hotel received from this review
    Rating float,
    -- Content of the review
    Text TEXT,
    -- This review's title
    Title TEXT,
    -- The user that left this review
    userID integer NOT NULL,
    PRIMARY KEY (reviewID),
    foreign key (hotelID) references hotels,
    foreign key (userID) references users
);

-- Categories associated with a hotel
CREATE TABLE categories (
    -- This hotel has Category category
    hotelID TEXT NOT NULL,
    -- The category for the hotel with hotelID hotel id
    Category TEXT NOT NULL,
    PRIMARY KEY (hotelID, category),
    foreign key (hotelID) references hotels
);

-- The website that this hotel was reviewed on
CREATE TABLE hotelWebsites (
    -- hotelID of the hotel reviewed on this website
    hotelID TEXT NOT NULL,
    -- URL of this site
    url TEXT NOT NULL,
    PRIMARY KEY (hotelID, url),
    UNIQUE(url),
    foreign key (hotelID) References hotels
);
