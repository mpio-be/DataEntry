# ==========================================================================
# UI with a vertical navigation bar to update an existing db table
#   shiny::runApp('inst/UI/db_update_vbar', launch.browser =  TRUE)
# ==========================================================================


	

	sapply(c('DataEntry', 'sdb', 'data.table','shinyBS','shinytoastr','knitr'),
		require, character.only = TRUE, quietly = TRUE)

	user           = 'bt'
	host           = '127.0.0.1'
	pwd            = 'bt'
	db             = 'test'
	tableName      =  'test_tbl'
	excludeColumns = c('pk', 'notShow')
	
	H = emptyFrame(user, host, db, pwd, tableName, n = 10, excludeColumns, 
				preFilled = list(
						datetime_ = as.character(Sys.Date()), author = 'AI') 
				)
	
	comments = column_comment(user, host, db, pwd, tableName,excludeColumns)



	inspector <- function(forv) {
		x = copy(forv)

		v1 = is.na_validator(x[, .(datetime_, author, nest)])
		v2 = POSIXct_validator(x[ , .(datetime_)] )
		v3 = is.element_validator(x[ , .(author)], v = data.table(variable = 'author', set = list( c('AI', 'AA', 'XY') ) ))
		v4 = interval_validator( x[, .(measure)], v = data.table(variable = 'measure', lq = 1, uq = 10 ) )

		o = list(v1, v2, v3, v4) %>% rbindlist
		o = o[, .(rowid = paste(rowid, collapse = ',')), by = .(variable, reason)]
		o

		}




	table_smry <- function() {
		data.frame(x = 'function applied on the table', y = 'returning meaningful summaries')
	}

