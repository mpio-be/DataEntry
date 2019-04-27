
#' data.table to html (boostrap style)
#' @param x  a data.table
#' @export
#' @examples
#' boostrap_table( data.table::data.table(x = 1, y = 'a') )

boostrap_table <- function(x, class = 'responsive') {
	paste0( '<div class="table-', class , '"> <table class="table">',  
		knitr::kable(x, format = 'html', align = 'c'), 
		' </table> </div>' )
}



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
#' @examples \dontrun{
#' emptyFrame(user = 'bt', host = '127.0.0.1', db = 'FIELD_BTatWESTERHOLZ', table = 'ADULTS')
#' emptyFrame(user = 'bt', host = '127.0.0.1', db = 'FIELD_BTatWESTERHOLZ', table = 'ADULTS', preFilled = list(datetime_ = as.character(Sys.Date())) )
#' }
#' 
emptyFrame <- function(user, host, db, pwd, table,n = 10, excludeColumns = 'pk', preFilled) {

	con =  dbConnect(RMySQL::MySQL(), host = host, user = user, password = pwd); on.exit(dbDisconnect(con))


	F = dbGetQuery(con, paste0('SELECT * from ', db, '.', table, ' where FALSE') ) %>% data.table

	if(!missing(excludeColumns))
	F = F[, setdiff(names(F), excludeColumns), with = FALSE]


	F = rbind(F, data.table(tempcol = rep(NA, n)), fill = TRUE)[, tempcol := NULL]

	if(!missing(preFilled) ) {
			for(i in 1:length(preFilled)) {
					set(F, j = names(preFilled[i]), value = preFilled[[i]])
					}
			}

	# convert un-handled rhandsontable types to characters (RMariaDB)
		# difftime_to_char = which( F[, sapply(.SD, function(x) inherits(x, 'difftime') ) ] ) %>% names
		# F[,(difftime_to_char) := lapply(.SD, as.character), .SDcols = difftime_to_char]
		# 
		# POSIXt_to_char = which( F[, sapply(.SD, function(x) inherits(x, 'POSIXt') ) ] ) %>% names
		# F[,(POSIXt_to_char) := lapply(.SD, as.character), .SDcols = POSIXt_to_char]

	F

	}



#' @export
column_comment <- function(user, host, db, pwd, table, excludeColumns = 'pk') {
		
		con =  dbConnect(RMySQL::MySQL(), host = host, user = user, password = pwd); on.exit(dbDisconnect(con))


		x = dbGetQuery(con,
				paste0('SELECT COLUMN_NAME `Column`, COLUMN_COMMENT description FROM  information_schema.COLUMNS
								WHERE TABLE_SCHEMA =', shQuote(db), 'AND TABLE_NAME =', shQuote(table)) ) %>% data.table

		x[!Column %in% excludeColumns]
 }


#' Initialize the bootstrap navbar
#' Call this function once from inside Shiny UI
#' @return The HTML tags to put into the \code{<head>} of the HTML file.
#' @export
useNavbar <- function() {
  addResourcePath("vNavBar", system.file("vNavBar", package = "DataEntry") )
  tags$head(
	tags$link(
	  rel = "stylesheet",
	  type = "text/css",
	  href = "vNavBar/navbar.css"
	),
	tags$script(
	  src = "vNavBar/navbar.js"
	)
  )
}



# ==========================================================================
# UI js
# ==========================================================================

# http://stackoverflow.com/questions/5266522/on-keypress-event-how-do-i-change-a-to-a
# http://keycode.info/

#' @export
js_insertMySQLTimeStamp <- function() {
  HTML("
    <script>
    $(document).ready(function(event){

       $(document).delegate('input, textarea', 'keyup', function(event){

            date = new Date().toISOString().slice(0, 19).replace('T', ' ');

            if(event.which === 191) { // 191 forward slash
                var timestamp = $(this).val().replace('/',date);
                $(this).val(timestamp);
            }

        });
    });
    </script>
    ")

}


#' @export
jquery_change_by_id <- function(divid, newtext) {
  
  # $("#TABLE_NAME").css("color", "red");

  x = (paste0('<script>
  $(document).ready(function() {
  $("#', divid, '").text("',newtext,'");
  });
  </script>'
  ))

  HTML(x)

}

