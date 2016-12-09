
shinyServer( function(input, output,session) {

  saved_session <<- FALSE

  N <- reactiveValues(n = 0)

  observeEvent(input$refresh, {
        shinyjs::js$refresh()
      })

  Save <- eventReactive(input$saveButton, {

    return(hot_to_r(input$table))

   })

  output$run_save <- renderUI({
    x = Save() %>% data.table
    x = cleaner(x)
    x<<- x

    isolate(ignore_validators <- input$ignore_checks )

    if(saved_session) {
      msg = 'This set was already saved to the database. Press Start New to enter another set.'
      toastr_error(msg)
      stop(msg)
    }

    # inspector
      cc = inspector(x)


      if(nrow(cc) > 0 & !ignore_validators) {
          toastr_error( boostrap_table(cc),
            title = HTML('<p>Data entry errors. Check <q>Ignore warnings</q> to by-pass this filter and save the data as it is.<br> </p>') ,
            timeOut = 100000, closeButton = TRUE, position = 'top-full-width')
       }

    # db update
      if(   nrow(cc) == 0 | (nrow(cc) > 0 & ignore_validators ) ) {

        saved_set = update_table_from_user_input(x)

        if(saved_set) {
          nSaved = nrow(x[!is.na(hour)])
          toastr_success( paste(nSaved, "rows saved to database.") )
          toastr_info('Before entering a new set press Start new.')

          N$n <- nSaved

          saved_session <<- TRUE
          }

            cat('-------')

        }

    })



    output$title <- renderText({
      paste( paste(table, db, sep = '.'),  '[Total entries updated:', N$n, ']' )

      })



  output$table  <- renderRHandsontable({
    H = get_table_for_data_entry()
    rhandsontable(H) %>%
    hot_cols(columnSorting = FALSE) %>%
    hot_rows(fixedRowsTop = 1) # TODO change editable cols
   })

   output$column_comments <- renderTable({
      comments
  })



  })

