make_coef_part.lm <- function(fit, modelname, robust = FALSE, small = FALSE, ...)
{
  out <- data.frame(modelname = modelname,
                    variable = names(fit$coefficients),
                    coef = fit$coefficients,
                    stringsAsFactors = FALSE)

  se <- rep(NA, nrow(out))
  vcov_func <- ifelse(robust, sandwich::sandwich, stats::vcov)
  se[!is.na(fit$coefficients)] <- sqrt(diag(vcov_func(fit)))
  out$se <- se

  out$tv <- out$coef / out$se
  out$pv <- pnorm(-abs(out$tv))*2
  rownames(out) <- NULL
  out
}


make_stat_part.lm <- function(fit, modelname, ...)
{
  data.frame(modelname = modelname,
             nobs = length(fit$fitted.values),
             R2 = summary(fit)$r.squared,
             adjR2 = summary(fit)$adj.r.squared,
             stringsAsFactors = FALSE)
}


