#' @name ui_vnavbar
#' @title shiny ui with a vertical navbar and a rHandsontable
#' @note see praise package
#' @export
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
