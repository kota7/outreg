
.coef_part_meta <- list(
  all_vars = c('coef', 'se', 'pv', 'tv'),
  real_vars = c('coef', 'se', 'pv', 'tv'),
  display_names = hash::hash(coef = 'Estimate', se = 'Std. Error',
                             pv = 'p Value', tv = 't Value')
)

.stat_part_meta <- list(
  all_vars = c('R2', 'adjR2', 'nobs'),
  real_vars = c('R2', 'adjR2'),
  display_names = hash::hash(nobs = 'N', R2 = 'R2', adjR2 = 'adjR2')
)

.display_names = list(
  coef = 'Estimate', se = 'SE', pv = 'p Value', tv = 't Value',
  nobs = 'N', R2 = 'R2', adjR2 = 'adjR2'
)


