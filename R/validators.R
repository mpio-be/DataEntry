# ==========================================================================
# Generic validators.
# ==========================================================================

#' @name          validators
#' @title         data validators
#' @param x       a data.table whose entries needs to be validated.
#' @param v       a data.table containing the validation rules. See notes.
#' @param reason  explain why it did not pass the validation.
#' @description   all validators (except is.na_validator) ignore NA entries.
#' @return        a data.table with two columns: variable (the names of the columns in x) 
#'                and rowid (the position of offending (i.e. not validated) entries).
NULL

#' @rdname validators
#' @name   is.na_validator
#' @export
#' @examples
#' #----------------------------------------------------#
#' x = data.table(v1 = c(1,2, NA, NA), v2  = c(1,2, NA, NA) )
#' is.na_validator(x)
is.na_validator <- function(x, reason = 'mandatory') {
		

	o = meltall(x, FALSE)
	o = o[is.na(value), .(rowid, variable)]
	o[, reason := reason]
	o
	}

#' @rdname validators
#' @name   POSIXct_validator
#' @export
#' @examples
#' #----------------------------------------------------#
#' t = Sys.time(); d = Sys.Date()
#' x = data.table(
#'  v1 = c(NA, as.character(d-1), as.character(t - 3600*24*10 )  ) ,
#'  v2 = c('2016-11-23 25:23', as.character(t -100) ,as.character(t+100)))
#' POSIXct_validator(x)
#' 
#' x = data.table(zz =  c( as.character(d -1), as.character(d ) )  )
#' POSIXct_validator(x)
#' 
#' 
POSIXct_validator <- function(x, reason = 'date-time wrong, in the future or older than a week') {
	o = meltall(x)

	o[, datetime_ := strp_date_or_time(value) ]

	o[, v := TRUE] # we are optimistic
	o[ !is.na(value) & is.na(datetime_), v := FALSE]
	o[ datetime_ > as.POSIXct(Sys.Date()+1) , v := FALSE]  # do not allow future dates
	o[ datetime_ < Sys.time() - 3600*24*7 , v:= FALSE ] # more than a week ago

	o = o[ (!v) , .(rowid, variable)]
	o[, reason := reason]
	o
	
	}

#' @rdname  validators
#' @name    hhmm_validator
#' @export
#' @examples
#'  #----------------------------------------------------#
#' x = data.table(v1 = c('02:04' , '16:56', '23:59'  ),
#'  v2 = c('24:04' , NA, '23:59'  ) )
#' hhmm_validator(x)

hhmm_validator <- function(x, reason = 'invalid time') {
	regexp = '^([0-1][0-9]|[2][0-3]):([0-5][0-9])$' # HH:MM
	o = meltall(x)
	o = o[, v := str_detect(value , regexp) , by = variable]
	
	o = o[ (!v) , .(rowid, variable)]
	o[, reason := reason]
	o
	}

#' @rdname  validators
#' @name    datetime_validator
#' @export
#' @examples
#'  #----------------------------------------------------#
#' x = data.table(v1 = c('2017-01-21 02:04' , '2012-04-21 16:56', '2017-05-21 23:59'  ),
#'                v2 = c('2017-07-27 00:00' , '2017-01-21', '2015-01-09 23:59'  ) )
#' datetime_validator(x)

datetime_validator <- function(x, reason = 'invalid datetime_ - should be: yyyy-mm-dd hh:mm') {
	regexp = '^\\d\\d\\d\\d-(0?[1-9]|1[0-2])-(0?[1-9]|[12][0-9]|3[01]) ([0-1][0-9]|[2][0-3]):([0-5][0-9])$' # YYYY-MM-DD hh:mm
	o = meltall(x)
	o = o[, v := str_detect(value , regexp) , by = variable]
	
	o = o[ (!v) , .(rowid, variable)]
	o[, reason := reason]
	o
}

#' @rdname  validators
#' @name    time_order_validator
#' @param time1  start time to compare
#' @param time2  end time to compare
#' @param time_max maximal time that is passing validation
#' @export
#' @examples
#'  #----------------------------------------------------#
#' x = data.table(cap_time = c('10:04' , '16:40', '01:55'),
#'                bleeding_time = c('10:10' , '16:30', '04:08'))
#' t = time_order_validator(x, time1 = 'cap_time', time2 = 'bleeding_time', time_max = 60)

time_order_validator <- function(x, time1, time2, time_max, reason = 'invalid time order or bird hold for more than max time set') {
	

	o = x[, c(time1, time2), with = FALSE]
	setnames(o, c('time1', 'time2'))
	o[, rowid := .I]
	
	fff = function(t1, format, t2) {
		ifelse(difftime(strptime(t1, format = "%H:%M"), strptime(t2, format = "%H:%M"), units = 'mins') >= 0
					 | difftime(strptime(t1, format = "%H:%M"), strptime(t2, format = "%H:%M"), units = 'mins') < -1 * time_max
					 , FALSE, TRUE)
	}
	
	o[, v := fff(time1, format, time2), by =  .(rowid)] 
	
	o = o[ (!v) , .(rowid)]
	o[, variable := time1]
	o[, reason := reason]
	o
	
}


