
# ==========================================================================
# UI with a vertical navigation bar to enter new data 
# shiny::runApp('./inst/UI/newData', launch.browser =  TRUE)
# ==========================================================================

# Settings
	
	sapply(c('DataEntry', 'shinyjs', 'glue', 'tableHTML'),require, character.only = TRUE, quietly = TRUE)
	tags = shiny::tags

	host    = getOption('DataEntry.host')
	db      = getOption('DataEntry.db'  )
	user    = getOption('DataEntry.user')
	pwd     = getOption('DataEntry.pwd' )

	tableName       = 'data_entry'
	excludeColumns  = c('pk', 'nov')
	n_empty_lines   = 3
	authors         = c('AI', 'CS', 'GS')

	describeTable <- function() {
		data.frame(x = 'function applied on the db table', y = 'returning meaningful summaries')
		}

	comments = column_comment(user, host, db, pwd, tableName,excludeColumns)	

# Define UI table  
	uitable = emptyFrame(user, host, db, pwd, tableName, n = n_empty_lines, excludeColumns, 
		preFilled = list(datetime_ = format(Sys.Date(), "%Y-%m-%d") ) ) %>% 
		rhandsontable %>% 
		hot_cols(columnSorting = FALSE, manualColumnResize = TRUE) %>%
		hot_rows(fixedRowsTop = 1) %>%
		hot_col(col = "author", type = "dropdown", source = authors )
	

# Define inspectors
	inspector.data_entry <- function(x) {
		v1  = is.na_validator(x[, .(author, datetime_, ID)])
		#v2  = is.na_validator(x[recapture == 0, .(sex, measure)], "Mandatory at first capture")
		#v3  = POSIXct_validator(x[, .(datetime_)] )
		#v4  = hhmm_validator(x[, .(released_time)] )
		#v5  = is.element_validator(x[ , .(sex)], v = data.table(variable = "sex", set = list(c("M", "F"))  ))
		#v6  = interval_validator( x[, .(measure)],  v = data.table(variable = "tarsus", lq = 10, uq = 20 ),   "Measurement out of typical range" )

		#o = list(v1, v2, v3, v4, v5, v6) %>% rbindlist
		o = list(v1) %>% rbindlist
		o[, .(rowid = paste(rowid, collapse = ",")), by = .(variable, reason)]

		}


# boostrap_table(cc)




