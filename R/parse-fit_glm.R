make_coef_part.glm <- function(fit, modelname, robust = FALSE, ...)
{
  out <- data.frame(modelname = modelname,
                    variable = names(coefficients(fit)),
                    coef = coefficients(fit),
                    stringsAsFactors = FALSE)

  se <- rep(NA, nrow(out))
  vcov_func <- ifelse(robust, sandwich, vcov)
  se[!is.na(coefficients(fit))] <- sqrt(diag(vcov_func(fit)))
  out$se <- se

  out$zv <- out$coef / out$se
  out$pv <- pnorm(-abs(out$zv))*2

  rownames(out) <- NULL
  out
}


make_stat_part.glm <- function(fit, modelname, ...)
{
  data.frame(modelname = modelname,
             nobs = length(fit$fitted.values),
             aic = AIC(fit),
             stringsAsFactors = FALSE)
}


