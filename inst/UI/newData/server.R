
# DataEntry::server_newData

function(input, output,session) {


    observe( on.exit( assign('input', reactiveValuesToList(input) , envir = .GlobalEnv)) )

    con =  dbConnect(RMySQL::MySQL(), host = host, user = user, db = db, password = pwd)
    onStop(function() {dbDisconnect(con)})

    # Is no-validation column present in table ?
    hasnov = dbGetQuery(con, glue::glue("SHOW COLUMNS FROM {tableName} LIKE 'nov';") ) %>% 
            nrow %>% 
            magrittr::is_greater_than(0)



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
    cleaner(x)

    

    isolate(ignore_validators <- input$ignore_checks )

    # inspector
      cc = inspector(x)


    assign('cc', cc , envir = .GlobalEnv)


    # ignored validation
      if(nrow(cc) > 0 & !ignore_validators) {
          toastr_error( message = HTML( glue('<p> {encourage()} <br/> Click the button </p>'  ) ) ,
            title = HTML('<p> Data entry errors 😢 </p>') ,
           timeOut = 10000, closeButton = TRUE, position = 'top-center')

       }

    # db update
      if(   nrow(cc) == 0 | (nrow(cc) > 0 & ignore_validators ) ) {

        # add no-validation info to table
        if(hasnov) {
            x = copy(x)
            x[, nov := as.integer(0)]
            x[char2vec(cc$rowid)%>% as.integer, nov := 1L]


            }

        assign('x', x , envir = .GlobalEnv)

        saved_set = dbWriteTable(con, tableName, x, append = TRUE, row.names = FALSE)


        if(saved_set) {
  
        toggleState(id = "saveButton")

        toastr_success(title = glue("<h2> {praise()} </h2>")  , 
        	message = glue( "<p>{nrow(x)} rows saved to database.</p><br/>
        			<i> Refreshing in progress ... </i>") , timeOut = 10000, 
        	position = 'top-center', 
        	progressBar = TRUE)
        

        Sys.sleep(10)


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


