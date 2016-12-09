
#' data.table to html (boostrap style)
#' @param x  a data.table
#' @export
#' @examples
#' boostrap_table( data.table(x = 1, y = 'a') )

boostrap_table <- function(x, class = 'responsive') {
    paste0( '<div class="table-', class , '"> <table class="table">',  
        knitr::kable(x, format = 'html', align = 'c'), 
        ' </table> </div>' )

}

