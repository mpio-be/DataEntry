% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/js.R
\name{js_hot_tippy_header}
\alias{js_hot_tippy_header}
\title{add tooltips to a handsontable}
\usage{
js_hot_tippy_header(x, tippy_column)
}
\arguments{
\item{x}{A data frame with two columns, one colum containing the fields of the table
and one column containing the description of the fields.}

\item{tippy_column}{Character vector. the name of the column in x containing the description of the columns.}
}
\description{
add tooltips to a handsontable
}
\note{
used inside shiny apps. Adapted from https://gist.github.com/timelyportfolio/b8001318ce3e25b6920a0f20e9db374e
}
\seealso{
\code{\link[=column_comment]{column_comment()}}
}
