

#' Generate Regression Table
#' @param fitlist list of regression outcomes
#' @param digits number of digit to real numbers
#' @param alpha  vector of significance levels to star
#' @param coef show coefficients
#' @param se show standard errors
#' @param pv show p values
#' @param tv show t values
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
#' @export
outreg <- function(fitlist,
                   digits = 3L, alpha = c(0.1, 0.05, 0.01),
                   coef = TRUE, se = TRUE, pv = FALSE, tv = FALSE,
                   bracket = c('se'), starred = c('coef'),
                   robust = FALSE, small = TRUE)
{
  coef_df <- NULL
  stat_df <- NULL
  for (i in seq_along(fitlist))
  {
    fit <- fitlist[[i]]
    modelname <- ifelse(is.null(names(fitlist)),
                        sprintf('Model %d', i), names(fitlist)[i])
    coef_df <- rbind(coef_df, make_coef_part(fit, modelname, robust, small))
    stat_df <- rbind(stat_df, make_stat_part(fit, modelname))
  }

  coef_df_str <- format_coef_part(coef_df, alpha, digits, bracket, starred)
  stat_df_str <- format_stat_part(stat_df, digits)

  # reshape and combine
  ## factorize variable column to keep orders
  coef_df_str$variable <- factor(coef_df_str$variable,
                                 levels = unique(coef_df_str$variable))
  coef_df_reshaped <- reshape2::melt(coef_df_str,
                                     id.vars = c('modelname', 'variable'),
                                     variable.name = 'statname') %>%
    tidyr::spread_(key = 'modelname', value = 'value', fill = '')
  coef_df_reshaped$variable <- as.character(coef_df_reshaped$variable)
  coef_df_reshaped$statname <- as.character(coef_df_reshaped$statname)

  stat_df_reshaped = reshape2::melt(stat_df_str,
                                    id.vars = 'modelname',
                                    variable.name = 'statname') %>%
    tidyr::spread_(key = 'modelname', value = 'value', fill = '')
  stat_df_reshaped$statname <- as.character(stat_df_reshaped$statname)

  # add dummy variable column to stat part
  # so as to consistently bind with coef part
  stat_df_reshaped$variable = ''
  stat_df_reshaped <- stat_df_reshaped[names(coef_df_reshaped)]

  out <- rbind(coef_df_reshaped, stat_df_reshaped)

  displayed <- unique(out$statname)
  if (!coef) displayed <- setdiff(displayed, 'coef')
  if (!se)   displayed <- setdiff(displayed, 'se')
  if (!pv)   displayed <- setdiff(displayed, 'pv')
  if (!tv)   displayed <- setdiff(displayed, 'tv')
  out <- out[out$statname %in% displayed,]
  out$statname <- .display_names[out$statname] %>% unlist() %>% unname()

  out
}
