#' DataEntryMaterialFloating
#' @param tableName 
#'
#' @param skin   default to 'yellow'
#' @param height default to 100
#' @param width  default to 100
#' @export
#'@examples
#'\dontrun{
  #' frm = function() { H<<- data.table(a = 1:10, b = rep(NA, 10)) }
  #' shinyApp(
  #'  onStart= frm,
  #'  ui = DataEntryDashboard('table name'), 
  #'  server = function(input, output,session) { 
  #'  output$table  <- renderRHandsontable({
  #'   rhandsontable(H)
  #'  } ) } )
#'  }
DataEntryDashboard <- function(tableName,skin = 'yellow' , height = '100%', width = '100%') {

  dashboardPage(skin = skin ,
  dashboardHeader(title = tableName),

  dashboardSidebar(width = 100, 
       
    actionButton("run_save", "SAVE"),
    checkboxInput("ignore_checks", "Ignore errors", FALSE),
    actionButton("helpButton", "Help"),
    
    hr(), 
    'Total entries:', br(), textOutput('title'),
    hr()

    )  ,

  dashboardBody(


  useToastr(),
  useShinyjs(),
  extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),
  js_insertMySQLTimeStamp(),


  rHandsontableOutput("table", height = height, width = width),


  bsModal("help", tableName , "helpButton", size = "large", tableOutput("column_comments"))


   )
  )

  }



#' DataEntryMaterialFloating
#' @param tableName 
#'
#' @param skin   default to 'yellow'
#' @param height default to 100
#' @param width  default to 100
#'
#' @export
DataEntryMaterialFloating <- function(tableName,skin = 'yellow' , height = '100%', width = '100%') {
  # https://codepen.io/simoberny/pen/pJZJQY

  dashboardPage(skin = skin ,
  dashboardHeader(title = tableName),

  dashboardSidebar(width = 100, 
    'Total entries:', br(), 
    textOutput('title')
    )  ,

  dashboardBody(

  includeCSS(system.file('UI', 'www', 'floatingButton.css', package = 'DataEntry'))   ,

  useToastr(),
  useShinyjs(),
  extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),
  js_insertMySQLTimeStamp(),


  rHandsontableOutput("table", height = height, width = width),



  # Menu
   HTML('
    <div id="container-floating">
      
      <!-- Save  -->
      <div id="saveButton" class="nd4 nds btn btn-danger action-button" data-toggle="tooltip">
      <h6> Save </h6>
      <div id="run_save" class="shiny-html-output"></div>
      </div>
      
       <!-- Ignore validators  -->  
      

      <div class="nd3 nds material-switch pull-right" data-toggle="tooltip" >
        <h6> No validation! </h6>
        <input id="ignore_checks"  type="checkbox"/>
        <label for="ignore_checks" class="label-danger"> </label>
       </div>


      <!-- Refresh  -->
      <div id="refresh" class="nd2 nds btn btn-primary action-button" data-toggle="tooltip" >

      <h6> Refresh </h6>
      </div>


      <!-- Columns definition  -->
      <div id = "helpButton" class="nd1 nds btn btn-primary action-button" data-toggle="tooltip">
        <h6> Help </h6>
      </div>

      <!-- Start  -->
      <div id="floating-button" data-toggle="tooltip">
        <p class="plus">+</p>
        
      </div>

    </div>


    ')

   , 


   bsModal("help", tableName , "helpButton", size = "large", tableOutput("column_comments"))



   )
  )

  }


#' @export
DataEntryMiniUI <- function() {
    miniUI::miniPage(
      useToastr(),
      useShinyjs(),
      extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),
      js_insertMySQLTimeStamp(),

      miniUI::gadgetTitleBar(  textOutput('title')    ,
        left = miniUI::miniTitleBarButton("saveButton", "Save", primary = TRUE),
        right = miniUI::miniTitleBarButton("refresh", "Start New", primary = FALSE)
        ),

       miniUI::miniTabstripPanel(

        miniUI::miniTabPanel("Data",

            miniUI::miniContentPanel(
                rHandsontableOutput("table") ),

            miniUI::miniButtonBlock(
                checkboxInput('ignore_checks', 'Ignore warnings'),
                actionButton("helpButton", "Columns definition") ),

            uiOutput("run_save"),

            bsModal("help", "Columns definition", "helpButton", size = "large", tableOutput("column_comments"))
            )
        )
     )

    }


#' @export
DataEntryFluidPage <- function() {
  fluidPage(

  useToastr(),
  useShinyjs(),
  extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),
  js_insertMySQLTimeStamp(),

  fluidRow(
    column(3,actionButton("saveButton", "Save")                ),
    column(2,actionButton("refresh", "Refresh")              ),    
    column(2,checkboxInput('ignore_checks', 'Ignore warnings') ),
    column(2,actionButton("helpButton", "Columns definition")  )
  ),

  fluidRow(
    rHandsontableOutput("table")
  ), 

  uiOutput("run_save"),

  bsModal("help", "Columns definition", "helpButton", size = "large", tableOutput("column_comments"))

 )

}

#' @export
DataEntryBootstrapPage <- function() {
  bootstrapPage(

  useToastr(),
  useShinyjs(),
  extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),
  js_insertMySQLTimeStamp(),

  fluidRow(
    column(3,actionButton("saveButton", "Save")                ),
    column(2,actionButton("refresh", "Refresh")              ),    
    column(2,checkboxInput('ignore_checks', 'Ignore warnings') ),
    column(2,actionButton("helpButton", "Columns definition")  )
  ),

  fluidRow(
    rHandsontableOutput("table")
  ), 

  uiOutput("run_save"),

  bsModal("help", "Columns definition", "helpButton", size = "large", tableOutput("column_comments"))

 )

}




