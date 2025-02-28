

#' @name dropDownNavPage_edit
#' @title shiny ui based on shinyWidgets
#' @export
#' @examples
#' if (interactive()) {
#' require(DataEntry)
#' shinyApp(
#'  ui = dropDownNavPage_edit(), 
#'  server = function(input, output) { 
#'      output$table <- renderRHandsontable( 
#'          rhandsontable(matrix(as.integer(NA), 
#' nrow = 30, ncol = 20) |> data.table() ) )
#'  } )
#' 
#' 
#' }
#' 

dropDownNavPage_edit <- function (tableName = 'Table Name') {


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
      


    hr() , 



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
    

    js_before_unload()
  
   )



}
