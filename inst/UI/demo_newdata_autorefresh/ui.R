  bootstrapPage(theme = NULL,

    HTML(paste('
        <div class="navbar navbar-inverse navbar-twitch" role="navigation">
        <div class="container">

        <ul class="nav navbar-nav" >
                      
            <li>
                <a id="saveButton" class = "action-button">
                    <span class="small-nav" data-toggle="tooltip" data-placement="right" title="Save"> 
                        <span class="glyphicon glyphicon-save"></span> 
                    </span>
                </a>
            </li>

            <li>
                <a id="helpButton" class = "action-button">
                    <span class="small-nav" data-toggle="tooltip" data-placement="right" title="Data entry help"> 
                        <span class="glyphicon glyphicon-list"></span> 
                    </span>
                </a>
            </li>

            
            <li>
               <a>
                <span class="small-nav" data-toggle="tooltip" data-placement="right" title="Bypass\ndata validation!"> 
                 <input id="ignore_checks" class="form-check-input" type="checkbox" >
                </span>
                </a>
            </li>
            

            <li>
                <a id="tableInfoButton" class = "action-button">
                    <span class="small-nav" data-toggle="tooltip" data-placement="right" title="Table summary"> 
                        <span class="glyphicon glyphicon-eye-open"></span> 
                    </span>
                </a>
            </li>


        <a class="vertical">', 
        
        tableName,
        
        '</a>

       </ul>

            </div>
        </div>
        ') ),




    rHandsontableOutput("table"),


    uiOutput("run_save"),

    # modals
    bsModal("help", "Columns definition", "helpButton", size = "large", tableOutput("column_comments") ),
    
    bsModal("smry", "Data summary", "tableInfoButton", size = "large", tableOutput("data_summary") ),


    # JS

    useToastr(),
    shinyjs::useShinyjs(),
    shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { 
        location.reload(true); 
    }"),
   



    js_insertMySQLTimeStamp(), 



    includeCSS( '/home/mihai/github/mpio-be/DataEntry/inst/UI/www/navbar.css' ),   

    # includeCSS( '/home/mihai/github/mpio-be/DataEntry/inst/UI/www/navbar.js' )


    # includeCSS(system.file('UI', 'www', 'navbar.css', package = 'DataEntry')),

    includeScript(system.file('UI', 'www', 'navbar.js', package = 'DataEntry'))



 )