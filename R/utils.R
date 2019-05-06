#' @name strp_date_or_time
#' @title strp datetime or time (Mysql compatible)
#' @param x  strip datetime or date
#' @export
#' @examples
#' x = c(Sys.Date() %>% as.character, Sys.time()%>% as.character )
#' strp_date_or_time(x)

strp_date_or_time <- function(x) {
 s1 = strptime(x, "%Y-%m-%d %H:%M")
 s2 = strptime(x, "%Y-%m-%d")
 o = data.frame(s1, s2)

 o[is.na(o$s1), 's1'] = o[is.na(o$s1), 's2']
 
 as.POSIXct(o$s1)

}



#' @name meltall
#' @title melt all columns in a data.table
#' @param x  a data.table
#' @param na.rm  TRUE by default
#' @export
meltall <- function(x, na.rm = TRUE) {
	x[, rowid := .I]
	
	suppressWarnings(data.table::melt(x, id.vars = 'rowid', variable.factor = FALSE, value.factor = FALSE, na.rm = na.rm))
	
	}


#' @name char2vec
#' @title convert a list of strings to a vector
#' @param x list
#' @export
char2vec <- function(x) {
		lapply(x, function(i) eval(parse(text = paste('c(',i , ')')) ) ) %>% 
		unlist %>% 
		unique 
	}


#' @name praise
#' @title praises
#' @note see praise package
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
    "Keep trying!",
    "Don't worry, you'll get it.",
    "No one is perfect!",
    "Frustration is a natural part of data entry.",
    "Hang in there and try again.",
    "Don't give up.",
    "Keep pushing.",
    "Keep fighting!",
    "Stay strong.",
    "Never give up.",
    "Never say 'die'.",
    "Come on! You can do it!."
  )

  sample(x, 1)
}