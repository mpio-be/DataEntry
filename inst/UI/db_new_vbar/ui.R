  bootstrapPage(theme = NULL,

    # navbar
    includeHTML( system.file("vNavBar", 'navbar.html', package = "DataEntry") ) ,
    jquery_change_by_id('TABLE_NAME', tableName),

    # table
    rHandsontableOutput("table"),

    # ui output
    uiOutput("run_save"),

    # modals
    shinyBS::bsModal("help", "Columns definition", "helpButton", size = "large", tableOutput("column_comments") ),
    shinyBS::bsModal("smry", "Data summary", "tableInfoButton", size = "large", tableOutput("data_summary") ),


    # elements
    useNavbar(),
    useToastr(),
    shinyjs::useShinyjs(),
    shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(true); }"),

    js_insertMySQLTimeStamp()

  
   )