#' is.na_validator
#' @param x  a data.table
#' @export
#' @examples
#' x = data.table(v1 = c(1,2, NA, NA), v2  = c(1,2, NA, NA) )
#' is.na_validator(x)
is.na_validator <- function(x) {
    x[, id := 1:.N]
    o = melt(x, id.vars = 'id')
    o[, .(rowid = which(is.na(value)) ), by = variable]
    }

#' POSIXct_validator
#' @param x  a data.table
#' @export
#' @examples
#' x = data.table(v1 = c(NA, '2016-11-23 10:23:00', as.character(Sys.time() - 3600*24*10 )  ),
#'                v2 = c('2016-11-23 25:23', '2016-11-23 30:80', as.character(Sys.time() + 100000)  ) )
#' POSIXct_validator(x)

POSIXct_validator <- function(x) {
    regexp = '(\\d{2}|\\d{4})(?:\\-)?([0]{1}\\d{1}|[1]{1}[0-2]{1})(?:\\-)?([0-2]{1}\\d{1}|[3]{1}[0-1]{1})(?:\\s)?([0-1]{1}\\d{1}|[2]{1}[0-3]{1})(?::)?([0-5]{1}\\d{1})' # mysql datetime
    x[, id:= 1:.N]
    o = melt(x, id.vars = 'id')
    o = o[, v := str_detect(value , regexp) , by = variable]
    o[(v) & as.POSIXct(value) > Sys.time() , v:= FALSE ]             # future date
    o[(v) & as.POSIXct(value) < Sys.time() - 3600*24*7 , v:= FALSE ] # more than a week ago
    o[, .(rowid = which(!v) ), by = variable]
    }


#' HH:MM validator
#' @param x  a data.table
#' @export
#' @examples
#' x = data.table(v1 = c('02:04' , '16:56', '23:59'  ), v2 = c('24:04' , NA, '23:59'  ) )
#' hhmm_validator(x)

hhmm_validator <- function(x) {
    regexp = '^([0-1][0-9]|[2][0-3]):([0-5][0-9])$' # HH:MM
    x[, id:= 1:.N]
    o = melt(x, id.vars = 'id')
    o = o[, v := str_detect(value , regexp) , by = variable]
    o[, .(rowid = which(!v) ), by = variable]
    }


#' interval (lower, upper)
#' @param x  a data.table
#' @param v  a data.table with variable, lq, uq columns
#' @export
#' @examples
#' x = data.table(v1 = runif(5)  , v2 = runif(5) )
#' v = data.table(variable = c('v1', 'v2'), lq = c(-1, 0.2), uq = c(.7, 0.5) )
#' interval_validator(x)

interval_validator <- function(x, v) {

    x[, id:= 1:.N]
    o = melt(x, id.vars = 'id')
    o = merge(o, v, by = 'variable')
    o = o[, v := value >= lq & value <= uq , by = variable]

    o[, .(rowid = which(!v) ), by = variable]
    }

#' N char
#' @param x  a data.table
#' @param v  a data.table with variable and N (n char)
#' @export
#' @examples
#' x = data.table(v1 = c('x', 'xy', 'x')  , v2 = c('xx', 'x', 'xxx')  )
#' v = data.table(variable = c('v1', 'v2'), n = c(1, 2) )
#' interval_validator(x)
nchar_validator <- function(x, v) {

    x[, id:= 1:.N]
    o = melt(x, id.vars = 'id')
    o = merge(o, v, by = 'variable')
    o = o[, v := nchar(value) == n  , by = variable]

    o[, .(rowid = which(!v) ), by = variable]
    }


