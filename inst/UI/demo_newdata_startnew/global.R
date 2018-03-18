
 # shiny::runApp('inst/UI/demo_newdata_startnew')
  sapply(c('sdb', 'data.table','shiny','shinyjs','rhandsontable','miniUI','shinyBS','shinytoastr','knitr', 'DataEntry'),
    require, character.only = TRUE, quietly = TRUE)

  user           = 'mihai'
  host           = '127.0.0.1'
  db             = 'test'
  table          =  'test_tbl'
  excludeColumns = c('pk', 'notShow')
  
  H = emptyFrame(user, host, db, table, n = 10, excludeColumns, 
        preFilled = list(
            datetime_ = as.character(Sys.Date()), author = 'AI') 
        )
  
  comments = column_comment(user, host, db, table,excludeColumns)




