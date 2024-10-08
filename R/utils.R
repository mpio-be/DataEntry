#' emptyFrame
#' emptyFrame used by handsontable
#' @param user             db user
#' @param host             db host
#' @param db               db name
#' @param pwd              pwd
#' @param table            db table
#' @param n                n empty lines
#' @param excludeColumns   default 'pk'
#' @param preFilled        a named list eg. list(datetime_ = as.character(Sys.Date()))
#' @param colorder         column order. see data.table::setcolorder
#' @export
#' @examples \dontrun{
#' emptyFrame(user = "testuser", pwd = "testuser", host = "127.0.0.1", db = "tests", table = "data_entry")
#' emptyFrame(
#'   user = "testuser", pwd = "testuser", host = "127.0.0.1", db = "tests", table = "data_entry",
#'   preFilled = list(datetime_ = as.character(Sys.Date()))
#' )
#' emptyFrame(
#'   user = "testuser", pwd = "testuser", host = "127.0.0.1", db = "tests", table = "data_entry",
#'   colorder = c("ID", "sex", "nest")
#' )
#' }
#'
emptyFrame <- function(user, host, db, pwd, table, n = 10, excludeColumns = "pk", preFilled, colorder) {
  con = dbConnect(RMySQL::MySQL(), host = host, user = user, password = pwd)
  on.exit(dbDisconnect(con))


  F = dbGetQuery(con, paste0("SELECT * from ", db, ".", table, " where FALSE")) |>
      data.table()

  if (!missing(excludeColumns)) {
    F = F[, setdiff(names(F), excludeColumns), with = FALSE]
  }

  if (!missing(colorder)) {
    setcolorder(F, colorder)
  }


  F = rbind(F, data.table(tempcol = rep(NA, n)), fill = TRUE)[, tempcol := NULL]

  if (!missing(preFilled)) {
    for (i in 1:length(preFilled)) {
      set(F, j = names(preFilled[i]), value = preFilled[[i]])
    }
  }

  # convert un-handled rhandsontable types to characters (RMariaDB)
  # difftime_to_char = which( F[, sapply(.SD, function(x) inherits(x, 'difftime') ) ] ) |> names()
  # F[,(difftime_to_char) := lapply(.SD, as.character), .SDcols = difftime_to_char]
  #
  # POSIXt_to_char = which( F[, sapply(.SD, function(x) inherits(x, 'POSIXt') ) ] ) |> names()
  # F[,(POSIXt_to_char) := lapply(.SD, as.character), .SDcols = POSIXt_to_char]

  F
}


#' column_comment
#' db table comments
#' @param user             db user
#' @param host             db host
#' @param db               db name
#' @param pwd              pwd
#' @param table            db table
#' @param excludeColumns   default 'pk'
#' @return a data.frame with two fields: Column and description
#' @note this is just a convenience function around a "Select .. from information_schema" query.
#' @export
column_comment <- function(user, host, db, pwd, table, excludeColumns = "pk") {
  con = dbConnect(RMySQL::MySQL(), host = host, user = user, password = pwd)
  on.exit(dbDisconnect(con))


  x = dbGetQuery(
    con,
    paste0("SELECT COLUMN_NAME `Column`, COLUMN_COMMENT description FROM  information_schema.COLUMNS
								WHERE TABLE_SCHEMA =", shQuote(db), "AND TABLE_NAME =", shQuote(table))
  ) 

  x[! x$Column %in% excludeColumns, ]
}


#' Cleans a data table
#' Removes NA rows, replaces 'NA' with NA
#' @param x  a data.table
#' @export
cleaner <- function(x) {

  for(j in seq_along(x) ) { 
    data.table::set(x, i=which(x[[j]] ==  'NA'), j=j, value=NA) } 
  
  for(j in seq_along(x) ) { 
    data.table::set(x, i=which(x[[j]] ==  ''), j=j, value=NA) } 
  
  # o = x[rowSums( as.matrix( is.na(x) ))  != ncol(x) ]
  # return(o)
  }

#' @name char2vec
#' @title convert a list of strings to a vector
#' @param x list
#' @export
char2vec <- function(x) {
  lapply(x, function(i) eval(parse(text = paste("c(", i, ")")))) |>
    unlist() |>
    unique()
}


#' @name praise
#' @title praises
#' @seealso [praise::praise()]
#' @export
praise <- function() {
  x <- c(
    praise::praise("Your data are ${adjective}!"),
    praise::praise("${EXCLAMATION} - ${adjective} data.")
  )

  sample(x, 1)
}


#' @name encourage
#' @title encourages
#' @note adapted from https://github.com/r-lib/testthat
#' @export
encourage <- function() {
  x <- c(
    "Mistakes happen dude just roll with it!", 
    "Data entry's a journey mate — enjoy the ride!", 
    "Every screw-up's a shot at leveling up dude; don't sweat it!",
    "Take a breather mate you'll crush it next time!", 
    "Just keep clicking dude; you'll find your groove!", 
    "Data entry's tricky mate!", 
    "It's all part of the process dude; stay chill!", 
    "Just a bump in the road mate; keep cruising!", 
    "Sometimes you gotta get your ass kicked to come back swinging like a boss dude!"
  )

  sample(x, 1)
}