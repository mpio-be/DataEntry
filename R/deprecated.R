
# ==========================================================================
# deprecated or soon to be deprecated functions 
# ==========================================================================




#' Shiny server function
#'
#' @param input     Shiny server
#' @param output    Shiny server
#' @param session   Shiny server
#'
#' @export
#' @note package, uitable, comments, describeTable, getDataSummary are defined in global.R
#'       inspectors are loaded with  DataEntry.validation::inspector_loader()
#'
server_newData <- function(input, output,session) {



  # Settings
    con =  dbConnect(RMySQL::MySQL(), host = host, user = user, db = db, password = pwd)
    onStop(function() {dbDisconnect(con)})

    # Is no-validation column present in table ?
    hasnov = dbGetQuery(con, glue::glue("SHOW COLUMNS FROM {tableName} LIKE 'nov';") ) %>% 
              nrow %>% 
              magrittr::is_greater_than(0)

    observeEvent(input$refresh, {
        shinyjs::js$refresh()
      })
  
    Save <- eventReactive(input$saveButton, {
      o = hot_to_r(input$table) %>% data.table
      cleaner(o)
      class(o) = c(class(o), tableName)
      
      DataEntry.validation::inspector_loader(package = package)

      o
      })


  # VALIDATE - SAVE 

    output$run_save <- renderUI({
    
    isolate(ignore_validators <- input$ignore_checks )
    isolate(is_invalid <- input$invalidButton )
  

    x = Save() 
    
    # Data validation

    cc = inspector(x) %>% evalidators
    # assign('cc', cc , envir = .GlobalEnv)


      # errors 
      if(nrow(cc) > 0 && !ignore_validators) {
          toastr_error( 
            message = HTML('<h4> To see what\'s wrong push the 
              <kbd class="glyphicon glyphicon-warning-sign"></kbd> then fix the data and try again.</h4> '  ) ,
            
            title = HTML(encourage() ) ,
            timeOut = 10000, closeButton = TRUE, position = 'top-center')

      if( is.null(is_invalid) )      
      insertUI(
        selector = "#saveButton",
        where = "afterEnd",
        ui = HTML('
                  <a id="invalidButton" class="action-button">
                      <span class="small-nav" data-toggle="tooltip" data-placement="right" title="Invalid entries"> 
                      <span class="glyphicon glyphicon-warning-sign"></span>
                      </span>
                  </a>
                  
              ')
        )


       }


    # Database update
      if(   nrow(cc) == 0 | (nrow(cc) > 0 & ignore_validators ) ) {

        # add no-validation info to table
        if(hasnov) {
            x = copy(x)
            x[, nov := as.integer(0)]
            x[char2vec(cc$rowid)%>% as.integer, nov := 1L]


            }

        saved_set = dbWriteTable(con, tableName, x, append = TRUE, row.names = FALSE)


        if(saved_set) {
  
        removeUI(selector = "#saveButton", immediate = TRUE, multiple = TRUE)

        msg = if(ignore_validators) "I'm sure you ignored the validation for a good reason." else 
              glue("   <h4> {praise()} </h4>    ")

        toastr_success(title = msg  , 
          message = glue( "<p>{nrow(x)} rows saved to database.</p><br/>
              <i> Refreshing in progress ... </i>") , timeOut = 10000, 
          position = 'top-center', 
          progressBar = TRUE)
        

        Sys.sleep(5)


        shinyjs::js$refresh()

        }


        cat('-------')

        }

    })

  # HOT TABLE
  output$table  <- renderRHandsontable({
    
    uitable
    
    })

  # Show INVALID data
  observeEvent(input$invalidButton, {
    showModal(modalDialog(
    title = "Invalid entries",
    
    tableHTML(Save() %>% inspector %>% evalidators, rownames =  FALSE) %>% 
    add_theme_colorize (color ='tomato', id_column = TRUE),
    
    easyClose = TRUE, footer = NULL, size = 'l'
    ))
    })


  # Show column DEFINITIONS
  observeEvent(input$helpButton, {
    showModal(modalDialog(
    title = "Columns definition",
    
    tableHTML(comments, rownames =  FALSE) %>% add_theme ('rshiny-blue'),

    
    easyClose = TRUE, footer = NULL, size = 'l'
    ))
    })


  # Show data SUMMARY
  observeEvent(input$tableInfoButton, {
    showModal(modalDialog(
    title =  "Data summary",
    
    tableHTML(describeTable(), rownames =  FALSE)%>% add_theme ('rshiny-blue'),

    
    easyClose = TRUE,footer = NULL, size = 'l'
    ))
    })

  # Show CHEATSHEET
  observeEvent(input$cheatsheetButton, {
    showModal(modalDialog(
    title =  "Data entry shortcuts",
    
    includeMarkdown(system.file('cheatsheet.md', package = "DataEntry")),
    
    easyClose = TRUE,footer = NULL, size = 'l'
    ))
    })







  # observe( on.exit( assign('input', reactiveValuesToList(input) , envir = .GlobalEnv)) )


 }

 


 #' @name ui_vnavbar
#' @title shiny ui with a vertical navbar and a rHandsontable
#' @note see praise package
#' @export
#' @examples
#' if (interactive()) {
#' tableName = 'TABLE X'
#' shinyApp(
#'  ui = ui_vnavbar(), 
#'  server = function(input, output) { 
#'      output$table <- renderRHandsontable( 
#'          rhandsontable(iris)
#'          )
#'  } )
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
#'  ui = vnavbarPage(), 
#'  server = function(input, output) { 
#'      output$table <- renderRHandsontable( 
#'          rhandsontable(matrix(as.integer(NA), nrow = 30, ncol = 20) %>% data.table) )
#'  } )
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
