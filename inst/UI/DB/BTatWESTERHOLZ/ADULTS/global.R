
 #my_remote2local('FIELD_BTatWESTERHOLZ',  remoteUser = 'mihai', localUser = 'mihai')
# shiny::runApp('inst/UI/DB/BTatWESTERHOLZ/ADULTS')

# settings
  sapply(c('sdb','shiny','shinyjs','rhandsontable','miniUI','shinyBS','shinytoastr','knitr', 'DataEntry'),
    require, character.only = TRUE, quietly = TRUE)

  user          = 'bt'
  host          = '127.0.0.1'
  db            = 'FIELD_BTatWESTERHOLZ'
  table         =  'ADULTS'
  n_empty_lines = 20
  excludeColumns = 'ad_pk'

# data
  H = emptyFrame(user, host, db, table, n = 10, excludeColumns, 
        preFilled = list(
            date_time_caught = as.character(Sys.Date()) ) 
        )
  comments = column_comment(user, host, db, table,excludeColumns)



  # validator parameters
  measures = dbq(user = user, host = host, q = 'select tarsus, weight, P3 from BTatWESTERHOLZ.ADULTS')
  measures = melt(measures)[!is.na(value)]
  measures = measures[, .(lq = quantile(value, 0.005), uq = quantile(value, 0.995)), by = variable]
  nchar = data.table(variable = c('ID', 'UL', 'LL', 'UR', 'LR', 'transponder', 'age', 'sex'), n = c(7, 1, 1, 1, 1, 6, 1, 1) )

# inspector
  inspector <- function(x) {

    i1 = is.na_validator(x[, .(date_time_caught, author)])
    i2 = is.na_validator(x[is.na(recapture), .(age,tarsus,weight,P3,transponder)])[, reason := 'mandatory on first recapture']
    i3 = POSIXct_validator(x[ , .(date_time_caught)])
    i4 = hhmm_validator(x[ , .(handling_start,handling_stop,release_time)])
    i5 = interval_validator(x[ , .(tarsus,P3, weight)], measures)
    i6 = nchar_validator(x[ , .(ID,UL,LL,UR,LR,transponder,age,sex)], nchar)


    o = list(i1, i2, i3, i4, i5, i6) %>% rbindlist
    o[, .(rowid = paste(rowid, collapse = ',')), by = .(variable, reason)]

    }

