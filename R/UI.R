

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
#' nrow = 30, ncol = 20) |> data.table() ) )
#'  } )
#' 
#' 
#' }
#' 

dropDownNavPage <- function (tableName = 'Table Name') {

  # http://shinyapps.dreamrs.fr/shinyWidgets/  

  bootstrapPage(theme = NULL,


  # HOT TABLE 

    rHandsontableOutput("table", width = "100%"),
   
  # MENU 

    HTML('<div style="position:absolute;top:0;z-index: 1000 !important;">') , 


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
              "> 
            {tableName}
          </p>

          ')) ,


      hr(), 

      actionBttn(
         inputId = "saveButton",
         label   = "Save", 
         style = "material-flat", 
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

      # refresh is defined in sever
      inlineCSS("#refresh { 
          background: #6366ff; 
          color: #dad9e7; 

          }"), 








    hr() , 



    switchInput(
      inputId        = "ignore_checks",
      label          = "VALIDATION", 
      value          = FALSE,
      inline         = TRUE,
      size           = 'large',
      width          = 'auto', 
      offStatus      = 'success',
      onStatus       = 'danger', 
      onLabel        = paste('OFF', icon('frown') )  ,
      offLabel       = paste('ON', icon('smile') )

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

   
    includeScript(system.file("JS", "popper.js", package = "DataEntry")),
    
    includeScript(system.file("JS", "tippy.js", package = "DataEntry")),

    useToastr(),
    
    shinyjs::useShinyjs(),
    
    shinyjs::extendShinyjs(text = "shinyjs.js_refresh = function() { location.reload(true); }", functions = "js_refresh" ),

    js_insertMySQLTimeStamp(),

    js_before_unload()
  
   )



}
