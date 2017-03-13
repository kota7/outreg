
.coef_part_meta <- list(
  all_vars = c('coef', 'se', 'pv', 'tv', 'zv'),
  real_vars = c('coef', 'se', 'pv', 'tv', 'zv')
)


.stat_part_meta <- list(
  all_vars = c('nobs', 'R2', 'adjR2', 'aic'),
  real_vars = c('R2', 'adjR2', 'aic',
                'WuHausman_stat', 'WuHausman_pv',
                'Sargan_stat', 'Sargan_pv'),
  real_var_keys = character(0)
)


.opt_part_meta <- list(
  real_vars = c('WeakInst_stat', 'WeakInst_pv')
)


.display_names = list(
  coef = 'Estimate', se = 'Std Err',
  pv = 'p Value', tv = 't Value', zv = 'z Value',

  nobs = 'N', R2 = 'R2', adjR2 = 'adj R2', aic = 'AIC',

  WuHausman_stat = 'Wu-Hasuman stat',
  WuHasuman_pv   = 'Wu-Hausman p-value',
  Sargan_stat    = 'Sargan stat',
  Sargn_pv       = 'Sargan p-value',
  WeakInst_stat  = 'Weak instr stat',
  WeakInst_pv    = 'Weak instr p-value'

)




.not_displayed_default = list(
  c('pv', 'tv', 'zv')
)

