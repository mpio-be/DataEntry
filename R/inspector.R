#' Data police
#'
#' Inspectors are usually a collection of validators
#'
#' @title   data inspector
#' @param   x a data.table with its (S3) class extended by the database table name (see server.R)
#'
#'
#' @export
inspector <- function (x) {
  UseMethod("inspector", x)
  }





