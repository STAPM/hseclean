% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clean_age.R
\name{clean_age}
\alias{clean_age}
\title{Age variables}
\usage{
clean_age(data)
}
\arguments{
\item{data}{Data table - the Health Survey for England dataset.}
}
\value{
Returns an updated version of data with the new age variables: age in single years, age in the categories above,
and birth cohort.
}
\description{
Processes the data on age.
}
\details{
From 2015 onwards, the HSE no longer supplies age in single years (to prevent individual identification).
For our modelling, we require age in single years, so we apply a method that randomly assigns
an age in single years to individuals for whom we only have an age category. The age categories we work with are:
0-1, 2-4, 5-7, 8-10, 11-12, 13-15, 16-17, 18-19, 20-24, 25-29, 30-34, 35-39, 40-44, 45-49,
 50-54, 55-59, 60-64, 65-69, 70-74, 75-79, 80-84, 85-89, 90+. These categories are the finest scale version of age
 that is available for years 2015+. We then select only individuals younger than 90 years
 for our modelling.
}
\examples{

\dontrun{

data_2016 <- read_2016()

data_2016 <- clean_age(data = data_2016)

}

}
