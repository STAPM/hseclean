
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Health Survey Data Wrangling <img src="logo.png" align="right" style="padding-left:10px;background-color:white;" width="100" height="100" />

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
<!-- badges: end -->

## Motivation

`hseclean` was created as part of a programme of work on the health
economics of tobacco and alcohol at the School of Health and Related
Research (ScHARR), The University of Sheffield. This programme is based
around the construction of the Sheffield Tobacco and Alcohol Policy
Model (STAPM), which aims to use comparable methodologies to evaluate
the impacts of tobacco and alcohol policies, and investigate the
consequences of clustering and interactions between tobacco and alcohol
consumption behaviours.

The original motivation for `hseclean` was to standardised the way that
the Health Survey for England (HSE) data were cleaned and prepared for
our analyses and inputs to our decision-analytic models. The
[HSE](https://digital.nhs.uk/data-and-information/publications/statistical/health-survey-for-england)
is a series of annual surveys covering health and health-related
behaviours. The suite of functions within `hseclean` reads the data for
each year since 2001, renames, organises and processes the variables
that we use for our analyses. The package also includes functions to
multiply impute missing data, and to summarise data considering survey
design.

We have subsequently added functions to process the Scottish Health
Survey (SHeS) into a form that matches our processing of the Health
Survey for England.

> Health Survey for England and Scottish Health Survey data are accessed
> via the UK Data Service. `hseclean` is designed to read the tab
> delimited files.

## Usage

`hseclean` is a package for reading and cleaning the Health Survey for
England and Scottish Health Survey data.

The **inputs** are the raw survey data files for each year.

The **processes** applied by the functions in `hseclean` give options
to:

1.  Read tobacco and alcohol related variables and the information on
    individual characteristics that we use in our analyses.  
2.  Clean alcohol consumption data, applying assumptions about beverage
    size and alcohol content.  
3.  Clean data on current smoking and smoking history.  
4.  Clean data on individual characteristics including age, sex,
    ethnicity, economic status, family, health and income.  
5.  Multiply impute missing data.  
6.  Summarise categorical variables using proportions, considering
    survey design.

The **output** of these processes is a cleaned dataset that is ready for
further analysis. This dataset can be saved so that you don’t need to
run the cleaning processes in `hseclean` each time you want to use the
cleaned data.

## Installation

`hseclean` is currently available only to members of the project team
(but please contact Duncan Gillespie <duncan.gillespie@sheffield.ac.uk>
to discuss). To access you need to [**sign-up for a GitLab
account**](https://gitlab.com/). You will then need to be added to the
STAPM project team to gain access.

Once that is sorted, you can **install the development version of
`hseclean`** from GitLab with:

``` r
#install.packages("devtools")
#install.packages("getPass")

devtools::install_git(
  "https://gitlab.com/stapm/hseclean.git", 
  credentials = git2r::cred_user_pass("uname", getPass::getPass()),
  ref = "x.x.x",
  build_vignettes = TRUE
)

# Where uname is your Gitlab user name.
# ref = "x.x.x" is the version to install - change to the version you want e.g. "1.2.3"
# this should make a box pop up where you enter your GitLab password
```

Then load the package, and some other packages that are useful. Note
that the code within `hseclean` uses the `data.table::data.table()`
syntax.

``` r
# Load the package
library(hseclean)

# Other useful packages
library(dplyr) # for data manipulation and summary
library(magrittr) # for pipes
library(ggplot2) # for plotting
```

## Citation

Please cite the latest version of the package using:  
“Duncan Gillespie, Laura Webster, Colin Angus and Alan Brennan (2020).
hseclean: Health Survey Data Wrangling. R package version x.x.x.
<https://stapm.gitlab.io/hseclean>.”
