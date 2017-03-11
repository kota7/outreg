
.coef_part_meta <- list(
  all_vars = c('coef', 'se', 'pv', 'tv', 'zv'),
  real_vars = c('coef', 'se', 'pv', 'tv', 'zv')
)


.stat_part_meta <- list(
  all_vars = c('nobs', 'R2', 'adjR2', 'aic'),
  real_vars = c('R2', 'adjR2', 'aic',
                'Wu-Hausman stat', 'Wu-Hausman p-value',
                'Sargan stat', 'Sargan p-value'),
  real_var_keys = character(0)
)


.opt_part_meta <- list(
  real_vars = c('Weak instr stat', 'Weak instr p-value')
)


.display_names = list(
  coef = 'Estimate', se = 'Std Err',
  pv = 'p Value', tv = 't Value', zv = 'z Value',

  nobs = 'N', R2 = 'R2', adjR2 = 'adj R2', aic = 'AIC'
)


