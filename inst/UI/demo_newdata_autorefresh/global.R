
# shiny::runApp('inst/UI/demo_newdata_autorefresh')


  sapply(c('sdb','shiny','shinyjs','rhandsontable','shinytoastr', 'shinydashboard' ,'knitr', 'DataEntry'),
    require, character.only = TRUE, quietly = TRUE)

  tags = shiny::tags

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



