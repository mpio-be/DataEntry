


shinyUI(miniPage(
  useToastr(),
  useShinyjs(),
  extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),

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
 ))




