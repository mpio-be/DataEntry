#' @name boostrap_table
#' @title convert a data.frame to a boostrap table
#' @note  a wrapper around knitr::kable
#' @param x      a data.table
#' @param class  `div` class
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


.vnavbar_saveButton <- function(title = 'Save') {
  glue(
  '<li>
      <a id="saveButton" class="action-button ">
          <span class="small-nav" data-toggle="tooltip" data-placement="right" title="{title}"> 
          <span class="glyphicon glyphicon-save"></span>
          </span>
      </a>
  </li>') %>% HTML
  }


.vnavbar_ignoreChecks <- function(title = 'Bypass data validation!') {
  glue(
  '
  <li>
      <a>
    <span class="small-nav" data-toggle="tooltip" data-placement="right" title="{title}"> 
    <form role="form">
     <input id="ignore_checks" class="form-check-input" type="checkbox" >
    </form>
  </span>
      </a>
  </li>

  ') %>% HTML
  }




.vnavbar_tableInfoButton <- function(title = 'Table summary') {
  glue(
  '
  <li>
    <a id="tableInfoButton" class="action-button">
        <span class="small-nav" data-toggle="tooltip" data-placement="right" title="{title}"> 
        <span class="glyphicon glyphicon-eye-open"></span>
        </span>
    </a>
  </li>

  ') %>% HTML
  }



.vnavbar_helpButton <- function(title = 'Data entry help') {
  glue(
  '
  <li>
      <a id="helpButton" class="action-button">
          <span class="small-nav" data-toggle="tooltip" data-placement="right" title="{title}"> 
          <span class="glyphicon glyphicon-info-sign"></span>
          </span>
      </a>
  </li>

  ') %>% HTML
  }


.vnavbar_cheatsheetButton <- function(title = 'Cheatsheet') {
  glue(
  '
  <li>
      <a id="cheatsheetButton" class="action-button">
          <span class="small-nav" data-toggle="tooltip" data-placement="right" title="{title}"> 
          <span class="glyphicon glyphicon-question-sign"></span>
          </span>
      </a>
  </li>

  ') %>% HTML
  }







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

