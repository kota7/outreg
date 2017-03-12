

#' Generate Regression Table
#' @param fitlist list of regression outcomes
#' @param digits number of digit to real numbers
#' @param alpha  vector of significance levels to star
#' @param coef show coefficients
#' @param se show standard errors
#' @param pv show p values
#' @param tv show t values
#' @param zv show z values
#' @param bracket stats to be in brackets
#' @param starred stats to put stars on
#' @param robust if TRUE, robust standard error is used
#' @param small if TRUE, small sample parameter distribution is used
#' @return regression table in data.frame format
#' @examples
#' fitlist <- list(lm(mpg ~ cyl, data = mtcars),
#'                 lm(mpg ~ cyl + wt + hp, data = mtcars),
#'                 lm(mpg ~ cyl + wt + hp + drat, data = mtcars))
#' outreg(fitlist)
#'
#' # with custom regression names
#' outreg(setNames(fitlist, c('small', 'medium', 'large')))
#'
#' # star on standard errors, instead of estimate
#' outreg(fitlist, starred = 'se')
#'
#' # include other stats
#' outreg(fitlist, pv = TRUE, tv = TRUE, se = FALSE)
#'
#'
#' # poisson regression
#' counts <- c(18,17,15,20,10,20,25,13,12)
#' outcome <- gl(3,1,9)
#' treatment <- gl(3,3)
#' fitlist2 <- list(glm(counts ~ outcome, family = poisson()),
#'                  glm(counts ~ outcome + treatment, family = poisson()))
#' outreg(fitlist2)
#'
#'
#' # logistic regression
#' fitlist3 <- list(glm(cbind(ncases, ncontrols) ~ agegp,
#'                      data = esoph, family = binomial()),
#'                  glm(cbind(ncases, ncontrols) ~ agegp + tobgp + alcgp,
#'                      data = esoph, family = binomial()),
#'                  glm(cbind(ncases, ncontrols) ~ agegp + tobgp * alcgp,
#'                      data = esoph, family = binomial()))
#' outreg(fitlist3)
#'
#'
#' # survival regression
#' library(survival)
#' fitlist4 <- list(survreg(Surv(time, status) ~ ph.ecog + age,
#'                          data = lung),
#'                  survreg(Surv(time, status) ~ ph.ecog + age + strata(sex),
#'                          data = lung))
#' outreg(fitlist4)
#'
#'
#' # tobit regression
#' fitlist5 <- list(survreg(Surv(durable, durable>0, type='left') ~ 1,
#'                  data=tobin, dist='gaussian'),
#'                  survreg(Surv(durable, durable>0, type='left') ~ age + quant,
#'                  data=tobin, dist='gaussian'))
#' outreg(fitlist5)
#'
#'
#' # instrumental variable regression
#' library(AER)
#' data("CigarettesSW", package = "AER")
#' CigarettesSW$rprice <- with(CigarettesSW, price/cpi)
#' CigarettesSW$rincome <- with(CigarettesSW, income/population/cpi)
#' CigarettesSW$tdiff <- with(CigarettesSW, (taxs - tax)/cpi)
#'
#' fitlist6 <- list(OLS = lm(log(packs) ~ log(rprice) + log(rincome),
#'                           data = CigarettesSW, subset = year == "1995"),
#'                  IV1 = ivreg(log(packs) ~ log(rprice) + log(rincome) |
#'                              log(rincome) + tdiff + I(tax/cpi),
#'                              data = CigarettesSW, subset = year == "1995"),
#'                  IV2 = ivreg(log(packs) ~ log(rprice) + log(rincome) |
#'                              log(population) + tdiff + I(tax/cpi),
#'                              data = CigarettesSW, subset = year == "1995"))
#' outreg(fitlist6)
#'
#' @export
outreg <- function(fitlist,
                   digits = 3L, alpha = c(0.1, 0.05, 0.01),
                   coef = TRUE, se = TRUE, pv = FALSE, tv = FALSE, zv = FALSE,
                   bracket = c('se'), starred = c('coef'),
                   robust = FALSE, small = TRUE)
{
  # check the class of fitlist object

  ## if a single fit is given, put it in a list
  if (is_supported(fitlist)) fitlist <- list(fitlist)


  if (!is.list(fitlist)) stop('fitlist must be a list of model objects')


  flg <- lapply(fitlist, is_supported) %>% unlist()
  if (any(!flg))
    stop('Unsupported object at: ', paste(which(!flg), collapse = ', '))



  coef_df <- list(NULL, NULL)
  opt_df <- NULL
  stat_df <- NULL

  modelnames_true <- paste('Model', seq_along(fitlist))
  if (!is.null(names(fitlist))) {
    flg <- !is.na(names(fitlist))
    modelnames_true[flg] <- names(fitlist)[flg]
  }
  # make temporary model names
  invalid_names <- c('variable', 'statname', 'value', 'stat1', 'stat2')
  modelnames <- make_unique(c(invalid_names, modelnames_true)) %>%
    tail(length(modelnames_true))

  for (i in seq_along(fitlist))
  {
    fit <- fitlist[[i]]
    modelname <- modelnames[i]

    # coef part, possibly splitted into two
    tmp <- make_coef_part(fit, modelname, robust, small)
    if (is.data.frame(tmp)) {
      coef_df[[1]] <- lazy_rbind(coef_df[[1]], tmp)
    } else if (is.list(tmp)) {
      for (j in seq_along(tmp))
        coef_df[[j]] <- lazy_rbind(coef_df[[j]], tmp[[j]])
    }
    stat_df <- lazy_rbind(stat_df, make_stat_part(fit, modelname, robust))
    opt_df <- lazy_rbind(opt_df, make_opt_part(fit, modelname, robust))
  }

  # stack coef parts
  coef_df <- do.call('rbind', coef_df)
  coef_df_str <- format_coef_part(coef_df, alpha, digits, bracket, starred)
  stat_df_str <- format_stat_part(stat_df, digits)
  opt_df_str  <- format_opt_part(opt_df, digits)

  # reshape each part
  coef_df_reshaped <- reshape_coef_part(coef_df_str)
  stat_df_reshaped <- reshape_stat_part(stat_df_str)
  opt_df_reshaped  <- reshape_opt_part(opt_df_str)

  out <- lazy_rbind(coef_df_reshaped, stat_df_reshaped, '') %>%
    lazy_rbind(opt_df_reshaped, '')

  displayed <- unique(out$statname)
  if (!coef) displayed <- setdiff(displayed, 'coef')
  if (!se)   displayed <- setdiff(displayed, 'se')
  if (!pv)   displayed <- setdiff(displayed, 'pv')
  if (!tv)   displayed <- setdiff(displayed, 'tv')
  if (!zv)   displayed <- setdiff(displayed, 'zv')
  out <- out[out$statname %in% displayed,]
  out$statname[out$statname %in% names(.display_names)] <-
    .display_names[out$statname] %>% unlist() %>% unname()


  out <- out[c('variable', 'statname', modelnames)]
  names(out) <- c('.variable', '.stat', modelnames_true)
  out
}



is_supported <- function(fit)
{
  # check if fit is a supported class object

  inherits(fit, 'lm') || inherits(fit, 'glm') ||
  inherits(fit, 'survreg') || inherits(fit, 'ivreg')
}

