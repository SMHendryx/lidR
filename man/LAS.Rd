% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/las-class.r
\name{LAS}
\alias{LAS}
\title{Create a \code{LAS} object}
\usage{
LAS(data, header = list(), check = TRUE)
}
\arguments{
\item{data}{a data.table containing the LiDAR data.}

\item{header}{a list containing the data from the header of a las file.}

\item{check}{logical. consistency tests while building the object.}
}
\value{
An object of class \code{LAS}
}
\description{
Create a \code{LAS} object
}
\seealso{
\link[lidR:LAS]{Class LAS}
}
