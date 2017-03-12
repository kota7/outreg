
format_coef_part <- function(coef_df,
                             alpha = c(0.1, 0.05, 0.01), digits = 3L,
                             bracket = c('se'), starred = c('se'), ...)
{
  if (is.null(coef_df)) return(NULL)
  stopifnot(is.data.frame(coef_df))

  # remeber NA positions
  na_pos <- lapply(coef_df, function(v) which(is.na(v)))

  # make sure all variables are not factor
  coef_df <- unfactor_df(coef_df)

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

  for (j in seq_along(coef_df)) coef_df[na_pos[[j]],j] <- ''

  coef_df
}



format_opt_part <- function(opt_df, digits = 3L, ...)
{
  if (is.null(opt_df)) return(NULL)
  stopifnot(is.data.frame(opt_df))

  # remeber NA positions
  na_pos <- lapply(opt_df, function(v) which(is.na(v)))

  # make sure all variables are not factor
  opt_df <- unfactor_df(opt_df)

  fmt_real <- sprintf('%%.%df', digits)
  var_list <- intersect(names(opt_df), .opt_part_meta$real_vars)
  for (j in var_list) opt_df[[j]] <- sprintf(fmt_real, opt_df[[j]])


  for (j in seq_along(opt_df))
  {
    if (is.numeric(opt_df[[j]])) opt_df[[j]] <- as.character(opt_df[[j]])
  }

  # give '' to NA positions
  for (j in seq_along(opt_df)) opt_df[na_pos[[j]],j] <- ''

  opt_df
}



format_stat_part <- function(stat_df, digits = 3L, ...)
{
  if (is.null(stat_df)) return(NULL)
  stopifnot(is.data.frame(stat_df))

  # remeber NA positions
  na_pos <- lapply(stat_df, function(v) which(is.na(v)))

  # make sure all variables are not factor
  stat_df <- unfactor_df(stat_df)

  fmt_real <- sprintf('%%.%df', digits)
  var_list <- intersect(names(stat_df), .stat_part_meta$real_vars)
  for (j in var_list) stat_df[[j]] <- sprintf(fmt_real, stat_df[[j]])

  var_list <- numeric(0)
  for (key in .stat_part_meta$real_var_keys)
    var_list <- union(var_list, grep(key, names(stat_df)))
  for (j in var_list)
  {
    if (is.numeric(stat_df[[j]]))
        stat_df[[j]] <- sprintf(fmt_real, stat_df[[j]])
  }

  for (j in seq_along(stat_df))
  {
    if (is.numeric(stat_df[[j]])) stat_df[[j]] <- as.character(stat_df[[j]])
  }

  for (j in seq_along(stat_df)) stat_df[na_pos[[j]],j] <- ''

  stat_df
}

