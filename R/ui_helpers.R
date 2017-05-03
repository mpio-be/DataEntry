
#' emptyFrame 
#' emptyFrame used by handsontable
#' @param user             db user 
#' @param host             db host 
#' @param db               db name 
#' @param table            db table 
#' @param n                n empty lines 
#' @param excludeColumns   default 'pk'
#' @param preFilled        a named list eg. list(datetime_ = as.character(Sys.Date())) 
#' @export
emptyFrame <- function(user, host, db, table,n = 10, excludeColumns = 'pk', preFilled) {
    F = dbq(user = user, host = host, q = paste0('SELECT * from ', db, '.', table, ' limit 0') )

    if(!missing(excludeColumns))
    F = F[, setdiff(names(F), excludeColumns), with = FALSE]
    F = rbind(F, data.table(tempcol = rep(NA, n)), fill = TRUE)[, tempcol := NULL]

    if(!missing(preFilled) ) {
        for(i in 1:length(preFilled)) {
            set(F, j = names(preFilled[i]), value = preFilled[[i]])
            }
    }

    F

    }



#' @export
column_comment <- function(user, host, db, table, excludeColumns = 'pk') {
    x = dbq(user = user, host = host,
        q = paste0('SELECT COLUMN_NAME `Column`, COLUMN_COMMENT description FROM  information_schema.COLUMNS
                WHERE TABLE_SCHEMA =', shQuote(db), 'AND TABLE_NAME =', shQuote(table)) )

    x[!Column %in% excludeColumns]

   
}


