
# require(sdb)
# my_remote2local('SNBatWESTERHOLZ', 'file_status', 'mihai')
# runApp('inst/UI/DB/SNBatWESTERHOLZ/file_status')

# dbWriteTable(con, 'file_status', data.table(id = NA, author = NA, box = 1:10, datetime_ = rep(Sys.Date() %>% as.character, 5), bat_status = NA, firmware_status = NA), append =TRUE, row.names = FALSE)

# settings
  sapply(c('sdb', 'SNB','shiny','shinyjs','shinydashboard','miniUI','shinyBS','shinytoastr','knitr', 'DataEntry'),
  require, character.only = TRUE, quietly = TRUE)

  host   = '127.0.0.1'
  user   = getOption('DB_user')
  db     =  getOption('snbDB')
  table  = 'file_status'


# data
 comments = column_comment(user, host, db, table)



# validators
  hhmm = data.table(variable = c('hour', 'min'), lq = c(0, 0), uq = c(23, 59) )


# Functions

  get_table_for_data_entry <- function() {

    con   = dbcon(user = user, host = host)
    on.exit(dbDisconnect(con))

    dbq(con, paste('USE', db) )

    d     = dbq(con, 'SELECT id, NULL as author, box, datetime_, bat_status, firmware_status
                          FROM file_status
                              WHERE path  NOT REGEXP BINARY "CF/"  and
                                time_to_sec(datetime_) = 0 and
                                year(datetime_) = year(NOW() )
                                    ORDER BY box'  )

   if(is.null(d))
      d = data.table(note = 'There are no new data!') else {
        d[, datetime_ := as.POSIXct(datetime_)]
        d[, `:=`(day             = as.integer(format(datetime_, "%d")),
                 month           = month(datetime_),
                 year            = year(datetime_),
                 hour            = as.integer(NA),
                 min             = as.integer(NA),
                 author          = as.character(author),
                 bat_status      = as.integer(bat_status),
                 firmware_status = as.integer(firmware_status),
                 box             = as.integer(box),
                 id              = as.integer(id),
                 datetime_       = NULL ) ]

        setcolorder(d, c('box', 'author', 'hour', 'min', 'bat_status', 'firmware_status','day', 'month', 'year', 'id'))
        }

    d

   }

  update_table_from_user_input <- function(d) {

    con   = dbcon(user, host = host)
    on.exit(dbDisconnect(con))
    dbq(con, paste('USE', db) )

    # d[, `:=`(author = sample(letters, nrow(d), T), hour = sample(1:23,nrow(d), T), min = sample(0:59,nrow(d), T)  )   ]
    d[, datetime_ := ISOdatetime(year, month, day, hour, min, sec = 0), ]
    d = d[ !is.na(datetime_), .(id, author, datetime_, bat_status, firmware_status)]

    dbq(con, "DROP  TABLE IF EXISTS temp")
    dbq(con, "CREATE  TABLE temp (id INT, author VARCHAR(4), datetime_ DATETIME, bat_status TINYINT, firmware_status TINYINT)")

    res = dbWriteTable(con, "temp", d,  row.names = FALSE, append = TRUE)
    o = dbq(con, 'UPDATE file_status f, temp t
                SET f.author = t.author,
                f.datetime_ = t.datetime_,
                f.bat_status = t.bat_status,
                f.firmware_status = t.firmware_status
                  WHERE f.id = t.id')

    dbq(con, "DROP  TABLE IF EXISTS temp")

    res

   }

  inspector <- function(x) {

    # hh mm
    i1 = interval_validator(x[, .(hour, min)], hhmm)[, reason := 'incorect value']


    o = list(i1) %>% rbindlist
    o[, .(rowid = paste(rowid, collapse = ',')), by = .(variable, reason)]

    }


