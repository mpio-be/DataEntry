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



## undocumented functions
#' @export
meltall <- function(x, na.rm = TRUE) {
    x[, rowid := 1:.N]
    
    suppressWarnings(melt(x, id.vars = 'rowid', variable.factor = FALSE, value.factor = FALSE, na.rm = na.rm))
	
	}



#' @name      colorCombos
#' @title     all color combinations
#' @param v   strip datetime or date
#' @export
#' @examples
#' colorCombos()
colorCombos <- function(v = c("R", "Y", "W", "DB", "G", "O") ) {
  setA       = gtools::permutations(length(v), 3, v, repeats=TRUE)
  L_combos = paste('M', setA[,1], setA[,2],  'Y', setA[,3],  sep = ",")
  R_combos = paste('M', setA[,3],  'Y', setA[,1], setA[,2],  sep = ",")
  c(L_combos, R_combos)
  }















