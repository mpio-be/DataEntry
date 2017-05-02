
#' @name             inspector
#' @title            data inspector
#' @param sql        sql string returning the script stored in db 
#' @param x          data to be validated.
#' @description      an inspector runs all the validators in the script.
#' @return           a data.table
#' @export
#' @examples
#' inspector('select script from validators where table_name = "test_tbl"', 
#'          x, 'mihai', 'test', '127.0.0.1')

  inspector <- function(sql, x, user, db, host) {
    
    require(sdb)
    con = dbcon(user, db = db, host = host); on.exit(dbDisconnect(con))
    getv = dbq(con, sql)
    stopifnot( !all(dim(getv) > 1 ) )

    o = getv[[1]]
    eval( parse(text = o) )
    
   }

