

#' Cleans a data table
#' Removes NA rows, replaces 'NA' with NA
#' @param x  a data.table
#' @export
cleaner <- function(x) {
  for(j in seq_along(x) ) { 
    data.table::set(x, i=which(x[[j]] ==  'NA'), j=j, value=NA) } 
  # o = x[rowSums( as.matrix( is.na(x) ))  != ncol(x) ]
  # return(o)
  }
