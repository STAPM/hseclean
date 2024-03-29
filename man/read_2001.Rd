% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_2001.R
\name{read_2001}
\alias{read_2001}
\title{Read the Health Survey for England 2001}
\usage{
read_2001(
  root = c("X:/", "/Volumes/Shared/")[1],
  file =
    "HAR_PR/PR/Consumption_TA/HSE/Health Survey for England (HSE)/HSE 2001/UKDA-4628-tab/tab/hse01ai.tab",
  select_cols = c("tobalc", "all")[1]
)
}
\arguments{
\item{root}{Character string - the root directory. This is the section of the file path to where the data is stored
that might vary depending on how the network drive is being accessed. The default is "X:/",
which corresponds to the University of Sheffield's X drive in the School of Health and Related Research.
Within the function, the root is pasted onto the front of the rest of the file path specified in the 'file' argument.
Thus, if root = NULL, then the complete file path is given in the 'file' argument.}

\item{file}{Character string - the file path and the name and extension of the file. The function has been
designed and tested to work with tab delimited files '.tab'. Files are read by the function [data.table::fread].}

\item{select_cols}{Character string - select either:
"all" - keep all variables in the survey data;
"tobalc" - keep a reduced set of variables associated with tobacco and alcohol consumption and a selected set of
survey design and socio-demographic variables that are needed for the functions within the hseclean package to work.}
}
\value{
Returns a data table. Note that:
\itemize{
\item Each data point is assigned a weight of 1 as there is no weight variable supplied.
\item A single sampling cluster is assigned.
\item The probabilistic sampling unit have the year appended to them.
}
}
\description{
Reads and does basic cleaning on the Health Survey for England 2001.
}
\section{Survey details}{

A sample of the population living in private households. All persons living in the house, including those
under 2 years were eligible for inclusion. At addresses where there were more than two children under 16,
two children were selected at random. Information was obtained directly from persons aged 13 and
over. Information about children aged 0-12 was obtained from a parent, with the child present.
}

\section{Weighting}{


There is no weighted variable for household adult data.
For children under 16, the weighted variable Child_Wt should be used.
}

\section{Missing values}{


\itemize{
\item -1 Not applicable: Used to signify that a particular variable did not apply to a given respondent
usually because of internal routing. For example, men in women only questions.
\item -2 Schedule not applicable: Used mainly for variables on the self-completions when the
respondent was not of the given age range, also used for children without legal guardians in the
home who could not participate in the nurse schedule.
\item -6 Schedule not obtained: Used to signify that a particular variable was not answered because the
respondent did not complete or agree to a particular schedule (i.e. nurse schedule or selfcompletions).
\item -7 Refused/ not obtained: Used only for variables on the nurse schedules, this code indicates that a
respondent refused a particular measurement or test or the measurement was attempted but not
obtained or not attempted.
\item -8 Don't know, Can't say.
\item -9 No answer/ Refused
}
}

\section{How the data is read and processed}{

The data is read by the function [data.table::fread]. The 'root' and 'file' arguments are
pasted together to form the file path. The following are converted to NA:
c("NA", "", "-1", "-2", "-6", "-7", "-8", "-9", "-90", "-90.0", "-99", "N/A").
All variable names are converted to lower case.
The cluster and probabilistic sampling unit have the year appended to them.
Some renaming of variables is done for consistency with other years.
}

\examples{

\dontrun{

data_2001 <- read_2001("X:/", "ScHARR/PR_Consumption_TA/HSE/HSE 2001/UKDA-4628-tab/tab/hse01ai.tab")

}

}
