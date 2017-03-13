reshape_coef_part <- function(coef_df_str, constbot)
{
  if (is.null(coef_df_str)) return(NULL)

  ## factorize variable column to keep orders
  coef_levels <- unique(as.character(coef_df_str$variable))
  if (constbot && ('(Intercept)' %in% coef_levels)) {
    coef_levels <- c(setdiff(coef_levels, '(Intercept)'), '(Intercept)')
  }
  coef_df_str$variable <- factor(coef_df_str$variable, levels = coef_levels)

  coef_df_reshaped <- reshape2::melt(coef_df_str,
                                     id.vars = c('modelname', 'variable'),
                                     variable.name = 'statname') %>%
    tidyr::spread_(key = 'modelname', value = 'value', fill = '')
  coef_df_reshaped$variable <- as.character(coef_df_reshaped$variable)
  coef_df_reshaped$statname <- as.character(coef_df_reshaped$statname)

  coef_df_reshaped
}


reshape_opt_part <- function(opt_df_str)
{
  if (is.null(opt_df_str)) return(NULL)

  opt_df_str$variable <- factor(opt_df_str$variable,
                                levels = unique(opt_df_str$variable))

  opt_df_reshaped <- reshape2::melt(opt_df_str,
                                    id.vars = c('modelname', 'variable'),
                                    variable.name = 'statname') %>%
    tidyr::spread_(key = 'modelname', value = 'value', fill = '')
  opt_df_reshaped$variable <- as.character(opt_df_reshaped$variable)
  opt_df_reshaped$statname <- as.character(opt_df_reshaped$statname)

  opt_df_reshaped
}


reshape_stat_part <- function(stat_df_str)
{
  if (is.null(stat_df_str)) return(NULL)


  stat_df_reshaped = reshape2::melt(stat_df_str,
                                    id.vars = c('modelname', 'variable'),
                                    variable.name = 'statname') %>%
    tidyr::spread_(key = 'modelname', value = 'value', fill = '')
  stat_df_reshaped$statname <- as.character(stat_df_reshaped$statname)

  stat_df_reshaped
}


