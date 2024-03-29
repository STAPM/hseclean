% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_SHeS_2011.R
\name{read_SHeS_2011}
\alias{read_SHeS_2011}
\title{Read Scottish Health Survey 2011}
\usage{
read_SHeS_2011(
  root = "X:/ScHARR/PR_Consumption_TA/HSE/Scottish Health Survey (SHeS)/",
  file = "SHeS 2011/UKDA-7247-tab/tab/shes11i_v5.tab"
)
}
\arguments{
\item{root}{Character - the root directory.}

\item{file}{Character - the file path and name.}
}
\value{
Returns a data table. Note that:

\itemize{
\item Missing data ("NA", "", "-1", "-2", "-6", "-7", "-9", "-90", "-90.0", "N/A") is replace with NA,
-8 ("don't know") is also missing.
\item All variable names are converted to lower case.
\item Each data point is assigned a weight of 1 as there is no weight variable supplied.
\item A single sampling cluster is assigned.
\item The probabilistic sampling unit have the year appended to them.
}
}
\description{
Reads and does basic cleaning on the Scottish Health Survey 2011.
}
\details{
The Scottish Health Survey is designed to yield a representative sample of the general population
living in private households in Scotland every year.


MISSING VALUES

\itemize{
\item -1 Not applicable: Used to signify that a particular variable did not apply to a given respondent
usually because of internal routing. For example, men in women only questions.
\item -2 Schedule not applicable: Used mainly for variables on the self-completions when the
respondent was not of the given age range, also used for children without legal guardians in the
home who could not participate in the nurse schedule.
\item -6 Schedule not obtained: Used to signify that a particular variable was not answered because the
respondent did not complete or agree to a particular schedule (i.e. nurse schedule or selfcompletions).
\item -8 Don't know, Can't say.
\item -9 No answer/ Refused
}
}
\examples{

\dontrun{

data_2011 <- read_SHeS_2011("X:/",
"ScHARR/PR_Tobacco_mup/Data/Scottish Health Survey/SHeS 2011/UKDA-7247-tab/tab/shes11i_v5.tab")

}

}
