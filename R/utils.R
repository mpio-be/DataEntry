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