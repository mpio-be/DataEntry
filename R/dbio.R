





#' @name  executeDB
#' @title execute a pre-defined script
#' @param action   		a name of for a db operation 
#' @param tableName   	table name
#' @param x   			a data.table
#' @param host   		host
#' @param user   		user
#' @param db   			db
#' @param pwd   		pwd
#' 
#' @return TRUE a named logical vector of length 1. The name is relevant to the action. 
#' @note  The following actions are defined here: __append__, __update__. 
#' 
#' @export

executeDB <- function(action, tableName, x, host, user, db, pwd) {

	con =  dbConnect(RMySQL::MySQL(), host = host, user = user, db = db, password = pwd); on.exit(dbDisconnect(con))

	if(action == "append") {
		out = dbWriteTable(con, tableName, x, append = TRUE, row.names = FALSE)
		if(out) names(out) = "Update OK!" else "Update failed"
		}

	if(action == "update") {
		dbExecute(con, 'DROP TABLE IF EXISTS TEMP')
		out = dbWriteTable(con, 'TEMP', x, append = TRUE, row.names = FALSE)
		if(out) {
			dbExecute(con, paste('DROP TABLE', tableName) )
			dbExecute(con, paste('RENAME TABLE TEMP to', tableName) )
		}

		if(out) names(out) = "Update OK!" else "Update failed"

		}

	out	


	}









#' table size (nrow)
#' @param table table name
#' @param user db user
#' @param host host
#' @export
grand_n <- function(table, db, user, host, pwd) {

	con =  dbConnect(RMySQL::MySQL(), host = host, user = user, password = pwd); on.exit(dbDisconnect(con))


	dbGetQuery(con, paste0('select count(*) n from ', db, '.' , table) )$n

}

