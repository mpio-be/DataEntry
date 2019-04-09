# https://github.com/mpio-be/sdb

require(sdb)

con = dbcon('mihai', host = '127.0.0.1')

dbExecute(con, 'DROP DATABASE IF EXISTS test' )
dbExecute(con, 'CREATE DATABASE test' )
dbExecute(con, 'USE test')

dbExecute(con, "CREATE TABLE test_tbl (
    author    VARCHAR(2)    NULL  DEFAULT NULL COMMENT 'author initials',
    datetime_ DATETIME      NULL  DEFAULT NULL COMMENT 'date and time',
    nest      VARCHAR(5)    NULL  DEFAULT NULL COMMENT 'nest',
    sex       VARCHAR(1)    NULL  DEFAULT NULL COMMENT 'sex',
    measure   DOUBLE(20,10) NULL  DEFAULT NULL COMMENT 'a measure',
    ID        INT(10)       NULL  DEFAULT NULL COMMENT 'an ID',
    comment   TEXT          NULL               COMMENT 'comment field',
    notShow   INT(1)        NULL  DEFAULT NULL,
    pk        INT(10)       NULL  DEFAULT NULL
    )")

x = data.table(
            author    = 'x', 
            datetime_ = Sys.Date(), 
            nest      = 'N001', 
            measure   = pi, 
            ID        = 1, 
            comment   = 'long text', 
            notShow   = 0,
            pk        = 1)
dbWriteTable(con, 'test_tbl', x, row.names = FALSE, append = TRUE)



