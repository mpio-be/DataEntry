# https://github.com/mpio-be/sdb

require(sdb)

con = dbcon('mihai', host = '127.0.0.1')

dbq(con, 'DROP DATABASE IF EXISTS test' )
dbq(con, 'CREATE DATABASE test' )
dbq(con, 'USE test')

dbq(con, "CREATE TABLE test_tbl (
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


# validators table
dbq(con,"CREATE TABLE IF NOT EXISTS validators (
      table_name varchar(50) NOT NULL,
      script     longtext    NOT NULL)")

dbq(con,"INSERT INTO validators (table_name, script) VALUES
    ('test_tbl', 
    'v1 = is.na_validator(x[, .(datetime_, author, nest)])
     v2 = POSIXct_validator(x[ , .(datetime_)] )
     v3 = is.element_validator(x[ , .(author)], v = data.table(variable = \"author\", set = list( c(\"AI\", \"AA\", \"XY\") ) ))
     v4 = interval_validator( x[, .(measure)], v = data.table(variable = \"measure\", lq = 1, uq = 10 ) )
     o = list(v1, v2, v3, v4) %>% rbindlist
     o[, .(row_id = paste(rowid, collapse = \",\")), by = .(variable, reason)]
     ');")



