
# ==========================================================================
# UI with a vertical navigation bar to enter new data 
# shiny::runApp('./inst/UI/newData', launch.browser =  TRUE)
# ==========================================================================

# Settings
	
	sapply(c('DataEntry', 'DataEntry.validation', 'shinyjs', 'shinyWidgets', 
			'glue', 'tableHTML', 'shinytoastr'),require, character.only = TRUE, quietly = TRUE)
	tags = shiny::tags

	host    = getOption('DataEntry.host')
	db      = getOption('DataEntry.db'  )
	user    = getOption('DataEntry.user')
	pwd     = getOption('DataEntry.pwd' )

	package         = 'DataEntry'
	tableName       = 'data_entry'
	excludeColumns  = c('pk', 'nov')
	n_empty_lines   = 20
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
	
