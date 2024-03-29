
#' Read the Health Survey for England 2008
#'
#' Reads and does basic cleaning on the Health Survey for England 2008.
#'
#' @section Survey details:
#' The HSE 2008 included a general population sample of adults and children, representative of the whole population at both national and regional level, and a boost sample of children aged
#' 2-15. A sub-sample was identified in which the main survey was supplemented with objective measures of physical activity and fitness. For the general population sample, 16,056 addresses were randomly selected in 1,176 postcode sectors, issued over twelve months from January to December 2008. Where an address was found to have multiple dwelling units, one was selected at random. Where there were multiple households at a dwelling unit, up to three households were included, and if there were more than three, a random selection was made.
#' At each address, all households, and all persons in them, were eligible for inclusion in the survey. Where there were three or more children aged 0-15 in a household, two of the children were selected at random. A nurse visit was arranged for all participants who consented.
#'
#' In addition to the core general population sample, a boost sample of children aged 2-15 was selected using 19,404 addresses. These were drawn from 996 of the core sampling points. As for the core sample, where there were three or more children in a household, two of the children were selected at random to limit the respondent burden for parents. There was no nurse follow up for this child boost sample.
#'
#' A sub-sample was identified in which the main survey was supplemented with objective measures of physical activity and fitness. The sub-sample was taken in 384 sampling points, including both core and boost addresses. Up to two individuals in the sub-sample households were selected to wear an accelerometer to measure physical activity; in households where both adults and children of the appropriate age were interviewed, an adult and a child were selected. In these households, eligible adults aged 16-74 were offered the step test in the nurse visit, to measure fitness.
#'
#' A total of 15,102 adults and 7,521 children were interviewed in 2008, with 3,473 children from the core sample and 4,048 from the boost. A household response rate of 64%was achieved for the core sample, and 73%for the boost sample. Among the general population sample, 10,740 adults and 2,464 children had a nurse visit.
#'
#' The 2008 survey focused on physical activity and fitness levels. Participants were interviewed, and for those in the core sample this was followed by a visit from a specially trained nurse. Adults and children were asked modules of questions including general health, fruit and vegetable consumption, alcohol consumption and smoking, as well as physical activity.
#'
#' @section Weighting:
#'
#' Individual weight
#'
#' For analyses at the individual level, the weighting variable to use is (wt_int). These weights are generated separately for adults and children:
#' \itemize{
#' \item for adults (aged 16 or more), the interview weights are a combination of the householdweight and a component which adjusts the sample to reduce bias from individual non-response within households;
#' \item for children (aged 0 to 15), the weights are generated from the household weights and the child selection weights – the selection weights correct for only including a maximum of two children in a household. The combined household and child selection weight were adjusted to ensure that the weighted age/sex distribution matched that of all children in co-operating households.
#' }
#' For analysis of children aged 0-15 in both the Core and the Boost sample, taking into account child selection only and not adjusting for non-response, the (wt_child) variable can be used. For analysis of children aged 2-15 in the only Boost sample the (wt_childb) variable can
#'
#' @section Missing values:
#'
#' \itemize{
#' \item -1 Not applicable: Used to signify that a particular variable did not apply to a given respondent
#' usually because of internal routing. For example, men in women only questions.
#' \item -2 Schedule not applicable: Used mainly for variables on the self-completions when the
#' respondent was not of the given age range, also used for children without legal guardians in the
#' home who could not participate in the nurse schedule.
#' \item -8 Don't know, Can't say.
#' \item -9 No answer/ Refused
#' }
#'
#' @template read-data-description
#'
#' @template read-data-args
#'
#' @importFrom data.table :=
#'
#' @return Returns a data table. Note that:
#' \itemize{
#' \item Missing data ("NA", "", "-1", "-2", "-6", "-7", "-8", "-9", "-90", "-90.0", "N/A") is replaced with NA.
#' \item All variable names are converted to lower case.
#' \item The cluster and probabilistic sampling unit have the year appended to them.
#' }
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' data_2008 <- read_2008("X:/", "ScHARR/PR_Consumption_TA/HSE/HSE 2008/UKDA-6397-tab/tab/hse08ai.tab")
#'
#' }
#'
read_2008 <- function(
    root = c("X:/", "/Volumes/Shared/")[1],
    file = "HAR_PR/PR/Consumption_TA/HSE/Health Survey for England (HSE)/HSE 2008/UKDA-6397-tab/tab/hse08ai.tab",
    select_cols = c("tobalc", "all")[1]
) {

  ##################################################################################
  # General population

  data <- data.table::fread(
    paste0(root, file),
    na.strings = c("NA", "", "-1", "-2", "-6", "-7", "-8", "-9", "-90", "-90.0", "N/A"))

  data.table::setnames(data, names(data), tolower(names(data)))

  if(select_cols == "tobalc") {

    alc_vars <- colnames(data[ , 445:522])
    smk_vars <- colnames(data[ , 1831:1981])
    health_vars <- paste0("compm", 1:15)

    other_vars <- Hmisc::Cs(
      mintb, addnum,
      psu, cluster, wt_int,
      hserial,pserial,
      age, sex,
      origin,
      qimd, econact, nssec3, nssec8,
      #econact2, #paidwk,
      activb, #HHInc,
      children, infants,
      educend, topqual3,
      eqv5, #eqvinc,

      marstatc, # marital status inc cohabitees

      # how much they weigh
      htval, wtval)

    names <- c(other_vars, alc_vars, smk_vars, health_vars)

    names <- tolower(names)

    data <- data[ , names, with = F]

  }

  data.table::setnames(data, c("marstatc", "origin", "pserial"), c("marstat", "ethnicity_raw", "hse_id"))

  data[ , psu := paste0("2008_", psu)]
  data[ , cluster := paste0("2008_", cluster)]

  data[ , year := 2008]
  data[ , country := "England"]

  data[ , quarter := c(1:4)[findInterval(mintb, c(1, 4, 7, 10))]]
  data[ , mintb := NULL]

  return(data[])
}



