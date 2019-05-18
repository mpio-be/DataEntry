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
#' require(DataEntry)
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


#' @name dropDownNavPage
#' @title shiny ui based on shinyWidgets
#' @export
#' @examples
#' if (interactive()) {
#' require(DataEntry)
#' shinyApp(
#'  ui = dropDownNavPage(), 
#'  server = function(input, output) { 
#'      output$table <- renderRHandsontable( 
#'          rhandsontable(matrix(as.integer(NA), 
#' nrow = 30, ncol = 20) %>% data.table) )
#'  } )
#' 
#' 
#' }
#' 

dropDownNavPage <- function (tableName = 'Table Name') {

  # http://shinyapps.dreamrs.fr/shinyWidgets/  
  require(shinyWidgets)  # TODO: move to description

  bootstrapPage(theme = NULL,
   
   # TABLE 

      rHandsontableOutput("table", width = "100%"),
   
   # MENU 
      HTML('<div style="position:absolute;top:0;z-index: 1000 !important;">') , 

      tags$head(
        tags$style(HTML('#menu{background-color:#f45f42;padding: 5px 13px;font-size: 10px;}'))
      ),


      dropdownButton(inputId = "menu",
        circle = FALSE, status = "danger",right = FALSE,
        icon = icon("kiwi-bird"), size = 'sm',margin = "20px", width = "300px",
        tooltip = tooltipOptions(title = " Set tooltip !"),

        tags$h4(tableName),

        selectInput(inputId = 'xcol',
                    label = 'X Variable',
                    choices = names(iris))


      ),


      HTML('</div>'),
    
   # SUPPORT 
      uiOutput("run_save"),

      useToastr(),
      shinyjs::useShinyjs(),
      shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(true); }"),

      js_insertMySQLTimeStamp()

  
   )



}
