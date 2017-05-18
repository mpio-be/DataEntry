


shinyUI(fluidPage(


  # http://stackoverflow.com/questions/5266522/on-keypress-event-how-do-i-change-a-to-a
  # http://keycode.info/

  HTML("
    <script>
    $(document).ready(function(event){

       $(document).delegate('input, textarea', 'keyup', function(event){

            date = new Date().toISOString().slice(0, 19).replace('T', ' ');

            if(event.which === 191) { // forward slash
                var timestamp = $(this).val().replace('/',date);
                $(this).val(timestamp);
            }

        });
    });
    </script>
    "),



  useToastr(),
  useShinyjs(),
  extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),

  fluidRow(
    column(3,actionButton("saveButton", "Save")                ),
    column(2,actionButton("refresh", "Refresh")              ),    
    column(2,dateInput("pulldate", NULL ) ),
    column(2,checkboxInput('ignore_checks', 'Ignore warnings') ),
    column(2,actionButton("helpButton", "Columns definition")  )

  ),

  fluidRow(
    rHandsontableOutput("table")
  ), 

  uiOutput("run_save"),

  bsModal("help", "Columns definition", "helpButton", size = "large", tableOutput("column_comments"))


) )


