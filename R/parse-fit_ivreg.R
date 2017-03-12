make_coef_part.ivreg <- function(fit, modelname, robust = FALSE,
                                 small = TRUE, ...)
{
  out <- data.frame(modelname = modelname,
                    variable = names(coefficients(fit)),
                    coef = coefficients(fit),
                    stringsAsFactors = FALSE)

  se <- rep(NA, nrow(out))
  vcov_func <- ifelse(robust, sandwich, vcov)
  se[!is.na(coefficients(fit))] <- sqrt(diag(vcov_func(fit)))
  out$se <- se

  out$tv <- out$coef / out$se

  if (small) {
    out$pv <- pt(-abs(out$tv), df.residual(fit))*2
  } else {
    out$pv <- pnorm(-abs(out$tv))*2
  }
  rownames(out) <- NULL


  out
}





make_stat_part.ivreg <- function(fit, modelname, robust = FALSE, ...)
{
  out <- data.frame(modelname = modelname,
                    variable = '',
                    nobs = length(fitted.values(fit)),
                    R2 = summary(fit)$r.squared,
                    adjR2 = summary(fit)$adj.r.squared,
                    stringsAsFactors = FALSE)

  # weak instrument diagnostics defined for entire model
  vcov_func <- ifelse(robust, sandwich, vcov)
  diag <- summary(fit, vcov. = vcov_func, diagnostics = TRUE)$diagnostics
  inst <- setdiff(colnames(model.matrix(fit, component = 'regressor')),
                  colnames(model.matrix(fit, component = 'instrument')))
  diag <- diag[(length(inst)+1):nrow(diag), c(3,4)]
  diag <- as.data.frame(diag)
  diag$stat1 <- rownames(diag)
  rownames(diag) <- NULL
  diag$stat1 <- factor(diag$stat1, levels = unique(diag$stat1))
  diag <- reshape2::melt(diag, id.vars = 'stat1', variable.name = 'stat2')
  diag <- diag[order(diag$stat2),]
  diag <- diag[order(diag$stat1),]
  diag$statname <- paste(as.character(diag$stat1), as.character(diag$stat2))
  diag$statname <- sub('statistic$', 'stat', diag$statname)
  diag$statname <- factor(diag$statname, levels = unique(diag$statname))
  diag <- diag[c('statname', 'value')]
  diag <- tidyr::spread_(diag, key = 'statname', value = 'value')

  out <- cbind(out, diag)
  out
}



make_opt_part.ivreg <- function(fit, modelname, robust = FALSE, ...)
{
  # weak instrument diagnostics defined for each variable
  vcov_func <- ifelse(robust, sandwich, vcov)
  diag <- summary(fit, vcov. = vcov_func, diagnostics = TRUE)$diagnostics

  vars <- stringr::str_match(rownames(diag), '\\((.*)\\)$')[, 2]
  if (all(is.na(vars))) {
    endo <- setdiff(colnames(model.matrix(fit, component = 'regressor')),
                    colnames(model.matrix(fit, component = 'instrument')))
    vars[seq_along(endo)] <- endo
  }
  stats <- sub('[ ]*\\((.*)\\)$', '', rownames(diag))

  diag <- diag[, c(3,4)]
  diag <- as.data.frame(diag, stringsAsFactors = FALSE)
  rownames(diag) <- NULL
  diag$variable <- vars
  diag$stat1 <- stats
  diag <- diag[!is.na(diag$variable),]
  diag$stat1 <- factor(diag$stat1, levels = unique(diag$stat1))
  diag$variable <- factor(diag$variable, levels = unique(diag$variable))
  diag <- reshape2::melt(diag, id.vars = c('stat1', 'variable'),
                         variable.name = 'stat2')
  diag <- diag[order(diag$variable),]
  diag <- diag[order(diag$stat1),]
  diag$statname <- paste(as.character(diag$stat1), as.character(diag$stat2))
  diag$statname <- diag$statname %>%
    stringr::str_replace('^Weak instruments', 'Weak instr') %>%
    stringr::str_replace('statistic$', 'stat')
  diag$modelname <- modelname
  diag <- diag[c('modelname', 'variable', 'statname', 'value')]
  diag$statname <- factor(diag$statname, levels = unique(diag$statname))
  diag <- tidyr::spread_(diag, key = 'statname', value = 'value')

  diag
}
