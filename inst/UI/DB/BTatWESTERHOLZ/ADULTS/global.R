
 # my_remote2local('FIELD_BTatWESTERHOLZ', 'ADULTS', 'mihai')
# shiny::runApp('inst/UI/DB/BTatWESTERHOLZ/ADULTS')

# settings
  sapply(c('sdb','shiny','shinyjs','rhandsontable','miniUI','shinyBS','shinytoastr','knitr', 'DataEntry'),
    require, character.only = TRUE, quietly = TRUE)

  user          = 'bt'
  host          = 'localhost'
  db            = 'FIELD_BTatWESTERHOLZ'
  table         =  'ADULTS'
  n_empty_lines = 5

# data
  H = dbq(user = user, host = host, q = paste0('SELECT * from ', db, '.', table, ' limit 1') )[-1]
  H[, ad_pk := NULL]
  H = rbind(H, data.table(box = rep(NA,n_empty_lines)), fill = TRUE)
  H[, box := as.integer(box)]

  comments = comments = column_comment(table, db, user, host )[COLUMN_NAME %in% names(H)]


  # validators
  measures = dbq(user = user, host = host, q = 'select tarsus, weight, P3 from BTatWESTERHOLZ.ADULTS')
  measures = melt(measures)[!is.na(value)]
  measures = measures[, .(lq = quantile(value, 0.005), uq = quantile(value, 0.995)), by = variable]

  nchar = data.table(variable = c('ID', 'UL', 'LL', 'UR', 'LR', 'transponder', 'age', 'sex'), n = c(7, 1, 1, 1, 1, 6, 1, 1) )

# functions
  inspector <- function(x) {

    # always mandatory
    i1 = is.na_validator(x[, .(date_time_caught, author)])[, reason := 'mandatory']

    # mandatory on first recapture
    i2 = is.na_validator(x[is.na(recapture), .(age,tarsus,weight,P3,transponder)])[, reason := 'mandatory on first recapture']

    # datetime
    i3 = POSIXct_validator(x[ , .(date_time_caught)])[, reason := 'date-time wrong, in the future or older than a week']

    # time
    i4 = hhmm_validator(x[ , .(handling_start,handling_stop,release_time)])[, reason := 'invalid time']

    # morphometrics
    i5 = interval_validator(x[ , .(tarsus,P3, weight)], measures)[, reason := 'unusually small or large measure']

    # n chars
    i6 = nchar_validator(x[ , .(ID,UL,LL,UR,LR,transponder,age,sex)], nchar)[, reason := 'incorrect length']


    o = list(i1, i2, i3, i4, i5, i6) %>% rbindlist
    o[, .(rowid = paste(rowid, collapse = ',')), by = .(variable, reason)]

    }

