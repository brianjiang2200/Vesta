-- Initialize Database
CREATE DATABASE vesta;

-- User Schema
CREATE SCHEMA IF NOT EXISTS user;

CREATE TABLE IF NOT EXISTS user.user (
    email       VARCHAR(64) PRIMARY KEY,
    firstname   VARCHAR(64) NOT NULL,
    prefname    VARCHAR(64),
    lastname    VARCHAR(64) NOT NULL,
    age         INTEGER NOT NULL,
    signup      DATETIME NOT NULL
);

CREATE TYPE user.FILETYPE AS ENUM ('pdf', 'jpg', 'png');

CREATE TYPE user.FILE AS (
    filetype    user.FILETYPE NOT NULL,
    content     BYTEA NOT NULL
)

CREATE TABLE IF NOT EXISTS user.upload (
    email       VARCHAR(64) NOT NULL,
    upload      user.FILE NOT NULL,
    uploadtime  DATETIME NOT NULL,

    FOREIGN KEY email REFERENCES user.user(email)
);

CREATE TABLE IF NOT EXISTS user.login (
    email       VARCHAR(64) NOT NULL,
    password    VARCHAR(64) NOT NULL,
    active      BOOLEAN NOT NULL

    FOREIGN KEY email REFERENCES user.user(email)
);

CREATE TABLE IF NOT EXISTS user.preferences (
    email       VARCHAR(64) PRIMARY KEY,
    pricerange  RANGE(INTEGER),
    timerange   RANGE(DATETIME),
    location    TEXT[],
    rating      NUMERIC,

    FOREIGN KEY email REFERENCES user.user(email)
);

CREATE TABLE IF NOT EXISTS user.settings (
    email       VARCHAR(64) PRIMARY KEY,
    visible     BOOLEAN,
    chatOn      BOOLEAN,

    FOREIGN KEY email REFERENCES user.user(email)
);

-- Listing Schema
CREATE SCHEMA IF NOT EXISTS listing;

CREATE TABLE IF NOT EXISTS listing.property (
    ID          SERIAL PRIMARY KEY,
    name        VARCHAR(64) NOT NULL,
    address     VARCHAR(128) NOT NULL,
    city        VARCHAR(64) NOT NULL,
    country     VARCHAR(64) NOT NULL
);

CREATE TYPE listing.LISTING_STATUS AS ENUM ('available', 'sold', 'unavailable')

CREATE TABLE IF NOT EXISTS listing.listing (
    ID          SERIAL PRIMARY KEY,
    owner       VARCHAR(64),
    propertyID  INTEGER NOT NULL,
    unit        VARCHAR(16),
    duration    RANGE(DATETIME),
    rate        RANGE(INTEGER),
    utilities   TEXT[],
    floorplan   user.FILE,
    status      listing.LISTING_STATUS,
    proof       user.FILE

    FOREIGN KEY propertyID REFERENCES listing.property(ID)
);

CREATE TYPE listing.INTEREST_STATUS AS ENUM ('closed', 'sold', 'pending')

CREATE TABLE IF NOT EXISTS listing.interest (
    buyer       VARCHAR(64),
    seller      VARCHAR(64),
    listingID   INTEGER,
    status      listing.INTEREST_STATUS,

    FOREIGN KEY buyer REFERENCES user.user(email),
    FOREIGN KEY seller REFERENCES user.user(email),
    FOREIGN KEY listingID REFERENCES listing.listing(ID)
);

CREATE TABLE IF NOT EXISTS listing.propertyReview (
    ID          SERIAL PRIMARY KEY,
    propertyID  INTEGER NOT NULL,
    rating      INTEGER NOT NULL,
    comments    TEXT,
    timestamp   DATETIME,

    FOREIGN KEY propertyID REFERENCES listing.property(ID)
);

CREATE TYPE listing.FLAGGEDLISTING_TYPE AS ENUM ('Illegal', 'Unethical', 'Inappropriate');

CREATE TABLE IF NOT EXISTS listing.flaggedListing (
    listingID   INTEGER NOT NULL,
    flagger     VARCHAR(64),
    timestamp   DATETIME,
    type        listing.FLAGGEDLISTING_TYPE,

    PRIMARY KEY (listingID, flagger),
    FOREIGN KEY listingID REFERENCES listing.listing(ID),
    FOREIGN KEY flagger REFERENCES user.user(email)
);

-- Messaging Schema
CREATE SCHEMA IF NOT EXISTS messaging;

CREATE TYPE messaging.MESSAGE_SENDER AS ENUM (1, 2);
CREATE TYPE messaging.MESSAGE AS (
    sender      messaging.MESSAGE_SENDER,
    message     TEXT,
    timestamp   DATETIME
);

CREATE TABLE IF NOT EXISTS messaging.chat (
    user1       VARCHAR(64),
    user2       VARCHAR(64),
    history     messaging.MESSAGE[],

    PRIMARY KEY (user1, user2),
    FOREIGN KEY user1 REFERENCES user.user(email),
    FOREIGN KEY user2 REFERENCES user.user(email)
);

CREATE TABLE IF NOT EXISTS messaging.blocks (
    blocker     VARCHAR(64),
    blocked     VARCHAR(64),
    timestamp   DATETIME NOT NULL,

    PRIMARY KEY (blocker, blocked),
    FOREIGN KEY blocker REFERENCES user.user(email),
    FOREIGN KEY blocked REFERENCES user.user(email)
);
