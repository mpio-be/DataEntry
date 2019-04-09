


#' table size (nrow)
#' @param table table name
#' @param user db user
#' @param host host
#' @export
grand_n <- function(table, db, user, host, pwd) {

	con =  dbConnect(RMySQL::MySQL(), host = host, user = user, password = pwd); on.exit(dbDisconnect(con))


    dbGetQuery(con, paste0('select count(*) n from ', db, '.' , table) )$n

}

