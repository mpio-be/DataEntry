
# ==========================================================================
# UI with a vertical navigation bar to enter new data 
# shiny::runApp('./inst/UI/newData', launch.browser =  TRUE)
# ==========================================================================

# Settings
	
	sapply(c('DataEntry', 'DataEntry.validation', 'shinyjs', 
			'glue', 'tableHTML', 'shinytoastr'),require, character.only = TRUE, quietly = TRUE)
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
	   
	   list( 
	   	
	    x[, .(author, datetime_, ID)] 		%>% is.na_validator,
		x[recapture == 0, .(sex, measure)]  %>% is.na_validator("Mandatory at first capture"),
		x[, .(datetime_)]                   %>% POSIXct_validator ,
		x[, .(released_time)]               %>% hhmm_validator, 
		x[ , .(sex)] 						%>% is.element_validator(v = data.table(variable = "sex", 
														set = list(c("M", "F"))  )) ,
		x[, .(measure)] 					%>% interval_validator( v = data.table(variable = "measure", lq = 10, uq = 20 ),   
												"Measurement out of typical range" )

		)



		}







