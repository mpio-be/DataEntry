
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

