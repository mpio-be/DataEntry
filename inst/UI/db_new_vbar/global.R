# ==========================================================================
# UI with a vertical navigation bar to enter new data in db table 
# shiny::runApp('inst/UI/db_new_vbar', launch.browser =  TRUE)
# ==========================================================================


  sapply(c('DataEntry', 'sdb', 'shinyBS'),require, character.only = TRUE, quietly = TRUE)

  user           = 'mihai'
  host           = '127.0.0.1'
  db             = 'test'
  tableName      =  'test_tbl'
  excludeColumns = c('pk', 'notShow')
  
  H = emptyFrame(user, host, db, tableName, n = 10, excludeColumns, 
        preFilled = list(
            datetime_ = as.character(Sys.Date()), author = 'AI') 
        )

  comments = column_comment(user, host, db, tableName,excludeColumns)

  sqlInspector = paste('select script from validators where table_name =', shQuote(tableName))

  table_smry <- function() {
    data.frame(x = 'function applied on the table', y = 'returning meaningful summaries')
  }
