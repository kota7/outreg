
.stats_meta <- list(
  coef_part = data.frame(
    variable_name = c('coef', 'se', 'pv', 'tv'),
    display_name  = c('Estimate', 'Std. Error', 'p Value', 't Value'),
    stringsAsFactors = FALSE
  ),

  stat_part = data.frame(
    variable_name = c('nobs', 'R2', 'adjR2'),
    display_name  = c('N', 'R2', 'adj. R2')
  )
)


