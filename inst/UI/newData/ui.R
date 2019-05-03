
# ui_vnavbar()

  bootstrapPage(theme = NULL,

    pushbar_deps(),

    # navbar
    includeHTML( system.file("vNavBar", 'navbar.html', package = "DataEntry") ) ,
    jquery_change_by_id('TABLE_NAME', tableName),

    # table
    rHandsontableOutput("table", width = "99%"),

    # ui output
    uiOutput("run_save"),

    # modals
    shinyBS::bsModal("help", "Columns definition", "helpButton", size = "large", tableOutput("column_comments") ),
    shinyBS::bsModal("smry", "Data summary", "tableInfoButton", size = "large", tableOutput("data_summary") ),
    shinyBS::bsModal("cheatsheet", "Cheat sheet", "cheatsheetButton", size = "large", tableOutput("cheatsheet_show") ),


    # pushbar
       pushbar(
     h4("HELLO"),
     id = "myPushbar", # add id to get event
     actionButton("close", "Close pushbar")
   ), 


    # elements
    useNavbar(),
    useToastr(),
    shinyjs::useShinyjs(),
    shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(true); }"),

    js_insertMySQLTimeStamp()

  
   )