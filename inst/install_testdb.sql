
CREATE DATABASE IF NOT EXISTS tests;
USE tests;
CREATE USER IF NOT EXISTS 'testuser'@'localhost' IDENTIFIED BY 'testuser';
GRANT ALL ON `tests`.* TO 'testuser'@'localhost';
FLUSH PRIVILEGES;

DROP TABLE IF EXISTS data_entry; 
CREATE TABLE data_entry (
    author          VARCHAR(2)        NULL  DEFAULT NULL COMMENT 'author initials',
    datetime_       DATETIME          NULL  DEFAULT NULL COMMENT 'date and time',
    released_time   VARCHAR(5)        NULL  DEFAULT NULL COMMENT 'released time',
    nest            VARCHAR(5)        NULL  DEFAULT NULL COMMENT 'nest',
    recapture       INT(1)            NULL  DEFAULT NULL COMMENT 'recapture',
    sex             VARCHAR(1)        NULL  DEFAULT NULL COMMENT 'sex',
    measure         DOUBLE(20,10)     NULL  DEFAULT NULL COMMENT 'a measure',
    ID              INT(10)           NULL  DEFAULT NULL COMMENT 'an ID',
    comment         TEXT              NULL               COMMENT 'comment field',
    nov             INT(1)            NULL  DEFAULT NULL COMMENT 'no validation',  
    pk              INT(10)           NOT NULL  AUTO_INCREMENT,
    PRIMARY KEY (pk)
    ) ; 







