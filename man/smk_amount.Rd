% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/smk_amount.R
\name{smk_amount}
\alias{smk_amount}
\title{Characteristics of smoking}
\usage{
smk_amount(data)
}
\arguments{
\item{data}{Data table - the health survey dataset.}
}
\value{
\itemize{
\item cigs_per_day - numeric (0+)
\item smoker_cat (non_smoker, 10_or_less, 11_to_20, 21_to_30, 31_or_more)
\item banded_consumption (non_smoker, light, moderate, heavy)
\item cig_type (non_smoker, hand rolled, machine rolled)
\item units_RYO_tob - numeric (0+) (years 2013+)
\item units_FM_cigs - numeric (0+) (years 2013+)
\item prop_handrolled - numeric (0-1) (years 2013+)
\item time_to_first_cig (non_smoker, less_than_5_minutes, five_to_thirty_minutes,
thirty_minutes_but_less_than_1_hour, one_hour_or_more)
}
}
\description{
Clean the variables that describe how many cigarettes per day people smoke on average, and to what level of addiction people smoke.
}
\details{
The main variable is the average number of cigarettes smoked per day. For adults, this is calculated
from questions about how many cigarettes are smoked typically on a weekday vs. a weekend
(this is a weighted average to account for more weekdays in a week than weekends). For children,
this is based on asking how many cigarettes were smoked in the last week. Missing values are imputed as
the average amount smoked for an age, sex and Index of Multiple Deprivation quintile subgroup.

For England, cigarette preferences are categorised based on the answer to 'what is the main type of cigarette smoked'. In
later years of the Health Survey for England, new questions are added from year 2013 that ask how many handrolled vs. machine rolled
cigarettes are smoked on a weekday vs. a weekend.

For England, information on the time from waking until smoking the first cigarette of the day is used.
The time from waking until first smoking has a high level of missingness. Together with data on the number of cigarettes smoked per day
these data allow calculation of
 \href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3307335/}{the heaviness of smoking index}.

For Scotland, people who smoke handrolled cigarettes so cannot give the amount that they typically smoke per day in terms of cigarettes
report the amount smoked in either grams or ounces of tobacco typically smoked per day. In these cases, a conversion rate of
0.5g tobacco per cigarette it used. The corresponding number of cigarettes smoked per day is calculated and added to any
machine rolled cigarette consumption recorded for that smoker.

For Scotland, the health survey data do not allow the estimation of the proportional split in tobacco consumption
between machine rolled and handrolled cigarettes.

The average number of cigarettes per day is capped at a theoretical maximum of 60 per day.
}
\examples{

\dontrun{

library(hseclean)

data <- read_2017(root = "/Volumes/Shared/")
data <- clean_age(data)
data <- clean_demographic(data)
data <- smk_status(data)
data <- smk_amount(data)

}

}