#' @rdname   validators
#' @name     interval_validator
#' @note     `v` for interval_validator: a data.table with variable, lq, uq columns
#' @export
#' @examples
#'  #----------------------------------------------------#
#' x = data.table(v1 = runif(5)  , v2 = runif(5) )
#' v = data.table(variable = c('v1', 'v2'), lq = c(-1, 0.2), uq = c(.7, 0.5) )
#' interval_validator(x,v)
#'  #-----------------------#
#'  x = data.table(box = c(0, 1, 100, 300))
#'  v = data.table(variable = 'box', lq = 1, uq = 277 )
#' interval_validator(x,v)

interval_validator <- function(x, v, reason = 'unusually small or large measure') {

	o = meltall(x)
	o = merge(o, v, by = 'variable', sort = FALSE)
	
	o[, v := value >= lq & value <= uq ]

	o = o[ (!v) , .(rowid, variable)]
	o[, reason := reason]
	o
	}

#' @rdname   validators
#' @name     nchar_validator
#' @note     `v`  for nchar_validator: a data.table with variable and n (number of characters)
#' @export
#' @examples
#'  #----------------------------------------------------#
#' x = data.table(v1 = c('x', 'xy', 'x')  , v2 = c('xx', 'x', 'xxx')  )
#' v = data.table(variable = c('v1', 'v2'), n = c(1, 2) )
#' nchar_validator(x, v)
nchar_validator <- function(x, v, reason = 'incorrect number of characters') {
	o = meltall(x)
	o = merge(o, v, by = 'variable', sort = FALSE)
	
	o[, v := nchar(value) == n, by = .(rowid, variable)]

	o = o[ (!v) , .(rowid, variable)]
	o[, reason := reason]
	o
	}

#' @rdname    validators
#' @name      is.element_validator 
#' @note      `v`   for is.element_validator: a data.table with variable and set (a vector of lists containing the valid elements for each variable )
#' @export
#' @examples
#'  #----------------------------------------------------#
#' x = data.table(v1 = c('A', 'B', 'C')  , v2 = c('ZZ', 'YY', 'QQ')  )
#' v = data.table(variable = c('v1', 'v2'), 
#'                set = c( list( c('A', 'C') ), list( c('YY')  )) )
#' is.element_validator(x, v)

is.element_validator <- function(x, v, reason = 'invalid entry') {
	o = meltall(x)
	o = merge(o, v, by = 'variable', sort = FALSE)

	o[, v := is.element(value, unlist(set) )  , by =  .(rowid, variable) ]
	
	o = o[ (!v) , .(rowid, variable)]
	o[, reason := reason]
	o
 }

#' @rdname    validators
#' @name      is.duplicate_validator 
#' @note      `v`  for is.duplicate_validator: a data.table with variable and set (a vector of lists containing the already existing values for each variable )
#' @export
#' @examples
#'  #----------------------------------------------------#
#' x = data.table(v1 = c('A', 'B', 'C')  , v2 = c('ZZ', 'YY', 'QQ')  )
#' v = data.table(variable = c('v1', 'v2'), 
#'                set = c( list( c('A', 'C') ), list( c('YY')  )) )
#' is.duplicate_validator(x, v)

is.duplicate_validator <- function(x, v, reason = 'duplicate entry') {
	o = meltall(x)
	o = merge(o, v, by = 'variable', sort = FALSE)

	o[, v := is.element(value, unlist(set) )  , by =  .(rowid, variable) ]

	o = o[ (v) , .(rowid, variable)]
	o[, reason := reason]
	o
	}

#' @rdname    validators
#' @name      is.identical_validator 
#' @note      `v`   for is.identical_validator: a data.table with variable and x (the value to test against)
#' @export
#' @examples
#'  #----------------------------------------------------#
#' x = data.table(v1 = 1:3  , v2 = c('a', 'b', 'c')  )
#' v = data.table(variable = c('v1', 'v2'),  x = c(1, 'd'))
#' is.identical_validator(x, v)

is.identical_validator <- function(x, v, reason = 'invalid entry') {
	o = meltall(x)
	o = merge(o, v, by = 'variable', sort = FALSE)

	o[, v := (value == x)  ]

	o = o[ (!v) , .(rowid, variable)]
	o[, reason := reason]
	o
	}


#' @rdname    validators
#' @name      combo_validator 
#' @param     validSet   for combo_validator: a vector containing the possible colours 
#' @export
#' @examples
#'  #----------------------------------------------------#
#'x = data.table(UL = c('M',    'M', ''),     
#'               UR = c('Y',    'Y', ''),
#'               LL = c('G,DB', 'G,P', ''),
#'               LR = c('R',    'G', 'NOBA'),
#'               recapture = c(1, 0, 1))
#'  combo_validator(x, validSet = 'M-G,DB|Y-R')              

combo_validator <- function(x, validSet, reason) {

	x[, rowid := .I ]
	x[is.na(x)] = ''
	o = x[, .(w = paste0(UL, '-', LL, '|', UR, '-',LR), recapture), by = rowid]

	o[recapture == 1, v := !is.element(w, validSet ), by = rowid ]
	o[recapture == 0, v := is.element(w, validSet ), by = rowid ]

	o[w %in% c(NA, 'M-|Y-COBA', 'M-|W-COBA', '-|-COBA','-|-NOBA', '-|-NOBA1', '-|-NOBA2', '-|-NOBA3'), v := FALSE]
	o = o[(v)]

	o[recapture == 0, reason  := 'Color combo does already exist in CAPTURES! Recapture?']
	o[recapture == 1, reason  := 'Color combo does not exist in CAPTURES! First capture?']

	o[, variable  := 'color combo']

	o = o[, .(rowid, variable, reason)]
	}











