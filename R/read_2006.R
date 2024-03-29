
#' Read the Health Survey for England 2006
#'
#' Reads and does basic cleaning on the Health Survey for England 2006.
#'
#' @section Survey details:
#' The Health Survey for England 2006 was designed to provide data at both national and regional level about the population living in private households in England. The sample for the HSE 2006 comprised of two components: the core (general population) sample and a boost sample of children aged 2-15. The core sample was designed to be representative of the population living in private households in England and should be used for analyses at the national level. The core sample was split in two for some modules of the 2006 survey, further details are shown in Appendix A.
#'
#' A random sample of 720 PSUs (Primary Sampling Units) was selected for the core sample and 468 PSUs selected for the child boost sample. The PSUs were selected with probability proportional to the total number of addresses within them. Once selected, the PSUs were randomly allocated to the 12 months of the year (60 per month in the core sample, 39 per month in the boost) so that each quarter provided a nationally representative sample.
#'
#' For the core sample, a sample of 20 addresses was selected within each selected postcode sector, giving a total selected sample of 14,400 (720 x 20) addresses. Because PSUs were sampled with probability proportional to the numbers of addresses, and then a fixed number of addresses was sampled in each PSU, every address had an equal chance of being included in the sample. For the child boost sample, a random sample of 36 addresses was selected in each PSU, giving a total sample of 16,848 addresses (468 x 36). The addresses sampled for the child boost sample also had equal probability of being selected for that sample.
#'
#' For the HSE core sample, all adults aged 16 years or older at each household were selected for the interview (up to a maximum of ten adults). However, a limit of two was placed on the number of interviews carried out with children aged 0-15. For households with three or more children, interviewers selected two children at random.
#'
#' At boost addresses interviewers screened for households containing at least one child aged 2-15 years. For households which included eligible children, up to two were selected by the interviewer for inclusion in the survey.
#'
#' An interview with each eligible person was followed by a nurse visit both using computer assisted interviewing (CAPI). The 2006 survey for adults focused primarily on Cardiovascular Disease (CVD) and its risk factors. All adults were also asked modules of questions on general health, alcohol consumption, smoking, fruit and vegetable consumption and physical activity. Adults aged 65 plus were randomly allocated to one of two questionnaire versions to avoid lengthy interviews. This included either the CVD module and a short physical activity module, or a long physical activity module but not the CVD module (further details are provided in section 5). Adults aged 16-64 completed both the CVD and long physical activity modules.
#'
#' Children aged 13-15 were interviewed themselves, and parents of children aged 0-12 were asked about their children, with the child interview including questions on physical activity and fruit and vegetable consumption.
#'
#' @section Weighting:
#'
#' Individual weight
#'
#' For analyses at the individual level, the weighting variable to use is (wt_int). These weights are generated separately for adults and children:
#' \itemize{
#' \item for adults (aged 16 or more), the interview weights are a combination of the household weight and a component which adjusts the sample to reduce bias from individual non-response within households;
#' \item for adults (aged 65 or more) who were in sample type 1 and answered the full CVD module, the interview weights are adjusted accordingly and the weighting variable to use is (wt_int_s1).
#' \item for adults (aged 65 or more) who were in sample type 2 and answered the short version of the physical activity module, the interview weights are adjusted accordingly and the weighting variable to use is (wt_int_s2).
#' \item for children (aged 0 to 15), the weights are generated from the household weights and the child selection weights – the selection weights correct for only including a maximum of two children in a household. The combined household and child selection weight were adjusted to ensure that the weighted age/sex distribution matched that of all children in co-operating households.
#' }
#' For analysis of children aged 0-15 in the Core sample, taking into account child selection only and not adjusting for non-response, the (child_wt) variable can be used.
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
#' @return Returns a data table.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' data_2006 <- read_2006("X:/", "ScHARR/PR_Consumption_TA/HSE/HSE 2006/UKDA-5809-tab/tab/hse06ai.tab")
#'
#' }
#'
read_2006 <- function(
    root = c("X:/", "/Volumes/Shared/")[1],
    file = "HAR_PR/PR/Consumption_TA/HSE/Health Survey for England (HSE)/HSE 2006/UKDA-5809-tab/tab/hse06ai.tab",
    select_cols = c("tobalc", "all")[1]
) {

  ##################################################################################
  # General population

  data <- data.table::fread(
    paste0(root, file),
    na.strings = c("NA", "", "-1", "-2", "-6", "-7","-8",  "-9", "-90", "-90.0", "N/A"))

  data.table::setnames(data, names(data), tolower(names(data)))

  if(select_cols == "tobalc") {

    alc_vars <- colnames(data[ , 730:801])
    smk_vars <- colnames(data[ , 1689:1762])
    health_vars <- paste0("compm", 1:15)

    other_vars <- Hmisc::Cs(
      mintb, addnum,
      psu, cluster, wt_int, child_wt,
      hserial,pserial,
      age, sex,
      ethinda,
      imd2004, econact, nssec3, nssec8,
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

  data.table::setnames(data, c("imd2004", "d7unit", "marstatc", "ethinda", "pserial"),
                       c("qimd", "d7unitwg", "marstat", "ethnicity_raw", "hse_id"))

  data[ , psu := paste0("2006_", psu)]
  data[ , cluster := paste0("2006_", cluster)]

  data[ , year := 2006]
  data[ , country := "England"]

  data[ , quarter := c(1:4)[findInterval(mintb, c(1, 4, 7, 10))]]
  data[ , mintb := NULL]

  return(data[])
}




