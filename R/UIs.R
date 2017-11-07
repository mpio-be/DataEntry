
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

#' @export
DataEntryMaterialFloating <- function(tableName, height = '100%', width = '100%') {
  # https://codepen.io/simoberny/pen/pJZJQY

  dashboardPage(
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




