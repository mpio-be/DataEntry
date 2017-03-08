
shinyServer( function(input, output,session) {

  saved_session <<- FALSE


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
      #cc<<- cc

      if(nrow(cc) > 0 & !ignore_validators) {
          toastr_error( boostrap_table(cc),
            title = HTML('<p>Data entry errors. Check <q>Ignore warnings</q> to by-pass this filter and save the data as it is.<br> WRITE IN THE COMMENTS WHY DID YOU IGNORE WARNINGS!</p>') ,
            timeOut = 100000, closeButton = TRUE, position = 'top-full-width')
       }

    # db update
      if(   nrow(cc) == 0 | (nrow(cc) > 0 & ignore_validators ) ) {

        con = dbcon(user = user,  host = host)
        dbq(con, paste('USE', db) )
        saved_set = dbWriteTable(con, table, x, append = TRUE, row.names = FALSE)

        if(saved_set) {
          toastr_success( paste(nrow(x), "rows saved to database.") )
          toastr_info('Before entering a new set press Start new.')
          saved_session <<- TRUE
          }

        dbDisconnect(con)

        cat('-------')

        }

    })


   # title
    N <- reactiveValues(n = grand_n(table, db, user, host))

    output$title <- renderText({
      observe({
      input$saveButton
      N$n <- grand_n(table, db, user, host)
      })

      paste( paste(table, db, sep = '.'),  '[Total entries:', N$n, ']' )

      })



  output$table  <- renderRHandsontable({
    rhandsontable(H) %>%
      hot_cols(columnSorting = FALSE, manualColumnResize = TRUE) %>%
      hot_rows(fixedRowsTop = 1) %>%
      hot_col(col = "method", type = "dropdown", source = 0:5)

   })

   output$column_comments <- renderTable({
      comments
  })



  })

