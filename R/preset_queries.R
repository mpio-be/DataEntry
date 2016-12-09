


#' select mariadb column's comment
#' @param table table name
#' @param user db user
#' @param host host
#' @export
column_comment <- function(table, db, user, host) {
  dbq(user = user, host = host,
            q = paste0('SELECT COLUMN_NAME, COLUMN_COMMENT FROM  information_schema.COLUMNS
                    WHERE TABLE_SCHEMA =', shQuote(db), 'AND TABLE_NAME =', shQuote(table)) )
}

#' table size (nrow)
#' @param table table name
#' @param user db user
#' @param host host
#' @export
grand_n <- function(table, db, user, host) {
    dbq(user = user, host = host, q = paste0('select count(*) n from ', db, '.' , table) )$n

}

