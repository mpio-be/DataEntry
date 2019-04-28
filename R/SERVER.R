
#' @export
server_dbupdate <- function(input, output,session) {


  observe( on.exit( assign('input', reactiveValuesToList(input) , envir = .GlobalEnv)) )


  observeEvent(input$refresh, {
		shinyjs::js$refresh()
	  })

  Save <- eventReactive(input$saveButton, {
	o = hot_to_r(input$table) %>% data.table
	class(o) = c(class(o), tableName)
	o
   })

  output$run_save <- renderUI({
	x = Save() 
	
	if(debug) on.exit( assign('x', x , envir = .GlobalEnv))

	cleaner(x)

	isolate(ignore_validators <- input$ignore_checks )

	# inspector
	  cc = inspector(x)
	  if(debug) on.exit( assign('cc', cc , envir = .GlobalEnv))

	  if(nrow(cc) > 0 & !ignore_validators) {
		  toastr_error( boostrap_table(cc),
			title = HTML('<p>Data entry errors. Check <q>Ignore warnings</q> to by-pass this filter and save the data as it is.<br> Write in the comments why did you ignore warnings!</p>') ,
			timeOut = 100000, closeButton = TRUE, position = 'top-full-width')
	   }

	# db update
	  if(   nrow(cc) == 0 | (nrow(cc) > 0 & ignore_validators ) ) {

	  con =  dbConnect(RMySQL::MySQL(), host = host, user = user, db = db, password = pwd)
	
	  saved_set = dbWriteTable(con, tableName, x, append = TRUE, row.names = FALSE)
	  
	  dbDisconnect(con)


	  if(saved_set) {
		toggleState(id = "saveButton")

		toastr_success( paste(nrow(x), "rows saved to database.") )
		toastr_warning('Refreshing in 5 secs ...', progressBar = TRUE, timeOut = 5000) 
		Sys.sleep(5)

		shinyjs::js$refresh()

		}


		cat('-------')

		}

	})


  # HOT TABLE
  output$table  <- renderRHandsontable({
	  uitable
	})


  # MODALS
  # column definitions
  output$column_comments <- renderTable({
	  comments
  })

  # DATA summary
  getDataSummary <- eventReactive(input$tableInfoButton, {
	describeTable()
   })
  output$data_summary <- renderTable({
	getDataSummary()
	})

  # CHEATSHEET
  output$cheatsheet_show <- renderUI({
	  includeMarkdown(system.file('cheatsheet.md', package = "DataEntry"))
	})



 }


