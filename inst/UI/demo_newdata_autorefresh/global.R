
 # shiny::runApp('inst/UI/demo_newdata_autorefresh', launch.browser =  TRUE)
  sapply(c('DataEntry', 'sdb', 'data.table','rhandsontable','shinyBS','shinytoastr','knitr'),
    require, character.only = TRUE, quietly = TRUE)

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




