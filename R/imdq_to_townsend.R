
#' Probabilistic mapping of Index of Multiple Deprivation to Townsend quintiles
#'
#' A matrix that maps quintiles of the Index of Multiple Deprivation onto the Townsend Index of Deprviation.
#'
#' To produce this We used area-level \href{https://census.ukdataservice.ac.uk/get-data/related/deprivation}{Office for National Statistics data} to estimate the statistical association between the two metrics of deprivation,
#' We used estimates of the Townsend Index from 2001 Census data at Ward level,
#' and the Index of Multiple Deprivation 2015 (IMD 2015) at Lower-layer Super Output Area (LSOA) level.
#' First, we mapped the \href{https://data.gov.uk/dataset/fe6e0ebc-8def-4cc6-a228-1968ccca3dd2/lower-layer-super-output-area-2001-to-ward-2001-lookup-in-england-and-wales}{2001 definitions of Wards to the 2001 definitions of LSOAs}.
#' Second, we mapped the \href{https://data.gov.uk/dataset/afc2ed54-f1c5-44f3-b8bb-6454eb0153d0/lower-layer-super-output-area-2001-to-lower-layer-super-output-area-2011-to-local-authority-district-2011-lookup-in-england-and-wales}{2001 definitions of LSOAs to the 2011 definitions of LSOAs that are used by the IMD 2015}.
#'
#' @docType data
#'
#' @format A data table
#'
#' @source See code in the data-raw folder of the hseclean package.
#'
#'
#'
"imdq_to_townsend"
