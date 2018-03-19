# ==========================================================================
# UI with a vertical navigation bar to enter new data 
# shiny::runApp('inst/UI/bigtable_vbar', launch.browser =  TRUE)
# ==========================================================================


  sapply(c('DataEntry', 'sdb'),require, character.only = TRUE, quietly = TRUE)

  tableName = "Large table test"

  H = data.table(matrix(1:200,ncol = 20, nrow = 100)); setnames(H, paste0(names(H), '__longnam'))


  table_smry <- function() {
    data.frame(x = 'function applied on the table', y = 'returning meaningful summaries')
  }
