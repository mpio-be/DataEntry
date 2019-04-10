
function(input, output,session) {

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
    # x<<- x
    cleaner(x)

    isolate(ignore_validators <- input$ignore_checks )

    # inspector
      cc = inspector(x)
      # cc<<- cc

      if(nrow(cc) > 0 & !ignore_validators) {
          toastr_error( boostrap_table(cc),
            title = HTML('<p>Data entry errors. Check <q>Ignore warnings</q> to by-pass this filter and save the data as it is.<br> Write in the comments why did you ignore warnings!</p>') ,
            timeOut = 100000, closeButton = TRUE, position = 'top-full-width')
       }

    # db update
      if(   nrow(cc) == 0 | (nrow(cc) > 0 & ignore_validators ) ) {

       con =  dbConnect(RMySQL::MySQL(), host = host, user = user, password = pwd, db = db)

        dbExecute(con, 'DROP TABLE IF EXISTS TEMP')
        update_ok = dbWriteTable(con, 'TEMP', x, append = TRUE, row.names = FALSE)

        if(update_ok) {
          
          dbExecute(con, paste('DROP TABLE', tableName) )
          dbExecute(con, paste('RENAME TABLE TEMP to', tableName) )

          toastr_success('Table updated successfully.')
          toastr_warning('Refreshing in 5 secs ...', progressBar = TRUE, timeOut = 5000) 
          Sys.sleep(5)
          
          shinyjs::js$refresh()

          }

        dbDisconnect(con)

        cat('-------')

        }
    })


  # HOT TABLE
  output$table  <- renderRHandsontable({
      
    con =  dbConnect(RMySQL::MySQL(), host = host, user = user, password = pwd, db = db)
    H = dbReadTable(con, tableName)
    dbDisconnect(con)


    uitable =  
    rhandsontable(H) %>%
        hot_cols(columnSorting = FALSE, manualColumnResize = TRUE) %>%
        hot_rows(fixedRowsTop = 1) %>%
        hot_col(col = "author", type = "dropdown", source = authors )


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


