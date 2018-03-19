
function(input, output,session) {

  observe( on.exit( assign('input', reactiveValuesToList(input) , envir = .GlobalEnv)) )


  Save <- eventReactive(input$saveButton, {

    return(hot_to_r(input$table))

   })

  output$run_save <- renderUI({
    x = Save() %>% data.table
    # x<<- x
    
    cleaner(x)


    isolate(ignore_validators <- input$ignore_checks )

    # inspector
      cc = inspector(sqlInspector, x, user, db, host)
      #cc<<- cc

      if(nrow(cc) > 0 & !ignore_validators) {
          toastr_error( boostrap_table(cc),
            title = HTML('<p>Data entry errors. Check <q>No validation!</q> to by-pass this filter and save the data as it is. Write in the comments why did you ignore warnings!</p>') ,
            timeOut = 1000000, closeButton = TRUE, position = 'top-full-width')
       }

    # db update
      if(   nrow(cc) == 0 | (nrow(cc) > 0 & ignore_validators ) ) {

        con = dbcon(user = user,  host = host)
        dbq(con, paste('USE', db) )
        
        update_ok = dbWriteTable(con, 'TEMP', x, append = TRUE, row.names = FALSE)

        if(update_ok) {
          
          dbq(con, paste('DROP TABLE', table) )
          dbq(con, paste('RENAME TABLE TEMP to', table) )

          toastr_success('Table updated successfully.')


          }

        dbDisconnect(con)

        cat('-------')

        }

    })


  output$table  <- renderRHandsontable({
    
    H = dbq(q = paste('SELECT * FROM', table), user = user, host = host, db = db)
       
    rhandsontable(H) %>%
      hot_cols(columnSorting = FALSE, manualColumnResize = TRUE) %>%
       hot_col(col = "sex",     type = "dropdown", source = c('male',  'female') ) %>%
       hot_rows(fixedRowsTop = 1)
    
    })


  # MODALS
  # column definitions
  output$column_comments <- renderTable({
      comments
  })

 
  getDataSummary <- eventReactive(input$tableInfoButton, {

    table_smry()

   })

  output$data_summary <- renderTable({

      getDataSummary()

      })


 }

