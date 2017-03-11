
format_coef_part <- function(coef_df,
                             alpha = c(0.1, 0.05, 0.01), digits = 3L,
                             bracket = c('se'), starred = c('se'), ...)
{
  stopifnot(is.data.frame(coef_df))

  var_list <- intersect(names(coef_df), .stats_meta$coef_part$variable_name)
  for (j in var_list) coef_df[[j]] <- round(coef_df[[j]], digits)

  if ('pv' %in% names(coef_df)) {
    star <- get_star(coef_df[['pv']], alpha, ...)
    var_list <- intersect(names(coef_df), starred)
    for (j in var_list) coef_df[[j]] <- paste0(coef_df[[j]], star)
  }

  var_list <- intersect(names(coef_df), bracket)
  for (j in var_list) coef_df[[j]] <- paste0('[', coef_df[[j]], ']')

  for (j in seq_along(coef_df))
  {
    if (is.numeric(coef_df[[j]])) coef_df[[j]] <- as.character(coef_df[[j]])
  }
  coef_df
}


format_stat_part <- function(stat_df, digits = 3L, ...)
{
  stopifnot(is.data.frame(stat_df))

  var_list <- intersect(names(stat_df), .stats_meta$stat_part$variable_name)
  for (j in var_list) stat_df[[j]] <- round(stat_df[[j]], digits)

  for (j in seq_along(stat_df))
  {
    if (is.numeric(stat_df[[j]])) stat_df[[j]] <- as.character(stat_df[[j]])
  }

  stat_df
}

