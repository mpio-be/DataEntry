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

  bootstrapPage(theme = NULL,
   
   # TABLE 

      rHandsontableOutput("table", width = "100%"),
   
   # MENU 


      HTML('<div style="position:absolute;top:0;z-index: 1000 !important;">') , 

     # tags$head(
     #   tags$style(HTML('#menu{padding: 5px 13px;font-size: 11px;}'))
     # ),
 
      inlineCSS("#menu { 
        background: #003152; 
        border-color: #003152; 
        padding: 5px 13px;
        font-size: 11px;
        border: none;
        }"),   

      inlineCSS("#menu:hover { 
        background: #2890D6!important; 
        }"),   


      dropdown(inputId = "menu",

        circle = FALSE,right = FALSE,status = "danger",
        icon = icon("feather"), size = 'sm', margin = "1px", width = "300px",
        tooltip = NULL,

        #btags$h4(tableName)  

        HTML(glue('<p id = "TABLE_NAME" style =" 
                color:#345678;
                font-size: 2em;
                text-align: center;
                font-family: Copperplate, Copperplate Gothic Light, fantasy; 
                "> 
              {tableName}
            </p>

            ')) ,

       

        hr(), 

		actionBttn(
		   inputId = "saveButton",
		   label   = "Save", style = "material-flat", 
		   block   = TRUE, 
		   icon    = icon("save")
		), 

        inlineCSS("#saveButton { 
            background: #345678; 
            color: #c2ccd6; 
            font-weight: bold; 

            }"), 
        

        # invalidButton is defined in sever
        inlineCSS("#invalidButton { 
            background: #484388; 
            color: #dad9e7; 

            }"), 

		hr() , 



        switchInput(
            inputId      = "ignore_checks",
            label      = "VALIDATION", 
            value      = FALSE,
            inline        = TRUE,
            size      = 'large',
            width      = 'auto', 
            offStatus      = 'success',
            onStatus      = 'danger', 
            onLabel      = paste('OFF', icon('skull') )  ,
            offLabel      = paste('ON', icon('thumbs-up') )

        ),





		hr() ,

		actionBttn(
		   inputId = "helpButton",
		   label   = "Columns definition", 
		   style   = "minimal",
		   block   = TRUE,
		   icon    = icon("binoculars")
		), 
        inlineCSS("#helpButton { color: #25596d; }"), 

		br() ,

		actionBttn(
		   inputId = "cheatsheetButton",
		   label   = "Keyboard shortcuts", 
		   style   = "minimal",
		   block   = TRUE,
		   icon    = icon("binoculars")
		),
        inlineCSS("#cheatsheetButton { color: #25596d; }"), 

		br(),
		actionBttn(
		   inputId = "tableInfoButton",
		   label   = "Table summary", 
		   style   = "minimal",
		   block   = TRUE,
		   icon    = icon("info-circle")
		),
         inlineCSS("#tableInfoButton { color: #425866; }")





      ),


      HTML('</div>'),
    
   # SUPPORT 
      uiOutput("run_save"),

      useToastr(),
      shinyjs::useShinyjs(),
      shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(true); }"),

      js_insertMySQLTimeStamp(),


 
       HTML('
       <script>
         window.onbeforeunload = function() {
          return "Are you sure you want to exit the page?";
        }

       </script>
          ')


       





  
   )



}
