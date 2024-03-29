% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/smk_quit.R
\name{smk_quit}
\alias{smk_quit}
\title{Quitting smoking \lifecycle{experimental}}
\usage{
smk_quit(data)
}
\arguments{
\item{data}{Data table - the Health Survey for England data.}
}
\value{
Returns an updated data table with:
\itemize{
\item giveup_smk - whether a current smoker wants to quit smoking (yes, no).
}
}
\description{
Cleans the data on the motivation to quit smoking and the use of support.
}
\details{
Only tested on England data
Use of support not currently incorporated
}
\examples{

\dontrun{

data <- read_2001()
data <- smk_quit(data)

}

}
