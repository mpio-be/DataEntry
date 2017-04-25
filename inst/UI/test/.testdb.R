
require(sdb)

con = dbcon('mihai', host = '127.0.0.1')

dbq(con, 'DROP DATABASE IF EXISTS test' )
dbq(con, 'CREATE DATABASE test' )
dbq(con, 'USE test')

x = data.table(
            author = 'x', 
            datetime_ = Sys.Date(), 
            nest = 'N001', 
            measure = pi, 
            ID = 1, 
            comment = 'long text', 
            notShow = 0,
            pk = 1)
dbWriteTable(con, 'test_tbl', x, row.names = FALSE, 
     field.types=list(
            author    ='varchar(2)', 
            datetime_ ='datetime',
            nest      ='varchar(5)', 
            measure   ='double(20,10)', 
            ID        ='int(10)', 
            comment   ='text', 
            notShow   = 'int(1)',
            pk        ='int(10)'))
dbq(con,
"ALTER TABLE test_tbl
    CHANGE COLUMN author author VARCHAR(2) NULL DEFAULT NULL COMMENT 'author initials' FIRST,
    CHANGE COLUMN datetime_ datetime_ DATETIME NULL DEFAULT NULL COMMENT 'dt' AFTER author,
    CHANGE COLUMN nest nest VARCHAR(5) NULL DEFAULT NULL COMMENT 'nest' AFTER datetime_,
    CHANGE COLUMN measure measure DOUBLE(20,10) NULL DEFAULT NULL COMMENT 'a measure' AFTER nest,
    CHANGE COLUMN ID ID INT(10) NULL DEFAULT NULL COMMENT 'an ID' AFTER measure,
    CHANGE COLUMN comment comment TEXT NULL COMMENT 'bla bla' AFTER ID;")
