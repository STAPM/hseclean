% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_hse.R
\name{read_hse}
\alias{read_hse}
\title{Read HSE data \lifecycle{deprecated}}
\usage{
read_hse(year, root = c("X:/", "/Volumes/Shared/"))
}
\arguments{
\item{year}{Character - the file path and name.}

\item{root}{Character - the root directory.}
}
\value{
Returns a data table of the year of data selected.
}
\description{
Reads and does basic cleaning of a selected year of the Health Survey for England.
}
\examples{

\dontrun{

data_2001 <- read_hse(year = 2001, root = "X:/")

}

}
