#' @name ui_vnavbar
#' @title shiny ui with a vertical navbar and a rHandsontable
#' @note see praise package
#' @export
#' @examples
#' if (interactive()) {
#' tableName = 'TABLE X'
#' shinyApp(
#' 	ui = ui_vnavbar(), 
#' 	server = function(input, output) { 
#' 		output$table <- renderRHandsontable( 
#' 			rhandsontable(iris)
#' 			)
#' 	} )
#' 
#' 
#' }
#' 
ui_vnavbar <- function() {
  

  bootstrapPage(theme = NULL,

	# navbar
	includeHTML( system.file("vNavBar", 'navbar.html', package = "DataEntry") ) ,
	jquery_change_by_id('TABLE_NAME', tableName),

	# table
	rHandsontableOutput("table", width = "99%"),

	# ui output
	uiOutput("run_save"),


	# elements
	useNavbar(),
	useToastr(),
	shinyjs::useShinyjs(),
	shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(true); }"),

	js_insertMySQLTimeStamp()

  
   )

}


#' @name vnavbarPage
#' @title shiny ui with a vertical navbar and a rHandsontable
#' @export
#' @examples
#' if (interactive()) {
#' 
#' shinyApp(
#' 	ui = vnavbarPage(), 
#' 	server = function(input, output) { 
#' 		output$table <- renderRHandsontable( 
#' 			rhandsontable(matrix(as.integer(NA), nrow = 30, ncol = 20) %>% data.table) )
#' 	} )
#' 
#' 
#' }
vnavbarPage <- function (tableName = 'Table Name') {

  require(shinyWidgets)  

  bootstrapPage(theme = NULL,


    HTML('<div class="navbar navbar-inverse navbar-twitch" role="navigation">
        <div class="container">
            <ul class="nav navbar-nav">'), 

    .vnavbar_saveButton(), 
    .vnavbar_ignoreChecks(), 
    .vnavbar_tableInfoButton(), 
    .vnavbar_helpButton(),
    .vnavbar_cheatsheetButton(),




     HTML(glue('<a class="vertical", id = "TABLE_NAME"> {tableName} </a>
            </ul>
           </div>
        </div>')),


	# table
	rHandsontableOutput("table", width = "99%"),

	# ui output
	uiOutput("run_save"),


	# elements
	useNavbar(),
	useToastr(),
	shinyjs::useShinyjs(),
	shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(true); }"),

	js_insertMySQLTimeStamp()

  
   )



}


