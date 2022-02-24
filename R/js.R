
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


#' @name js_before_unload
#' @title prevent page exit
#' @param msg   msg
#' @note used inside shiny apps
#' @export
js_before_unload <- function(msg = "Are you sure you want to exit the page?") {
  
     HTML(

      paste0('
      <script>
       window.onbeforeunload = function() {
        return '  , shQuote(msg)  , ';
      }

      </script>
        ') 

      )


}


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

  x <- (paste0('<script>
  $(document).ready(function() {
  $("#', divid, '").text("', newtext, '");
  });
  </script>'))

  HTML(x)
}




#' @name js_hot_tippy_header
#' @title add tooltips to a handsontable
#' @param x   A data frame with two columns, one colum containing the fields of the table
#'            and one column containing the description of the fields.
#' @param tippy_column   Character vector. the name of the column in x containing the description of the columns.
#' @note used inside shiny apps. Adapted from https://gist.github.com/timelyportfolio/b8001318ce3e25b6920a0f20e9db374e
#' @seealso [DataEntry::column_comment()]
#' @export
js_hot_tippy_header <- function(x, tippy_column) {
  x <- cbind(loc = glue("[,{1:nrow(x) } ]"), x)

  jj <- jsonlite::toJSON(x, auto_unbox = TRUE)

  glue("function(i, TH) {
  var titleLookup = <<jj>>;
  if(TH.hasOwnProperty('_tippy')) {TH._tippy.destroy()}
  
  if(i >= 0) {

    tippy(TH, {
    content: titleLookup[i].<<tippy_column>>,
    allowHTML:true
    });

    }; 

  }
  ", .open = "<<", .close = ">>") |>

    htmlwidgets::JS()
}