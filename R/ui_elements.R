
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


#' @export
DataEntryMiniUI <- function() {
    miniPage(
      useToastr(),
      useShinyjs(),
      extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),
      js_insertMySQLTimeStamp(),

      gadgetTitleBar(  textOutput('title')    ,
        left = miniTitleBarButton("saveButton", "Save", primary = TRUE),
        right = miniTitleBarButton("refresh", "Start New", primary = FALSE)
        ),

       miniTabstripPanel(

        miniTabPanel("Data",

            miniContentPanel(
                rHandsontableOutput("table") ),

            miniButtonBlock(
                checkboxInput('ignore_checks', 'Ignore warnings'),
                actionButton("helpButton", "Columns definition") ),

            uiOutput("run_save"),

            bsModal("help", "Columns definition", "helpButton", size = "large", tableOutput("column_comments"))
            )
        )
     )

    }


