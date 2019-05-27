# ==========================================================================
# UI js
# ==========================================================================

# http://stackoverflow.com/questions/5266522/on-keypress-event-how-do-i-change-a-to-a
# http://keycode.info/

#' @name js_insertMySQLTimeStamp
#' @title translate forward slash to a Mysql timestamp
#' @note used inside shiny apps
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

#' @name jquery_change_by_id
#' @title find and replace given `div` id.
#' @param divid   div id
#' @param newtext new text entry
#' @note used inside shiny apps
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
