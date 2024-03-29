% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/impute_data_mice.R
\name{impute_data_mice}
\alias{impute_data_mice}
\title{Chained multiple imputation of a set of variables}
\usage{
impute_data_mice(data, var_names, var_methods, n_imputations)
}
\arguments{
\item{data}{Data table - the Health Survey for England dataset with missing values}

\item{var_names}{Character vector - the names of the variables to be considered in the multiple imputation.}

\item{var_methods}{Character vector - the names of the statistical methods to be used to predict each of
the above variables - see the mice documentation.}

\item{n_imputations}{Integer - the number of different versions of the imputed data to produce.}
}
\value{
Returns a list containing
\itemize{
\item{data} All versions of the multiply imputed data in a single data table.
\item{object} The mice multiple imputation object.
}
}
\description{
This function uses the \href{https://cran.r-project.org/web/packages/mice/mice.pdf}{mice} package to
multiply impute missing values based on the statistical relationships among a set of variables.
There is a range of mice documentation and tutorials that is worth getting into to develop and check this function.
}
\examples{

\dontrun{

# "logreg" - binary Logistic regression
# "polr" - ordered Proportional odds model
# "polyreg" - unordered Polytomous logistic regression

imp_obj <- impute_data_mice(
  data = test_data,
  c("binary_variable", "order_categorical_variable", "unordered_categorical_variable"),
  c("logreg", "polr", "polyreg"),
  n_imputations = 5
)

}

}
