 # source('inst/UI/test/.testdb.R')
 # shiny::runApp('inst/UI/test/')

# settings
  sapply(c('sdb','shiny','shinyjs','rhandsontable','miniUI','shinyBS','shinytoastr','knitr', 'DataEntry'),
    require, character.only = TRUE, quietly = TRUE)

  user           = 'mihai'
  host           = '127.0.0.1'
  db             = 'test'
  table          =  'test_tbl'
  excludeColumns = c('pk', 'notShow')
  sqlInspector   = 'select script from validators where table_name = "test_tbl"'


  H = emptyFrame(user, host, db, table, n = 10, excludeColumns, 
        preFilled = list(
            datetime_ = as.character(Sys.Date()), author = 'AI') 
        )
  comments = column_comment(user, host, db, table,excludeColumns)





