


#' @title       Data entry 'in-browser' interfaces
#' @name        DataEntry
#' @description Data-entry front-end; Mysql/MariaDB backend
#' @docType     package
#' @name        wadeR


#' Data entry 'in-browser' interfaces
#' @aliases DataEntry-package DataEntry
#' @docType package
.onLoad <- function(libname, pkgname){
    dcf <- read.dcf(file=system.file('DESCRIPTION', package=pkgname) )
    packageStartupMessage(paste('This is', pkgname, dcf[, 'Version'] ))

    # see ./inst/install_testdb.sql
    options(DataEntry.host = "127.0.0.1")
    options(DataEntry.db   = "tests")
    options(DataEntry.user = 'testuser')
    options(DataEntry.pwd  = 'testuser')


    }


# data.table, foreach, rangeMapExport 'values'
# utils::globalVariables(c('i', '.', ':='))


#' @import methods glue stringr shinydashboard shinytoastr shinyBS praise
NULL


#' @importFrom shinyjs useShinyjs extendShinyjs
NULL


#' @importFrom grDevices colorRampPalette
NULL


#' @importFrom magrittr %>% is_greater_than 
NULL
