
format_coef_part <- function(coef_df,
                             alpha = c(0.1, 0.05, 0.01), digits = 3L,
                             bracket = c('se'), starred = c('se'), ...)
{
  stopifnot(is.data.frame(coef_df))

  star <- rep('', nrow(coef_df))
  if ('pv' %in% names(coef_df)) star <- get_star(coef_df[['pv']], alpha, ...)

  fmt_real <- sprintf('%%.%df', digits)
  var_list <- intersect(names(coef_df), .coef_part_meta$real_vars)
  for (j in var_list) coef_df[[j]] <- sprintf(fmt_real, coef_df[[j]])

  var_list <- intersect(names(coef_df), starred)
  for (j in var_list) coef_df[[j]] <- paste0(coef_df[[j]], star)


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

  fmt_real <- sprintf('%%.%df', digits)
  var_list <- intersect(names(stat_df), .stat_part_meta$real_vars)
  for (j in var_list) stat_df[[j]] <- sprintf(fmt_real, stat_df[[j]])

  for (j in seq_along(stat_df))
  {
    if (is.numeric(stat_df[[j]])) stat_df[[j]] <- as.character(stat_df[[j]])
  }

  stat_df
}

