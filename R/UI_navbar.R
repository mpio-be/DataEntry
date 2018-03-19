#' Initialize the bootstrap navbar
#'
#' Call this function once from inside Shiny UI
#'
#' @return The HTML tags to put into the \code{<head>} of the HTML file.
#'
#' @export



useNavbar <- function() {
  addResourcePath("vNavBar", system.file("vNavBar", package = "DataEntry") )
  tags$head(
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "vNavBar/navbar.css"
    ),
    tags$script(
      src = "vNavBar/navbar.js"
    )
  )
}


