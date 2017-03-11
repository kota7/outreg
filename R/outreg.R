

#' Generate Regression Table
#' @param fitlist list of regression outcomes
#' @param digits number of digit to real numbers
#' @param alpha  vector of significance levels to star
#' @param displayed vector of stats names to display
#' @param bracket stats to be in brackets
#' @param starred stats to star
#' @param robust if TRUE, robust standard error is used
#' @param small if TRUE, small sample parameter distribution is used
#' @examples
#' fitlist <- list(lm(mpg ~ cyl, data = mtcars),
#'                 lm(mpg ~ cyl + wt + hp, data = mtcars),
#'                 lm(mpg ~ cyl + wt + hp + drat, data = mtcars))
#' outreg(fitlist)
#' @export
outreg <- function(fitlist,
                   digits = 3L, alpha = c(0.1, 0.05, 0.01),
                   displayed = c('coef', 'se', 'nobs', 'R2', 'adjR2'),
                   bracket = c('se'), starred = c('coef'),
                   robust = FALSE, small = FALSE)
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
  stat_df_reshaped = reshape2::melt(stat_df_str,
                                    id.vars = 'modelname',
                                    variable.name = 'statname') %>%
    tidyr::spread_(key = 'modelname', value = 'value', fill = '')

  # add dummy variable column to stat
  stat_df_reshaped$variable = ''
  stat_df_reshaped <- stat_df_reshaped[names(coef_df_reshaped)]

  out <- rbind(coef_df_reshaped, stat_df_reshaped)

  out <- out[out$statname %in% displayed,]
  out$statname <- .display_names[out$statname] %>% unlist() %>% unname()

  out
}
