% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dbio.R
\name{executeDB}
\alias{executeDB}
\title{execute a pre-defined script}
\usage{
executeDB(action, tableName, x, host, user, db, pwd)
}
\arguments{
\item{action}{a name of for a db operation}

\item{tableName}{table name}

\item{x}{a data.table}

\item{host}{host}

\item{user}{user}

\item{db}{db}

\item{pwd}{pwd}
}
\value{
TRUE a named logical vector of length 1. The name is relevant to the action.
}
\description{
execute a pre-defined script
}
\note{
The following actions are defined here: \strong{append}, \strong{update}.
}
