
 # shiny::runApp('inst/UI/test/')

# settings
  sapply(c('sdb','shiny','shinyjs','rhandsontable','miniUI','shinyBS','shinytoastr','knitr', 'DataEntry'),
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



# inspector [ runs on the handsontable output]
  inspector <- function(x) {

    v1 = is.na_validator(x[, .(datetime_, author, nest)])
    v2 = POSIXct_validator(x[ , .(datetime_)] )
    v3 = is.element_validator(x[ , .(author)], 
         v = data.table(variable = 'author', set = list( c('AI', 'AA', 'XY') ) ))
    v4 = interval_validator( x[, .(measure)], 
         v = data.table(variable = 'measure', lq = 1, uq = 10 ) )
    

    o = list(v1, v2, v3, v4) %>% rbindlist
    o[, .(rowid = paste(rowid, collapse = ',')), by = .(variable, reason)]
    }


