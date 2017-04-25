


#' table size (nrow)
#' @param table table name
#' @param user db user
#' @param host host
#' @export
grand_n <- function(table, db, user, host) {
    dbq(user = user, host = host, q = paste0('select count(*) n from ', db, '.' , table) )$n

}

