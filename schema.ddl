drop schema if exists hotelReviews cascade;
create schema hotelReviews;
set search_path to hotelReviews;

CREATE TABLE cities (
    cityID integer NOT NULL,
    name TEXT NOT NULL,
    province TEXT NOT NULL,
    PRIMARY KEY (cityID)
);
CREATE TABLE hotels (
    hotelID TEXT NOT NULL,
    city integer NOT NULL,
    name TEXT NOT NULL,
    PRIMARY KEY (hotelID),
    foreign key (city) references cities
);
CREATE TABLE users (
    userID integer NOT NULL,
    city integer,
    name TEXT NOT NULL,
    PRIMARY KEY (userID),
    foreign key (city) references cities
);
CREATE TABLE reviews (
    reviewID integer NOT NULL,
    hotelID TEXT NOT NULL,
    Date DATE,
    Rating float,
    Text TEXT,
    Title TEXT,
    userID integer NOT NULL,
    PRIMARY KEY (reviewID),
    foreign key (hotelID) references hotels,
    foreign key (userID) references users
);
CREATE TABLE categories (
    hotelID TEXT NOT NULL,
    Category TEXT NOT NULL,
    PRIMARY KEY (hotelID, category),
    foreign key (hotelID) references hotels
);
CREATE TABLE hotelWebsites (
    hotelID TEXT NOT NULL,
    url TEXT NOT NULL,
    PRIMARY KEY (hotelID, url),
    UNIQUE(url),
    foreign key (hotelID) References hotels
);
