

#' emptyFrame 
#' emptyFrame used by handsontable
#' @param user             db user 
#' @param host             db host 
#' @param db               db name 
#' @param table            db table 
#' @param n                n empty lines 
#' @param excludeColumns   default 'pk'
#' @param preFilled        a named list eg. list(datetime_ = as.character(Sys.Date())) 
#' @export
#' @examples \dontrun{
#' emptyFrame(user = 'bt', host = '127.0.0.1', db = 'FIELD_BTatWESTERHOLZ', table = 'ADULTS')
#' emptyFrame(user = 'bt', host = '127.0.0.1', db = 'FIELD_BTatWESTERHOLZ', table = 'ADULTS', preFilled = list(datetime_ = as.character(Sys.Date())) )
#' }
#' 
emptyFrame <- function(user, host, db, pwd, table,n = 10, excludeColumns = 'pk', preFilled) {

	con =  dbConnect(RMySQL::MySQL(), host = host, user = user, password = pwd); on.exit(dbDisconnect(con))


	F = dbGetQuery(con, paste0('SELECT * from ', db, '.', table, ' where FALSE') ) %>% data.table

	if(!missing(excludeColumns))
	F = F[, setdiff(names(F), excludeColumns), with = FALSE]


	F = rbind(F, data.table(tempcol = rep(NA, n)), fill = TRUE)[, tempcol := NULL]

	if(!missing(preFilled) ) {
			for(i in 1:length(preFilled)) {
					set(F, j = names(preFilled[i]), value = preFilled[[i]])
					}
			}

	# convert un-handled rhandsontable types to characters (RMariaDB)
		# difftime_to_char = which( F[, sapply(.SD, function(x) inherits(x, 'difftime') ) ] ) %>% names
		# F[,(difftime_to_char) := lapply(.SD, as.character), .SDcols = difftime_to_char]
		# 
		# POSIXt_to_char = which( F[, sapply(.SD, function(x) inherits(x, 'POSIXt') ) ] ) %>% names
		# F[,(POSIXt_to_char) := lapply(.SD, as.character), .SDcols = POSIXt_to_char]

	F

	}



#' @rdname emptyFrame
#' @name   emptyFrameHot
#' @export
emptyFrameHot <- function(...) {
	emptyFrame(...) %>%
	rhandsontable   %>%
			hot_cols(columnSorting = FALSE, manualColumnResize = TRUE) %>%
			hot_rows(fixedRowsTop = 1)
	}






#' @export
column_comment <- function(user, host, db, pwd, table, excludeColumns = 'pk') {
		
		con =  dbConnect(RMySQL::MySQL(), host = host, user = user, password = pwd); on.exit(dbDisconnect(con))


		x = dbGetQuery(con,
				paste0('SELECT COLUMN_NAME `Column`, COLUMN_COMMENT description FROM  information_schema.COLUMNS
								WHERE TABLE_SCHEMA =', shQuote(db), 'AND TABLE_NAME =', shQuote(table)) ) %>% data.table

		x[!Column %in% excludeColumns]
 }

