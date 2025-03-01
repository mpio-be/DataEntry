
CREATE DATABASE IF NOT EXISTS tests;

CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'testuser';
GRANT ALTER, CREATE, CREATE VIEW, DELETE, DROP, INDEX, INSERT, SELECT, SHOW VIEW, TRIGGER, UPDATE
ON tests.* TO 'testuser'@'localhost';
FLUSH PRIVILEGES;

USE tests;
DROP TABLE IF EXISTS data_entry; 
CREATE TABLE data_entry (
    author          VARCHAR(2)        NULL  DEFAULT NULL COMMENT 'author initials',
    datetime_       DATETIME          NULL  DEFAULT NULL COMMENT 'date and time',
    released_time   VARCHAR(5)        NULL  DEFAULT NULL COMMENT 'released time',
    nest            VARCHAR(5)        NULL  DEFAULT NULL COMMENT 'nest',
    recapture       INT(1)            NULL  DEFAULT NULL COMMENT 'recapture',
    sex             VARCHAR(1)        NULL  DEFAULT NULL COMMENT 'Observed sex.<br>Enter <code>M</code> for male or <code>F</code> for female.',
    measure         DOUBLE(20,10)     NULL  DEFAULT NULL COMMENT 'a measure',
    ID              INT(10)           NULL  DEFAULT NULL COMMENT 'an ID',
    comment         TEXT              NULL               COMMENT '<h1>hcomment field</h1>. This is somewhat a lengthy comment which is used to test the tooltip function on handsontable columns.  field. <hr> This is somewhat a lengthy comment which is used to test the tooltip function on handsontable columns.',
    nov             INT(1)            NULL  DEFAULT NULL COMMENT 'no validation',  
    pk              INT(10)           NOT NULL  AUTO_INCREMENT,
    PRIMARY KEY (pk)
    ) ; 
