make_coef_part.survreg <- function(fit, modelname, robust = FALSE, ...)
{
  nvar <- nrow(fit$var)
  out <- data.frame(modelname = rep(modelname, nvar),
                    stringsAsFactors = FALSE)

  coef <- coefficients(fit)
  cname <- names(coef)

  nvar0 <- length(coef)
  if (nvar > nvar0) {
    coef <- c(coef, log(fit$scale))
    if ((nvar-nvar0) == 1) {
      cname <- c(cname, 'Log(scale)')
    } else {
      cname <- c(cname, paste0('Log(scale) ', names(fit$scale)))
    }
  }
  out$variable <- cname
  out$coef <- coef

  se <- rep(NA, nrow(out))
  vcov_func <- ifelse(robust, sandwich, vcov)
  se[!is.na(coef)] <- sqrt(diag(vcov_func(fit)))
  out$se <- se

  out$zv <- out$coef / out$se
  out$pv <- pnorm(-abs(out$zv))*2

  rownames(out) <- NULL
  out
}


make_stat_part.survreg <- function(fit, modelname, ...)
{
  data.frame(modelname = modelname,
             nobs = length(fit$linear.predictors),
             aic = AIC(fit),
             stringsAsFactors = FALSE)
}


