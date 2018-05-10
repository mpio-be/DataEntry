
#' @name             inspectorSQL
#' @title            data inspector
#' @param sql        sql string returning the script stored in db 
#' @param x          data to be validated.
#' @description      an inspector runs all the validators in the script.
#' @return           a data.table
#' @export
#' @examples
#' inspectorSQL('select script from validators where table_name = "test_tbl"', 
#'          x, 'mihai', 'test', '127.0.0.1')

  inspectorSQL <- function(sql, x, user, db, host) {
    f = function() {
      require(sdb)
      con = dbcon(user, db = db, host = host); on.exit(dbDisconnect(con))
      getv = dbq(con, sql)
      stopifnot( !all(dim(getv) > 1 ) )
      
      o = getv[[1]]
      eval( parse(text = o) )  
    }

    o = try(f(), silent = TRUE)
    if( !inherits(o, 'data.table') ) 
      o = data.table(variable = '', reason = 'Validation does not work; please contact your server administrator. In the mean-time press ignore validation and try again.', row_id= 0)
    
    o
    
    }
  
  
  
  
  
  
  

