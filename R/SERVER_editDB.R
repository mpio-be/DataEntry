
#' Shiny server function
#'
#' @param input     Shiny server
#' @param output    Shiny server
#' @param session   Shiny server
#'
#' @export
#' @note package, uitable, comments, describeTable, getDataSummary are hardwired and should be defined in global.R
#'       inspectors are loaded with  [DataEntry.validation::inspector_loader()]
#'

server_editDB_inPlace <- function(input, output, session) {
  

  getDBtable <- function() {
    con  = dbConnect(RMySQL::MySQL(), host = host, user = user, db = db, password = pwd)
    dat = dbReadTable(con, tableName)
    dbDisconnect(con)

    empty_rows = as.data.frame(matrix(NA, ncol = ncol(dat), nrow = 10))
    names(empty_rows) = names(dat)
    dat = rbind(dat, empty_rows)

    dat
  }
  

  rv_data = reactiveVal(getDBtable())
  

  output$table <- renderRHandsontable({
    req(rv_data())
    rhandsontable(rv_data(), rowHeaders = TRUE)
  })
  

  observeEvent(input$saveButton, {

    editedData = hot_to_r(input$table)
    editedData = editedData[!apply(editedData, 1, function(x) all(is.na(x) | x == "")), ]
    
    
    bk_path = save_backup(editedData, tableName)

    con <- dbConnect(RMySQL::MySQL(), host = host, user = user, db = db, password = pwd)
    tableSaved = dbWriteTable(con, tableName, editedData, overwrite = TRUE, row.names = FALSE)
    dbDisconnect(con)
    

    rv_data(editedData)
    
    if (tableSaved) {
      rv_data(getDBtable())

      toastr_success(
        title = "",
        message = paste("Table saved successfully. Backup stored as", basename(bk_path)),
        timeOut = 5000,
        position = "top-center"
      )
    }
    
  })
  

  observeEvent(input$helpButton, {
    showModal(modalDialog(
      tableHTML(comments, rownames = FALSE, collapse = "separate_shiny") |>
        add_css_table(css = list("font-size", "1.2vw")) |>  
        add_theme('rshiny-blue'),
      title = "Columns definition:",
      easyClose = TRUE, 
      footer = NULL, 
      size = 'l'
    ))
  })
  
  observeEvent(input$tableInfoButton, {
    showModal(modalDialog(
      tableHTML(describeTable(), rownames = FALSE, collapse = "separate_shiny") |>
        add_css_table(css = list("font-size", "1.2vw")) |>  
        add_theme('rshiny-blue'),
      title = "Data summary:",
      easyClose = TRUE,
      footer = NULL, 
      size = 'l'
    ))
  })
  
  observeEvent(input$cheatsheetButton, {
    showModal(modalDialog(
      title = "Data entry shortcuts:",
      includeMarkdown(system.file('cheatsheet.md', package = "DataEntry")),
      easyClose = TRUE,
      footer = NULL, 
      size = 'l'
    ))
  })
  
  observe( on.exit( assign('input', reactiveValuesToList(input) , envir = .GlobalEnv)) )

  session$allowReconnect(TRUE)
}
