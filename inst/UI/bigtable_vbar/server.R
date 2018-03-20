
function(input, output,session) {

  observe( on.exit( assign('input', reactiveValuesToList(input) , envir = .GlobalEnv)) )


  Save <- eventReactive(input$saveButton, {

    return(hot_to_r(input$table))

   })

  output$run_save <- renderUI({
    x = Save() %>% data.table
    
    cleaner(x)

    isolate(ignore_validators <- input$ignore_checks )

    # inspector
      cc = data.table(info = 'this demo has no validators')

      if(nrow(cc) > 0 & !ignore_validators) {
          toastr_error( boostrap_table(cc),
            title = HTML('<p>Data entry errors. Check <q>No validation!</q> to by-pass this filter and save the data as it is. Write in the comments why did you ignore warnings!</p>') ,
            timeOut = 1000000, closeButton = TRUE, position = 'top-full-width')
       }

    # db update
      if(   nrow(cc) == 0 | (nrow(cc) > 0 & ignore_validators ) ) {


        saved_set = TRUE

        if(saved_set) {
          toastr_success( paste(nrow(x), "rows could be saved to database.") )
          toastr_warning('Refreshing in 2 secs ...', progressBar = TRUE, timeOut = 2000) 
          Sys.sleep(2)
          shinyjs::js$refresh()
        
          }



        cat('-------')

        }

    })


  # ---------------------------------------------------------------------------------------

  # HOT table
  output$table  <- renderRHandsontable({
    rhandsontable(H) %>%
      hot_cols(columnSorting = FALSE, manualColumnResize = TRUE, halign = 'htCenter' ) %>%
      hot_rows(fixedRowsTop = 1) 

    })

  # MODALS
  # column definitions
  output$column_comments <- renderTable({
      comments
  })

  # DATA summary
  getDataSummary <- eventReactive(input$tableInfoButton, {
    table_smry()
   })
  output$data_summary <- renderTable({
    getDataSummary()
    })

  # CHEATSHEET
  output$cheatsheet_show <- renderUI({
      includeMarkdown(system.file('cheatsheet.md', package = "DataEntry"))
    })


 }

