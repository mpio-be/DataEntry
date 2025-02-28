
# ==========================================================================
# UI with a vertical navigation bar to enter new data 
#' shiny::runApp('./inst/UI/editData', launch.browser =  TRUE)
# ==========================================================================

# Settings
  
  sapply(c('DataEntry', 'DataEntry.validation', 'shinyjs', 'shinyWidgets', 
      'glue', 'tableHTML', 'shinytoastr'),require, character.only = TRUE, quietly = TRUE)
  tags = shiny::tags

  host    = getOption('DataEntry.host')
  db      = getOption('DataEntry.db'  )
  user    = getOption('DataEntry.user')
  pwd     = getOption('DataEntry.pwd' )
  tableName  = 'data_entry'

  describeTable <- function() {
    data.frame(x = 'function applied on the db table', y = 'returning meaningful summaries')
    }

  comments = column_comment(user, host, db, pwd, tableName,excludeColumns)	
