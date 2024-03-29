% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_2005.R
\name{read_2005}
\alias{read_2005}
\title{Read the Health Survey for England 2005}
\usage{
read_2005(
  root = c("X:/", "/Volumes/Shared/")[1],
  file =
    "HAR_PR/PR/Consumption_TA/HSE/Health Survey for England (HSE)/HSE 2005/UKDA-5675-tab/tab/hse05ai.tab",
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
Returns a data table.
}
\description{
Reads and does basic cleaning on the Health Survey for England 2005.
}
\section{Survey details}{

The Health Survey for England 2005 was designed to provide data at both national and regional level about the population living in private households in England. The sample for the HSE 2005 comprised of three components: the core (general population) sample, a boost sample of people aged 65 and over (those living in institutions were not included) and a boost sample of children aged 2-15. The core sample was designed to be representative of the population living in private households in England and should be used for analyses at the national level.

A random sample of 720 postcode sectors was then selected with probability proportional to the total number of addresses within them. Once selected, the PSUs were randomly allocated to the 12 months of the year (60 per month) so that each quarter provided a nationally representative sample.

Within each selected postcode sector, a sample of 26 delivery points was selected, giving a total selected sample of 18,720 (720 x 26) addresses. From the 26 addresses within each postcode sector, ten were selected at random and allocated to the core sample, and the remaining 16 addresses were allocated to the boost sample.

All private households in the general population sample are eligible for inclusion in the survey (up to a maximum of three households per address). For the core sample, up to two children aged 0-15 are interviewed in each household, as well as up to 10 adults aged 16 and over.

At boost addresses interviewers screened for households containing at least one person of either of the age groups covered in the boost: persons aged 65 and over, or (for certain months) children aged 2-15 years. Because of funding restrictions, the boost included children only during January, February, October, November and December. At each household where people of the eligible ages were found, all persons aged 65 and over and up to two eligible children were selected by the interviewer for inclusion in the survey.

An interview with each eligible person was followed by a nurse visit both using computer assisted interviewing. The 2005 survey for adults focused on the health of older people. All adults were asked modules of questions on general health, alcohol consumption, smoking, fruit and vegetable consumption and complementary and alternative medicine. Older informants were also asked about use of health, dental and social care services, cardiovascular disease (CVD), chronic diseases and quality of care, disabilities and falls. Older informants in the boost sample were asked a slightly shorter questionnaire, omitting questions about fruit and vegetable consumption and complementary and alternative medicines.

Children aged 13-15 were interviewed themselves, and parents of children aged 0-12 were asked about their children, with the child interview including questions on physical activity and fruit and vegetable consumption.
}

\section{Weighting}{


Individual weight

For analyses at the individual level, the weighting variable to use is wt_int. These weights are generated separately for adults and children:
\itemize{
\item for adults (aged 16 or more), the interview weights are a combination of the household weight and a component which adjusts the sample to reduce bias from individual non-response within households;
\item for children (aged 0 to 15), the weights are generated from the household weights and the child selection weights – the selection weights correct for only including a maximum of two children in a household. The combined household and child selection weight were adjusted to ensure that the weighted age/sex distribution matched that of all children in co-operating households.
}
For analysis of children aged 0-15 in the Core sample, taking into account child selection only and not adjusting for non-response, the child_wt variable can be used.
}

\section{Missing values}{


\itemize{
\item -1 Not applicable: Used to signify that a particular variable did not apply to a given respondent
usually because of internal routing. For example, men in women only questions.
\item -2 Schedule not applicable: Used mainly for variables on the self-completions when the
respondent was not of the given age range, also used for children without legal guardians in the
home who could not participate in the nurse schedule.
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

data_2005 <- read_2005("X:/", "ScHARR/PR_Consumption_TA/HSE/HSE 2005/UKDA-5675-tab/tab/hse05ai.tab")

}

}
